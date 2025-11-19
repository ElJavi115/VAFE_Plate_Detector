import os 
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    LOCAL_USER = os.getenv("DB_USER", "admin")
    LOCAL_PASSWORD = os.getenv("DB_PASSWORD", "admin123")
    LOCAL_HOST = os.getenv("DB_HOST", "db")
    LOCAL_PORT = os.getenv("DB_PORT", "5432")
    LOCAL_NAME = os.getenv("DB_NAME", "placas_db")

    DATABASE_URL = f"postgresql+psycopg2://{LOCAL_USER}:{LOCAL_PASSWORD}@{LOCAL_HOST}:{LOCAL_PORT}/{LOCAL_NAME}"
else:
    if DATABASE_URL.startswith("postgres://"):
        DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql+psycopg2://", 1)

engine = create_engine(DATABASE_URL, echo=False, future=True)

SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)

Base = declarative_base()