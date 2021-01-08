import 'package:admin/authentication/auth.dart';
import 'package:admin/models/user.dart';
import 'package:admin/screen/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screen/register.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    

    return StreamProvider<TheUser>.value(

      value:Auth().user,

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
    ));
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    if (user== null) {
      return SignIn();
    } else {
      return Register();
    }
  }
}