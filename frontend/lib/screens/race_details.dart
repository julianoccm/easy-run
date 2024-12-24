import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/components/primary_title.dart';
import 'package:frontend/entities/returns/location_coords.dart';
import 'package:frontend/entities/returns/race_entity_return.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/resources/fonts.dart';
import 'package:frontend/services/race_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class RaceDetailsScreen extends StatefulWidget {
  const RaceDetailsScreen({super.key});

  @override
  State<RaceDetailsScreen> createState() => _RaceDetailsScreenState();
}

class _RaceDetailsScreenState extends State<RaceDetailsScreen> {
  String mapStyle = "";

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.json').then((string) {
      mapStyle = string;
    });
  }

  Set<Polyline> _createPolylines(List<LocationCoords> raceCoordinates) {
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

  @override
  Widget build(BuildContext context) {
    _deleteRace(id) async {
      RaceService.deleteRace(id);
      Navigator.pushNamed(context, '/races');
    }

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    Race race = arguments["race"];

    return Scaffold(
      backgroundColor: appColors['primaryDark'],
      body: Padding(
        padding: const EdgeInsets.only(top: 55, left: 12, right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                  child: Icon(Icons.arrow_back,
                      color: appColors['primary'], size: 30),
                  onTap: () {
                     Navigator.pushNamed(context, '/races');
                  }),
            ),
            PrimaryTitle(
              title: "Sua última corrida",
              style: TextStyle(color: appColors['primary']),
            ),
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        Text(race.kilometers.toStringAsFixed(2),
                            style: TextStyle(
                              color: appColors['white'],
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: appFonts['montserrat'],
                            )),
                        Text("Quilômetros",
                            style: TextStyle(
                                color: appColors['grey'],
                                fontWeight: FontWeight.bold,
                                fontFamily: appFonts['montserrat'],
                                fontSize: 18)),
                      ]),
                      Column(children: [
                        Text(race.calories.toStringAsFixed(2),
                            style: TextStyle(
                              color: appColors['white'],
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: appFonts['montserrat'],
                            )),
                        Text("Calorias",
                            style: TextStyle(
                                color: appColors['grey'],
                                fontWeight: FontWeight.bold,
                                fontFamily: appFonts['montserrat'],
                                fontSize: 18)),
                      ]),
                      Column(children: [
                        Text(
                            "${DateTime.fromMillisecondsSinceEpoch(race.initialTime, isUtc: true).toLocal().hour}:${(DateTime.fromMillisecondsSinceEpoch(race.initialTime, isUtc: true).minute % 60).toString().padLeft(2, '0')}",
                            style: TextStyle(
                              color: appColors['white'],
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: appFonts['montserrat'],
                            )),
                        Text("Hora inicial",
                            style: TextStyle(
                                color: appColors['grey'],
                                fontWeight: FontWeight.bold,
                                fontFamily: appFonts['montserrat'],
                                fontSize: 18))
                      ]),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
                    child: Container(
                      width: 2,
                      color: appColors['primary'],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        Text(
                            race.time < 60
                                ? race.time.toString()
                                : "${race.time ~/ 60}:${(race.time % 60).toString().padLeft(2, '0')}",
                            style: TextStyle(
                              color: appColors['white'],
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: appFonts['montserrat'],
                            )),
                        Text("Tempo (${race.time < 60 ? "min)" : "hr)"}",
                            style: TextStyle(
                                color: appColors['grey'],
                                fontWeight: FontWeight.bold,
                                fontFamily: appFonts['montserrat'],
                                fontSize: 18)),
                      ]),
                      Column(children: [
                        Text(DateFormat('dd/MM').format(race.date).toString(),
                            style: TextStyle(
                              color: appColors['white'],
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: appFonts['montserrat'],
                            )),
                        Text("Data",
                            style: TextStyle(
                                color: appColors['grey'],
                                fontWeight: FontWeight.bold,
                                fontFamily: appFonts['montserrat'],
                                fontSize: 18)),
                      ]),
                      Column(children: [
                        Text(
                            "${DateTime.fromMillisecondsSinceEpoch(race.initialTime, isUtc: true).toLocal().hour}:${(DateTime.fromMillisecondsSinceEpoch(race.finalTime, isUtc: true).minute % 60).toString().padLeft(2, '0')}",
                            style: TextStyle(
                              color: appColors['white'],
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: appFonts['montserrat'],
                            )),
                        Text("Hora final",
                            style: TextStyle(
                                color: appColors['grey'],
                                fontWeight: FontWeight.bold,
                                fontFamily: appFonts['montserrat'],
                                fontSize: 18))
                      ]),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: PrimaryTitle(
                title: "Seu percurso",
                style: TextStyle(color: appColors['primary']),
              ),
            ),
            Container(
              height: 230,
              width: 400,
              child: GoogleMap(
                zoomControlsEnabled: true,
                scrollGesturesEnabled: true,
                compassEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(mapStyle);
                },
                polylines: _createPolylines(race.coords),
                initialCameraPosition: CameraPosition(
                    target: LatLng(race.coords.first.latitude,
                        race.coords.first.longitude),
                    zoom: 13.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: ElevatedButton(
                onPressed: () {
                  _deleteRace(race.id);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: appColors['secondaryDark'],
                    minimumSize: const Size.fromHeight(50)),
                child: Text(
                  "Excluir corrida",
                  style: TextStyle(
                      color: appColors['primary'],
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: appFonts['primary']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
