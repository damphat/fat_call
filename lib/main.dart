import 'package:flutter/material.dart';

import 'auth_test/auth.dart';
import 'package:sprintf/sprintf.dart';

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
      thickness: 5,
    );

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Btn(auth.ensureInit, 'ensureInit'),
          sep,
          Btn(auth.signInWithGoogle, 'signInWithGoogle'),
          sep,
          Btn(auth.signOut, 'signOut'),
          sep,
          Btn(auth.close, 'close'),
          sep,
          Btn(txt.clear, 'clear'),
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

class Btn extends StatefulWidget {
  dynamic onPressed;
  dynamic text;

  Btn(this.onPressed, this.text);
  @override
  _BtnState createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  List<Emit> emits = [];
  // ignore: missing_return
  Stream<Emit> wrap(dynamic func) async* {
    if (func == null) {
      yield Emit(value: 'not implemented');
      return;
    }

    if (func is Function) {
      var watch = Stopwatch();
      var ret;
      var err;
      int dur;
      try {
        watch.start();
        ret = func();
      } catch (e) {
        err = e;
      } finally {
        watch.stop();
        dur = watch.elapsedMilliseconds;
      }

      if (err != null) {
        yield Emit(dur: dur, kind: 'throws', value: err);
        return;
      } else {
        yield Emit(dur: dur, kind: 'return', value: ret);
      }

      if (ret is Future) {
        try {
          watch.start();
          ret = await ret;
        } catch (e) {
          err = e;
        } finally {
          watch.stop();
          dur = watch.elapsedMilliseconds;
        }

        if (err != null) {
          yield Emit(dur: dur, kind: 'reject', value: err);
        } else {
          yield Emit(dur: dur, kind: 'resolve', value: ret);
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
      emits.add(event);
      setState(() {});
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
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) => Text('${emits[i]}'),
          separatorBuilder: (_, i) => Divider(),
          itemCount: emits.length,
        )
      ],
    );
  }
}

class Emit {
  int dur;
  String kind;
  Object value;
  Emit({this.dur, this.kind, this.value});

  @override
  String toString() {
    return sprintf('%s:%s:%s', [dur, kind, value]);
  }
}
