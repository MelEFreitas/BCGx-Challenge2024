from pydantic import BaseModel

class UserBase(BaseModel):
    role: str


class UserInfo(UserBase):
    email:str


class UserCreate(UserInfo):
    password: str


class UserUpdate(UserBase):
    pass

