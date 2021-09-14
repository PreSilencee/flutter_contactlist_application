import 'package:flutter/material.dart';
import 'package:flutter_contactlist_application/screens/login.dart';
import 'package:flutter_contactlist_application/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contactlist_application/models/MyUser.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    _animationController.repeat();
    super.initState();
  }

  _loadingIndicator() {
    return CircularProgressIndicator(
        valueColor: _animationController
            .drive(ColorTween(begin: Colors.yellow, end: Colors.blue)));
  }

  _loadingMessage() {
    return Text('Checking Authentication...',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  Future navigatetomain(MyUser? user, BuildContext ct) async {
    showDialog(
      context: ct,
      barrierDismissible: false,
      builder: (BuildContext context) {
        ct = context;
        return Dialog(
          child: Container(
              width: double.infinity,
              height: 100,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _loadingIndicator(),
                    SizedBox(width: 20),
                    _loadingMessage()
                  ])),
        );
      },
    );

    await Future.delayed(Duration(milliseconds: 3000), () {});

    if (user != null) {
      Navigator.pop(ct);
      Navigator.pushReplacement(
          ct, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.pop(ct);
      Navigator.pushReplacement(
          ct, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final user = Provider.of<MyUser?>(context);
    navigatetomain(user, context);
    return Scaffold(backgroundColor: Colors.blue, body: _body(size));
  }
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

  



// class _SplashState extends State<Splash> {
//   @override
//   void initState() {
//     super.initState();
//     _navigatetomain();
//   }



//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//         backgroundColor: Colors.blue,
//         body: Container(
//             width: size.width,
//             height: size.height,
//             child: Center(
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                   Container(
//                       width: size.width / 4,
//                       height: size.height / 8,
//                       child: Card(
//                         semanticContainer: true,
//                         clipBehavior: Clip.antiAliasWithSaveLayer,
//                         child: Icon(Icons.call, size: 50, color: Colors.blue),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         elevation: 5,
//                         margin: EdgeInsets.all(10),
//                       )),
//                   SizedBox(height: 10),
//                   Text('Contact List Application',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           color: Colors.white))
//                 ]))));
//   }
// }
