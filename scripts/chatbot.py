from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.chains import LLMChain, ConversationalRetrievalChain
#from langchain_community.chat_models import ChatOpenAI
from langchain_openai import ChatOpenAI
from langchain_openai import OpenAI
from langchain.schema import HumanMessage, AIMessage, SystemMessage
from langchain_community.document_loaders import PyMuPDFLoader  # Exemplo de loader de PDF
from langchain_community.embeddings import OpenAIEmbeddings  # Import the missing class
from langchain.text_splitter import RecursiveCharacterTextSplitter  # Import the missing class
from langchain_community.vectorstores import FAISS
from langchain_core.output_parsers import StrOutputParser
from langchain.memory import CombinedMemory, ConversationSummaryMemory, ConversationEntityMemory


class Chatbot:
    def __init__(self, document_path: str, openai_api_key: str, temperature=0.7):
        """Inicializa o chatbot com recuperação de documentos e gerenciamento de contexto"""
        # Configurar o modelo OpenAI
        self.llm = ChatOpenAI(temperature=temperature, openai_api_key=openai_api_key)
        
        # Carregar documentos (exemplo: PDF)
        self.loader = PyMuPDFLoader(document_path)
        self.documents = self.loader.load()

        #Separar o texto em pedaços menores
        self.text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
        documents_split = self.text_splitter.split_documents(self.documents)
        
        #Creating Embeddings
        self.embbedings = OpenAIEmbeddings(openai_api_type=openai_api_key)
        faiss = FAISS.from_documents(documents_split, self.embbedings)
        
        # Configurar retriever
        self.retriever = faiss.as_retriever(search_type="similarity_score_threshold", 
                                            search_kwargs={"score_threshold": 0.8},
                                            search_limit=5)

        # Configurar a memória de contexto
        summary_memory = ConversationSummaryMemory(llm=OpenAI(), memory_key="summary_history")  # Use 'summary_history' as key
        entity_memory = ConversationEntityMemory(llm=OpenAI(), memory_key="entity_info")  # Use 'entity_info' as key
        self.memory = CombinedMemory(memories=[summary_memory, entity_memory]) # Combine both memories

        # Inicializar cadeias de prompts
        self._init_prompt_chains()

    def _init_prompt_chains(self):
        """Inicializa os prompts para o LLM e a recuperação de documentos"""
        # Instruções para perguntas baseadas no histórico da conversa
        instructions = """
        You are a knowledgeable assistant. Answer the questions based on the ongoing conversation.
        """

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
        You are a climate crisis specialist. Use the following context from retrieved documents to answer the user's question.

        Context: {context}

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
            | qa_prompt
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
        #chat_history = [AIMessage(content="Hi there, how can I help you today?")]
        #ai_message = self.question_chain.invoke({
        #    "question": question,
        #    "chat_history": self.chat_history
        #})
        
        ai_message = self.llm.predict(f"Pergunta: {question}")
        
        self.chat_history.extend([HumanMessage(content=question), AIMessage(content=ai_message)])
        return ai_message, None, self.chat_history

    def handle_specific_question(self, question: str):
        """
        Processa perguntas específicas, buscando documentos relevantes e respondendo com base neles.
        """
        #chat_history = [AIMessage(content="Hi there, how can I help you today?")]
        context = self.retriever.get_relevant_documents(question)
        
        ai_message = self.rag_chain.invoke({
            "question": question,
            "context": context,
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

    def run_chat(self, question: str):
        """
        Método principal que decide se a pergunta é geral ou específica e processa adequadamente.
        """
        question_type = self.detect_question_type(question)
        #chat_history = [AIMessage(content="Hi there, how can I help you today?")]
        
        if question_type == "geral":
            # Para perguntas gerais, só usa o LLM
            ai_message = self.llm.predict(f"Pergunta: {question}")
            #chat_history.extend([HumanMessage(content=question), AIMessage(content=ai_message)])
            
            return ai_message, None, self.chat_history

        elif question_type == "específica":
            # Para perguntas específicas, usa documentos embasados
            context = self.retriever.get_relevant_documents(question)
            
            # Ajustar a chave de entrada para conter apenas 'question' e 'context'
            ai_message = self.rag_chain.invoke({
                "question": question,  # Apenas 'question'
                "context": context,
                "chat_history": self.chat_history
            })

            # Atualizar o histórico de chat
            self.chat_history.extend([HumanMessage(content=question), AIMessage(content=ai_message)])

            # Retornar a resposta e os documentos relevantes
            return ai_message, context, self.chat_history
