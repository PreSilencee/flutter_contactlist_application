import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  var pass;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confPasswordController = new TextEditingController();
  bool visible = false;

  Future sendData(String randomId) async {
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String id = randomId;
    String email = emailController.text;
    String password = passwordController.text;

    // API URL
    var url = 'https://rlcm.000webhostapp.com/registerUser.php';

    // Store all data with Param Name.
    var data = {'id': id, 'email': email, 'password': password};

    // Starting Web Call with data.
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    // If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
      });
    }

    // Showing Alert Dialog with Response JSON.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            TextButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                emailController.clear();
                passwordController.clear();
                confPasswordController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Registration", style: TextStyle(color: Colors.blue)),
                TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: 'Enter your email address',
                        labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email address';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Invalid email address';
                      }
                      return null;
                    }),
                SizedBox(height: 10),
                TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: 'Enter your password', labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else {
                        pass = value;
                      }
                      return null;
                    }),
                SizedBox(height: 10),
                TextFormField(
                    controller: confPasswordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: 'Enter your confirm password',
                        labelText: 'Confirm Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter confirm password';
                      } else if (value != pass) {
                        return 'Passwords are not same';
                      }
                      return null;
                    }),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String randomString = getRandomString(15);
                      sendData(randomString);
                    }
                  },
                  child: const Text('Register'),
                ),
                Visibility(
                    visible: visible,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: CircularProgressIndicator())),
              ],
            )));
  }
}
