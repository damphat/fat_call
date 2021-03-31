import 'package:fat_call/src/ui/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SplashScreen()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate);
  }
}
