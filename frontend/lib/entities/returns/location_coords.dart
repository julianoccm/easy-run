class LocationCoords {
  final int id;
  final double latitude;
  final double longitude;
  // final int raceId;

  LocationCoords({
    required this.id,
    required this.latitude,
    required this.longitude,
    // required this.raceId
  });

  factory LocationCoords.fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    double latitude = json['latitude'];
    double longitude = json['longitude'];
    // int raceId = json['raceId'];

    return LocationCoords(
      id: id,
      latitude: latitude,
      longitude: longitude,
      // raceId: raceId
    );
  }

    Map<String, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        // 'raceId': raceId
      };
}