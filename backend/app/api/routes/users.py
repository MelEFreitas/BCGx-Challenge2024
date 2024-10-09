from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.schemas.user import UserBase, UserCreate, UserUpdate
from app.api.routes.auth import get_current_user
from app.db import crud
from app.db.database import get_db
from app.db.models.user import UserDB

router = APIRouter()

@router.post("/users", response_model=UserBase, status_code=status.HTTP_201_CREATED)
async def create_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    
    if db_user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already registered")
    created_user = crud.create_user(db=db, user=user)

    return UserBase(email=created_user.email, role=created_user.role)


@router.get("/users/me", response_model=UserBase)
def read_current_user(current_user: UserDB = Depends(get_current_user)):
    return UserBase(email=current_user.email, role=current_user.role)


@router.post("/users/me/role", response_model=UserBase)
def update_user_role(user: UserUpdate, db: Session = Depends(get_db), current_user: UserDB = Depends(get_current_user)):
    if not user.role:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Role cannot be empty")
    updated_user = crud.update_user_role(db=db, email=current_user.email, new_role=user.role)
    
    if not updated_user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return UserBase(email=updated_user.email, role=updated_user.role)
