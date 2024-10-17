from langchain.chains.llm import LLMChain
from langchain.chains.conversational_retrieval.base import ConversationalRetrievalChain
from langchain.memory import CombinedMemory, ConversationSummaryMemory, ConversationEntityMemory
from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.schema import SystemMessage, AIMessage, HumanMessage
from langchain_community.embeddings import OpenAIEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_core.output_parsers import StrOutputParser
from langchain_openai import ChatOpenAI, OpenAI

from app.schemas.chat import ChatBase
from app.db.models.chat import ChatDB
from app.schemas.question_answer import QuestionAnswerBase

faiss_index_path = "app/api/routes/faiss_index"

instructions = """
    You are a knowledgeable assistant. Answer the questions based on the ongoing conversation.
"""

qa_system_prompt = """
    You are a climate crisis specialist. Use the following context from retrieved documents to answer the user's question.

    Context: {context}

    Question: {question}
"""

general_question_prompt_template = """
    Você é um assistente treinado para identificar o tipo de pergunta. Diga apenas "Geral" se a pergunta for uma questão genérica e não precisa consultar documentos, ou "Específica" se a pergunta precisar de informações detalhadas de uma base de dados.

    Pergunta: {question}

    Classificação:
"""

score_threshold = 0.8

llm = ChatOpenAI(temperature=0.5)
embeddings = OpenAIEmbeddings()
faiss = FAISS.load_local(faiss_index_path, embeddings, allow_dangerous_deserialization=True)
retriever = faiss.as_retriever(search_type="similarity_score_threshold", search_kwargs={"score_threshold": score_threshold}, search_limit=5)
summary_memory = ConversationSummaryMemory(llm=OpenAI(), memory_key="summary_history")
entity_memory = ConversationEntityMemory(llm=OpenAI(), memory_key="entity_info")
memory = CombinedMemory(memories=[summary_memory, entity_memory])

question_maker_prompt = ChatPromptTemplate(
    [
        ("system", instructions),
        MessagesPlaceholder(variable_name="chat_history"),
        ("human", "{question}"),
    ]
)

question_chain = LLMChain(
    llm=llm,
    prompt=question_maker_prompt,
    memory=memory
)

qa_prompt = ChatPromptTemplate.from_template(qa_system_prompt)

retriever_chain = ConversationalRetrievalChain.from_llm(
    llm=llm,
    retriever=retriever,
    return_source_documents=True 
)

rag_chain = (
    retriever_chain
    | qa_prompt
    | llm
    | StrOutputParser()
)

question_classifier_prompt = ChatPromptTemplate.from_template(general_question_prompt_template)

classification_chain = LLMChain(
    llm=llm,
    prompt=question_classifier_prompt
)

def detect_question_type(question: str) -> str:
    """
    Usa o LLM para classificar a pergunta como 'geral' ou 'específica'.
    """
    result = classification_chain.invoke({"question": question})
    return result["text"].strip().lower()

def fetch_chat_history(db_chat: ChatDB | None):
    """
    Fetches the previous conversation history from the database and prepares it for the LLM prompt.
    """
    chat_history = [SystemMessage(content="You're a helpful assistant")]
    if db_chat:
        for qa in db_chat.conversation:
            chat_history.append(HumanMessage(content=qa.question))
            chat_history.append(AIMessage(content=qa.answer))
    
    return chat_history


def handle_general_question(question: str):
    """
    Processa perguntas gerais (não precisam de contexto de documentos).
    """
    ai_message = llm.predict(f"Pergunta: {question}")
    
    return ai_message


def handle_specific_question(db_chat: ChatDB | None, question: str, role: str):
    """
    Processa perguntas específicas, buscando documentos relevantes e respondendo com base neles.
    """
    chat_history = fetch_chat_history(db_chat=db_chat)

    context = retriever.get_relevant_documents(question)

    if not context:
        return "Não possuo informações suficientes para responder."
    
    # for doc in context:
    #     print(doc)
    # if context:
    #     highest_score = max([doc.metadata['similarity_score'] for doc in context])

    #     if highest_score < score_threshold:
    #         return "Não possuo informações suficientes para responder."
        
    ai_message = rag_chain.invoke({
        "question": question,
        "context": context[0],
        "chat_history": chat_history
    })

    # context.metadata.get('page_number')
    # context.metadata.get('file_name')
    # context.page_content

    return ai_message
    

def ask_question_ai(db_chat: ChatDB | None, question: ChatBase, role: str):  
    question_type = detect_question_type(question)
    
    if question_type == "específica":
        ai_message = handle_specific_question(db_chat, question.question, role)
    else:
        ai_message = handle_general_question(question.question)
    
    return QuestionAnswerBase(question=question.question, answer=ai_message)
    

def create_chat_title(question: ChatBase) -> str:
    """
    Create the chat title.
    """
    return question.question[:21].strip() + "..."