from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.mall import Mall


router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/malls")
def get_malls(db: Session = Depends(get_db)):
    malls = db.query(Mall).all()

    return malls