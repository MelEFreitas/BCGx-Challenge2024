from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.schemas.user import UserCreate, UserInfo, UserUpdate
from app.api.routes.auth import get_current_user
from app.db import crud
from app.db.database import get_db
from app.db.models.user import UserDB

router = APIRouter()

@router.post("/users", response_model=UserInfo, status_code=status.HTTP_201_CREATED)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    """
    Create a new user.
    """
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already registered")
    created_user = crud.create_user(db=db, user=user)
    return UserInfo(email=created_user.email, role=created_user.role)


@router.get("/users/me", response_model=UserInfo, status_code=status.HTTP_200_OK)
def read_current_user(current_user: UserDB = Depends(get_current_user)):
    """
    Get informations abou the current user.
    """
    return UserInfo(email=current_user.email, role=current_user.role)


@router.post("/users/me/role", response_model=UserInfo, status_code=status.HTTP_200_OK)
def update_user_role(user: UserUpdate, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)):
    """
    Update a user's role.
    """
    if not user.role:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Role cannot be empty")
    db_user = crud.get_user_by_email(db, current_user.email)
    if not db_user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    updated_user = crud.update_user_role(db=db, email=current_user.email, new_role=user.role)
    return UserInfo(email=updated_user.email, role=updated_user.role)
