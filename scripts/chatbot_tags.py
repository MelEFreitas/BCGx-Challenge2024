from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.chains import LLMChain, ConversationalRetrievalChain
from langchain_openai import ChatOpenAI
from langchain_openai import OpenAI
from langchain.schema import HumanMessage, AIMessage, SystemMessage
from langchain_community.document_loaders import PyMuPDFLoader 
from langchain_community.embeddings import OpenAIEmbeddings  # Import the missing class
from langchain.text_splitter import RecursiveCharacterTextSplitter  # Import the missing class
from langchain_community.vectorstores import FAISS
from langchain_core.output_parsers import StrOutputParser
from langchain.memory import CombinedMemory, ConversationSummaryMemory, ConversationEntityMemory
import tiktoken


class Chatbot:
    def __init__(self, openai_api_key: str, faiss_index_path: str, role:str):
        """Inicializa o chatbot com recuperação de documentos e gerenciamento de contexto"""
        # Configurar o modelo OpenAI
        #self.role = role
        
        self.llm = ChatOpenAI(model="gpt-4o",
                              temperature=0.5,  # Ajuste da criatividade
                              frequency_penalty=0.7,  # Penalidade por repetição de palavras
                              presence_penalty=0.5,  # Incentiva variedade de palavras
                              )
        
        #Creating Embeddings
        self.embbedings = OpenAIEmbeddings(openai_api_type=openai_api_key)
        
        # Carregar o índice FAISS existente
        self.faiss = FAISS.load_local(faiss_index_path, self.embbedings, allow_dangerous_deserialization=True)
        
        # Configurar retriever
        self.retriever = self.faiss.as_retriever(search_type="similarity_score_threshold", 
                                                search_kwargs={"score_threshold": 0.75, 'k':5})#,search_limit=1)

        # Configurar a memória de contexto
        summary_memory = ConversationSummaryMemory(llm=OpenAI(), memory_key="summary_history")  # Use 'summary_history' as key
        entity_memory = ConversationEntityMemory(llm=OpenAI(), memory_key="entity_info")  # Use 'entity_info' as key
        self.memory = CombinedMemory(memories=[summary_memory, entity_memory]) # Combine both memories

        # Inicializar cadeias de prompts
        self._init_prompt_chains()
        
    def get_relevant_documents(self, question: str, tags: list = None):
        """
        Recupera documentos relevantes para a pergunta e filtra por tags, se fornecidas.
        """
        # Primeiro, realiza a busca baseada na similaridade
        docs = self.faiss.as_retriever(
            search_type="similarity_score_threshold",
            search_kwargs={"score_threshold": 0.75, 'k': 5}
        ).get_relevant_documents(question)

        # Se não há tags fornecidas, retorna os documentos encontrados
        if not tags:
            return docs

        # Caso contrário, filtra os documentos baseados nas tags fornecidas
        filtered_docs = []
        for doc in docs:
            doc_tags = doc.metadata.get("tags", [])
            # Verifica se o documento contém ao menos uma das tags fornecidas
            if any(tag in doc_tags for tag in tags):
                filtered_docs.append(doc)

        return filtered_docs
        
        # Função para criar o System Message de acordo com a role
    def get_system_message(self,role):
        role_based_instructions = {
            "usuário padrão": "Explique de forma simples e acessível.",
            "especialista ambiental": "Forneça detalhes técnicos e termos ambientais específicos.",
            "gerente municipal": "Foque em ações práticas e implementáveis no nível municipal."
        }
        return SystemMessage(content=role_based_instructions.get(role, "Explique de forma simples."))


    def _init_prompt_chains(self):
        """Inicializa os prompts para o LLM e a recuperação de documentos"""
        # Instruções para perguntas baseadas no histórico da conversa
        instructions = """
        You are a knowledgeable assistant. Answer the questions based on the ongoing conversation.
        
        Chat History: {chat_history}
        """
        
        tag_classification_prompt_template = """
        You are a climate crisis specialist. 
        For each question the user made, classify it under one or more of the following categories:
        - Segurança Hídrica
        - Adaptação Climática
        - Mitigação das Emissões de GEE
        - Inclusão Social
        - Conservação de Ecossistemas
        - Resiliência das Comunidades
        - Segurança Alimentar
        - Qualidade do Ar
        - Infraestrutura e Urbanização
        - Educação e Conscientização
        - Saúde Pública
        - Energia Renovável e Eficiência Energética
        - Mobilidade e Transporte Sustentável
        - Política e Governança Climática
        - Setor Agropecuário
        - Colaboração Intersetorial
        - Proteção das Comunidades Tradicionais

        Classifique a pergunta na categoria mais relevante. 
        Pergunta: {question}
        Classificação:
        """
        tag_classification_prompt = ChatPromptTemplate.from_template(tag_classification_prompt_template)

        self.tag_classification_chain = LLMChain(
            llm=self.llm,
            prompt=tag_classification_prompt
        )

        question_maker_prompt = ChatPromptTemplate(
            [
                ("system", instructions),
               MessagesPlaceholder(variable_name="chat_history"),
                ("human", "{question}"),
            ]
        )

        # Cadeia para gerar respostas baseadas no histórico da conversa
        self.question_chain = LLMChain(
            llm=self.llm,
            prompt=question_maker_prompt,
            memory=self.memory
        )

        # Cadeia de prompts para o sistema de QA com recuperação de documentos
        qa_system_prompt = """
        You are a climate crisis specialist. 
        Use the following context from retrieved documents and, if you think is useful,
        the chat history to answer the user's question.
        Context: {context},
        
        Chat History: {chat_history}, 
        
        Question: {question}
        
        """
        qa_prompt = ChatPromptTemplate.from_template(qa_system_prompt)

        # Cadeia de recuperação de documentos e geração de respostas
        self.retriever_chain = ConversationalRetrievalChain.from_llm(
            llm=self.llm,
            retriever=self.retriever,
            return_source_documents=True  # Retorna os documentos fonte usados
        )
        
        self.rag_chain = (
            self.retriever_chain
            | (lambda inputs: {
                "context": self.get_system_message("especialista ambiental").content, 
                "chat_history": self.chat_history,  # Incluindo o histórico diretamente
                **inputs
            })
            | qa_prompt  # Garantir que o prompt usa o histórico
            | self.llm
            | StrOutputParser()
        )

        # Prompt de classificação de perguntas
        general_question_prompt_template = """
        Você é um assistente treinado para identificar o tipo de pergunta. Diga apenas "Geral" se a pergunta for uma questão genérica e não precisa consultar documentos, ou "Específica" se a pergunta precisar de informações detalhadas de uma base de dados.
        Pergunta: {question}
        Classificação:
        
        """
        question_classifier_prompt = ChatPromptTemplate.from_template(general_question_prompt_template)

        # Cadeia de classificação de perguntas
        self.classification_chain = LLMChain(
            llm=self.llm,
            prompt=question_classifier_prompt
        )
        
        self.chat_history = [
            SystemMessage(content="You're a helpful assistant")
        ]

    def detect_question_type(self, question: str) -> str:
        """
        Usa o LLM para classificar a pergunta como 'geral' ou 'específica'.
        """
        result = self.classification_chain.invoke({"question": question})
        return result["text"].strip().lower()

    def handle_general_question(self, question: str):
        """
        Processa perguntas gerais (não precisam de contexto de documentos).
        """
        
        ai_message = self.llm.predict(f"Pergunta: {question}")
        
        self.chat_history.extend([HumanMessage(content=question), AIMessage(content=ai_message)])
        return ai_message, None, self.chat_history
    
    def classify_question_tags(self, question: str):
        """
        Usa o LLM para classificar a pergunta de acordo com as tags definidas.
        """
        result = self.tag_classification_chain.invoke({"question": question})
        tags = result["text"].strip().split(',')  # Processa o output para obter uma lista de tags
        return [tag.strip() for tag in tags]

    def handle_specific_question(self, question: str, tags: list = None):
        """
        Processa perguntas específicas, buscando documentos relevantes e respondendo com base neles.
        """
        
        # Classificar a pergunta nas categorias de tags
        tags = self.classify_question_tags(question)
        
        context = self.get_relevant_documents(question, tags)
        
        if not context:
            return "I don't have enough information to answer this question. \
                    Can you reformulate your question or ask anything else?", None, self.chat_history
        
        ai_message = self.rag_chain.invoke({
            "question": question,
            "context": context[0],
            "chat_history": self.chat_history
        })

        # Armazena o histórico da conversa
        self.chat_history.extend([HumanMessage(content=question), AIMessage(content=ai_message)])

        return ai_message, context, self.chat_history
    
    def run_chat_test(self, question: str):
        
        question_type = self.detect_question_type(question)
        
        if question_type == "geral":
            return self.handle_general_question(question)
        
        elif question_type == "específica":
            return self.handle_specific_question(question)

    