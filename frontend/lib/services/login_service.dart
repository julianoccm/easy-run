import 'dart:convert';

import 'package:frontend/api.dart';
import 'package:frontend/entities/returns/login_entity_return.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<LoginEntityReturn> login(String email, String password) async {
    Uri uri = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': email, 'password': password}));

    if (response.statusCode == 201 && response.body.isNotEmpty) {
      return LoginEntityReturn.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Credenciais de login inválidas.');
    }
  }

  static Future<UserEntityReturn> loginWithToken(String token) async {
    Uri uri = Uri.parse("$baseUrl/auth/token");

    print(token);

    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'token': token}));

    if (response.statusCode == 201 && response.body.isNotEmpty) {
      return UserEntityReturn.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Credenciais de login inválidas.');
    }
  }
}
