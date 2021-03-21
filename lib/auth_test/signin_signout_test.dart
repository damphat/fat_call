import 'package:fat_call/src/auth.dart';

Future<void> main() async {
  var auth = Auth();

  for (var i = 0; i < 3; i++) {
    // signin
    var userCredential = await auth.signInWithGoogle();
    var user = userCredential.user;
    assert(user != null);
    assert(auth.user != null);
    assert(auth.state == AuthState.on);

    // signout
    await auth.signOut();
    assert(auth.state == AuthState.off);
    assert(auth.user == null);
  }
}
