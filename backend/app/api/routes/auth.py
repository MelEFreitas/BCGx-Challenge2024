from fastapi import APIRouter, Depends, HTTPException, status, Request
from jose.exceptions import ExpiredSignatureError, JWTClaimsError, JWTError
from sqlalchemy.orm import Session
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import timedelta

from app.schemas.token import Token
from app.db import crud
from app.core.security import decode_access_token, create_access_token
from app.db.database import get_db
from app.core.config import settings
from app.db.models.user import UserDB

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

@router.post("/token", response_model=Token)
def sign_in_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)
):
    """
    Authenticate user and issue access and refresh tokens.

    Args:
        form_data (OAuth2PasswordRequestForm): OAuth2 form data with username and password.
        db (Session): SQLAlchemy database session.

    Returns:
        dict: A dictionary containing the access token, refresh token, and token type.

    Raises:
        HTTPException:
            If authentication fails (incorrect email or password), returns a 401 Unauthorized.
            If the creation of access token fails, returns a 500 Internal Server Error.
            If the creation of refresh token fails, returns a 500 Internal Server Error.
    """
    user = crud.authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    try:
        access_token = create_access_token(
            data={"sub": user.email}, expires_delta=access_token_expires
        )
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create the access token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    refresh_token_expires = timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
    try:
        refresh_token = create_access_token(
            data={"sub": user.email}, expires_delta=refresh_token_expires
        )
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create the refresh token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }

@router.post("/token/refresh", response_model=Token)
def refresh_access_token(
    request: Request, db: Session = Depends(get_db)
):
    """
    Refresh an access token using the refresh token.

    Args:
        request (Request): FastAPI request object containing headers with the refresh token.
        db (Session): SQLAlchemy database session.

    Returns:
        dict: A dictionary containing the new access token, refresh token, and token type.

    Raises:
        HTTPException:
            If the refresh token is missing or invalid, returns a 401 Unauthorized.
            If the refresh token has expired, returns a 403 Forbidden.
            If the user doesn't exist, returns a 404 Not Found.
            If the creation of access token fails, returns a 500 Internal Server Error.
    """
    token = request.headers.get("Authorization")
    if not token or not token.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing refresh token"
        )

    refresh_token = token.split(" ")[1]

    try:
        payload = decode_access_token(refresh_token)
    except (JWTError, JWTClaimsError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
        )
    except ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Refresh token has expired.",
        )

    email = payload.get("sub")
    user = crud.get_user_by_email(db, email=email)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    try:
        new_access_token = create_access_token(
            data={"sub": user.email}, expires_delta=access_token_expires
        )
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create the access token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return {
        "access_token": new_access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }

def get_current_user(
    token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)
) -> UserDB:
    """
    Validate the access token and retrieve the current user.

    Args:
        token (str): The OAuth2 access token provided by the client.
        db (Session): SQLAlchemy database session.

    Returns:
        UserDB: The authenticated user instance.

    Raises:
        HTTPException:
            If the access token is invalid, returns a 401 Unauthorized.
            If the access token has expired, returns a 403 Forbidden.
            If the user doesn't exist, returns a 404 Not Found.
    """
    try:
        payload = decode_access_token(token)
    except ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access token has expired. Please refresh your token.",
        )
    except (JWTError, JWTClaimsError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
        )

    email = payload.get("sub")
    user = crud.get_user_by_email(db, email=email)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return user
