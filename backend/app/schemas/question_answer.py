import uuid
from pydantic import BaseModel


class QuestionAnswerBase(BaseModel):
    """
    Base model for a question and its corresponding answer.

    Attributes:
        question (str): The question asked by the user.
        answer (str): The answer provided for the question.
    """
    question: str
    answer: str


class QuestionAnswer(QuestionAnswerBase):
    """
    Represents a question-answer pair along with its metadata.

    Attributes:
        id (UUID): The unique identifier for the question-answer record.
        chat_id (UUID): The unique identifier of the chat session to which this question-answer pair belongs.
    """

    id: uuid.UUID
    chat_id: uuid.UUID

    class Config:
        from_attributes = True
