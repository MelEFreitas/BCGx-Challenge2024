from fastapi import APIRouter, Depends, HTTPException, Request
from pydantic import ValidationError
from sqlalchemy.orm import Session

from app.schemas.user import User, UserBase, UserCreate
from app.api.routes.auth import get_current_user
from app.db import crud
from app.db.database import get_db

router = APIRouter()

@router.post("/users", response_model=UserBase)
async def create_user(user: UserCreate, request: Request, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    created_user = crud.create_user(db=db, user=user)
    return UserBase(email=created_user.email, role=created_user.role)


@router.get("/users/me", response_model=UserBase)
def read_current_user(current_user: User = Depends(get_current_user)):
    return UserBase(email=current_user.email, role=current_user.role)

@router.patch("/users/me/role", response_model=UserBase)
def update_user_role(new_role: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    if not new_role:
        raise HTTPException(status_code=400, detail="Role cannot be empty")
    updated_user = crud.update_user_role(db=db, email=current_user.email, new_role=new_role)
    
    if not updated_user:
        raise HTTPException(status_code=404, detail="User not found")
    return UserBase(email=updated_user.email, role=updated_user.role)
