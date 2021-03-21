import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void log(msg) {
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
  FirebaseApp fapp;
  FirebaseAuth fauth;
  AuthState state = AuthState.none;
  User user;
  dynamic error;

  StreamSubscription<User> _userChangesSub;
  // test: lỗi config
  // test: lỗi mạng
  Future<void> ensureInit() async {
    if (state == AuthState.none) {
      state = AuthState.init;
      notifyListeners();

      WidgetsFlutterBinding.ensureInitialized();
      try {
        try {
          fapp = await Firebase.initializeApp(
              name: 'fatcall',
              options: FirebaseOptions(
                projectId: "damphat-1ce0d",
                appId: "1:143894010196:android:b7299fb869015314e290c1",
                apiKey: "AIzaSyCl05SoXlATK9s3sqGCBYCtnfgwq53i86g",
                messagingSenderId: "143894010196",
                authDomain: "damphat-1ce0d.firebaseapp.com",
                androidClientId:
                    "143894010196-p1qnmldpv1ucao51e35v4bcu3lq3b4tb.apps.googleusercontent.com",
                storageBucket: "damphat-1ce0d.appspot.com",
              ));
        } catch (FirebaseException) {
          fapp = Firebase.app('fatcall');
        }

        fauth = FirebaseAuth.instanceFor(app: fapp);
      } catch (e) {
        error = e;
        state = AuthState.initError;
        notifyListeners();
        return;
      }

      state = user != null ? AuthState.on : AuthState.off;
      notifyListeners();

      _userChangesSub = fauth.userChanges().listen((u) {
        // dỏm, cái subcribtion này không tự close khi app đã close
        // vậy mình phải dùng biến để lưu và tự close
        // muốn biết
        log(u);
        if (user != u || (state != AuthState.on && state != AuthState.off)) {
          user = u;
          state = u != null ? AuthState.on : AuthState.off;
          notifyListeners();
        }
      }, onDone: () {
        log('userChangs() is done');
      });
    }
  }

  Future<void> signOut() async {
    if (state == AuthState.on) {
      state = AuthState.turnOff;
      await fauth.signOut();
    } else {
      log('Can not signout when state=$state');
    }
  }

  // signIn with different user?
  // link: not phat?
  // timeout?
  Future<UserCredential> signInWithGoogle() async {
    await ensureInit();

    // Unhandled Exception: PlatformException(network_error, com.google.android.gms.common.api.ApiException: 7: , null, null)
    // Error: PlatformException(popup_closed_by_user, Exception raised from GoogleAuth.signIn(), https://developers.google.com/identity/sign-in/web/reference#error_codes_2, null)
    // disable internet => lệnh không bao giờ finish
    final GoogleSignInAccount googleUser = await GoogleSignIn()
        .signIn()
        .timeout(Duration(seconds: 5), onTimeout: () {
      log('signInWithGoogle() timeout');
    });

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await fauth.signInWithCredential(credential);
  }

  Future<void> close() async {
    if (state != AuthState.none) {
      await fapp?.delete();
      state = AuthState.none;
      user = null;
      error = null;
      notifyListeners();
    }
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
