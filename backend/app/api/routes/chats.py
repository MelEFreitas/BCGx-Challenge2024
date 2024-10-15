from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.schemas.chat import ChatContent, ChatCreate, ChatInfo, ChatSummary, ChatUpdate, Chat
from app.schemas.question_answer import QuestionAnswerBase
from app.api.routes.auth import get_current_user
from app.db.database import get_db
from app.db import crud
from app.db.models.user import UserDB
from app.api.routes.utils import ask_question_ai, create_chat_title

router = APIRouter()

@router.post("/chats", response_model=Chat, status_code=status.HTTP_201_CREATED)
async def create_chat(
    chat: ChatCreate, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)
) -> Chat:
    """
    Create a new chat.
    """
    title = create_chat_title(question=chat)
    response = await ask_question_ai(question=chat)
    chat_info = ChatInfo(title=title, question_answer=response)
    db_chat = crud.create_chat(db, current_user, chat_info)
    return Chat(
        id=db_chat.id,
        title=db_chat.title,
        conversation=[QuestionAnswerBase(question=qa.question, answer=qa.answer) for qa in db_chat.conversation]
    )


@router.post("/chats/{chat_id}", response_model=ChatContent, status_code=status.HTTP_200_OK)
async def add_question_answer_to_chat(
    chat_id: int, chat: ChatUpdate, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)
) -> ChatContent:
    """
    Add the user message and the ai answer to the chat.
    """
    response = await ask_question_ai(question=chat)
    chat_content =  ChatContent(question_answer=response)
    db_chat = crud.get_chat_by_id(db, chat_id)
    if db_chat is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Chat not found")
    if db_chat.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to update this chat")
    db_qa = crud.add_question_answer_to_chat(db, db_chat, chat_content)
    return db_qa


@router.delete("/chats/{chat_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_chat(
    chat_id: int, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)
):
    """
    Delete a chat.
    """
    db_chat = crud.get_chat_by_id(db, chat_id)
    if db_chat is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Chat not found")
    if db_chat.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to delete this chat")
    crud.delete_chat(db, db_chat)
    return


@router.get("/chats", response_model=List[ChatSummary], status_code=status.HTTP_200_OK)
def get_all_chat_summaries(db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)) -> List[ChatSummary]:
    """
    Get all the user's chat summaries.
    """
    chat_summaries = crud.get_all_chat_summaries(db, current_user)
    return [ChatSummary(id=chat.id, title=chat.title) for chat in chat_summaries]


@router.get("/chats/{chat_id}", response_model=Chat, status_code=status.HTTP_200_OK)
def get_chat_by_id(chat_id: int, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)) -> Chat:
    """
    Get a user's chat by id.
    """
    db_chat = crud.get_chat_by_id(db, chat_id)
    if db_chat is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Chat not found")
    if db_chat.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to view this chat")
    return Chat(
        id=db_chat.id,
        title=db_chat.title,
        conversation=[
            QuestionAnswerBase(question=qa.question, answer=qa.answer) for qa in db_chat.conversation
        ]
    )