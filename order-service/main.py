from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import httpx
import os
import uvicorn
from datetime import datetime

app = FastAPI(
    title="Order Service",
    description="E-commerce Order Management API",
    version="1.0.0"
)

# Configuration - URL של Product Service
PRODUCT_SERVICE_URL = os.getenv("PRODUCT_SERVICE_URL", "http://localhost:8000")

# In-memory database
orders_db = []
next_id = 1

# Models
class OrderItem(BaseModel):
    product_id: int
    quantity: int

class Order(BaseModel):
    items: List[OrderItem]
    customer_email: str

class OrderResponse(BaseModel):
    id: int
    items: List[OrderItem]
    customer_email: str
    total_price: float
    status: str
    created_at: str

# Health check
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "order-service",
        "product_service_url": PRODUCT_SERVICE_URL
    }

# Get all orders
@app.get("/api/orders", response_model=List[OrderResponse])
async def get_orders():
    return orders_db

# Get order by ID
@app.get("/api/orders/{order_id}", response_model=OrderResponse)
async def get_order(order_id: int):
    order = next((o for o in orders_db if o["id"] == order_id), None)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return order

# Create order - הפונקציה החשובה!
@app.post("/api/orders", response_model=OrderResponse, status_code=201)
async def create_order(order: Order):
    global next_id
    
    # בדיקה שכל המוצרים קיימים ויש מלאי
    total_price = 0.0
    
    async with httpx.AsyncClient() as client:
        for item in order.items:
            try:
                # קריאה ל-Product Service
                response = await client.get(
                    f"{PRODUCT_SERVICE_URL}/api/products/{item.product_id}",
                    timeout=5.0
                )
                
                if response.status_code == 404:
                    raise HTTPException(
                        status_code=400,
                        detail=f"Product {item.product_id} not found"
                    )
                
                response.raise_for_status()
                product = response.json()
                
                # בדיקת מלאי
                if product["stock"] < item.quantity:
                    raise HTTPException(
                        status_code=400,
                        detail=f"Insufficient stock for product {item.product_id}. Available: {product['stock']}, Requested: {item.quantity}"
                    )
                
                # חישוב מחיר
                total_price += product["price"] * item.quantity
                
            except httpx.RequestError as e:
                raise HTTPException(
                    status_code=503,
                    detail=f"Product service unavailable: {str(e)}"
                )
    
    # יצירת ההזמנה
    new_order = {
        "id": next_id,
        "items": [item.dict() for item in order.items],
        "customer_email": order.customer_email,
        "total_price": round(total_price, 2),
        "status": "pending",
        "created_at": datetime.now().isoformat()
    }
    
    orders_db.append(new_order)
    next_id += 1
    
    return new_order

# Update order status
@app.patch("/api/orders/{order_id}/status")
async def update_order_status(order_id: int, status: str):
    valid_statuses = ["pending", "confirmed", "shipped", "delivered", "cancelled"]
    
    if status not in valid_statuses:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid status. Must be one of: {valid_statuses}"
        )
    
    for order in orders_db:
        if order["id"] == order_id:
            order["status"] = status
            return order
    
    raise HTTPException(status_code=404, detail="Order not found")

# Delete order
@app.delete("/api/orders/{order_id}", status_code=204)
async def delete_order(order_id: int):
    for i, order in enumerate(orders_db):
        if order["id"] == order_id:
            orders_db.pop(i)
            return
    raise HTTPException(status_code=404, detail="Order not found")

# Seed data
@app.on_event("startup")
async def startup_event():
    global next_id
    if not orders_db:
        sample_order = {
            "id": 1,
            "items": [
                {"product_id": 1, "quantity": 1},
                {"product_id": 2, "quantity": 2}
            ],
            "customer_email": "customer@example.com",
            "total_price": 1059.97,
            "status": "pending",
            "created_at": datetime.now().isoformat()
        }
        orders_db.append(sample_order)
        next_id = 2
    
    print(f"Order Service started. Product Service URL: {PRODUCT_SERVICE_URL}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)