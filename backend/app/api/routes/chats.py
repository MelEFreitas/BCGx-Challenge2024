from typing import List
import uuid
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

    Args:
        chat (ChatCreate): The chat creation data.
        db (Session): The SQLAlchemy database session.
        current_user (UserDB): The currently authenticated user.

    Returns:
        Chat: The created chat object.

    Raises:
        HTTPException:
            If the access token is invalid, returns a 401 Unauthorized.
            If the access token has expired, returns a 403 Forbidden.
            If the user doesn't exist, returns a 404 Not Found.
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
    chat_id: uuid.UUID, chat: ChatUpdate, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)
) -> ChatContent:
    """
    Add the user message and the AI answer to the chat.

    Args:
        chat_id (UUID): The unique identifier of the chat to update.
        chat (ChatUpdate): The chat update data containing the user's message.
        db (Session): The SQLAlchemy database session.
        current_user (UserDB): The currently authenticated user.

    Returns:
        ChatContent: The updated chat content including the question-answer pair.
    
    Raises:
        HTTPException:
            If the access token is invalid, returns a 401 Unauthorized.
            If the access token has expired, returns a 403 Forbidden.
            If the user is not found, returns a 404 Not Found.
            If the chat is not found, return 404 Not Found.
            If the user is not authorized to update the chat, returns 403 Forbidden.
    """
    db_chat = crud.get_chat_by_id(db, chat_id)
    if db_chat is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Chat not found")
    if db_chat.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to update this chat")
    
    response = await ask_question_ai(question=chat)
    chat_content = ChatContent(question_answer=response)
    db_qa = crud.add_question_answer_to_chat(db, db_chat, chat_content)
    return chat_content


@router.delete("/chats/{chat_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_chat(
    chat_id: uuid.UUID, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)
):
    """
    Delete a chat.

    Args:
        chat_id (UUID): The unique identifier of the chat to delete.
        db (Session): The SQLAlchemy database session.
        current_user (UserDB): The currently authenticated user.

    Returns:
        dict: A dictionary containing a message if the chat deletion was successful.

    Raises:
        HTTPException: If the chat is not found or the user is not authorized to delete it.
    """
    db_chat = crud.get_chat_by_id(db, chat_id)
    if db_chat is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Chat not found")
    if db_chat.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to delete this chat")
    
    crud.delete_chat(db, db_chat)


@router.get("/chats", response_model=List[ChatSummary], status_code=status.HTTP_200_OK)
def get_all_chat_summaries(
    db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)
) -> List[ChatSummary]:
    """
    Get all the user's chat summaries.

    Args:
        db (Session): The SQLAlchemy database session.
        current_user (UserDB): The currently authenticated user.

    Returns:
        List[ChatSummary]: A list of chat summaries for the authenticated user.
    """
    chat_summaries = crud.get_all_chat_summaries(db, current_user)
    return [ChatSummary(id=chat.id, title=chat.title) for chat in chat_summaries]


@router.get("/chats/{chat_id}", response_model=Chat, status_code=status.HTTP_200_OK)
def get_chat_by_id(
    chat_id: uuid.UUID, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)
) -> Chat:
    """
    Get a user's chat by ID.

    Args:
        chat_id (UUID): The unique identifier of the chat to retrieve.
        db (Session): The SQLAlchemy database session.
        current_user (UserDB): The currently authenticated user.

    Returns:
        Chat: The requested chat object.
    
    Raises:
        HTTPException: If the chat is not found or the user is not authorized to view it.
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
