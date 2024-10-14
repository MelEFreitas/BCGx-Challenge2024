# from typing import List
from pydantic import BaseModel

# from app.schemas.chat import ChatSummary

class UserBase(BaseModel):
    role: str


class UserInfo(UserBase):
    email:str


class UserCreate(UserInfo):
    password: str


class UserUpdate(UserBase):
    pass


# Talvez já puxar o summaries do user quando ele logar
# class User(UserBase):
#     id: int
#     chats: List[ChatSummary]

#     class Config:
#         from_attributes = True
