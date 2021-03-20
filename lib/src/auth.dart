import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void log(String msg) {
  print('xxx $msg');
}

// none|on|off,
enum AuthState {
  none, // chưa khởi động (nằm yên)
  init, // đang khởi động (đang chuyển đến on | off | initError)
  initError,
  on, // đã login (nằm yên)
  off, // chưa login (nằm yên)
  turnOn, // đang login (đang chuyển đến on | off(cancel) | error(pass, net, internal))
  turnOnError,
  turnOff, // đang logout (đang chuyển đến off)
}

class Auth with ChangeNotifier {
  AuthState state = AuthState.none;
  User user;
  dynamic error;

  // test: lỗi config
  // test: lỗi mạng
  Future<void> ensureInit() async {
    if (state == AuthState.none) {
      state = AuthState.init;
      notifyListeners();

      WidgetsFlutterBinding.ensureInitialized();
      try {
        await Firebase.initializeApp();
      } catch (e) {
        error = e;
        state = AuthState.initError;
        notifyListeners();
        return;
      }

      state = user != null ? AuthState.on : AuthState.off;
      notifyListeners();

      FirebaseAuth.instance.userChanges().listen((u) {
        if (user != u || (state != AuthState.on && state != AuthState.off)) {
          user = u;
          state = u != null ? AuthState.on : AuthState.off;
          notifyListeners();
        }
      });
    }
  }

  Future<void> signOut() async {
    if (state == AuthState.on) {
      state = AuthState.turnOff;
      await FirebaseAuth.instance.signOut();
    } else {
      log('Can not signout when state=$state');
    }
  }

  // signIn with different user?
  // link: not phat?
  // timeout?
  Future<UserCredential> signInWithGoogle() async {
    await ensureInit();

    // Error: PlatformException(popup_closed_by_user, Exception raised from GoogleAuth.signIn(), https://developers.google.com/identity/sign-in/web/reference#error_codes_2, null)
    // disable internet => lệnh không bao giờ finish
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  String toString() {
    var _user = 'null';
    if (user != null) {
      _user = user.displayName ?? user.email ?? user.uid;
    }

    return '$runtimeType($state, $_user, $error)';
  }
}
