import 'dart:convert';

import 'package:frontend/api.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<UserEntityReturn> updateTarget(int userId, int target) async {
    Uri uri = Uri.parse("${"$baseUrl/user/target/$userId"}/$target");

    final response = await http.put(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return UserEntityReturn.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Credenciais de login inválidas.');
    }
  }

  static Future<void> removeUser(int userId) async {
    Uri uri = Uri.parse("$baseUrl/user/$userId");
    await http.delete(uri);
  }
}
