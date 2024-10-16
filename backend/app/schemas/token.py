from pydantic import BaseModel


class Token(BaseModel):
    """
    Represents an authentication token response.

    Attributes:
        access_token (str): The JWT access token used for authenticating requests.
        refresh_token (str): The JWT refresh token used to obtain new access tokens.
        token_type (str): The type of token, typically 'bearer'.
    """
    access_token: str
    refresh_token: str
    token_type: str


class TokenData(BaseModel):
    """
    Represents the data extracted from the token payload.

    Attributes:
        email (str | None): The email associated with the token, or None if not available.
    """
    email: str | None
