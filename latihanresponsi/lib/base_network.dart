import 'dart:async';
import 'dart:convert';
import 'package:logger/web.dart';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";
  static final _logger = Logger();

  static Future<Map<String, dynamic>> getAll(String path) async {
    final uri = Uri.parse("$_baseUrl/$path");
    _logger.i("GET ALL : $uri");

    try {
      final response = await http.get(uri).timeout(Duration(seconds: 10));
      _logger.i("Response: ${response.statusCode}");
      _logger.t("Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        _logger.e("Error : ${response.statusCode}");
        throw Exception("Server Error : ${response.statusCode}");
      }
    } on TimeoutException {
      _logger.e("Request time out to $uri");
      throw Exception("Request Timed out");
    } catch (e) {
      _logger.e("Error fetching data from $uri : $e");
      throw Exception("Error fetching data: $e");
    }
  }

  static Future<Map<String, dynamic>> getDetail(String id) async {
    final uri = Uri.parse("$_baseUrl/detail/$id");
    _logger.i("GET DETAIL : $uri");

    try {
      final response = await http.get(uri).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load detail");
      }
    } catch (e) {
      throw Exception("Error fetching detail: $e");
    }
  }
}
