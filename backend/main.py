from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.db import database
from app.api.routes import users, auth, chats

database.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(users.router)
app.include_router(auth.router)
app.include_router(chats.router)
