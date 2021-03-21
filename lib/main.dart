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
              Btn(auth.ensureInit, 'ensureInit'),
              Btn(auth.signInWithGoogle, 'signInWithGoogle'),
              Btn(auth.signOut, 'signOut'),
              Btn(auth.close, 'close'),
              Btn(txt.clear, 'clear'),
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

class Btn extends StatefulWidget {
  dynamic onPressed;
  dynamic text;

  Btn(this.onPressed, this.text);
  @override
  _BtnState createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  List<List> emits = [];
  // ignore: missing_return
  Stream<dynamic> wrap(dynamic func) async* {
    yield 'start';

    if (func == null) {
      yield 'not implemented';
      return;
    }

    if (func is Function) {
      var watch = Stopwatch();
      var ret;
      var err;
      var dur;
      try {
        watch.start();
        ret = func();
      } catch (e) {
        err = e;
      } finally {
        watch.stop();
        dur = watch.elapsed;
      }

      if (err != null) {
        yield [dur, 'throws', err];
        return;
      } else {
        yield [dur, 'return', ret];
      }

      if (ret is Future) {
        try {
          watch.start();
          ret = await ret;
        } catch (e) {
          err = e;
        } finally {
          watch.stop();
          dur = watch.elapsed;
        }

        if (err != null) {
          yield [dur, 'reject', err];
        } else {
          yield [dur, 'resolve', ret];
        }

        return;
      }

      if (ret is Stream) {
        return;
      }
    }
  }

  void exec() {
    emits = [];
    wrap(widget.onPressed).listen((event) {
      emits.add(emits);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: exec,
          child: Text(widget.text),
        ),
        for (var item in emits) Text('${item[0]}:${item[1]}:${item[2]}'),
      ],
    );
  }
}
