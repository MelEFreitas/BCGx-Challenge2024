from app.schemas.question_answer import QuestionAnswerBase
from app.schemas.chat import ChatBase

from openai import OpenAI
client = OpenAI()

async def ask_question_ai(question: ChatBase) -> QuestionAnswerBase:
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "You are an expert in earth and climate and environment preservation"},
            {
                "role": "user",
                "content": question.question
            }
        ]
    )
    answer = response.choices[0].message.content
    return QuestionAnswerBase(question=question.question, answer=answer)

# from langchain.chains.llm import LLMChain
# from langchain.chains.conversational_retrieval.base import ConversationalRetrievalChain
# from langchain.memory import CombinedMemory, ConversationSummaryMemory, ConversationEntityMemory
# from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
# from langchain.schema import SystemMessage, AIMessage, HumanMessage
# from langchain_community.embeddings import OpenAIEmbeddings
# from langchain_community.vectorstores import FAISS
# from langchain_core.output_parsers import StrOutputParser
# from langchain_openai import ChatOpenAI, OpenAI
# import tiktoken

# from app.schemas.chat import ChatBase

# faiss_index_path = "app/api/routes/faiss_index"

# instructions = """
#     You are a knowledgeable assistant. Answer the questions based on the ongoing conversation.
# """

# qa_system_prompt = """
#     You are a climate crisis specialist. Use the following context from retrieved documents to answer the user's question.

#     Context: {context}

#     Question: {question}
# """

# general_question_prompt_template = """
#     Você é um assistente treinado para identificar o tipo de pergunta. Diga apenas "Geral" se a pergunta for uma questão genérica e não precisa consultar documentos, ou "Específica" se a pergunta precisar de informações detalhadas de uma base de dados.

#     Pergunta: {question}

#     Classificação:
# """

# llm = ChatOpenAI(temperature=0.5)
# embeddings = OpenAIEmbeddings()
# faiss = FAISS.load_local(faiss_index_path, embeddings, allow_dangerous_deserialization=True)
# retriever = faiss.as_retriever(search_type="similarity_score_threshold", search_kwargs={"score_threshold": 0.8}, search_limit=5)
# summary_memory = ConversationSummaryMemory(llm=OpenAI(), memory_key="summary_history")
# entity_memory = ConversationEntityMemory(llm=OpenAI(), memory_key="entity_info")
# memory = CombinedMemory(memories=[summary_memory, entity_memory])

# question_maker_prompt = ChatPromptTemplate(
#     [
#         ("system", instructions),
#         MessagesPlaceholder(variable_name="chat_history"),
#         ("human", "{question}"),
#     ]
# )

# question_chain = LLMChain(
#     llm=llm,
#     prompt=question_maker_prompt,
#     memory=memory
# )

# qa_prompt = ChatPromptTemplate.from_template(qa_system_prompt)

# retriever_chain = ConversationalRetrievalChain.from_llm(
#     llm=llm,
#     retriever=retriever,
#     return_source_documents=True 
# )

# rag_chain = (
#     retriever_chain
#     | qa_prompt
#     | llm
#     | StrOutputParser()
# )

# question_classifier_prompt = ChatPromptTemplate.from_template(general_question_prompt_template)

# classification_chain = LLMChain(
#     llm=llm,
#     prompt=question_classifier_prompt
# )

# chat_history = [
#     SystemMessage(content="You're a helpful assistant")
# ]

# def detect_question_type(self, question: str) -> str:
#     """
#     Usa o LLM para classificar a pergunta como 'geral' ou 'específica'.
#     """
#     result = self.classification_chain.invoke({"question": question})
#     return result["text"].strip().lower()


# def handle_general_question(self, question: str):
#     """
#     Processa perguntas gerais (não precisam de contexto de documentos).
#     """
    
#     ai_message = self.llm.predict(f"Pergunta: {question}")
    
#     self.chat_history.extend([HumanMessage(content=question), AIMessage(content=ai_message)])
#     return ai_message, None, self.chat_history


# def handle_specific_question(self, question: str):
#     """
#     Processa perguntas específicas, buscando documentos relevantes e respondendo com base neles.
#     """
#     context = self.retriever.get_relevant_documents(question)
#     encoding = tiktoken.encoding_for_model("gpt-4o")

#     total_tokens = sum(len(encoding.encode(str(c))) for c in context[0])
    
#     ai_message = self.rag_chain.invoke({
#         "question": question,
#         "context": context[0],
#         "chat_history": self.chat_history
#     })

#     self.chat_history.extend([HumanMessage(content=question), AIMessage(content=ai_message)])
#     return ai_message, context, self.chat_history
    

# def ask_question_ai(self, question: str):    
#     question_type = self.detect_question_type(question)
    
#     if question_type == "geral":
#         return self.handle_general_question(question)
    
#     elif question_type == "específica":
#         return self.handle_specific_question(question)
    

def create_chat_title(question: ChatBase) -> str:
    """
    Create the chat title.
    """
    return question.question[:21].strip() + "..."