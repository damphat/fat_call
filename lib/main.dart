import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var app = await Firebase.initializeApp();
  print(app);
  var user = await FirebaseAuth.instance.signInAnonymously();
  print(user);
}
