from typing import List
import uuid
from pydantic import BaseModel

class AnswerMetadata(BaseModel):
    """
    Metadata model with three named fields.
    
    Attributes:
        page_number (str): The number of the page where the answer was taken from.
        file_name (str): The name of the document that contained the answer.
    """
    page_number: str | None
    file_name: str | None


class QuestionAnswerBase(BaseModel):
    """
    Base model for a question and its corresponding answer.

    Attributes:
        question (str): The question asked by the user.
        answer (str): The answer provided for the question.
        metadata (Metadata): Metadata about the document that the LLM used to provide the answer to the question.
    """
    question: str
    answer: str
    answer_metadata: List[AnswerMetadata] = []


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