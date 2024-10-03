from fastapi import FastAPI

from app.db import database
from app.api.routes import users, auth

database.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

app.include_router(users.router)
app.include_router(auth.router)
