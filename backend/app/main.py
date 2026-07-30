# from fastapi import FastAPI

# app = FastAPI()


# @app.get("/")
# def home():
#     return {
#         "message": "Welcome to Thriver Backend"
#     }

from fastapi import FastAPI
from app.routes import parking

app = FastAPI()

app.include_router(parking.router)


@app.get("/")
def home():
    return {
        "message": "Welcome to Thriver Backend"
    }