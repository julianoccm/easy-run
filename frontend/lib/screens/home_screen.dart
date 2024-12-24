import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/primary_button.dart';
import 'package:frontend/components/primary_title.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:frontend/entities/returns/user_info_return.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/resources/fonts.dart';
import 'package:frontend/services/race_service.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserEntityReturn? userEntity = null;
  late UserInfoReturn? userInfo = null;

  final Location _locationController = Location();

  _getLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        Navigator.pushNamed(context, '/login');
      }
    }
  }

  Future<UserEntityReturn> _loadSharedPreferencesValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPrefsJson = prefs.getString("user") ?? '';

    if (userPrefsJson == '') {
      Navigator.pushNamed(context, '/login');
    }

    UserEntityReturn userEntityReturn =
        UserEntityReturn.fromJson(jsonDecode(userPrefsJson));

    setState(() {
      userEntity = userEntityReturn;
    });

    return userEntity!;
  }

  _loadUserInfo(userid) async {
    UserInfoReturn infoReturn = await RaceService.userMonthInfo(userid);
    setState(() {
      userInfo = infoReturn;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
    _loadSharedPreferencesValue().then((value) => _loadUserInfo(value.id));
  }

  @override
  Widget build(BuildContext context) {
    if (userEntity == null || userInfo == null) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: appColors['primaryDark'],
          body: Center(
              child: CircularProgressIndicator(
                  color: appColors['primary'])
              ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: appColors['primaryDark'],
          body: Padding(
            padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryTitle(title: "Olá, ${userEntity!.name}"),
                        Text("Vamos olhar seus dados mensais?",
                            style: TextStyle(
                                color: appColors['white'],
                                fontFamily: appFonts['secondary'],
                                fontSize: 15)),
                      ],
                    ),
                    GestureDetector(
                        child: Icon(Icons.settings,
                            color: appColors['primary'], size: 30),
                        onTap: () {
                          Navigator.pushNamed(context, '/settings');
                        }),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 30)),
                Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: appColors['secondaryDark'],
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: CircularPercentIndicator(
                            radius: 60,
                            lineWidth: 10,
                            reverse: true,
                            percent: userInfo!.porcentagemMeta,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: appColors['primary'],
                            backgroundColor: const Color(0xff3C3C3C),
                            center: Text(
                                "${(userInfo!.porcentagemMeta * 100).toInt()}%",
                                style: TextStyle(
                                    color: appColors['white'],
                                    fontFamily: appFonts['montserrat'],
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Meta do mês",
                                style: TextStyle(
                                    color: appColors['grey'],
                                    fontFamily: appFonts['montserrat'],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: userInfo!.metaAtingida.toString(),
                                  style: TextStyle(
                                      color: appColors['primary'],
                                      fontWeight: FontWeight.w900,
                                      fontFamily: appFonts['montserrat'],
                                      fontSize: 34)),
                              TextSpan(
                                  text: "   / ${userInfo!.meta}",
                                  style: TextStyle(
                                      color: appColors['grey'],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: appFonts['montserrat'],
                                      fontSize: 16))
                            ])),
                            const Padding(padding: EdgeInsets.only(bottom: 20)),
                            Text("Calorias perdidas",
                                style: TextStyle(
                                    color: appColors['grey'],
                                    fontFamily: appFonts['montserrat'],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Text("${userInfo!.calorias.toStringAsFixed(2)} Cal",
                                style: TextStyle(
                                    color: appColors['white'],
                                    fontSize: 18,
                                    fontFamily: appFonts['montserrat'],
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    )),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                          color: appColors['secondaryDark'],
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Image(
                                image: AssetImage('assets/run.png'),
                                height: 60,
                                fit: BoxFit.fill),
                            const Padding(padding: EdgeInsets.only(bottom: 15)),
                            Text(
                              "Distância total",
                              style: TextStyle(
                                  color: appColors['white'],
                                  fontFamily: appFonts['montserrat'],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Padding(padding: EdgeInsets.only(bottom: 10)),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: userInfo!.distanciaTotal
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: appColors['primary'],
                                      fontWeight: FontWeight.w900,
                                      fontFamily: appFonts['montserrat'],
                                      fontSize: 25)),
                              TextSpan(
                                  text: "   Km",
                                  style: TextStyle(
                                      color: appColors['grey'],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: appFonts['montserrat'],
                                      fontSize: 16))
                            ])),
                          ]),
                    ),
                    Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                          color: appColors['secondaryDark'],
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Image(
                                image: AssetImage('assets/time.png'),
                                height: 60,
                                fit: BoxFit.fill),
                            const Padding(padding: EdgeInsets.only(bottom: 15)),
                            Text(
                              "Tempo total",
                              style: TextStyle(
                                  color: appColors['white'],
                                  fontFamily: appFonts['montserrat'],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Padding(padding: EdgeInsets.only(bottom: 10)),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: userInfo!.tempo < 60
                                      ? userInfo!.tempo.toString()
                                      : "${userInfo!.tempo ~/ 60}:${(userInfo!.tempo % 60).toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                      color: appColors['primary'],
                                      fontWeight: FontWeight.w900,
                                      fontFamily: appFonts['montserrat'],
                                      fontSize: 25)),
                              TextSpan(
                                  text:
                                      "   ${userInfo!.tempo < 60 ? "min" : "hr"}",
                                  style: TextStyle(
                                      color: appColors['grey'],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: appFonts['montserrat'],
                                      fontSize: 16))
                            ])),
                          ]),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/races');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: appColors['secondaryDark'],
                      minimumSize: const Size.fromHeight(50)),
                  child: Text(
                    "Minhas corridas",
                    style: TextStyle(
                        color: appColors['primary'],
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: appFonts['primary']),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 24),
                        child: Image(image: AssetImage('assets/runner.png')),
                      ),
                      PrimaryButton(
                          title: "Iniciar uma nova corrida",
                          onPressed: () {
                            Navigator.pushNamed(context, '/startRace');
                          })
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
