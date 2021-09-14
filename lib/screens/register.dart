import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_contactlist_application/screens/login.dart';
import 'package:flutter_contactlist_application/services/auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

//register page state
class RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late BuildContext dialogContext;
  //initialize the auth service
  final AuthService _auth = AuthService();

  var pass;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confPasswordController = new TextEditingController();
  bool visible = false;

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
    return Text('Registering... Please wait awhile',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  Future sendData() async {
    showDialog(
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
                    _loadingIndicator(),
                    SizedBox(width: 20),
                    _loadingMessage()
                  ])),
        );
      },
    );

    // Getting value from Controller
    String email = emailController.text;
    String password = passwordController.text;

    dynamic result = await _auth.registerWithEmailandPassword(email, password);

    if (result == null) {
      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Register Failed. Please Try Again later."),
            actions: <Widget>[
              TextButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // API URL
      var url = 'https://rlcm.000webhostapp.com/registerUser.php';

      // Store all data with Param Name.
      var data = {
        'id': _auth.getCurrentUserId(),
        'email': _auth.getCurrentUserEmail()
      };

      // Starting Web Call with data.
      var response = await http.post(Uri.parse(url), body: json.encode(data));

      // Getting Server response into variable.
      var message = jsonDecode(response.body);

      // If Web call Success than Hide the CircularProgressIndicator.
      if (response.statusCode == 200) {
        Navigator.pop(dialogContext);
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
      } else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  _body() {
    return Center(
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
      _logo(),
      _form(),
      _footer(),
    ])));
  }

  _logo() {
    return Container(
        width: 130,
        height: 130,
        child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Icon(Icons.person_add_alt, size: 50, color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(20)));
  }

  _form() {
    return Padding(
      padding: EdgeInsets.only(left: 22.0, right: 22.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              _emailTextField(),
              _passwordTextField(),
              _confirmPasswordTextField(),
              _registerButton(),
            ],
          )),
    );
  }

  _emailTextField() {
    return TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
            labelText: 'Email', hintText: 'Enter your email address'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter email address';
          } else if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return 'Invalid email address';
          }
          return null;
        });
  }

  _passwordTextField() {
    return TextFormField(
        controller: passwordController,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: const InputDecoration(
            hintText: 'Enter your password', labelText: 'Password'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter password';
          }
          if (value.length < 6) {
            return 'Password should be at least 6 characters';
          } else {
            pass = value;
          }
          return null;
        });
  }

  _confirmPasswordTextField() {
    return TextFormField(
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
        });
  }

  _registerButton() {
    return Container(
        padding: EdgeInsets.all(20),
        child: SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  sendData();
                }
              },
              child: const Text('Register',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )));
  }

  _footer() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text('Already have an account?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
      SizedBox(width: 10),
      GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Text('Login',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline,
                color: Colors.blue)),
      )
    ]);
  }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return Scaffold(
  //       body: SingleChildScrollView(
  //           reverse: true,
  //           child: Column(
  //             children: [
  //               Align(
  //                   alignment: Alignment.topCenter,
  //                   child: Container(
  //                       margin: EdgeInsets.only(top: 100),
  //                       width: size.width / 4 + 30,
  //                       height: size.height / 7 + 20,
  //                       child: Card(
  //                           semanticContainer: true,
  //                           clipBehavior: Clip.antiAliasWithSaveLayer,
  //                           child: Icon(Icons.person_add_alt,
  //                               size: 50, color: Colors.blue),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(50.0),
  //                           ),
  //                           elevation: 5,
  //                           margin: EdgeInsets.all(20)))),
  //               Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: Row(children: <Widget>[
  //                     Text('Already have an account?',
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 20,
  //                         )),
  //                     SizedBox(width: 10),
  //                     GestureDetector(
  //                       onTap: () {
  //                         Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => LoginPage()));
  //                       },
  //                       child: Text('Login',
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 20,
  //                               decoration: TextDecoration.underline,
  //                               color: Colors.blue)),
  //                     )
  //                   ]))
  //             ],
  //           )));
  // }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return Scaffold(
  //       resizeToAvoidBottomInset: false,
  //       body: SingleChildScrollView(
  //           child: Stack(
  //         children: <Widget>[
  //           Positioned.fill(
  //               top: (size.height / 2) - 250,
  //               child: Align(
  //                   alignment: Alignment.topCenter,
  //                   child: Container(
  //                       width: size.width / 4 + 30,
  //                       height: size.height / 7 + 20,
  //                       child: Card(
  //                           semanticContainer: true,
  //                           clipBehavior: Clip.antiAliasWithSaveLayer,
  //                           child: Icon(Icons.person_add_alt,
  //                               size: 50, color: Colors.blue),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(50.0),
  //                           ),
  //                           elevation: 5,
  //                           margin: EdgeInsets.all(20))))),
  //           Positioned.fill(
  //               top: (size.height / 2) - 90,
  //               child: Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: Container(
  //                       margin: EdgeInsets.only(left: 20, right: 20),
  //                       child: Form(
  //                           key: _formKey,
  //                           child: Column(children: <Widget>[
  //                             TextFormField(
  //                               controller: emailController,
  //                               decoration: const InputDecoration(
  //                                   labelText: 'Email',
  //                                   hintText: 'Enter your email address'),
  //                               validator: (value) {
  //                                 if (value == null || value.isEmpty) {
  //                                   return 'Please enter email address';
  //                                 } else if (!RegExp(
  //                                         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //                                     .hasMatch(value)) {
  //                                   return 'Invalid email address';
  //                                 }
  //                                 return null;
  //                               },
  //                             ),
  //                             SizedBox(height: 25),
  //                             TextFormField(
  //                                 controller: passwordController,
  //                                 obscureText: true,
  //                                 enableSuggestions: false,
  //                                 autocorrect: false,
  //                                 decoration: const InputDecoration(
  //                                     hintText: 'Enter your password',
  //                                     labelText: 'Password'),
  //                                 validator: (value) {
  //                                   if (value == null || value.isEmpty) {
  //                                     return 'Please enter password';
  //                                   }
  //                                   return null;
  //                                 }),
  //                             SizedBox(height: 25),
  //                             TextFormField(
  //                                 controller: confPasswordController,
  //                                 obscureText: true,
  //                                 enableSuggestions: false,
  //                                 autocorrect: false,
  //                                 decoration: const InputDecoration(
  //                                     hintText: 'Enter your confirm password',
  //                                     labelText: 'Confirm Password'),
  //                                 validator: (value) {
  //                                   if (value == null || value.isEmpty) {
  //                                     return 'Please enter confirm password';
  //                                   } else if (value != pass) {
  //                                     return 'Passwords are not same';
  //                                   }
  //                                   return null;
  //                                 }),
  //                           ]))))),
  //           Positioned.fill(
  //               top: (size.height / 2) + 200,
  //               child: Container(
  //                   padding: EdgeInsets.all(20),
  //                   child: Align(
  //                       alignment: Alignment.topCenter,
  //                       child: SizedBox(
  //                           width: double.infinity,
  //                           height: 45,
  //                           child: ElevatedButton(
  //                             onPressed: () {
  //                               if (_formKey.currentState!.validate()) {}
  //                             },
  //                             child: const Text('Register',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 20)),
  //                           ))))),
  //           Positioned.fill(
  //               bottom: 20,
  //               child: Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: Row(
  //                     children: <Widget>[
  //                       Text('Already have an account?',
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 20,
  //                           )),
  //                       SizedBox(width: 10),
  //                       GestureDetector(
  //                         onTap: () {
  //                           Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   builder: (context) => LoginPage()));
  //                         },
  //                         child: Text('Login',
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 20,
  //                                 decoration: TextDecoration.underline,
  //                                 color: Colors.blue)),
  //                       ),
  //                     ],
  //                   )))
  //         ],
  //       ))
  //       // body: new Form(
  //       //     key: _formKey,
  //       //     child: Column(
  //       //       mainAxisAlignment: MainAxisAlignment.center,
  //       //       children: <Widget>[
  //       //         Text("Registration", style: TextStyle(color: Colors.blue)),
  //       //         TextFormField(
  //       //             controller: emailController,
  //       //             decoration: const InputDecoration(
  //       //                 hintText: 'Enter your email address',
  //       //                 labelText: 'Email'),
  //       //             validator: (value) {
  //       //               if (value == null || value.isEmpty) {
  //       //                 return 'Please enter email address';
  //       //               } else if (!RegExp(
  //       //                       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //       //                   .hasMatch(value)) {
  //       //                 return 'Invalid email address';
  //       //               }
  //       //               return null;
  //       //             }),
  //       //         SizedBox(height: 10),
  //       //         TextFormField(
  //       //             controller: passwordController,
  //       //             obscureText: true,
  //       //             enableSuggestions: false,
  //       //             autocorrect: false,
  //       //             decoration: const InputDecoration(
  //       //                 hintText: 'Enter your password', labelText: 'Password'),
  //       //             validator: (value) {
  //       //               if (value == null || value.isEmpty) {
  //       //                 return 'Please enter password';
  //       //               } else {
  //       //                 pass = value;
  //       //               }
  //       //               return null;
  //       //             }),
  //       //         SizedBox(height: 10),
  //       //         TextFormField(
  //       //             controller: confPasswordController,
  //       //             obscureText: true,
  //       //             enableSuggestions: false,
  //       //             autocorrect: false,
  //       //             decoration: const InputDecoration(
  //       //                 hintText: 'Enter your confirm password',
  //       //                 labelText: 'Confirm Password'),
  //       //             validator: (value) {
  //       //               if (value == null || value.isEmpty) {
  //       //                 return 'Please enter confirm password';
  //       //               } else if (value != pass) {
  //       //                 return 'Passwords are not same';
  //       //               }
  //       //               return null;
  //       //             }),
  //       //         ElevatedButton(
  //       //           onPressed: () {
  //       //             if (_formKey.currentState!.validate()) {
  //       //               String randomString = getRandomString(15);
  //       //               sendData(randomString);
  //       //             }
  //       //           },
  //       //           child: const Text('Register'),
  //       //         ),
  //       //         Visibility(
  //       //             visible: visible,
  //       //             child: Container(
  //       //                 margin: EdgeInsets.only(bottom: 30),
  //       //                 child: CircularProgressIndicator())),
  //       //       ],
  //       //     ))
  //       );
  // }
}
