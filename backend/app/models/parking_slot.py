from sqlalchemy import Column, Integer, String, ForeignKey
from app.database import Base


class ParkingSlot(Base):
    __tablename__ = "parking_slots"

    id = Column(Integer, primary_key=True, index=True)
    slot_number = Column(String)
    floor = Column(Integer)
    status = Column(String)

    mall_id = Column(Integer, ForeignKey("malls.id"))