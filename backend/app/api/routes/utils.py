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
from app.schemas.question_answer import AnswerMetadata

faiss_index_path = "app/api/routes/faiss_index"

instructions = """
    You are a knowledgeable assistant. Answer the questions based on the ongoing conversation.
"""

qa_system_prompt = """
    You are a climate crisis specialist. Use the following context from retrieved documents to answer the user's question.
    {instruction}
    
    Context: {context},

    Chat History: {chat_history},
    
    Question: {question}
"""

general_question_prompt_template = """
    You are an assistant trained to identify the type of question. 
    Classify as "General" if the question is ONLY a greeting like "Hi/Hello/Good morning/Thank you," 
    or "Specific" if it's a detailed question requiring information from a database.

    Question: {question}

    Classification:
"""

score_threshold = 0.8

# Initialize models and embeddings
llm = ChatOpenAI(
    model="gpt-4o",
    temperature=0.7,
    frequency_penalty=0.5,
    presence_penalty=0.3,
)
embeddings = OpenAIEmbeddings()
faiss = FAISS.load_local(faiss_index_path, embeddings, allow_dangerous_deserialization=True)
retriever = faiss.as_retriever(
    search_type="similarity_score_threshold", 
    search_kwargs={"score_threshold": 0.75, 'k': 5}
)

# Memory modules to track conversation
summary_memory = ConversationSummaryMemory(llm=OpenAI(), memory_key="summary_history")
entity_memory = ConversationEntityMemory(llm=OpenAI(), memory_key="entity_info")
memory = CombinedMemory(memories=[summary_memory, entity_memory])

# Prompt template for generating questions
question_maker_prompt = ChatPromptTemplate(
    [
        ("system", instructions),
        MessagesPlaceholder(variable_name="chat_history"),
        ("human", "{question}"),
    ]
)

# Chain to generate the question
question_chain = LLMChain(
    llm=llm,
    prompt=question_maker_prompt,
    memory=memory
)

# Prompt template for question answering
qa_prompt = ChatPromptTemplate.from_template(qa_system_prompt)

# Retrieval-based question answering chain
retriever_chain = ConversationalRetrievalChain.from_llm(
    llm=llm,
    retriever=retriever,
    return_source_documents=True
)

# RAG chain combining retriever and LLM
rag_chain = (
    retriever_chain
    | qa_prompt
    | llm
    | StrOutputParser()
)

# Question classification prompt
question_classifier_prompt = ChatPromptTemplate.from_template(general_question_prompt_template)

# Chain to classify questions
classification_chain = LLMChain(
    llm=llm,
    prompt=question_classifier_prompt
)


def detect_question_type(question: str) -> str:
    """
    Use the LLM to classify the question as either 'general' or 'specific'.

    Args:
        question (str): The question to classify.

    Returns:
        str: The classification of the question as either 'general' or 'specific'.
    """
    result = classification_chain.invoke({"question": question})
    return result["text"].strip().lower()


def fetch_chat_history(db_chat: ChatDB | None):
    """
    Fetches the previous conversation history from the database and prepares it for the LLM prompt.

    Args:
        db_chat (ChatDB | None): The chat history stored in the database.

    Returns:
        list: The chat history including system, human, and AI messages.
    """
    chat_history = [SystemMessage(content="You're a helpful assistant")]
    if db_chat:
        for qa in db_chat.conversation:
            chat_history.append(HumanMessage(content=qa.question))
            chat_history.append(AIMessage(content=qa.answer))
    
    return chat_history


def get_system_message(role: str) -> SystemMessage:
    """
    Generates a system message based on the role of the user.

    Args:
        role (str): The role of the user (e.g., 'User', 'Environmental Analyst', 'Manager').

    Returns:
        SystemMessage: A system message with instructions tailored to the user's role.
    """
    role_based_instructions = {
        "User": "Explain in a simple and accessible way.",
        "Environmental Analyst": "Provide technical details and specific environmental terms.",
        "Manager": "Focus on practical actions feasible at the municipal level."
    }
    return SystemMessage(content=role_based_instructions.get(role, "Explain in a simple way."))


def handle_general_question(question: str) -> str:
    """
    Processes general questions (do not require document context).

    Args:
        question (str): The general question to process.

    Returns:
        str: The AI's response to the general question.
    """
    ai_message = llm.predict(f"Question: {question}")
    
    return ai_message


def handle_specific_question(db_chat: ChatDB | None, question: str, role: str):
    """
    Processes specific questions by retrieving relevant documents and answering based on them.

    Args:
        db_chat (ChatDB | None): The chat history stored in the database.
        question (str): The specific question to process.
        role (str): The role of the user asking the question.

    Returns:
        tuple: A tuple containing the AI's message and metadata about the documents used to answer.
    """
    chat_history = fetch_chat_history(db_chat=db_chat)
    context = retriever.get_relevant_documents(question)
    instruction = get_system_message(role)

    if not context:
        return "I do not have enough information to answer.", []
    
    ai_message = rag_chain.invoke({
        "instruction": instruction,
        "question": question,
        "context": context[0],
        "chat_history": chat_history
    })

    answer_metadatas = []

    for doc in context:
        answer_metadatas.append(
            AnswerMetadata(
                page_number=str(doc.metadata.get('page_number')),
                file_name=str(doc.metadata.get('file_name'))
            )
        )

    return ai_message, answer_metadatas
    

def ask_question_ai(db_chat: ChatDB | None, question: ChatBase, role: str) -> QuestionAnswerBase:
    """
    Handles AI question answering, classifying the question and processing accordingly.

    Args:
        db_chat (ChatDB | None): The chat history stored in the database.
        question (ChatBase): The question asked by the user.
        role (str): The role of the user asking the question.

    Returns:
        QuestionAnswerBase: The AI's answer and any relevant metadata.
    """
    question_type = detect_question_type(question.question)
    answer_metadatas = []
    
    if question_type == "specific":
        ai_message, answer_metadatas = handle_specific_question(db_chat, question.question, role)
    else:
        ai_message = handle_general_question(question.question)
    
    return QuestionAnswerBase(question=question.question, answer=ai_message, answer_metadata=answer_metadatas)
    

def create_chat_title(question: ChatBase) -> str:
    """
    Creates a title for the chat based on the question.

    Args:
        question (ChatBase): The question asked by the user.

    Returns:
        str: The generated title for the chat.
    """
    suffix = ''
    if len(question.question) > 21:
        suffix = "..."
    
    return question.question[:21].strip() + suffix
