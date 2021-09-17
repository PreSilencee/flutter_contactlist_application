import 'package:flutter/material.dart';
import 'package:flutter_contactlist_application/services/wrapper.dart';

class MyDialog {
  late BuildContext dialogContext;
  waiting(BuildContext context, String title) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return Dialog(
            child: Container(
                width: double.infinity,
                height: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loadingIndicator(),
                      SizedBox(width: 20),
                      loadingMessage(title)
                    ])),
          );
        });
  }

  registerConfirmation(BuildContext context, String title) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            actions: <Widget>[
              TextButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => Wrapper()));
                },
              ),
            ],
          );
        });
  }

  confirmation(BuildContext context, String title) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            actions: <Widget>[
              TextButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  getDialogContext() {
    return dialogContext;
  }

  loadingIndicator() {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue));
  }

  loadingMessage(String title) {
    return Text(title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }
}
