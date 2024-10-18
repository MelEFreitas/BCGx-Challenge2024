import os
from dotenv import load_dotenv
from chatbot import Chatbot

# Get api key
load_dotenv(".env")
OPENAI_API_KEY = os.environ.get('OPENAI_API_KEY')    

faiss_index_path = "faiss_index"

role = 'Public Manager'

def main():
    
    print("\n----------------------------------------")
    print("Bem-vindo ao Chatbot sobre crises climáticas!")
    print("----------------------------------------\n")
    
    chatbot = Chatbot(
        #document_path=pdf_path,  
        openai_api_key=OPENAI_API_KEY,   
        faiss_index_path = faiss_index_path,
        role = role
    )
    
    chat = True

    while chat:
        
        # Obter pergunta do usuário
        question = input("Digite sua pergunta (ou 'sair' para encerrar): ")
        
        if question.lower() == "sair":
            chat = False
        
        else:               
            # Interagir com o chatbot
            response, docs, chat_history = chatbot.run_chat_test(question)
        
            # Exibir resposta
            print(f"Resposta: {response}")
        
            # Exibir documentos usados como referência (se houver)
            if docs:
                print("\nDocumentos usados como referência:")
                for doc in docs:
                    print(f"- Página: {doc.metadata.get('page_number')}")
                    print(f"- File: {doc.metadata.get('file_name')}")
                    print(f"Conteúdo: {doc.page_content}\n")  
                    
            # Exibir histórico da conversa
            print("\nHistórico da conversa:")
            for msg in chat_history:
                print(msg)
                
            if question.lower() == "sair":
                chat = False
                

if __name__ == "__main__":
    main()