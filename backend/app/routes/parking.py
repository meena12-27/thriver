from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import SessionLocal
from app.models.parking_slot import ParkingSlot


router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

from fastapi import Query

@router.get("/parking/available")
def get_available_slots(
    mall_id: int = Query(1),
    db: Session = Depends(get_db)
):

    slots = (
        db.query(ParkingSlot)
        .filter(
            ParkingSlot.status == "available",
            ParkingSlot.mall_id == mall_id
        )
        .all()
    )

    return slots

# @router.get("/parking/recommend")
# def recommend_slot(db: Session = Depends(get_db)):

#     slot = (
#         db.query(ParkingSlot)
#         .filter(ParkingSlot.status == "available")
#         .order_by(ParkingSlot.floor.asc())
#         .first()
#     )

#     if not slot:
#         return {
#             "message": "No parking available"
#         }

#     return {
#         "recommended_slot": slot.slot_number,
#         "floor": slot.floor,
#         "reason": "Closest available parking slot"
#     }

import math

from fastapi import Query

@router.get("/parking/recommend")
def recommend_slot(
    mall_id: int = Query(1),
    db: Session = Depends(get_db)
):

    user_x = 0
    user_y = 0

    slots = (
        db.query(ParkingSlot)
        .filter(
            ParkingSlot.status == "available",
            ParkingSlot.mall_id == mall_id
        )
        .all()
    )

    if not slots:
        return {
            "message": "No parking available"
        }

    nearest_slot = None
    shortest_distance = float("inf")

    for slot in slots:
        distance = math.sqrt(
            (slot.x_coordinate - user_x) ** 2 +
            (slot.y_coordinate - user_y) ** 2
        )

        if distance < shortest_distance:
            shortest_distance = distance
            nearest_slot = slot

    return {
    "mall": nearest_slot.mall.name,
    "parking": {
        "slot": nearest_slot.slot_number,
        "floor": nearest_slot.floor,
        "zone": nearest_slot.zone
    },
    "distance": round(shortest_distance, 2),
    "navigation": [
        "Enter main entrance",
        f"Go to Floor {nearest_slot.floor}",
        f"Park at Slot {nearest_slot.slot_number}"
    ],
    "message": f"Your recommended parking slot is {nearest_slot.slot_number}"
}