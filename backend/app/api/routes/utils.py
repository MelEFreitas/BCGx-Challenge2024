from openai import OpenAI

# from app.core.config import settings
from app.schemas.chat import ChatBase
from app.schemas.question_answer import QuestionAnswerBase

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
    
def create_chat_title(question: ChatBase) -> str:
    return question.question[:21].strip() + "..."