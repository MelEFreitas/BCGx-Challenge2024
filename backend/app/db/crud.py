from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.core.security import (
    get_password_hash,
    verify_password,
)
from app.db.models.user import UserDB
from app.schemas.user import UserCreate
from app.db.models.chat import ChatDB
from app.db.models.question_answer import QuestionAnswerDB
from app.schemas.chat import ChatCreate, ChatUpdate


def get_user(db: Session, user_id: int) -> UserDB | None:
    return db.query(UserDB).filter(UserDB.id == user_id).first()


def get_user_by_email(db: Session, email: str) -> UserDB | None:
    return db.query(UserDB).filter(UserDB.email == email).first()


def create_user(db: Session, user: UserCreate) -> UserDB:
    hashed_password = get_password_hash(user.password)
    db_user = UserDB(email=user.email, hashed_password=hashed_password, role=user.role)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    return db_user


def authenticate_user(db: Session, email: str, password: str) -> UserDB | None:
    db_user = get_user_by_email(db, email)

    if not db_user:
        return None
    if not verify_password(password, db_user.hashed_password):
        return None
    
    return db_user


def update_user_role(db: Session, email: str, new_role: str) -> UserDB | None:
    db_user = get_user_by_email(db, email)

    if not db_user:
        return None
    db_user.role = new_role
    db.commit()
    db.refresh(db_user)

    return db_user


def create_chat(db: Session, chat: ChatCreate, user: UserDB) -> ChatDB:
    db_chat = ChatDB(title=chat.title, user_id=user.id)
    db.add(db_chat)
    db.commit()
    db.refresh(db_chat)

    question_answer = QuestionAnswerDB(
        question=chat.question_answer.question,
        answer=chat.question_answer.answer,
        chat_id=db_chat.id
    )
    db.add(question_answer)
    db.commit()
    db.refresh(question_answer)

    return db_chat


def add_question_answer_to_chat(db: Session, chat_id: int, chat: ChatUpdate, user: UserDB) -> ChatDB:
    db_chat = db.query(ChatDB).filter(ChatDB.id == chat_id).first()

    if db_chat is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Chat not found")

    if db_chat.user_id != user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to update this chat")

    new_qa = QuestionAnswerDB(
        question=chat.question_answer.question,
        answer=chat.question_answer.answer,
        chat_id=db_chat.id
    )
    db.add(new_qa)
    db.commit()
    db.refresh(new_qa)

    return db_chat


def delete_chat(db: Session, chat_id: int, user: UserDB) -> None:
    db_chat = db.query(ChatDB).filter(ChatDB.id == chat_id).first()

    if db_chat is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Chat not found")

    if db_chat.user_id != user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to delete this chat")

    db.delete(db_chat)
    db.commit()


def get_all_chat_summaries(db: Session, user: UserDB) -> list[ChatDB]:
    return db.query(ChatDB.id, ChatDB.title).filter(ChatDB.user_id == user.id).all()


def get_chat_by_id(db: Session, chat_id: int, user: UserDB) -> ChatDB:
    db_chat = db.query(ChatDB).filter(ChatDB.id == chat_id).first()

    if db_chat is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Chat not found")

    if db_chat.user_id != user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to view this chat")

    return db_chat