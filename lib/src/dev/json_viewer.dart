import 'dart:convert';

import 'package:flutter/material.dart';

Widget textColor(String text, Color color) {
  return Expanded(
    child: Text(text, style: TextStyle(color: color)),
  );
}

Widget jsonColor(dynamic value, Color color) {
  return textColor(jsonEncode(value), color);
}

class MapViewer extends StatefulWidget {
  final Map<String, dynamic> obj;
  final bool indented;

  MapViewer(this.obj, {this.indented = false});

  @override
  MapViewerState createState() => MapViewerState();
}

class MapViewerState extends State<MapViewer> {
  Map<String, bool> isExpanded = {};

  @override
  Widget build(BuildContext context) {
    Widget w = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getList(),
    );

    if (widget.indented) {
      w = Container(
        padding: EdgeInsets.only(left: 14.0),
        child: w,
      );
    }

    return w;
  }

  List<Widget> _getList() {
    var list = <Widget>[];
    for (MapEntry entry in widget.obj.entries) {
      var ex = isExtensible(entry.value);
      var ink = hasChildren(entry.value);
      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ex
                ? ((isExpanded[entry.key] ?? false)
                    ? Icon(Icons.arrow_drop_down,
                        size: 14, color: Colors.grey[700])
                    : Icon(Icons.arrow_right,
                        size: 14, color: Colors.grey[700]))
                : const Icon(
                    Icons.arrow_right,
                    color: Color.fromARGB(0, 0, 0, 0),
                    size: 14,
                  ),
            (ex && ink)
                ? InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded[entry.key] =
                            !(isExpanded[entry.key] ?? false);
                      });
                    },
                    child: Text(
                      entry.key,
                      style: TextStyle(color: Colors.purple[900]),
                    ),
                  )
                : Text(
                    entry.key,
                    style: TextStyle(
                      color: entry.value == null
                          ? Colors.grey
                          : Colors.purple[900],
                    ),
                  ),
            Text(':', style: TextStyle(color: Colors.grey)),
            const SizedBox(width: 3),
            getValueWidget(entry.key, entry.value),
          ],
        ),
      );
      list.add(const SizedBox(height: 4));
      if (isExpanded[entry.key] ?? false) {
        list.add(getContentWidget(entry.value));
      }
    }
    return list;
  }

  static StatefulWidget getContentWidget(dynamic content) {
    if (content is List) {
      return ListViewer(content, isChild: true);
    } else {
      return MapViewer(content, indented: true);
    }
  }

  static bool hasChildren(dynamic content) {
    if (content == null) return false;
    if (content is int) return false;
    if (content is String) return false;
    if (content is bool) return false;
    if (content is double) return false;
    if (content is List) return content.isNotEmpty;

    // TODO if (content is Map)

    return true;
  }

  Widget getValueWidget(dynamic key, dynamic value) {
    if (value == null) return jsonColor(value, Colors.grey);
    if (value is int) return jsonColor(value, Colors.teal);
    if (value is String) return jsonColor(value, Colors.redAccent);
    if (value is bool) return jsonColor(value, Colors.purple);
    if (value is double) return jsonColor(value, Colors.teal);

    if (value is List) {
      if (value.isEmpty) {
        return jsonColor('[]', Colors.teal);
      } else {
        return InkWell(
          onTap: () {
            setState(() {
              isExpanded[key] = !(isExpanded[key] ?? false);
            });
          },
          child: Text(
            'Array<${getTypeName(value[0])}>[${value.length}]',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
    }
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded[key] = !(isExpanded[key] ?? false);
        });
      },
      child: Text(
        'Object',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  static bool isExtensible(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    }
    return true;
  }

  static String getTypeName(dynamic content) {
    if (content is int) {
      return 'int';
    } else if (content is String) {
      return 'String';
    } else if (content is bool) {
      return 'bool';
    } else if (content is double) {
      return 'double';
    } else if (content is List) {
      return 'List';
    }
    return 'Object';
  }
}

class ListViewer extends StatefulWidget {
  final List<dynamic> jsonArray;

  final bool? isChild;

  ListViewer(this.jsonArray, {this.isChild});

  @override
  _ListViewerState createState() => _ListViewerState();
}

class _ListViewerState extends State<ListViewer> {
  late List<bool?> openFlag;

  @override
  Widget build(BuildContext context) {
    if (widget.isChild ?? false) {
      return Container(
        padding: EdgeInsets.only(left: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getList(),
    );
  }

  @override
  void initState() {
    super.initState();
    openFlag = List.filled(widget.jsonArray.length, null, growable: false);
  }

  List<Widget> _getList() {
    var list = <Widget>[];
    var i = 0;
    for (dynamic content in widget.jsonArray) {
      var ex = MapViewerState.isExtensible(content);
      var ink = MapViewerState.hasChildren(content);
      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ex
                ? ((openFlag[i] ?? false)
                    ? Icon(Icons.arrow_drop_down,
                        size: 14, color: Colors.grey[700])
                    : Icon(Icons.arrow_right,
                        size: 14, color: Colors.grey[700]))
                : const Icon(
                    Icons.arrow_right,
                    color: Color.fromARGB(0, 0, 0, 0),
                    size: 14,
                  ),
            (ex && ink)
                ? getInkWell(i)
                : Text(
                    '[$i]',
                    style: TextStyle(
                        color:
                            content == null ? Colors.grey : Colors.purple[900]),
                  ),
            Text(
              ':',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(width: 3),
            getValueWidget(content, i)
          ],
        ),
      );

      list.add(const SizedBox(height: 4));
      if (openFlag[i] ?? false) {
        list.add(MapViewerState.getContentWidget(content));
      }
      i++;
    }
    return list;
  }

  InkWell getInkWell(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          openFlag[index] = !(openFlag[index] ?? false);
        });
      },
      child: Text('[$index]', style: TextStyle(color: Colors.purple[900])),
    );
  }

  Widget getValueWidget(dynamic content, int index) {
    if (content == null) {
      return Expanded(
        child: Text(
          'undefined',
          style: TextStyle(color: Colors.grey),
        ),
      );
    } else if (content is int) {
      return Expanded(
        child: Text(
          content.toString(),
          style: TextStyle(color: Colors.teal),
        ),
      );
    } else if (content is String) {
      return Expanded(
        child: Text(
          '\"' + content + '\"',
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    } else if (content is bool) {
      return Expanded(
        child: Text(
          content.toString(),
          style: TextStyle(color: Colors.purple),
        ),
      );
    } else if (content is double) {
      return Expanded(
        child: Text(
          content.toString(),
          style: TextStyle(color: Colors.teal),
        ),
      );
    } else if (content is List) {
      if (content.isEmpty) {
        return Text(
          'Array[0]',
          style: TextStyle(color: Colors.grey),
        );
      } else {
        return InkWell(
          onTap: () {
            setState(() {
              openFlag[index] = !(openFlag[index] ?? false);
            });
          },
          child: Text(
            'Array<${MapViewerState.getTypeName(content)}>[${content.length}]',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
    }
    return InkWell(
      onTap: () {
        setState(() {
          openFlag[index] = !(openFlag[index] ?? false);
        });
      },
      child: Text(
        'Object',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
