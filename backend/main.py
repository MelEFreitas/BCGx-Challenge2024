from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.db import database
from app.api.routes import users, auth

database.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this to your frontend URL if needed
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

app.include_router(users.router)
app.include_router(auth.router)
