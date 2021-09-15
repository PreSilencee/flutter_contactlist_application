import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_contactlist_application/components/MyDialog.dart';
import 'package:flutter_contactlist_application/services/wrapper.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      _checkAuthentication();
    });
  }

  _checkAuthentication() {
    MyDialog dialog = new MyDialog();
    dialog.waiting(context, 'Checking Authentication');
    Timer(Duration(seconds: 3), () {
      Navigator.pop(dialog.getDialogContext());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Wrapper()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(backgroundColor: Colors.blue, body: _body(size));
  }

  _body(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_logo(size), SizedBox(height: 10), _appName()],
        ),
      ),
    );
  }

  _logo(Size size) {
    return Container(
        width: size.width / 4,
        height: size.height / 8,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Icon(Icons.call, size: 50, color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ));
  }

  _appName() {
    return Text('Contact List Application',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white));
  }
}
