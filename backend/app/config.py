from pydantic import BaseSettings


class Settings(BaseSettings):
    db_driver: str
    db_host: str
    db_port: int
    db_name: str
    db_user: str
    db_pass: str
    ssl_ca: str

    class Config:
        env_file = ".env"


settings = Settings()
