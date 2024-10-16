import uuid
from sqlalchemy import Column, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.database import Base


class UserDB(Base):
    """
    Represents a user in the database.

    Attributes:
        id (UUID): The unique identifier for the user, generated using UUID.
        email (str): The email address of the user, must be unique.
        hashed_password (str): The hashed password used for authentication.
        role (str): The role of the user.
        chats (relationship): A relationship to the `ChatDB` model, representing the user's chats.
    """
    
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    email = Column(String(length=64), unique=True, index=True)
    hashed_password = Column(String, nullable=False)
    role = Column(String(length=64), nullable=False)
    
    chats = relationship("ChatDB", back_populates="user")
