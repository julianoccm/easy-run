import 'package:frontend/entities/returns/location_coords.dart';

class Race {
  final int id;
  final double kilometers;
  final int time;
  final double calories;
  final DateTime date;
  final int initialTime;
  final int finalTime;
  final List<LocationCoords> coords;

  Race({
    required this.id,
    required this.kilometers,
    required this.time,
    required this.calories,
    required this.date,
    required this.initialTime,
    required this.finalTime,
    required this.coords,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    double kilometers = 0.0;
    int time = json['time'];
    double calories = 0.0;
    DateTime date = DateTime.parse(json['date']);
    int initialTime = int.parse(json['initialTime'].toString());
    int finalTime = int.parse(json['finalTime'].toString());

    if (json['calories'] is! double) {
      calories = double.parse(json['calories'].toString());
    } else {
      calories = json['calories'];
    }

    if (json['kilometers'] is! double) {
      kilometers = double.parse(json['kilometers'].toString());
    } else {
      kilometers = json['kilometers'];
    }

    List<dynamic> coordsList = json['coords'];
    List<LocationCoords> coords = coordsList
        .map((coordJson) => LocationCoords.fromJson(coordJson))
        .toList();

    return Race(
      id: id,
      kilometers: kilometers,
      time: time,
      calories: calories,
      date: date,
      initialTime: initialTime,
      finalTime: finalTime,
      coords: coords,
    );
  }
    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kilometers': kilometers,
      'time': time,
      'calories': calories,
      'date': date.toIso8601String(),
      'initialTime': initialTime,
      'finalTime': finalTime,
      'coords': coords.map((coord) => coord.toJson()).toList(),
    };
  }
}
