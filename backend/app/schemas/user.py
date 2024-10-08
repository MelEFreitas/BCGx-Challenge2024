from pydantic import BaseModel


class UserBase(BaseModel):
    email: str
    role: str


class UserCreate(UserBase):
    password: str


class User(UserBase):
    id: int

    class Config:
        from_attributes = True
