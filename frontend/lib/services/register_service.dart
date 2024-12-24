import 'dart:convert';

import 'package:frontend/api.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  static Future<UserEntityReturn> register(
      String name, String email, String password, String target, String peso) async {
    Uri uri = Uri.parse("$baseUrl/user");

    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password, 
          'target': target,
          'peso': peso
        }));

    if (response.statusCode == 201 && response.body.isNotEmpty) {
      return UserEntityReturn.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar o usuário.');
    }
  }
}
