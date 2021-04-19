import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Flutter screen size'),
      ),
      body: Builder(
        builder: (context) {
          var size = MediaQuery.of(context).size;
          var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
          var psize = size * devicePixelRatio;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('size: $size'),
              Divider(),
              Text('devicePixelRatio: $devicePixelRatio'),
              Divider(),
              Text('physic size: $psize'),
            ],
          );
        },
      ),
    ),
  ));
}
