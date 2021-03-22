import 'dart:async';

import 'package:flutter/material.dart';

// TODO lỗi layout
// TODO tách Stream<_Emit> _exec(future)
// TODO json5
// TODO coloring
// TODO future hoặc stream không kết thúc
// TODO default icon
// TODO bung dạng animation
// TODO \t là 1 khoản trắng trong android, hoặc một ô vuông trên web

class DevButton extends StatefulWidget {
  final Function func;
  final String text;

  DevButton(this.func, this.text);
  @override
  _DevButtonState createState() => _DevButtonState();
}

class _DevButtonState extends State<DevButton> {
  bool showLog = true;
  // multiple executing of the input function
  int running = 0;
  List<_Emit> logs = [];

  void exec() {
    // only clear emits if not running
    if (running == 0) logs = [];
    running++;
    setState(() {});

    _execAndReturnStream(widget.func).listen((event) {
      logs.add(event);
      setState(() {});
    }, onDone: () {
      running--;
      setState(() {});
    }, onError: (err) {
      assert(false, 'never');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: exec,
                icon: running > 0
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(),
                      )
                    : Icon(Icons.play_arrow),
                label: Text(widget.text),
              ),
            ),
            Positioned(
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.clear_all_sharp),
                    onPressed: () {
                      logs = [];
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      showLog ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      showLog = !showLog;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showLog)
          for (var e in logs)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 16, left: 16),
              child: RichText(
                text: TextSpan(
                  text: '',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: e.kindName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: e.color),
                    ),
                    TextSpan(text: '(${e.dur}ms)\t\t'),
                    TextSpan(text: '${e.value}'),
                  ],
                ),
              ),
            )
      ],
    );
  }
}

enum X {
  notFunc,
  returns,
  throws,
  resolve,
  reject,
  onData,
  onError,
  onDone,
}

class _Emit {
  int dur;
  X kind;
  Object value;
  String get kindName {
    return kind?.toString()?.split('.')[1];
  }

  Color get color {
    switch (kind) {
      case X.notFunc:
      case X.throws:
      case X.reject:
      case X.onError:
        return Colors.red;
      case X.resolve:
      case X.onData:
        return Colors.green;
      default:
        return null;
    }
  }

  _Emit({this.dur, this.kind, this.value});

  @override
  String toString() {
    return '$dur:$kind:$value';
  }
}

Stream<_Emit> _execStream(Stream<Object> stream) {
  // ignore: close_sinks
  var controller = StreamController<_Emit>();
  var watch = Stopwatch();
  watch.start();
  stream.listen(
    (event) {
      watch.stop();
      controller.add(
          _Emit(dur: watch.elapsedMilliseconds, kind: X.onData, value: event));
      watch
        ..reset()
        ..start();
    },
    onError: (error) {
      watch.stop();
      controller.add(
          _Emit(dur: watch.elapsedMilliseconds, kind: X.onError, value: error));
      watch
        ..reset()
        ..start();
    },
    onDone: () {
      watch.stop();
      controller.add(
          _Emit(dur: watch.elapsedMilliseconds, kind: X.onDone, value: ''));
      controller.close();
      watch
        ..reset()
        ..start();
    },
  );
  return controller.stream;
}

Stream<_Emit> _execAndReturnStream(Function func) async* {
  if (func == null) {
    yield _Emit(dur: 0, kind: X.notFunc, value: 'function is null');
    return;
  }

  var watch = Stopwatch();
  var ret;
  var err;
  try {
    watch.start();
    ret = func();
  } catch (e) {
    err = e;
  } finally {
    watch.stop();
  }

  if (err != null) {
    yield _Emit(dur: watch.elapsedMilliseconds, kind: X.throws, value: err);
    return;
  } else {
    yield _Emit(dur: watch.elapsedMilliseconds, kind: X.returns, value: ret);
  }

  if (ret is Future) {
    try {
      watch
        ..reset()
        ..start();
      ret = await ret;
    } catch (e) {
      err = e;
    } finally {
      watch.stop();
    }

    if (err != null) {
      yield _Emit(dur: watch.elapsedMilliseconds, kind: X.reject, value: err);
    } else {
      yield _Emit(dur: watch.elapsedMilliseconds, kind: X.resolve, value: ret);
    }

    return;
  }

  if (ret is Stream) {
    yield* _execStream(ret);
    return;
  }
}
