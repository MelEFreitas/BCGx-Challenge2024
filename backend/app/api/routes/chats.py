from typing import List
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.schemas.chat import ChatCreate, ChatSummary, ChatUpdate, Chat
from app.schemas.question_answer import QuestionAnswerBase
from app.api.routes.auth import get_current_user
from app.db.database import get_db
from app.db import crud
from app.db.models.user import UserDB

router = APIRouter()

@router.post("/chats", response_model=Chat, status_code=status.HTTP_201_CREATED)
def create_chat(
    chat: ChatCreate, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)
):
    db_chat = crud.create_chat(db, chat, current_user)
    return Chat(
        id=db_chat.id,
        title=db_chat.title,
        conversation=[QuestionAnswerBase(question=qa.question, answer=qa.answer) for qa in db_chat.conversation]
    )


@router.post("/chats/{chat_id}", response_model=Chat)
def add_question_answer_to_chat(
    chat_id: int, chat: ChatUpdate, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)
):
    db_chat = crud.add_question_answer_to_chat(db, chat_id, chat, current_user)
    return Chat(
        id=db_chat.id,
        title=db_chat.title,
        conversation=[QuestionAnswerBase(question=qa.question, answer=qa.answer) for qa in db_chat.conversation]
    )


@router.delete("/chats/{chat_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_chat(
    chat_id: int, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)
):
    crud.delete_chat(db, chat_id, current_user)
    return {"message": "Chat deleted successfully"}


@router.get("/chats", response_model=List[ChatSummary], status_code=status.HTTP_200_OK)
def get_all_chats(db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)):
    chat_summaries = crud.get_all_chat_summaries(db, current_user)
    return [ChatSummary(id=chat.id, title=chat.title) for chat in chat_summaries]


@router.get("/chats/{chat_id}", response_model=Chat)
def get_chat_by_id(chat_id: int, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)):
    db_chat = crud.get_chat_by_id(db, chat_id, current_user)
    return Chat(
        id=db_chat.id,
        title=db_chat.title,
        conversation=[
            QuestionAnswerBase(question=qa.question, answer=qa.answer) for qa in db_chat.conversation
        ]
    )