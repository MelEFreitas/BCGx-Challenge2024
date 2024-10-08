from sqlalchemy.orm import Session

from app.core.security import (
    get_password_hash,
    verify_password,
)
from app.db.models.user import UserDB
from app.schemas.user import UserCreate


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