import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {

  static const String baseUrl =
      "http://127.0.0.1:8000";


  static Future<Map<String, dynamic>> getRecommendation() async {

    final response = await http.get(
      Uri.parse("$baseUrl/parking/recommend"),
    );


    if (response.statusCode == 200) {

      return json.decode(response.body);

    } else {

      throw Exception(
        "Failed to load recommendation"
      );

    }
  }
  static Future<Map<String, dynamic>> getAvailableSlots() async {

    final response = await http.get(
        Uri.parse("$baseUrl/parking/available"),
    );

    if (response.statusCode == 200) {

        return {
        "slots": json.decode(response.body)
        };

    } else {

        throw Exception(
        "Failed to load parking slots"
        );

    }
}
}