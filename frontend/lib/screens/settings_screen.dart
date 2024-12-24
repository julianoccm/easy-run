import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/primary_title.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/resources/fonts.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  _removePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('acess_token');
    await prefs.remove('user');
  }

  _deleteUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPrefsJson = prefs.getString("user") ?? '';

    if (userPrefsJson == '') {
      Navigator.pushNamed(context, '/login');
    }

    UserEntityReturn userEntityReturn =
        UserEntityReturn.fromJson(jsonDecode(userPrefsJson));

    await UserService.removeUser(userEntityReturn.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColors['primaryDark'],
        body: Padding(
          padding: const EdgeInsets.only(top: 55, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                    child: Icon(Icons.arrow_back,
                        color: appColors['primary'], size: 30),
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ),
              PrimaryTitle(
                title: "Configurações",
                style: TextStyle(color: appColors['primary']),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/meta');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: appColors['secondaryDark'],
                      minimumSize: const Size.fromHeight(50)),
                  child: Text(
                    "Configurar meta",
                    style: TextStyle(
                        color: appColors['white'],
                        fontSize: 18,
                        fontFamily: appFonts['primary']),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteUserData();
                  _removePrefs();
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: appColors['secondaryDark'],
                    minimumSize: const Size.fromHeight(50)),
                child: Text(
                  "Deletar meus dados",
                  style: TextStyle(
                      color: appColors['white'],
                      fontSize: 18,
                      fontFamily: appFonts['primary']),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _removePrefs();
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: appColors['secondaryDark'],
                              minimumSize: const Size.fromHeight(50)),
                          child: Text(
                            "Sair",
                            style: TextStyle(
                                color: appColors['primary'],
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: appFonts['primary']),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
