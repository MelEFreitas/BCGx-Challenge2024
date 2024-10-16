import uuid
from sqlalchemy import Column, DateTime, ForeignKey, String
from sqlalchemy.dialects.postgresql import UUID 
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.db.database import Base


class ChatDB(Base):
    """
    Represents a chat session in the database.

    Attributes:
        id (UUID): The unique identifier for the chat, generated using UUID.
        title (str): The title of the chat session.
        created_at (DateTime): The timestamp when the chat was created, automatically set to the current time.
        user_id (UUID): The unique identifier of the user who owns the chat.
        user (relationship): The relationship to the `UserDB` model, representing the chat owner.
        conversation (relationship): The relationship to `QuestionAnswerDB`, representing the chat's conversation.
    """

    __tablename__ = "chats"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    title = Column(String(length=64), nullable=False)
    created_at = Column(DateTime, server_default=func.now())
    user_id = Column(UUID(as_uuid=True), ForeignKey('users.id'), nullable=False)

    user = relationship("UserDB", back_populates="chats")
    conversation = relationship("QuestionAnswerDB", back_populates="chat", cascade="all, delete-orphan")
