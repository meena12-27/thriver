// class RecommendedParking {
//   final String slot;
//   final int floor;
//   final String zone;


//   RecommendedParking({
//     required this.slot,
//     required this.floor,
//     required this.zone,
//   });


//   factory RecommendedParking.fromJson(
//       Map<String, dynamic> json
//   ) {

//     return RecommendedParking(
//       slot: json["slot"],
//       floor: json["floor"],
//       zone: json["zone"],
//     );

//   }
// }



// class Recommendation {

//   final String mall;
//   final RecommendedParking parking;
//   final double distance;
//   final List<String> navigation;
//   final String message;


//   Recommendation({
//     required this.mall,
//     required this.parking,
//     required this.distance,
//     required this.navigation,
//     required this.message,
//   });



//   factory Recommendation.fromJson(
//       Map<String, dynamic> json
//   ) {

//     return Recommendation(

//       mall: json["mall"],

//       parking:
//           RecommendedParking.fromJson(
//             json["parking"],
//           ),

//       distance:
//           (json["distance"] as num)
//               .toDouble(),

//       navigation:
//           List<String>.from(
//             json["navigation"],
//           ),

//       message:
//           json["message"],

//     );

//   }

// }
import 'parking_slot.dart';

class Recommendation {

  final String mall;
  final ParkingSlot parking;
  final double distance;
  final List<String> navigation;
  final String message;


  Recommendation({
    required this.mall,
    required this.parking,
    required this.distance,
    required this.navigation,
    required this.message,
  });


  factory Recommendation.fromJson(
      Map<String,dynamic> json
  ){

    return Recommendation(

      mall: json["mall"],

      parking:
          ParkingSlot.fromJson(
              json["parking"]
          ),

      distance:
          (json["distance"] as num).toDouble(),

      navigation:
          List<String>.from(
              json["navigation"]
          ),

      message:
          json["message"],

    );

  }

}