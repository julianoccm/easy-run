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
import 'package:frontend/services/register_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController metaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();

  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    void register() async {
      setState(() {
        errorMessage = "";
      });

      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty ||
          metaController.text.isEmpty) {
        setState(() {
          errorMessage = "Preencha todos os campos.";
        });
        return;
      } else {
        if (passwordController.text != confirmPasswordController.text) {
          setState(() {
            errorMessage = "As senhas devem ser iguais.";
          });
          return;
        }

        try {
          UserEntityReturn user = await RegisterService.register(
              nameController.text,
              emailController.text,
              passwordController.text,
              metaController.text, 
              pesoController.text);

          LoginEntityReturn loginEntity =
              await LoginService.login(user.email, user.password);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('acess_token', loginEntity.accessToken);
          await prefs.setString('user', jsonEncode(user.toJson()));

          Navigator.pushNamed(context, '/home');
        } catch (e) {
          setState(() {
            errorMessage = e.toString().substring(11);
          });
        }
      }
    }

    return Scaffold(
        backgroundColor: appColors['primaryDark'],
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const PrimaryTitle(title: 'Registre-se'),
                    const SizedBox(height: 40),
                    PrimaryTextInput(
                        controller: nameController,
                        placeholder: 'Insira seu nome'),
                    const SizedBox(height: 15),
                    PrimaryTextInput(
                        controller: emailController,
                        placeholder: 'Insira seu e-mail'),
                    const SizedBox(height: 15),
                    PrimaryTextInput(
                        controller: passwordController,
                        placeholder: 'Insira sua senha',
                        isPassword: true),
                    const SizedBox(height: 15),
                    PrimaryTextInput(
                        controller: confirmPasswordController,
                        placeholder: 'Confirme sua senha',
                        isPassword: true),
                    const SizedBox(height: 15),
                    PrimaryTextInput(
                        isNumber: true,
                        controller: metaController,
                        placeholder: 'Insira uma meta de dias'),
                    const SizedBox(height: 15),
                    PrimaryTextInput(
                        isNumber: true,
                        controller: pesoController,
                        placeholder: 'Insira seu peso'),
                    const SizedBox(height: 10),
                    Text(errorMessage,
                        style: TextStyle(
                            color: appColors['red'],
                            fontFamily: appFonts['primary'],
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                    const SizedBox(height: 10),
                    PrimaryButton(title: 'Acessar', onPressed: register),
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
                    Text("Já tem uma conta?",
                        style: TextStyle(
                            color: appColors['white'],
                            fontFamily: appFonts['secondary'],
                            fontSize: 15)),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text("Faça o login",
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
