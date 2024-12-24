import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/routes.dart';

void main() {
  runApp(const EasyRunApp());
}

class EasyRunApp extends StatelessWidget {
  const EasyRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Remove status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      title: 'Easy Run',
      initialRoute: '/auth',
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
