from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional

from pydantic.types import conint


class PostBase(BaseModel):
    title: str
    body: str


class PostCreate(PostBase):
    pass


class UserOut(BaseModel):
    user_id: int
    username: str
    email: EmailStr
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True


class Post(PostBase):
    post_id: int
    created_at: datetime
    updated_at: datetime
    user_id: int
    user: UserOut

    class Config:
        orm_mode = True


class PostOut(BaseModel):
    Post: Post
    likes: int

    class Config:
        orm_mode = True


class UserCreate(BaseModel):
    username: str
    email: EmailStr
    password: str


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    id: Optional[str] = None


class Like(BaseModel):
    post_id: int
    dir: conint(le=1)


class LikeCount(BaseModel):
    count: int
