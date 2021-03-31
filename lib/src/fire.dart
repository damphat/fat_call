import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Fire {
  User? _user;

  User? get user => _user;
  Completer<User?>? _initCompleter;

  Future<User?> init() {
    if (_initCompleter != null) {
      if (_initCompleter!.isCompleted) {
        return Future<User?>.value(_user);
      } else {
        return _initCompleter!.future;
      }
    } else {
      _initCompleter = Completer<User?>(); // FIXME change to <User?>
      WidgetsFlutterBinding.ensureInitialized();

      () async {
        await Firebase.initializeApp();
        var first = true;
        late StreamSubscription<User?> sub;
        final timer = Timer(const Duration(seconds: 2), () {
          sub.cancel();
          _initCompleter!.complete(null);
        });

        // note: bad firebase auth config cause an exception here
        sub = FirebaseAuth.instance.authStateChanges().listen((User? event) {
          if (event != null) {
            _user = event;
            sub.cancel();
            timer.cancel();
            _initCompleter!.complete(event);
            return;
          }

          if (first) {
            // skip first null
            first = false;
          } else {
            // take second null
            _user = null;
            sub.cancel();
            timer.cancel();
            _initCompleter!.complete(null);
            return;
          }
        });
      }();

      return _initCompleter!.future;
    }
  }

  Future<User?> login() async {
    final currentUser = await init();
    if (currentUser != null) {
      return currentUser;
    }

    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    _user = userCredential.user;
    return _user;
  }

  Future<void> logout() {
    _user = null;
    return FirebaseAuth.instance.signOut();
  }
}
