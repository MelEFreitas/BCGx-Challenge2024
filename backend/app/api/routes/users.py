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

    This endpoint allows for the creation of a new user by passing in user details.
    It checks if the email is already registered and raises an error if so.

    Args:
        user (UserCreate): The user details required to create a new user.
        db (Session): The database session used for accessing the database.

    Returns:
        UserInfo: The created user's information including email and role.

    Raises:
        HTTPException: If the email is already registered, returns a 400 Bad Request.
    """
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already registered")
    created_user = crud.create_user(db=db, user=user)
    return UserInfo(email=created_user.email, role=created_user.role)


@router.get("/users/me", response_model=UserInfo, status_code=status.HTTP_200_OK)
def read_current_user(current_user: UserDB = Depends(get_current_user)):
    """
    Get information about the current authenticated user.

    This endpoint retrieves information about the current user, such as email and role.

    Args:
        current_user (UserDB): The current authenticated user.

    Returns:
        UserInfo: The current user's information including email and role.

    Raises:
        HTTPException:
            If the access token is invalid, returns a 401 Unauthorized.
            If the access token has expired, returns a 403 Forbidden.
            If the user doesn't exist, returns a 404 Not Found.
    """
    return UserInfo(email=current_user.email, role=current_user.role)


@router.post("/users/me/role", response_model=UserInfo, status_code=status.HTTP_200_OK)
def update_user_role(
    user: UserUpdate, 
    db: Session = Depends(get_db), 
    current_user: UserDB = Depends(get_current_user)
):
    """
    Update the role of the current user.

    This endpoint allows updating the role of the currently authenticated user.
    The role cannot be empty, and the user must be found in the database.

    Args:
        user (UserUpdate): The new role details to be updated.
        db (Session): The database session used for accessing the database.
        current_user (UserDB): The current authenticated user.

    Returns:
        UserInfo: The updated user's information, including the updated role.

    Raises:
        HTTPException:
            If the access token is invalid, returns a 401 Unauthorized.
            If the access token has expired, returns a 403 Forbidden.
            If the user is not found, returns a 404 Not Found.
            If the role is empty, returns a 400 Bad Request.
    """
    if not user.role:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Role cannot be empty")
    db_user = crud.get_user_by_email(db, current_user.email)
    if not db_user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    updated_user = crud.update_user_role(db=db, db_user=current_user, new_role=user.role)
    return UserInfo(email=updated_user.email, role=updated_user.role)
