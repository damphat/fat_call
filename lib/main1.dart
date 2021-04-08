import 'package:fat_call/src/ui/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SplashScreen()));
}

class MyApp extends StatelessWidget {
  final routeInformationParser = MyRouteInformationParser();
  final routerDelegate = MyRouterDelegate();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen(this.text, this.onPressed);
  final String text;
  final Function onPressed;

  Widget btn(String text, VoidCallback onPressed) {
    return ElevatedButton(onPressed: onPressed, child: Text(text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
      ),
      body: Column(
        children: [
          btn('pop', () => onPressed('pop')),
          btn('push setttings', () => onPressed('push', MyPathSettings())),
          btn('push users', () => onPressed('push', MyPathUsers())),
          btn('push users/1', () => onPressed('push', MyPathUserDetail(1))),
          btn('push users/2', () => onPressed('push', MyPathUserDetail(2))),
          btn('push users/3', () => onPressed('push', MyPathUserDetail(3))),
        ],
      ),
    );
  }
}

class MyRouterDelegate extends RouterDelegate<MyPath> with ChangeNotifier {
  final List<Page> pages = [];

  MyRouterDelegate() {
    pages.add(MaterialPage(child: HomeScreen('/', nav)));
  }
  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [MaterialPage(child: HomeScreen('', () {}))],
    );
  }

  @override
  Future<bool> popRoute() async {
    return true;
  }

  @override
  Future<void> setInitialRoutePath(configuration) {
    return super.setInitialRoutePath(configuration);
  }

  void nav(String cmd, [MyPath? path]) {
    if (cmd == 'pop') {
      pages.removeLast();
      return;
    }

    if (cmd == 'push') {
      pages.add(MaterialPage(child: HomeScreen('$path', nav)));
    }
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    late Widget child = HomeScreen('$configuration', nav);

    pages.add(MaterialPage(child: child));
  }
}

class MyRouteInformationParser extends RouteInformationParser<MyPath> {
  @override
  Future<MyPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    var segs = Uri.parse(routeInformation.location ?? '').pathSegments;
    if (segs.isNotEmpty) {
      if (segs[0] == 'settings') return MyPathSettings();
      if (segs[0] == 'users') {
        if (segs.length > 1) {
          var id = int.tryParse(segs[1]);
          if (id != null) return MyPathUserDetail(id);
        }
        return MyPathUsers();
      }
    }
    return MyPathRoot();
  }

  @override
  RouteInformation? restoreRouteInformation(MyPath configuration) {
    if (configuration is MyPathRoot) return RouteInformation(location: '/');
    if (configuration is MyPathSettings) {
      return RouteInformation(location: '/settings');
    }
    if (configuration is MyPathUsers) {
      return RouteInformation(location: '/users');
    }
    if (configuration is MyPathUserDetail) {
      return RouteInformation(location: '/users/${configuration.id}');
    }
    return null;
  }
}

abstract class MyPath {}

class MyPathRoot extends MyPath {}

class MyPathSettings extends MyPath {}

class MyPathUsers extends MyPath {}

class MyPathUserDetail extends MyPath {
  int id;
  MyPathUserDetail(this.id);
}
