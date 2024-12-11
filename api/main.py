from fastapi import FastAPI

app = FastAPI()

# needs to be prefixed with 'api'
# https://github.com/Azure/static-web-apps/issues/1585
@app.get("/api/animals")
async def root():
    return {"data": ["Tiger", "Lion", "Penguin", "Cobra"]}

