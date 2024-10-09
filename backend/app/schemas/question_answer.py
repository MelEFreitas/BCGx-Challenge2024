from pydantic import BaseModel


class QuestionAnswerBase(BaseModel):
    question: str
    answer: str

class QuetionAnswer(QuestionAnswerBase):
    id: int
    chat_id: int

    class Config:
        from_attributes = True