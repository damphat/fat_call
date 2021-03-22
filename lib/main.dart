import 'package:fat_call/dev_button.dart';
import 'package:flutter/material.dart';

import 'auth_test/auth.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final txt = TextEditingController();

  @override
  void initState() {
    super.initState();
    auth.addListener(() {
      txt.text += '\n$auth';
    });
  }

  @override
  Widget build(BuildContext context) {
    const sep = const Divider(
      thickness: 4,
    );

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          DevButton(() async* {
            for (var i = 1; i < 5; i++) {
              if (i == 3) throw ' ba oi';
              await Future.delayed(Duration(seconds: 1));
              yield i;
            }
          }, '12345'),
          sep,
          DevButton(auth.ensureInit, 'ensureInit'),
          sep,
          DevButton(auth.signInWithGoogle, 'signInWithGoogle'),
          sep,
          DevButton(auth.signOut, 'signOut'),
          sep,
          DevButton(auth.close, 'close'),
          sep,
          DevButton(txt.clear, 'clear'),
          sep,
          Expanded(
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(border: OutlineInputBorder()),
              controller: txt,
              maxLines: 1000,
              minLines: 4,
            ),
          ),
        ],
      ),
    );
  }
}
