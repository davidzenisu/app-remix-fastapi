from fastapi import FastAPI

app = FastAPI()


@app.get("/animals")
async def root():
    return {"data": ["Tiger", "Lion", "Penguin", "Cobra"]}

