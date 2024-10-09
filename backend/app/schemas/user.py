from typing import List
from pydantic import BaseModel

from app.schemas.chat import ChatBase


class UserBase(BaseModel):
    email: str
    role: str

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    role: str

class User(UserBase):
    id: int
    chats: List[ChatBase]

    class Config:
        from_attributes = True
