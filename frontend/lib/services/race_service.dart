import 'dart:convert';

import 'package:frontend/api.dart';
import 'package:frontend/entities/returns/location_coords.dart';
import 'package:frontend/entities/returns/race_entity_return.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:frontend/entities/returns/user_info_return.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RaceService {
  static Future<UserInfoReturn> userMonthInfo(int userId) async {
    Uri uri = Uri.parse("$baseUrl/race/user/month/$userId");

    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      print(response.body);

      return UserInfoReturn.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao pegar informações do usuário');
    }
  }

  static Future<List<Race>> userRaces(int userId) async {
    Uri uri = Uri.parse("$baseUrl/race/user/$userId");

    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<Race> races = List.empty();

      List<dynamic> maps = jsonDecode(response.body);
      races = maps.map((race) => Race.fromJson(race)).toList();

      return races;
    } else {
      throw Exception('Erro ao pegar informações do usuário');
    }
  }

  static Future<void> deleteRace(int raceId) async {
    Uri uri = Uri.parse("$baseUrl/race/$raceId");
    await http.delete(uri);
  }

  static Future<Race> saveRace(
      int id,
      double km,
      DateTime date,
      int finalTime,
      int initialTime,
      int time,
      double calories,
      List<LocationCoords> coords,
      UserEntityReturn user) async {
    Uri uri = Uri.parse("$baseUrl/race");

    List<Map<String, dynamic>> jsonList =
        coords.map((location) => location.toJson()).toList();

    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id': id,
          'user': jsonEncode(user.toJson()),
          'kilometers': km,
          'time': time,
          'calories': calories,
          'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(date),
          'initialTime': initialTime,
          'finalTime': finalTime,
          'coords': jsonEncode(jsonList)
        }));

    if (response.statusCode == 201 && response.body.isNotEmpty) {
      return Race.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao pegar informações do usuário');
    }
  }
}
