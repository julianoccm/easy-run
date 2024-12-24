import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/components/primary_button.dart';
import 'package:frontend/entities/returns/location_coords.dart';
import 'package:frontend/entities/returns/race_entity_return.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/resources/fonts.dart';
import 'package:frontend/services/race_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class StartRaceScreen extends StatefulWidget {
  const StartRaceScreen({super.key});

  @override
  State<StartRaceScreen> createState() => _StartRaceScreenState();
}

class _StartRaceScreenState extends State<StartRaceScreen> {
  String mapStyle = "";
  bool startRecord = false;

  LatLng? _currentPosition = null;
  var locationSubscription;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  List<LatLng> raceCoordinates = [];
  double totalDistance = 0.0;
  double speed = 0.0;
  int altitude = 0;
  int seconds = 0;
  double peso = 60;
  double calorias = 0;
  int initialTime = 0;
  int finalTime = 0;

  late DateTime startTime;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final Location _locationController = Location();

  @override
  void initState() {
    super.initState();

    loadPesoUsuario();
    loadCustomIcon();

    rootBundle.loadString('assets/map_style.json').then((string) {
      mapStyle = string;
    });

    _getLocationUpdates();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  void loadPesoUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPrefsJson = prefs.getString("user") ?? '';

    if (userPrefsJson == '') {
      Navigator.pushNamed(context, '/login');
    }

    UserEntityReturn userEntityReturn =
        UserEntityReturn.fromJson(jsonDecode(userPrefsJson));

    setState(() {
      peso = userEntityReturn.peso;
    });
  }

  void stopListening() async {
    if (locationSubscription != null) {
      locationSubscription!.cancel();
    }
  }

  void saveRace() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPrefsJson = prefs.getString("user") ?? '';

    if (userPrefsJson == '') {
      Navigator.pushNamed(context, '/login');
    }

    UserEntityReturn userEntityReturn =
        UserEntityReturn.fromJson(jsonDecode(userPrefsJson));

    List<LocationCoords> coords = [];

    for (var location in raceCoordinates) {
      coords.add(LocationCoords(
          id: 0, latitude: location.latitude, longitude: location.longitude));
    }

    Race race = await RaceService.saveRace(
        0,
        totalDistance,
        DateTime.now(),
        finalTime,
        initialTime,
        seconds ~/ 60,
        calorias,
        coords,
        userEntityReturn);

    setState(() {
      raceCoordinates = [];
      totalDistance = 0.0;
      speed = 0.0;
      altitude = 0;
      seconds = 0;
      calorias = 0;
      initialTime = 0;
      finalTime = 0;
    });

    stopListening();

