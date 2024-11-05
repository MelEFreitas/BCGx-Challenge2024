from secrets import token_urlsafe
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """
    Configuration settings for the application.

    This class reads environment variables and defines various 
    configuration values for database access, authentication, 
    and external API integration.

    Attributes:
        POSTGRES_USER (str): Username for the PostgreSQL database.
        POSTGRES_PASSWORD (str): Password for the PostgreSQL database.
        POSTGRES_DB (str): Name of the PostgreSQL database.
        POSTGRES_HOST (str): Host address for the PostgreSQL database.
        POSTGRES_PORT (int): Port number for the PostgreSQL database.
        OPENAI_API_KEY (str): API key for accessing OpenAI services.
        ALGORITHM (str): Encryption algorithm for token signing.
        SECRET_KEY (str): Secret key for signing tokens (generated securely).
        ACCESS_TOKEN_EXPIRE_MINUTES (int): Expiration time (in minutes) for access tokens.
        REFRESH_TOKEN_EXPIRE_DAYS (int): Expiration time (in days) for refresh tokens.
    """

    model_config = SettingsConfigDict(
        env_file="../.env",
    )
    POSTGRES_USER: str
    POSTGRES_PASSWORD: str
    POSTGRES_DB: str
    POSTGRES_HOST: str
    POSTGRES_PORT: int
    OPENAI_API_KEY: str
    ALGORITHM: str = "HS256"
    SECRET_KEY: str = token_urlsafe(32)
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7


settings = Settings()
