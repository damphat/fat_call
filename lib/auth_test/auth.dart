import 'package:fat_call/src/auth.dart';
import 'package:flutter_test/flutter_test.dart';

var auth = Auth();
var states = [];
var users = [];
var errors = [];
void handler() {
  states.add(auth.state);
  users.add(auth.user);
  errors.add(auth.error);
}

initTest() {
  setUp(() async {
    states = [];
    users = [];
    errors = [];
    auth.addListener(handler);
  });

  tearDown(() async {
    auth.removeListener(handler);
    auth.close();
  });
}
