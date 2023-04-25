from pydantic import BaseSettings


class Settings(BaseSettings):
    db_driver: str
    db_host: str
    db_port: int
    db_name: str
    db_user: str
    db_pass: str
    ssl_ca: str
    secret_key: str
    algorithm: str
    access_token_expire_minutes: int

    class Config:
        env_file = ".env"


settings = Settings()
