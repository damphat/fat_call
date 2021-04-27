import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_call/src/dev/dbtn.dart';
import 'package:fat_call/src/fire/auth.dart';
import 'package:fat_call/src/fire/store.dart';
import 'package:flutter/material.dart';
import 'package:json5/json5.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: CollectionView('users'),
      ),
    ),
  );
}

class CollectionView extends StatefulWidget {
  final String name;
  CollectionView(this.name);

  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<QuerySnapshot> snapshots() async* {
    await auth.init();
    var ref = store.collection(widget.name);
    yield* ref.snapshots();
  }

  Widget dataView(QuerySnapshot snap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...snap.docs.map((e) => Text(json5Encode(e.data(), space: 2))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Btn('login', () async {
          var user = await auth.login();
          if (user != null) {
            await store.collection('users').doc(user.uid).set(user.toJson());
          }
        }),
        StreamBuilder<QuerySnapshot>(
          stream: snapshots(),
          builder: (context, snap) {
            if (snap.hasData) return dataView(snap.data!);
            if (snap.hasError) return Text('${snap.error}');
            return Text('${snap.connectionState}');
          },
        ),
      ],
    );
  }
}
