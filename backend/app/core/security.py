from typing import Any, Dict, Optional
from passlib.context import CryptContext
from datetime import datetime, timedelta, timezone
from jose import jwt
from app.core.config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    Verify if the provided plain password matches the hashed password.

    Args:
        plain_password (str): The plain text password to verify.
        hashed_password (str): The hashed password to compare against.

    Returns:
        bool: True if the password matches, False otherwise.
    """
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    """
    Hash a password using the bcrypt algorithm.

    Args:
        password (str): The plain text password to hash.

    Returns:
        str: The hashed password.
    """
    return pwd_context.hash(password)


def create_access_token(data: Dict[str, Any], expires_delta: Optional[timedelta] = None) -> str:
    """
    Create a JWT access token.

    This function encodes the given data into a JWT token, with an optional expiration time.

    Args:
        data (Dict[str, Any]): The data to encode into the JWT token.
        expires_delta (Optional[timedelta]): The expiration time for the token. If not provided, 
            defaults to `settings.ACCESS_TOKEN_EXPIRE_MINUTES`.

    Returns:
        str: The encoded JWT token if successful.
    
    Raises:
        JWTError: If the encoding fails.
    """
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt


def decode_access_token(token: str) -> Dict[str, Any]:
    """
    Decode a JWT access token.

    This function decodes the given JWT token and returns the payload. It raises exceptions
    if the token is invalid, expired, or fails to decode for any reason.

    Args:
        token (str): The JWT token to decode.

    Returns:
        Dict[str, Any]: The decoded payload if successful.

    Raises:
        JWTError: If the token is invalid or decoding fails.
        ExpiredSignatureError: If the token has expired.
        JWTClaimsError: If there is an issue with the claims in the token.
    """
    payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
    return payload
