from typing import List
import uuid
from pydantic import BaseModel, Field

from app.schemas.question_answer import QuestionAnswerBase


class ChatBase(BaseModel):
    """Base model for chat operations.

    Attributes:
        question (str): The question related to the chat.
    """
    question: str


class ChatCreate(ChatBase):
    """Model for creating a new chat.

    Inherits from:
        ChatBase: Base model for chat operations.
    """
    pass


class ChatUpdate(ChatBase):
    """Model for updating an existing chat.

    Inherits from:
        ChatBase: Base model for chat operations.
    """
    pass


class ChatContent(BaseModel):
    """Model for chat content that includes a question-answer pair.

    Attributes:
        question_answer (QuestionAnswerBase): The question-answer pair for the chat.
    """
    question_answer: QuestionAnswerBase


class ChatInfo(BaseModel):
    """Model for chat information, including title and question-answer pair.

    Attributes:
        title (str): The title of the chat, with a maximum length of 64 characters.
        question_answer (QuestionAnswerBase): The question-answer pair for the chat.
    """
    title: str = Field(max_length=64)
    question_answer: QuestionAnswerBase


class ChatSummary(BaseModel):
    """Model for summarizing chat information.

    Attributes:
        id (UUID): The unique identifier for the chat.
        title (str): The title of the chat.
    """
    id: uuid.UUID
    title: str


class Chat(ChatSummary):
    """Model representing a full chat with a conversation history.

    Attributes:
        conversation (List[QuestionAnswerBase]): A list of question-answer pairs that make up the chat's conversation.
    """
    conversation: List[QuestionAnswerBase]

    class Config:
        from_attributes = True
