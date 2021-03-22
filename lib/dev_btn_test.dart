import 'dart:async';

import 'package:fat_call/dev_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

stream1() {
  // ignore: close_sinks
  var c = StreamController();
  c.add(1);
  c.add(2);
  c.addError(3);
  c.add(4);
  c.addError(5);
  c.close();
  return c.stream;
}

stream2() async* {
  for (var i = 0; i < 5; i++) {
    yield i;
    await Future.delayed(Duration(seconds: 1));
    if (i == 3) throw null;
  }
}

var div = const Divider(
  height: 4,
);
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            DevButton(null, 'null'),
            div,
            DevButton(() => Future.error('an error'), 'Future.error()'),
            div,
            DevButton(() => Future.value('a value'), 'Future.value()'),
            div,
            DevButton(stream1, 'stream1'),
            div,
            DevButton(stream2, 'stream2'),
          ],
        ),
      ),
    ),
  );
}
