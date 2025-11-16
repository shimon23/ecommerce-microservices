from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import uvicorn

app = FastAPI(
    title="Product Service",
    description="E-commerce Product Management API",
    version="1.0.0"
)

# In-memory database (נחליף ב-PostgreSQL אחר כך)
products_db = []
next_id = 1

# Models
class Product(BaseModel):
    name: str
    price: float
    stock: int

class ProductResponse(Product):
    id: int

# Health check endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "product-service"}

# Get all products
@app.get("/api/products", response_model=List[ProductResponse])
async def get_products():
    return products_db

# Get product by ID
@app.get("/api/products/{product_id}", response_model=ProductResponse)
async def get_product(product_id: int):
    product = next((p for p in products_db if p["id"] == product_id), None)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

# Create product
@app.post("/api/products", response_model=ProductResponse, status_code=201)
async def create_product(product: Product):
    global next_id
    new_product = {
        "id": next_id,
        "name": product.name,
        "price": product.price,
        "stock": product.stock
    }
    products_db.append(new_product)
    next_id += 1
    return new_product

# Update product
@app.put("/api/products/{product_id}", response_model=ProductResponse)
async def update_product(product_id: int, product: Product):
    for i, p in enumerate(products_db):
        if p["id"] == product_id:
            products_db[i] = {
                "id": product_id,
                "name": product.name,
                "price": product.price,
                "stock": product.stock
            }
            return products_db[i]
    raise HTTPException(status_code=404, detail="Product not found")

# Delete product
@app.delete("/api/products/{product_id}", status_code=204)
async def delete_product(product_id: int):
    for i, p in enumerate(products_db):
        if p["id"] == product_id:
            products_db.pop(i)
            return
    raise HTTPException(status_code=404, detail="Product not found")

# Seed initial data
@app.on_event("startup")
async def startup_event():
    global next_id
    if not products_db:
        initial_products = [
            {"id": 1, "name": "Laptop", "price": 999.99, "stock": 50},
            {"id": 2, "name": "Mouse", "price": 29.99, "stock": 200},
            {"id": 3, "name": "Keyboard", "price": 79.99, "stock": 150},
        ]
        products_db.extend(initial_products)
        next_id = 4

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)