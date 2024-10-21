from sqlalchemy import desc
from sqlalchemy.orm import Session
import uuid

from app.core.security import (
    get_password_hash,
    verify_password,
)
from app.db.models.chat import ChatDB
from app.db.models.question_answer import QuestionAnswerDB
from app.db.models.user import UserDB
from app.schemas.user import UserCreate
from app.schemas.chat import ChatContent, ChatInfo
from app.schemas.question_answer import AnswerMetadata
from app.db.models.answer_metadata import AnswerMetadataDB


def get_user(db: Session, user_id: uuid.UUID) -> UserDB | None:
    """
    Retrieve a user from the database by their user ID.

    Args:
        db (Session): The SQLAlchemy database session.
        user_id (UUID): The ID of the user to retrieve.

    Returns:
        UserDB | None: The user object if found, otherwise None.
    """
    return db.query(UserDB).filter(UserDB.id == user_id).first()


def get_user_by_email(db: Session, email: str) -> UserDB | None:
    """
    Retrieve a user from the database by their email address.

    Args:
        db (Session): The SQLAlchemy database session.
        email (str): The email address of the user to retrieve.

    Returns:
        UserDB | None: The user object if found, otherwise None.
    """
    return db.query(UserDB).filter(UserDB.email == email).first()


def create_user(db: Session, user: UserCreate) -> UserDB:
    """
    Create a new user in the database.

    Args:
        db (Session): The SQLAlchemy database session.
        user (UserCreate): The user information for the new user.

    Returns:
        UserDB: The created user object.
    """
    hashed_password = get_password_hash(user.password)
    db_user = UserDB(email=user.email, hashed_password=hashed_password, role=user.role)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def authenticate_user(db: Session, email: str, password: str) -> UserDB | None:
    """
    Authenticate a user by their email and password.

    Args:
        db (Session): The SQLAlchemy database session.
        email (str): The email address of the user.
        password (str): The password provided by the user.

    Returns:
        UserDB | None: The authenticated user object if credentials are valid, otherwise None.
    """
    db_user = get_user_by_email(db, email)
    if not db_user:
        return None
    if not verify_password(password, db_user.hashed_password):
        return None
    return db_user


def update_user_role(db: Session, db_user: UserDB, new_role: str) -> UserDB:
    """
    Update the role of an existing user.

    Args:
        db (Session): The SQLAlchemy database session.
        db_user (UserDB): The user object to update.
        new_role (str): The new role to assign to the user.

    Returns:
        UserDB: The updated user object.
    """
    db_user.role = new_role
    db.commit()
    db.refresh(db_user)
    return db_user


def create_chat(db: Session, db_user: UserDB, chat_info: ChatInfo) -> ChatDB:
    """
    Create a new chat session and add an initial question-answer pair.

    Args:
        db (Session): The SQLAlchemy database session.
        db_user (UserDB): The user object who owns the chat.
        chat_info (ChatInfo): Information about the chat and the question-answer pair.

    Returns:
        ChatDB: The created chat object.
    """
    db_chat = ChatDB(title=chat_info.title, user_id=db_user.id)
    db.add(db_chat)
    db.commit()
    db.refresh(db_chat)
    
    question_answer = QuestionAnswerDB(
        question=chat_info.question_answer.question,
        answer=chat_info.question_answer.answer,
        chat_id=db_chat.id
    )
    db.add(question_answer)
    db.commit()
    db.refresh(question_answer)

    answer_metadatas = []
    
    for metadata in chat_info.question_answer.answer_metadata: 
        new_metadata = AnswerMetadataDB(
            page_number=metadata.page_number,
            file_name=metadata.file_name,
            qa_id=question_answer.id 
        )
        answer_metadatas.append(new_metadata)

    db.add_all(answer_metadatas)
    db.commit()
    return db_chat


def add_question_answer_to_chat(db: Session, db_chat: ChatDB, chat_content: ChatContent) -> QuestionAnswerDB:
    """
    Add a new question-answer pair to an existing chat.

    Args:
        db (Session): The SQLAlchemy database session.
        db_chat (ChatDB): The chat object to which the question-answer pair will be added.
        chat_content (ChatContent): The question-answer content to add.

    Returns:
        QuestionAnswerDB: The created question-answer object.
    """
    new_db_qa = QuestionAnswerDB(
        question=chat_content.question_answer.question,
        answer=chat_content.question_answer.answer,
        chat_id=db_chat.id
    )
    db.add(new_db_qa)
    db.commit()
    db.refresh(new_db_qa)

    new_answer_metadatas = []
    
    for metadata in chat_content.question_answer.answer_metadata: 
        new_metadata = AnswerMetadataDB(
            page_number=metadata.page_number,
            file_name=metadata.file_name,
            qa_id=new_db_qa.id 
        )
        new_answer_metadatas.append(new_metadata)
    db.add_all(new_answer_metadatas)
    db.commit()
    return new_db_qa


def delete_chat(db: Session, db_chat: ChatDB) -> None:
    """
    Delete a chat session from the database.

    Args:
        db (Session): The SQLAlchemy database session.
        db_chat (ChatDB): The chat object to delete.
    """
    db.delete(db_chat)
    db.commit()


def get_all_chat_summaries(db: Session, db_user: UserDB) -> list[ChatDB]:
    """
    Retrieve all chat summaries for a specific user.

    Args:
        db (Session): The SQLAlchemy database session.
        db_user (UserDB): The user object for whom to retrieve chat summaries.

    Returns:
        list[ChatDB]: A list of chat summaries, including IDs and titles.
    """
    return db.query(ChatDB.id, ChatDB.title).filter(ChatDB.user_id == db_user.id).order_by(desc(ChatDB.created_at)).all()


def get_chat_by_id(db: Session, chat_id: uuid.UUID) -> ChatDB | None:
    """
    Retrieve a chat session from the database by its ID.

    Args:
        db (Session): The SQLAlchemy database session.
        chat_id (UUID): The ID of the chat session to retrieve.

    Returns:
        ChatDB | None: The chat object if found, otherwise None.
    """
    db_chat = db.query(ChatDB).filter(ChatDB.id == chat_id).first()
    return db_chat
