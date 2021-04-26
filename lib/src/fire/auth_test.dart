import 'auth.dart';

Future<void> main() async {
  final fire = Auth();
  var user = await fire.init();
  assert(user == fire.user);
  assert(user == await fire.init());

  var login = await fire.login();
  assert(login == fire.user);
  assert(login == await fire.login());

  await fire.logout();

  assert(fire.user == null);
}
