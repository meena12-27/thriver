from fastapi import FastAPI

from app.database import engine
from app.models.mall import Mall
from app.database import Base

from app.routes import parking
from app.routes import malls

Base.metadata.create_all(bind=engine)


app = FastAPI()


app.include_router(parking.router)
app.include_router(malls.router)

@app.get("/")
def home():
    return {
        "message": "Welcome to Thriver Backend"
    }