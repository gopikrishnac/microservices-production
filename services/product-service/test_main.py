from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_healthz():
    response = client.get("/healthz")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

def test_get_products():
    response = client.get("/api/products")
    assert response.status_code == 200
    assert len(response.json()["products"]) >= 1