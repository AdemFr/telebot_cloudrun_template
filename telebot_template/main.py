import os

from fastapi import FastAPI

TOKEN = os.environ["TOKEN"]

app = FastAPI()


@app.get("/")
async def root():
    return {"message": TOKEN}
