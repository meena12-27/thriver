# import random
# import time

# from sqlalchemy.orm import Session

# from backend.app.database import SessionLocal
# from backend.app.models.parking_slot import ParkingSlot
import sys
import os
import random
import time

sys.path.append(
    os.path.abspath(
        os.path.join(os.path.dirname(__file__), "../backend")
    )
)

from app.database import SessionLocal
from app.models.mall import Mall
from app.models.parking_slot import ParkingSlot
from sqlalchemy.orm import Session

def update_parking_status():

    db: Session = SessionLocal()

    slots = db.query(ParkingSlot).all()

    if slots:
        slot = random.choice(slots)

        if slot.status == "available":
            slot.status = "occupied"
        else:
            slot.status = "available"

        db.commit()

        print(
            f"{slot.slot_number} changed to {slot.status}"
        )

    db.close()


while True:
    update_parking_status()
    time.sleep(10)