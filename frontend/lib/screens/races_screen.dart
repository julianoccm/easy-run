import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/primary_title.dart';
import 'package:frontend/components/race_card.dart';
import 'package:frontend/entities/returns/race_entity_return.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/resources/fonts.dart';
import 'package:frontend/services/race_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  late List<Race>? races = null;

  _loadRaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPrefsJson = prefs.getString("user") ?? '';

    if (userPrefsJson == '') {
      Navigator.pushNamed(context, '/login');
    }

    UserEntityReturn userEntityReturn =
        UserEntityReturn.fromJson(jsonDecode(userPrefsJson));
    List<Race> list = await RaceService.userRaces(userEntityReturn.id);
    list.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      races = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRaces();
  }

  @override
  Widget build(BuildContext context) {
    if (races == null) {
      return Scaffold(
        backgroundColor: appColors['primaryDark'],
        body: Center(
            child: CircularProgressIndicator(color: appColors['primary'])
            ),
      );
    }

    if (races!.isEmpty) {
      return Scaffold(
        backgroundColor: appColors['primaryDark'],
        body: Padding(
          padding: const EdgeInsets.only(top: 55, left: 12, right: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  child: Icon(Icons.arrow_back,
                      color: appColors['primary'], size: 30),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              Expanded(
                flex: 1,
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryTitle(
                      title: "Você não possui \nnenhuma corrida.",
                      style: TextStyle(color: appColors['primary']),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("Tela inicial > Iniciar uma nova corrida",
                          style: TextStyle(
                              color: appColors['white'],
                              fontFamily: appFonts['secondary'],
                              fontSize: 15)),
                    )
                  ],
                )),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: appColors['primaryDark'],
        body: Padding(
          padding: const EdgeInsets.only(top: 55, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  child: Icon(Icons.arrow_back,
                      color: appColors['primary'], size: 30),
                  onTap: () {
                         Navigator.pushNamed(context, '/home');
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: PrimaryTitle(
                  title: "Sua última corrida",
                  style: TextStyle(color: appColors['primary']),
                ),
              ),
              RaceCard(
                horaFinal:
                    "${DateTime.fromMillisecondsSinceEpoch(races!.first.finalTime).hour}:${DateTime.fromMillisecondsSinceEpoch(races!.first.finalTime).minute}",
                horaInicial:
                    "${DateTime.fromMillisecondsSinceEpoch(races!.first.finalTime).hour}:${DateTime.fromMillisecondsSinceEpoch(races!.first.finalTime).minute}",
                kilometragem: races!.first.kilometers.toStringAsFixed(2),
                date: DateFormat('dd/MM/yyyy')
                    .format(races!.first.date)
                    .toString(),
                onPressed: () {
                  Navigator.pushNamed(context, "/details",
                      arguments: {"race": races!.first});
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: PrimaryTitle(
                  title: "Outras corridas",
                  style: TextStyle(color: appColors['primary']),
                ),
              ),
              SizedBox(
                height: 450,
                child: ListView.separated(
                  itemCount: races!.length,
                  padding: const EdgeInsets.all(0),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return RaceCard(
                        horaFinal:
                            "${DateTime.fromMillisecondsSinceEpoch(races![index].finalTime).hour}:${DateTime.fromMillisecondsSinceEpoch(races![index].finalTime).minute}",
                        horaInicial:
                            "${DateTime.fromMillisecondsSinceEpoch(races![index].initialTime).hour}:${DateTime.fromMillisecondsSinceEpoch(races![index].initialTime).minute}",
                        kilometragem: races![index].kilometers.toStringAsFixed(2),
                        date: DateFormat('dd/MM/yyyy')
                            .format(races![index].date)
                            .toString(),
                        onPressed: () {
                          Navigator.pushNamed(context, "/details",
                              arguments: {"race": races![index]});
                        });
                  },
                ),
              )
            ],
          ),
        ));
  }
}
