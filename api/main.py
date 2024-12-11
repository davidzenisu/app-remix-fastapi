from fastapi import APIRouter, FastAPI

app = FastAPI(
    docs_url="/api/docs",
    openapi_url="/api/openapi.json",
)

# needs to be prefixed with 'api'
# https://github.com/Azure/azure-functions-python-worker/issues/1310
api_router = APIRouter(prefix="/api")

@api_router.get("/animals")
async def root():
    return {"data": ["Tiger", "Lion", "Penguin", "Cobra"]}

app.include_router(api_router)