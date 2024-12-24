import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/entities/returns/user_entity_return.dart';
import 'package:frontend/resources/colors.dart';
import 'package:frontend/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HandleAuthScreen extends StatefulWidget {
  const HandleAuthScreen({super.key});

  @override
  State<HandleAuthScreen> createState() => _HandleAuthScreenState();
}

class _HandleAuthScreenState extends State<HandleAuthScreen> {
  @override
  void initState() {
    super.initState();
    _handleLogin();
  }

  void _handleLogin() async {
    loginWithToken();
  }

  void loginWithToken() async {
    String whereNavigate = '';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('acess_token');

    if (token == null) {
      Navigator.pushNamed(context, '/login');
    }

    UserEntityReturn userData = await LoginService.loginWithToken(token!);
    
    await prefs.setString('user', jsonEncode(userData.toJson()));
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
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
}
