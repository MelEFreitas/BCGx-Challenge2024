import uuid
from sqlalchemy import Column, DateTime, ForeignKey, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.db.database import Base


class QuestionAnswerDB(Base):
    """
    Represents a question and answer pair in a chat session.

    Attributes:
        id (UUID): The unique identifier for the question-answer record, generated using UUID.
        question (str): The question asked by the user.
        answer (str): The answer provided for the question.
        created_at (DateTime): The timestamp when the question-answer pair was created, automatically set to the current time.
        chat_id (UUID): The unique identifier of the chat session to which this question-answer pair belongs.
        chat (relationship): The relationship to the `ChatDB` model, representing the chat session.
    """

    __tablename__ = "question_answers"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    question = Column(String, nullable=False)
    answer = Column(String, nullable=False)
    created_at = Column(DateTime, server_default=func.now())
    chat_id = Column(UUID(as_uuid=True), ForeignKey('chats.id', ondelete="CASCADE"), nullable=False)
    
    chat = relationship("ChatDB", back_populates="conversation")
