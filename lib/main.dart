import 'package:fat_call/src/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var auth = Auth();
Future<void> main() async {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

// splash (wait)
// đã signin => home | signout
// chưa signin => show button signin
// đang signin
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          if (user != null)
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL),
            )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.accents[14],
              radius: 100,
              child: Icon(
                Icons.phone_enabled_outlined,
                size: 150,
              ),
            ),
            SizedBox(height: 40),
            Text('Fat Call', textScaleFactor: 3),
            SizedBox(
              height: 150,
            ),
            if (user == null)
              ElevatedButton(
                onPressed: () {
                  auth.signInWithGoogle();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('SIGN IN WITH GOOGLE'),
                ),
              )
            else
              TextButton(
                onPressed: () {
                  auth.signOut();
                },
                child: Text('SIGN OUT'),
              )
          ],
        ),
      ),
    );
  }
}
