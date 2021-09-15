import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contactlist_application/models/MyUser.dart';
import 'package:flutter_contactlist_application/screens/login.dart';
import 'package:flutter_contactlist_application/screens/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    if (user == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}
