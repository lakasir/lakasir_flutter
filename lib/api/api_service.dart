import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lakasir/Exceptions/unauthenticated.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/utils/auth.dart';

class ApiService<T> {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<T> fetchData(String endpoint) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 401) {
      logout();
      throw UnauthorizedException(jsonDecode(response.body)['message']);
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<T> postData(String endpoint, Object? request) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(request),
    );


    if (response.statusCode == 401) {
      logout();
      throw UnauthorizedException(jsonDecode(response.body)['message']);
    }

    if (response.statusCode == 422) {
      throw ValidationException(response.body);
    }

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      return json;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<T> putData(String endpoint, Object? request) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(request),
    );

    if (response.statusCode == 401) {
      logout();
      throw UnauthorizedException(jsonDecode(response.body)['message']);
    }

    if (response.statusCode == 422) {
      throw ValidationException(response.body);
    }

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      return json;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<T> deleteData(String endpoint) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 401) {
      logout();
      throw UnauthorizedException(jsonDecode(response.body)['message']);
    }

    if (response.statusCode == 400) {
      throw ValidationException(response.body);
    }

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      return json;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
