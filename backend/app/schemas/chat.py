from typing import List
from pydantic import BaseModel

from app.schemas.question_answer import QuestionAnswerBase


class ChatBase(BaseModel):
    title: str


class ChatContent(ChatBase):
    question_answer: QuestionAnswerBase


class ChatCreate(ChatContent):
    pass


class ChatUpdate(BaseModel):
    question_answer: QuestionAnswerBase


class Chat(ChatBase):
    id: int
    conversation: List[QuestionAnswerBase]

    class Config:
        from_attributes = True


class ChatSummary(ChatBase):
    id: int

    class Config:
        from_attributes = True