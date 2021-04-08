import 'package:fat_call/src/fire.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png'),
            SizedBox(height: 100),
            ElevatedButton(
              onPressed: () async {
                var user = await fire.login();
                if (user != null) {
                  if (Navigator.canPop(context)) {
                    await Navigator.maybePop(context, user);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Navigator.canPop() return false'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('fire.login() return null')),
                  );
                }
              },
              child: Text('Login With Google'),
            )
          ],
        ),
      ),
    );
  }
}
