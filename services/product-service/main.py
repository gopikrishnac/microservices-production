from fastapi import FastAPI

app = FastAPI(title="Product Service")

PRODUCTS = [
    {"id": 1, "name": "Cloud Architecture Guide", "price": 49.99},
    {"id": 2, "name": "Kubernetes on EC2 Handbook", "price": 29.99}
]

@app.get("/healthz")
def health_check():
    return {"status": "healthy", "service": "product-service"}

@app.get("/api/products")
def get_products():
    return {"products": PRODUCTS}