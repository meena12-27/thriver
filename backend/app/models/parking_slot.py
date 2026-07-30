from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base


class ParkingSlot(Base):
    __tablename__ = "parking_slots"

    id = Column(Integer, primary_key=True, index=True)
    slot_number = Column(String)
    floor = Column(Integer)
    status = Column(String)

    zone = Column(String)
    
    x_coordinate = Column(Integer)
    y_coordinate = Column(Integer)

    mall_id = Column(Integer, ForeignKey("malls.id"))

    mall = relationship("Mall", back_populates="parking_slots")