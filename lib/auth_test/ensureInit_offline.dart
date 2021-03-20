import 'package:fat_call/src/auth.dart';

Future<void> main() async {
  var auth = Auth();
  auth.addListener(() {
    print('$auth');
  });
  await auth.ensureInit();
  var u = await auth.signInWithGoogle();
  print(u);
}
