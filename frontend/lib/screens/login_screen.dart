import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/primary_button.dart';
import 'package:frontend/components/primary_text_input.dart';
import 'package:frontend/components/primary_title.dart';
import 'package:frontend/entities/returns/login_entity_return.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/resources/fonts.dart';
import 'package:frontend/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loginWithToken();
  }

  void loginWithToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('acess_token');

    if (token == null) {
      return;
    }

    UserEntityReturn userData = await LoginService.loginWithToken(token);

    await prefs.setString('user', jsonEncode(userData.toJson()));
    Navigator.pushNamed(context, '/home');
  }

  void login() async {
    setState(() {
      errorMessage = "";
    });

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = "Preencha todos os campos.";
      });
      return;
    } else {
      try {
        LoginEntityReturn loginEntity = await LoginService.login(
            emailController.text, passwordController.text);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('acess_token', loginEntity.accessToken);
        await prefs.setString('user', jsonEncode(loginEntity.userEntityReturn));

        Navigator.pushNamed(context, '/home');
      } catch (e) {
        setState(() {
          errorMessage = e.toString().substring(11);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColors['primaryDark'],
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const PrimaryTitle(title: 'Login'),
                    const SizedBox(height: 40),
                    PrimaryTextInput(
                        controller: emailController,
                        placeholder: 'Insira seu e-mail'),
                    const SizedBox(height: 15),
                    PrimaryTextInput(
                        controller: passwordController,
                        placeholder: 'Insira sua senha',
                        isPassword: true),
                    const SizedBox(height: 10),
                    Text(errorMessage,
                        style: TextStyle(
                            color: appColors['red'],
                            fontFamily: appFonts['primary'],
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                    const SizedBox(height: 10),
                    PrimaryButton(title: 'Acessar', onPressed: login)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Não tem uma conta?",
                        style: TextStyle(
                            color: appColors['white'],
                            fontFamily: appFonts['secondary'],
                            fontSize: 15)),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text("Registre-se",
                          style: TextStyle(
                              color: appColors['white'],
                              fontFamily: appFonts['secondary'],
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline)),
                    )
                  ]),
            )
          ],
        ));
  }
}
