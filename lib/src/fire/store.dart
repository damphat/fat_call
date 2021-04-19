import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_call/src/model/muser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fire.dart';

class Store {
  FirebaseFirestore get instance => FirebaseFirestore.instance;

  Stream<void> snapshotsInSync() {
    return FirebaseFirestore.instance.snapshotsInSync();
  }

  Future<void> enableNetwork() {
    return instance.enableNetwork();
  }

  Future<void> disableNetwork() {
    return instance.disableNetwork();
  }

  // Clears any persisted data for the current instance.
  Future<void> clearPersistence() {
    return instance.clearPersistence();
  }

  //. This is a web-only method. Use [Settings.persistenceEnabled] for non-web platforms
  Future<void> enablePersistence() {
    return instance.enablePersistence();
  }

  Future<void> terminate() {
    return instance.terminate();
  }

  Future<void> waitForPendingWrites() {
    return instance.waitForPendingWrites();
  }

  Stream<MUser> users() async* {
    var users = instance.collection('users');

    await for (final snap in users.snapshots()) {
      var docs = snap.docs;
      // yield docs.map((e) {
      //   return MUser(id: e.id, name: e.data(), photoUrl: photoUrl, online: online);
      // });
    }
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
            Btn('init', fire.init),
            Btn('logout', fire.logout),
            Btn('login', fire.login),
            Btn('firestore', () => store.instance),
            Btn('data', store.snapshotsInSync),
            Btn('enableNetwork', store.enableNetwork),
            Btn('disableNetwork', store.disableNetwork),
            Btn('clearPersistence', store.clearPersistence),
            Btn('enablePersistence', store.enablePersistence),
            Btn('terminate', store.terminate),
            Btn('users/docs', store.users),
            Btn('users/changes', store.users),
            Btn('users/add', () {
              var users = FirebaseFirestore.instance.collection('users');
              return users.add({'name': 'Phat'});
            }),
            Btn('users/clear', () {
              var users = FirebaseFirestore.instance.collection('users');
              return users.add({'name': 'Phat'});
            }),
          ],
        ),
      ),
    ),
  ));
}

class Btn extends StatefulWidget {
  Btn(this.title, this.task);

  final String title;
  final Function task;

  @override
  _BtnState createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  Stream? stream;
  var items = [];

  Stream exec(Function task) {
    try {
      var ret = task();
      if (ret == null) return Stream.empty();
      if (ret is Future) return ret.asStream();
      if (ret is Stream) return ret;
      return Stream.value(ret);
    } catch (error) {
      return Stream.error(error);
    }
  }

  void add(String kind, [data]) {
    setState(() {
      items.add([kind, data]);
    });
  }

  void onPressed() {
    stream = exec(widget.task);
    add('init');
    stream!.listen((event) {
      add('data', event);
    }, onError: (error) {
      add('error', error);
    }, onDone: () {
      add('done');
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Row(
        children: [
          ElevatedButton(onPressed: onPressed, child: Text(widget.title)),
          if (items.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(
                  () {
                    items.clear();
                  },
                );
              },
            )
        ],
      )
    ];

    for (var item in items) {
      children.add(Divider());
      children.add(Text('${item[0]}: ${item[1]}'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
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
