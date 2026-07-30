from fastapi import APIRouter

router = APIRouter()


@router.get("/parking")
def get_parking():
    return {
        "mall": "Sunrise Mall",
        "available_slots": 120,
        "floors": [
            {
                "floor": 1,
                "available": 40
            },
            {
                "floor": 2,
                "available": 80
            }
        ]
    }