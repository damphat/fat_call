import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_call/src/dev/dbtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

class Store {

  CollectionReference collection(String path) {
    return FirebaseFirestore.instance.collection(path);
  }

  DocumentReference doc(String path, [String? key]) {
    return FirebaseFirestore.instance.collection(path).doc(key);
  }

  Future<Map<String, dynamic>?> data(String path, String id) async {
    var docSnap = await doc(path, id).get();
    return docSnap.data();
  }

  Future<Iterable<Map<String, dynamic>>> getDocs(String path) async {
    var colSnap = await collection(path).get();
    return colSnap.docs.map((e) => e.data());
  }

  Future<void> setDoc(
    String path,
    String id,
    Map<String, dynamic>? data,
  ) async {
    if (data != null) {
      await collection(path).doc(id).set(data);
    } else {
      await collection(path).doc(id).delete();
    }
  }

  Future<Iterable<T>> eachDoc<T>(
    String p,
    T Function(Map<String, dynamic>) func,
  ) async {
    var querySnap = await collection(p).snapshots().first;
    return querySnap.docs.map((e) => func(e.data()));
  }

  Future<void> addUser(User user) async {
    await collection('users').doc(user.uid).set({
      'uid': user.uid,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
    });
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    var docSnap = await collection('users').doc(uid).get();
    return docSnap.data();
  }

  static Iterable<Map<String, dynamic>> toList(QuerySnapshot snap) {
    return snap.docs.map((docSnap) => docSnap.data());
  }

  Future users() async {
    var users = await collection('users').get();
    return users.docs.map((e) => e.data());
  }
}

final store = Store();

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Btn('init', auth.init),
            Btn('logout', auth.logout),
            Btn('login', auth.login),
            Btn('fire.addUser', () => store.collection('users')),
            Btn('fire.users', () => store.collection('user')),
          ],
        ),
      ),
    ),
  ));
}

class UserList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {}

  @override
  Widget build(context) {
    final children = <Widget>[];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class UserItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.face),
    );
  }
}
