from typing import List
from pydantic import BaseModel

from app.schemas.question_answer import QuestionAnswerBase


class ChatBase(BaseModel):
    question: str


class ChatCreate(ChatBase):
    pass


class ChatUpdate(ChatBase):
    pass


class ChatContent(BaseModel):
    question_answer: QuestionAnswerBase


class ChatInfo(BaseModel):
    title: str
    question_answer: QuestionAnswerBase

    
class ChatSummary(BaseModel):
    id: int
    title: str


class Chat(ChatSummary):
    conversation: List[QuestionAnswerBase]

    class Config:
        from_attributes = True