    Navigator.pushNamed(context, "/details", arguments: {"race": race});
  }

  _getLocationUpdates() async {
    locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);

          if (raceCoordinates.isEmpty && startRecord) {
            raceCoordinates.add(_currentPosition!);
            _calculateDistance();
          } else {
            if (raceCoordinates.isNotEmpty) {
              if (startRecord && raceCoordinates.last != _currentPosition) {
                raceCoordinates.add(_currentPosition!);
                _calculateDistance();
              }
            }
          }

          speed = currentLocation.speed!;
          altitude = currentLocation.altitude!.toInt();
          calorias = (speed * 3.6) * peso * (0.0175 * (seconds / 60));

          print(raceCoordinates);

          _cameraToPosition(_currentPosition!);
        });
      }
    });
  }

  Set<Polyline> _createPolylines() {
    Set<Polyline> polylines = {};

    if (raceCoordinates.isNotEmpty) {
      List<LatLng> coords =
          raceCoordinates.map((e) => LatLng(e.latitude, e.longitude)).toList();

      Polyline polyline = Polyline(
        polylineId: const PolylineId('user_path'),
        color: appColors['primary']!,
        width: 5,
        points: coords,
      );

      polylines.add(polyline);
    }
    return polylines;
  }

  _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;

    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 19);

    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  void _calculateDistance() {
    if (raceCoordinates.length > 1) {
      double lat1 = raceCoordinates[raceCoordinates.length - 2].latitude;
      double lon1 = raceCoordinates[raceCoordinates.length - 2].longitude;
      double lat2 = raceCoordinates.last.latitude;
      double lon2 = raceCoordinates.last.longitude;

      double distance = _calculateDistanceBetweenPoints(lat1, lon1, lat2, lon2);
      totalDistance += distance;
    }
  }

  double _calculateDistanceBetweenPoints(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0; // Radius of Earth in kilometers

    double degToRad(double deg) {
      return deg * (math.pi / 180.0);
    }

    double dLat = degToRad(lat2 - lat1);
    double dLon = degToRad(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(degToRad(lat1)) *
            math.cos(degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    double distance = earthRadius * c;

    return distance;
  }

  loadCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/marker-big.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  void startTimer() {
    setState(() {
      startTime = DateTime.now();
      _updateTimer();
    });
  }

  void _updateTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        seconds = DateTime.now().difference(startTime).inSeconds;
        _updateTimer();
      });
    });
  }

  String formatTime(int timeInSeconds) {
    Duration duration = Duration(seconds: timeInSeconds);
    String formattedTime = "";

    if (seconds < 3600) {
      formattedTime = DateFormat('mm:ss')
          .format(DateTime(2020, 1, 1, 0, 0, 0).add(duration));
    } else {
      formattedTime = DateFormat('hh:mm')
          .format(DateTime(2020, 1, 1, 0, 0, 0).add(duration));
    }

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Scaffold(
        backgroundColor: appColors['primaryDark'],
        body: Center(
            child: CircularProgressIndicator(
                color: appColors['primary'])
            ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if(startRecord) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: appColors['primaryDark'],
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: startRecord ? 240 : 80),
              child: GoogleMap(
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                compassEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(mapStyle);
                  _mapController.complete(controller);
                },
                polylines: _createPolylines(),
                initialCameraPosition:
                    CameraPosition(target: _currentPosition!, zoom: 19),
                markers: {
                  Marker(
                      markerId: const MarkerId("user"),
                      position: _currentPosition!,
                      draggable: false,
                      icon: markerIcon),
                },
              ),
            ),
            Container(
                color: appColors['primaryDark'],
                height: startRecord ? 240 : 80,
                child: !startRecord
                    ? null
                    : Container(
                        height: 240,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 60, bottom: 60, left: 15, right: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(children: [
                                    Text(totalDistance.toStringAsFixed(2),
                                        style: TextStyle(
                                          color: appColors['white'],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: appFonts['montserrat'],
                                        )),
                                    Text("Quilômetros",
                                        style: TextStyle(
                                            color: appColors['grey'],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: appFonts['montserrat'],
                                            fontSize: 15)),
                                  ]),
                                  Column(children: [
                                    Text(speed.toStringAsFixed(2),
                                        style: TextStyle(
                                          color: appColors['white'],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: appFonts['montserrat'],
                                        )),
                                    Text("Velocidade",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: appColors['grey'],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: appFonts['montserrat'],
                                            fontSize: 15)),
                                  ]),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(children: [
                                    Text(formatTime(seconds),
                                        style: TextStyle(
                                          color: appColors['white'],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: appFonts['montserrat'],
                                        )),
                                    Text("Tempo",
                                        style: TextStyle(
                                            color: appColors['grey'],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: appFonts['montserrat'],
                                            fontSize: 15)),
                                  ]),
                                  Column(children: [
                                    Text("$altitude m",
                                        style: TextStyle(
                                          color: appColors['white'],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: appFonts['montserrat'],
                                        )),
                                    Text("Altitude",
                                        style: TextStyle(
                                            color: appColors['grey'],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: appFonts['montserrat'],
                                            fontSize: 15)),
                                  ]),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(children: [
                                    Text(calorias.toInt().toString(),
                                        style: TextStyle(
                                          color: appColors['white'],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: appFonts['montserrat'],
                                        )),
                                    Text("Calorias",
                                        style: TextStyle(
                                            color: appColors['grey'],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: appFonts['montserrat'],
                                            fontSize: 15)),
                                  ]),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
            Padding(
              padding: EdgeInsets.only(
                  bottom: startRecord ? 220 : 40, left: 20, right: 20),
              child: PrimaryButton(
                  title: startRecord ? "Finalizar" : "Iniciar",
                  onPressed: () {
                    setState(() {
                      if (startRecord) {
                        finalTime = DateTime.now().millisecondsSinceEpoch;
                        startRecord = false;
                        saveRace();
                      } else {
                        startRecord = true;
                        initialTime = DateTime.now().millisecondsSinceEpoch;
                        startTimer();
                      }
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
