import 'package:fat_call/src/auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth.dart';

void main() {
  initTest();

  // test('close', () async {
  //   await expectLater(auth.close(), completion(null));
  //   expect(auth.state, AuthState.none);
  //   expect(states, []);
  // });

  // test('ensureInit', () async {
  //   await expectLater(auth.ensureInit(), completion(null));
  //   expect(users, [null, null]);
  //   expect(states, [AuthState.init, AuthState.off]);
  //   expect(errors, [null, null]);
  // });

  test('signOut', () async {
    var lastState = auth.state;
    await expectLater(auth.signOut(), completion(null));
    if (lastState != AuthState.on) {
      expect(users, []);
      expect(states, []);
      expect(errors, []);
    } else {
      expect(users, [null]);
      expect(states, [AuthState.off]);
      expect(errors, [null]);
    }
  });

  // test('signInWithGoogle', () async {
  //   await expectLater(auth.signInWithGoogle(), completion(isNotNull));
  //   expect(users, [null, isNotNull]);
  //   expect(states, [AuthState.init, AuthState.on]);
  //   expect(errors, [null, null]);
  // });
}
