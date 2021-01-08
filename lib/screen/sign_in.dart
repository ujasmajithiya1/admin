import 'package:admin/authentication/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Auth auth  = Auth();
  String email = "";
  String password = "";
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (val) => val.toString() != "thisisadmin@gmail.com"
                  ? "wrong mail!"
                  : null,
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              obscureText: true,
              validator: (val) =>
                  val.toString() != "adminisAwesome" ? "wrong password!" : null,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
              decoration: InputDecoration(labelText: "Password"),
            ),
            RaisedButton(
              child: Text("submit"),
              onPressed: () async {
                if (_key.currentState.validate()) {
                  await auth.signUser(email, password);
                }
                // auth.signUser(email,password);
              },
            )
          ],
        ),
      ),
    );
  }
}
