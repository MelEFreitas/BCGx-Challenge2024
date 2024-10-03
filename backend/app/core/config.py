from secrets import token_urlsafe
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
    )
    POSTGRES_USER: str
    POSTGRES_PASSWORD: str
    POSTGRES_DB: str
    POSTGRES_HOST: str
    POSTGRES_PORT: int
    API_KEY: str
    ALGORITHM: str = "HS256"
    SECRET_KEY: str = token_urlsafe(32)
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30


settings = Settings()
