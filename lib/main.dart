import 'package:flutter/material.dart';
import 'package:flutter_contactlist_application/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

// class MainPageState extends State<MainPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Home Page'),
//         ),
//         body: Center(
//           child: Text('This is Home Page'),
//         ));
//   }
// }

class MainPageState extends State<MainPage> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: new BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: new Icon(
                Icons.call,
                size: 50,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 120),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email address'),
            ),
            SizedBox(height: 30),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password'),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: style,
              onPressed: () {},
              child: const Text('Login'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account?"),
                SizedBox(width: 10),
                new GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: new Text("Create One",
                      style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
