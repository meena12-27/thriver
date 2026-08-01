// import 'dart:convert';
// import 'package:http/http.dart' as http;


// class ApiService {

//   static const String baseUrl =
//       "http://127.0.0.1:8000";


//   static Future<Map<String, dynamic>> getRecommendation(
//     int mallId
// ) async {

//     final response = await http.get(
//       Uri.parse(
//         "$baseUrl/parking/recommend?mall_id=$mallId",
//       ),
//     );


//     if (response.statusCode == 200) {

//       return json.decode(response.body);

//     } else {

//       throw Exception(
//         "Failed to load recommendation"
//       );

//     }
//   }
// static Future<Map<String, dynamic>> getAvailableSlots(
//     int mallId
// ) async {
//     final response = await http.get(
//         Uri.parse("$baseUrl/parking/available?mall_id=$mallId"),
//     );

//     if (response.statusCode == 200) {

//         return {
//         "slots": json.decode(response.body)
//         };

//     } else {

//         throw Exception(
//         "Failed to load parking slots"
//         );

//     }
// }
// static Future<List<dynamic>> getMalls() async {

//   final response = await http.get(
//     Uri.parse("$baseUrl/malls"),
//   );


//   if (response.statusCode == 200) {

//     return json.decode(response.body);

//   } else {

//     throw Exception(
//       "Failed to load malls"
//     );

//   }
// }
// static Future<List<dynamic>> getParkingMap(
//     int mallId
// ) async {

//   final response = await http.get(
//     Uri.parse(
//       "$baseUrl/parking/map?mall_id=$mallId",
//     ),
//   );


//   if (response.statusCode == 200) {

//     return json.decode(response.body);

//   } else {

//     throw Exception(
//       "Failed to load parking map"
//     );

//   }
// }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/mall.dart';
import '../models/parking_slot.dart';
import '../models/recommendation.dart';


class ApiService {

  static const String baseUrl =
      "http://127.0.0.1:8000";



  // -----------------------------
  // Recommendation
  // -----------------------------

  static Future<Recommendation> getRecommendation(
      int mallId
  ) async {

    final response = await http.get(
      Uri.parse(
        "$baseUrl/parking/recommend?mall_id=$mallId",
      ),
    );


    if(response.statusCode == 200){

      // final data = json.decode(response.body);

      return Recommendation.fromJson(json.decode(response.body));

    }
    else{

      throw Exception(
        "Failed to load recommendation",
      );

    }

  }




  // -----------------------------
  // Available Parking Slots
  // -----------------------------

  static Future<List<ParkingSlot>> getAvailableSlots(
      int mallId
  ) async {


    final response = await http.get(
      Uri.parse(
        "$baseUrl/parking/available?mall_id=$mallId",
      ),
    );


    if(response.statusCode == 200){


      List<dynamic> data =
          json.decode(response.body);


      return data
          .map(
            (slot) =>
                ParkingSlot.fromJson(slot),
          )
          .toList();


    }
    else{

      throw Exception(
        "Failed to load parking slots",
      );

    }

  }





  // -----------------------------
  // Malls
  // -----------------------------

  static Future<List<Mall>> getMalls() async {


    final response = await http.get(
      Uri.parse(
        "$baseUrl/malls",
      ),
    );


    if(response.statusCode == 200){


      List<dynamic> data =
          json.decode(response.body);


      return data
          .map(
            (mall) =>
                Mall.fromJson(mall),
          )
          .toList();


    }
    else{

      throw Exception(
        "Failed to load malls",
      );

    }

  }





  // -----------------------------
  // Parking Map
  // -----------------------------

  static Future<List<ParkingSlot>> getParkingMap(
      int mallId
  ) async {


    final response = await http.get(
      Uri.parse(
        "$baseUrl/parking/map?mall_id=$mallId",
      ),
    );



    if(response.statusCode == 200){


      List<dynamic> data =
          json.decode(response.body);



      return data
          .map(
            (slot) =>
                ParkingSlot.fromJson(slot),
          )
          .toList();


    }
    else{

      throw Exception(
        "Failed to load parking map",
      );

    }

  }

}