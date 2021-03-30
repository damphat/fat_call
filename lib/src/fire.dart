import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Fire {
  User? _user;
  User? get user => _user;
  Completer<User?>? _initCompleter;

  // ensure init and restore user
  // return current login
  Future<User?> init() {
    if (_initCompleter != null) {
      if (_initCompleter!.isCompleted) {
        return Future.value(_user);
      } else {
        return _initCompleter!.future;
      }
    } else {
      _initCompleter = Completer<User>();
      WidgetsFlutterBinding.ensureInitialized();

      () async {
        await Firebase.initializeApp();
        bool first = true;
        late StreamSubscription sub;
        final timer = Timer(Duration(seconds: 2), () {
          sub.cancel();
          _initCompleter!.complete(null);
        });
        sub = FirebaseAuth.instance.authStateChanges().listen((event) {
          if (event != null) {
            _user = event;
            sub.cancel();
            timer.cancel();
            _initCompleter!.complete(event);
            return;
          }

          if (first) {
            // first null
            first = false;
          } else {
            _user = event;
            sub.cancel();
            timer.cancel();
            _initCompleter!.complete(event);
            return;
          }
        });
      }();

      return _initCompleter!.future;
    }
  }

  Future<User?> login() async {
    // FIXME is this
    var u = await init();
    if (u != null) return u;

    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    _user = userCredential.user;
    return _user;
  }

  Future<void> logout() {
    _user = null;
    return FirebaseAuth.instance.signOut();
  }
}
