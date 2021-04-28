import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_call/src/dev/json_viewer.dart';
import 'package:fat_call/src/fire/auth.dart';
import 'package:fat_call/src/fire/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(),
      body: Browser('users'),
    ),
  ));
}

class Browser extends StatelessWidget {
  Browser(this.path);

  final String path;

  Stream<QuerySnapshot> snapshots() async* {
    await auth.init();
    var c = store.collection(path);
    yield* c.snapshots();
  }

  Widget QueryDocumentSnapshotView(QueryDocumentSnapshot e) {
    var data = e.data();

    return MapViewer(data);
  }

  Widget QuerySnapView(QuerySnapshot snap) {
    return Column(
      children: [
        ...snap.docs.map((e) => QueryDocumentSnapshotView(e)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshots(),
      builder: (context, snap) {
        if (snap.hasData) {
          return QuerySnapView(snap.data!);
        }

        return Text(snap.connectionState.toString());
      },
    );
  }
}
