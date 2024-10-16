from pydantic import BaseModel, Field


class UserBase(BaseModel):
    """
    Base model for user data.

    Attributes:
        role (str): The role of the user, with a maximum length of 64 characters.
    """
    role: str = Field(max_length=64)


class UserInfo(UserBase):
    """
    Model for representing basic user information.

    Attributes:
        email (str): The email address of the user, with a maximum length of 64 characters.
    """
    email: str = Field(max_length=64)


class UserCreate(UserInfo):
    """
    Model for creating a new user.

    Attributes:
        password (str): The password for the user, with a minimum length of 8 and a maximum length of 64 characters.
    """
    password: str = Field(min_length=8, max_length=64)


class UserUpdate(UserBase):
    """
    Model for updating user information.

    This class inherits from `UserBase` and can be used for updating a user's role.
    """
    pass
