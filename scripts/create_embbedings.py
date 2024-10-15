import os
import re
import nltk
import tiktoken
from datetime import datetime
from dotenv import load_dotenv
from langchain_community.document_loaders import PyMuPDFLoader
from langchain_community.embeddings import OpenAIEmbeddings
from langchain_community.vectorstores import FAISS
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.docstore.document import Document # Import Document class

# Get api key
load_dotenv(".env")
OPENAI_API_KEY = os.environ.get('OPENAI_API_KEY') 


# Função para adicionar metadados ao texto
def add_metadata(text, file_name, page_number):
    metadata = {
                    "file_name": file_name,
                    "page_number": page_number,
                    "text": text
                }
    return {"text": text, "metadata": metadata}

# Função para remover páginas indesejadas com base em palavras-chave
def is_relevant_page(text, keywords_to_remove=None):
    if keywords_to_remove is None:
        keywords_to_remove = ["sumário", "índice", "glossário"]  # Palavras-chave que indicam páginas indesejadas
    # Verifica se alguma das palavras-chave está presente na página (ignorando maiúsculas/minúsculas)
    for keyword in keywords_to_remove:
        if re.search(rf"\b{keyword}\b", text, re.IGNORECASE):
            return False  # Página não é relevante
    return True

# Função para limpar o texto, removendo caracteres especiais e espaços extras
def clean_text(text):
    # Remove quebras de linha, tabulações e substitui múltiplos espaços por um único espaço
    text = text.replace('\n', ' ').replace('\t', ' ')
    text = re.sub(r'\s+', ' ', text)  # Remove múltiplos espaços
    # Adicione aqui mais limpezas personalizadas se necessário

    return text.strip()  # Remove espaços no início e fim

# Função para carregar e processar documentos PDF
def load_and_process_documents(file_paths):
    documents = []
    for file_path in file_paths:
        loader = PyMuPDFLoader(file_path)  # Carregar o PDF
        pages = loader.load()  # Carregar todas as páginas do PDF

        for page_number, page in enumerate(pages):
            text = page.page_content
            if is_relevant_page(text):  # Se a página for relevante
                cleaned_text = clean_text(text)  # Limpeza do texto
                document_with_metadata = add_metadata(cleaned_text, file_path, page_number + 1)  # Adicionar metadados
                documents.append(document_with_metadata)  # Adicionar à lista de documentos
    return documents

def create_embeddings(document, embeddings) -> list:
    """
    Recebe um documento com texto e metadados, divide em chunks, gera embeddings
    e retorna uma lista de objetos Document contendo os chunks e seus embeddings.
    """
    text = document['text']  # Extrai o texto limpo do documento
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=800, chunk_overlap=200)
    documents = []  # Lista para armazenar os objetos Document
    text_split = text_splitter.split_text(text)

    # Inicializa o codificador de tokens
    encoding = tiktoken.encoding_for_model("gpt-4")  

    for t in text_split:
        # Conta os tokens do chunk
        token_count = len(encoding.encode(t))
        print(f"Chunk length in tokens: {token_count}") 

        # Gera o embedding para o chunk
        emb = embeddings.embed_query(t)

        # Armazena o embedding e metadados no formato correto
        documents.append(
            Document(
                page_content=t, 
                metadata={
                    "embedding": emb,
                    "file_name": document["metadata"]["file_name"],
                    "page_number": document["metadata"]["page_number"]
                }
            )
        )   

    return documents

# Função para salvar os documentos no FAISS
def save_to_faiss(documents, embeddings):
    # Cria uma lista de textos e metadados para o FAISS
    texts = [doc.page_content for doc in documents]
    
    # Atualiza a coleta de metadados para incluir página e nome do arquivo
    metadatas = [
        {
            "file_name": doc.metadata["file_name"], 
            "page_number": doc.metadata["page_number"],
            "embedding": doc.metadata["embedding"]
        }
        for doc in documents
    ]

    # Cria o banco de dados FAISS com textos e metadados atualizados
    vector_store = FAISS.from_texts(texts, embeddings, metadatas=metadatas)

    # Salva o banco de dados FAISS
    vector_store.save_local("faiss_index")
    print(f"Saved {len(documents)} documents to FAISS.")

# Exemplo de uso
def main():
    data_dir = "C:/Users/Melissa Freitas/Documents/Melissa/BCGx-Challenge2024/data"
    if not os.path.exists(data_dir):
        print(f"Directory {data_dir} does not exist.")
        return
        
    file_paths = [os.path.join(data_dir, pdf_file) for pdf_file in os.listdir(data_dir) if pdf_file.endswith(".pdf")]
    documents = load_and_process_documents(file_paths)

    # Inicializa os embeddings
    embeddings = OpenAIEmbeddings()

    # Cria embeddings para os documentos processados
    all_documents = []
    for doc in documents:
        print(f"Processing {doc['metadata']['file_name']}...")
        
        # Agora passa o dicionário inteiro (doc), não apenas o texto
        chunk_embeddings = create_embeddings(doc, embeddings)  
        
        all_documents.extend(chunk_embeddings)

    # Salva os documentos no FAISS
    save_to_faiss(all_documents, embeddings)

if __name__ == "__main__":
    main()