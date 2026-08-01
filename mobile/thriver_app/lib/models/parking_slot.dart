// class ParkingSlot {
//   final int id;
//   final String slotNumber;
//   final int floor;
//   final String status;
//   final String zone;
//   final int xCoordinate;
//   final int yCoordinate;
//   final int mallId;


//   ParkingSlot({
//     required this.id,
//     required this.slotNumber,
//     required this.floor,
//     required this.status,
//     required this.zone,
//     required this.xCoordinate,
//     required this.yCoordinate,
//     required this.mallId,
//   });


//   factory ParkingSlot.fromJson(Map<String, dynamic> json) {
//     return ParkingSlot(
//       id: json["id"],
//       slotNumber: json["slot_number"],
//       floor: json["floor"],
//       status: json["status"],
//       zone: json["zone"],
//       xCoordinate: json["x_coordinate"],
//       yCoordinate: json["y_coordinate"],
//       mallId: json["mall_id"],
//     );
//   }
// }

class ParkingSlot {

  final String slotNumber;
  final int floor;
  final String status;
  final String zone;

  final int xCoordinate;
  final int yCoordinate;


  ParkingSlot({

    required this.slotNumber,
    required this.floor,
    required this.status,
    required this.zone,
    required this.xCoordinate,
    required this.yCoordinate,

  });



factory ParkingSlot.fromJson(
    Map<String,dynamic> json
){

return ParkingSlot(

slotNumber:
    json["slot_number"] ??
    json["slot"],


floor:
    json["floor"] ?? 0,


status:
    json["status"] ?? "unknown",


zone:
    json["zone"] ?? "",


xCoordinate:
    json["x"] ?? 0,


yCoordinate:
    json["y"] ?? 0,


);

}


}