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
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Wrap(
            // alignment: MainAxisAlignment.center,

            children: [
              TextButton(
                  onPressed: () {
                    auth.ensureInit();
                  },
                  child: Text('ensureInit')),
              TextButton(
                  onPressed: () {
                    auth.signInWithGoogle();
                  },
                  child: Text('signInWithGoogle')),
              TextButton(
                  onPressed: () {
                    auth.signOut();
                  },
                  child: Text('signOut')),
              TextButton(
                  onPressed: () {
                    auth.close();
                  },
                  child: Text('close')),
              TextButton(
                  onPressed: () {
                    txt.clear();
                  },
                  child: Text('clear log')),
            ],
          ),
          Expanded(
            child: TextField(
              controller: txt,
              maxLines: 1000,
            ),
          ),
        ],
      ),
    );
  }
}
