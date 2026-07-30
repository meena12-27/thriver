import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {

  static const String baseUrl =
      "http://127.0.0.1:8000";


  static Future<Map<String, dynamic>> getRecommendation(
    int mallId
) async {

    final response = await http.get(
      Uri.parse(
        "$baseUrl/parking/recommend?mall_id=$mallId",
      ),
    );


    if (response.statusCode == 200) {

      return json.decode(response.body);

    } else {

      throw Exception(
        "Failed to load recommendation"
      );

    }
  }
static Future<Map<String, dynamic>> getAvailableSlots(
    int mallId
) async {
    final response = await http.get(
        Uri.parse("$baseUrl/parking/available?mall_id=$mallId"),
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
static Future<List<dynamic>> getMalls() async {

  final response = await http.get(
    Uri.parse("$baseUrl/malls"),
  );


  if (response.statusCode == 200) {

    return json.decode(response.body);

  } else {

    throw Exception(
      "Failed to load malls"
    );

  }
}
}