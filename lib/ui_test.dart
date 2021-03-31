import 'package:fat_call/src/fire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fire = Fire();
  var logText = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.runtimeType}')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          btn('init', fire.init),
          btn('login', fire.login),
          btn('logout', fire.logout),
          btn('clear', () {
            setState(() {
              logText.clear();
            });
          }),
          for (var text in logText) Text(text),
        ],
      ),
    );
  }

  void log(String msg) {
    setState(() {
      logText.add(msg);
    });
  }

  Widget btn(String text, Function func) {
    return TextButton(
      onPressed: () {
        var ret = func();
        log('$ret');
        if (ret is Future) {
          ret
              .then((value) => log('resolve $value'))
              .catchError((err) => log('reject $err'));
        }
      },
      child: Text(text),
    );
  }
}
