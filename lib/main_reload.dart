import 'dart:async';

import 'package:flutter/material.dart';

int count = 2; //
void begin(String msg) {
  print('${' ' * count ?? 0}$msg');
  count += 2;
}

void end() {
  count -= 2;
}

List<_HomeState> state = [];

void main(List<String> args) {
  begin('main function');
  runApp(
    MaterialApp(
      home: Home2(),
    ),
  );
  end();
}

class Home2 extends StatefulWidget {
  Home2() {
    begin('$runtimeType()');
    end();
  }
  @override
  _HomeState createState() {
    try {
      begin('$runtimeType.createState()');
      return _HomeState();
    } finally {
      end();
    }
  }
}

class _HomeState extends State<Home2> {
  int count = 0;
  int u = 4;
  _HomeState() {
    state.add(this);
    begin('$runtimeType()');
    end();
  }

  // void inc(x) {
  //   setState(() {
  //     count = count + 2;
  //   });
  // }

  @override
  void initState() {
    try {
      begin('$runtimeType.initState()');
      void inc(x) {
        setState(() {
          count = count + 10;
        });
      }

      Timer.periodic(Duration(seconds: 8), inc);
      super.initState();
    } finally {
      end();
    }
  }

  @override
  void dispose() {
    try {
      begin('$runtimeType.dispose()');
      super.dispose();
    } finally {
      end();
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      begin('$runtimeType.build()');
      return Container(
        child: TextX('$count !!'),
      );
    } finally {
      end();
    }
  }
}

class TextX extends StatefulWidget {
  final String txt;
  TextX(this.txt) {
    begin('$runtimeType($txt)');
    end();
  }

  @override
  _TextXState createState() {
    try {
      begin('$runtimeType.createState()');
      return _TextXState();
    } finally {
      end();
    }
  }
}

class _TextXState extends State<TextX> {
  _TextXState() {
    begin('$runtimeType()');
    end();
  }
  @override
  Widget build(BuildContext context) {
    try {
      begin('$runtimeType.build()');
      return Text(widget.txt + 'xxx');
    } finally {
      end();
    }
  }
}
