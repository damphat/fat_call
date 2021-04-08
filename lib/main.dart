import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void log(String msg) {
  print('xxx $msg');
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final parser = MyParser();
  final delegate = MyDelegate();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: parser,
      routerDelegate: delegate,
    );
  }
}

@immutable
class HomeScreen extends StatelessWidget {
  HomeScreen(this.state, this.pressed);

  final MyPath state;
  final Function pressed;

  Widget btn(String text, void Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$state'),
      ),
      body: Column(
        children: [
          btn('push settings', () {
            pressed('push', MyPathSettings());
          }),
          btn('push users', () {
            pressed('push', MyPathList());
          }),
          btn('push users/1', () {
            pressed('push', MyPathDetail(1));
          }),
          btn('push users/2', () {
            pressed('push', MyPathDetail(2));
          }),
          btn('push users/3', () {
            pressed('push', MyPathDetail(3));
          }),
          btn('pop', () {
            pressed('pop');
          }),
        ],
      ),
    );
  }
}

class MyParser extends RouteInformationParser<MyPath> {
  @override
  Future<MyPath> parseRouteInformation(RouteInformation routeInfomation) async {
    log('parseRouteInformation(${routeInfomation.location}, ${routeInfomation.state}))');

    var segs = Uri.parse(routeInfomation.location ?? '').pathSegments;
    if (segs.isEmpty) return MyPathRoot();
    if (segs[0] == 'settings') return MyPathSettings();
    if (segs[0] == 'users') {
      if (segs.length > 1) {
        var id = int.tryParse(segs[1]);
        if (id != null) return MyPathDetail(id);
      }

      return MyPathList();
    }

    return MyPathNotFound();
  }

  @override
  RouteInformation? restoreRouteInformation(MyPath configuration) {
    log('restoreRouteInformation $configuration');
    return super.restoreRouteInformation(configuration);
  }
}

class MyDelegate extends RouterDelegate<MyPath> {
  List<VoidCallback> listeners = [];
  MyPath? currentPath;

  void notifyListeners() {
    for (var listener in listeners) {
      listener();
    }
  }

  @override
  void addListener(listener) {
    log('addListener $listener');
    listeners.add(listener);
  }

  @override
  void removeListener(listener) {
    log('removeListener $listener');
    listeners.remove(listener);
  }

  @override
  Future<void> setNewRoutePath(MyPath path) async {
    log('setNewRoutePath $path');
    currentPath = path;
    notifyListeners();
  }

  @override
  Future<bool> popRoute() async {
    log('popRoute');
    return true;
  }

  void nav(String cmd, [MyPath? path]) {
    log('$cmd, $path');

    if (cmd == 'pop') {
      return;
    }

    if (cmd == 'push') {
      currentPath = path;
    }
  }

  @override
  Widget build(BuildContext context) {
    log('build $context');
    return HomeScreen(currentPath ?? MyPathList(), nav);
  }
}

abstract class MyPath {}

class MyPathRoot extends MyPath {}

class MyPathNotFound extends MyPath {}

class MyPathSettings extends MyPath {}

class MyPathList extends MyPath {}

class MyPathDetail extends MyPath {
  int id;
  String? error;
  MyPathDetail(this.id, [this.error]);
}
