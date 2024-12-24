import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/primary_button.dart';
import 'package:frontend/components/primary_text_input.dart';
import 'package:frontend/components/primary_title.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/resources/fonts.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MetaScreen extends StatefulWidget {
  const MetaScreen({super.key});

  @override
  State<MetaScreen> createState() => _MetaScreenState();
}

class _MetaScreenState extends State<MetaScreen> {
  TextEditingController metaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _updateTarget() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userPrefsJson = prefs.getString("user") ?? '';

      if (userPrefsJson == '') {
        Navigator.pushNamed(context, '/login');
      }

      UserEntityReturn userEntityReturn =
          UserEntityReturn.fromJson(jsonDecode(userPrefsJson));

      UserEntityReturn entityReturn = await UserService.updateTarget(
          userEntityReturn.id, int.parse(metaController.value.text));

      await prefs.remove('user');
      await prefs.setString('user', jsonEncode(entityReturn.toJson()));
      Navigator.pushNamed(context, '/home');
    }

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
                title: "Minha meta",
                style: TextStyle(color: appColors['primary']),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        "Defina a quantidade de dias por mês que deseja correr",
                        style: TextStyle(
                            color: appColors['white'],
                            fontFamily: appFonts['secondary'],
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 80,
                          child: PrimaryTextInput(
                              controller: metaController,
                              placeholder: "0",
                              isNumber: true),
                        ),
                        PrimaryTitle(
                          title: " Dias",
                          style: TextStyle(color: appColors['primary']),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: PrimaryButton(
                    title: "Salvar",
                    onPressed: () {
                      _updateTarget();
                    }),
              )
            ],
          ),
        ));
  }
}
