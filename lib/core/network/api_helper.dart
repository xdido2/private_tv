import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthHttp {
  // static const String baseUrl = "http://127.0.0.1:8000";
  static const String baseUrl = "http://172.20.10.6:8000";

  static void Function()? onUnauthorized;

  static Future<http.Response> request(
    String path, {
    String method = "GET",
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool authRequired = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? access = prefs.getString("access");
    String? refresh = prefs.getString("refresh");

    final uri = Uri.parse("$baseUrl$path");

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      ...?headers,
    };

    if (authRequired && access != null) {
      requestHeaders["Authorization"] = "Bearer $access";
    }

    http.Response response;

    if (method == "POST") {
      response = await http.post(
        uri,
        headers: requestHeaders,
        body: jsonEncode(body),
      );
    } else {
      response = await http.get(uri, headers: requestHeaders);
    }

    if ((response.statusCode == 401 || response.statusCode == 403) &&
        refresh != null &&
        authRequired) {
      final refreshResponse = await http.post(
        Uri.parse("$baseUrl/users/refresh/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": refresh}),
      );

      if (refreshResponse.statusCode == 200) {
        final data = jsonDecode(refreshResponse.body);
        final newAccess = data["access"];

        await prefs.setString("access", newAccess);
        requestHeaders["Authorization"] = "Bearer $newAccess";

        if (method == "POST") {
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: jsonEncode(body),
          );
        } else {
          response = await http.get(uri, headers: requestHeaders);
        }
      } else {
        onUnauthorized?.call();
      }
    }

    return response;
  }

  static Future<http.Response> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse("$baseUrl/users/login/");
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    return response;
  }

  static Future<http.Response> register({
    required String username,
    required String password,
    required String password2,
  }) async {
    final uri = Uri.parse("$baseUrl/users/register/");
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "password2": password2,
      }),
    );

    return response;
  }
}
