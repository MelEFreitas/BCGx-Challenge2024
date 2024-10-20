import uuid
from sqlalchemy import UUID, Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from app.db.database import Base

class AnswerMetadataDB(Base):
    """
    Database model for storing metadata about the answers provided by the AI.

    Attributes:
        id (UUID): Unique identifier for each metadata entry.
        page_number (str): The page number where the relevant information was found (optional).
        file_name (str): The file name from which the relevant information was retrieved (optional).
        qa_id (UUID): Foreign key linking to the corresponding question-answer pair.
        question_answer (QuestionAnswerDB): Relationship to the QuestionAnswerDB model.
    """
    __tablename__ = "answer_metadatas"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    page_number = Column(String(length=63), nullable=True)
    file_name = Column(String(length=255), nullable=True)
    qa_id = Column(UUID(as_uuid=True), ForeignKey('question_answers.id', ondelete="CASCADE"), nullable=False)

    question_answer = relationship("QuestionAnswerDB", back_populates="answer_metadatas")
