import 'package:flutter/material.dart';
import 'package:frontend/screens/handle_auth_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/meta_screen.dart';
import 'package:frontend/screens/race_details.dart';
import 'package:frontend/screens/races_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/settings_screen.dart';
import 'package:frontend/screens/start_race_screen.dart';

var appRoutes = <String, WidgetBuilder>{
  '/auth': (context) => const HandleAuthScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/home': (context) => const HomeScreen(),
  '/races': (context) => const RaceScreen(),
  '/details': (context) => const RaceDetailsScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/meta': (context) => const MetaScreen(),
  '/startRace': (context) => const StartRaceScreen()
};
