import 'package:flutter/material.dart';
import 'package:flutter_contactlist_application/services/auth.dart';
import 'package:flutter_contactlist_application/screens/login.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () async {
          dynamic result = await _auth.signOut();
          if (result != null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          }
        },
        child: Text("Sign out"),
      )),
    );
  }
}
