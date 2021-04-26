import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json5/json5.dart';

dynamic stringify(dynamic d) {
  if (d is String) return d;
  try {
    d = jsonEncode(d);
    d = jsonDecode(d);

    d = json5Encode(d, space: 2);
  } catch (e) {
    return d;
  }

  return d;
}

class Btn extends StatefulWidget {
  Btn(this.title, this.task);

  final String title;
  final Function task;

  @override
  _BtnState createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  Stream? stream;
  var items = [];

  Stream exec(Function task) {
    try {
      var ret = task();
      if (ret == null) return Stream.empty();
      if (ret is Future) return ret.asStream();
      if (ret is Stream) return ret;
      return Stream.value(ret);
    } catch (error) {
      return Stream.error(error);
    }
  }

  void add(String kind, [data]) {
    setState(() {
      items.add([kind, data]);
    });
  }

  void onPressed() {
    stream = exec(widget.task);
    add('init');
    stream!.listen((event) {
      add('data', event);
    }, onError: (error) {
      add('error', error);
    }, onDone: () {
      add('done');
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Row(
        children: [
          ElevatedButton(onPressed: onPressed, child: Text(widget.title)),
          if (items.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(
                  () {
                    items.clear();
                  },
                );
              },
            )
        ],
      )
    ];

    for (var item in items) {
      children.add(Divider());
      children.add(Text('${item[0]}: ${stringify(item[1])}'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
