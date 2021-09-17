import 'package:flutter/material.dart';
import 'package:flutter_contactlist_application/components/MyDialog.dart';
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
class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late BuildContext dialogContext;
  //initialize the auth service
  final AuthService _auth = AuthService();

  var pass;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confPasswordController = new TextEditingController();

  Future sendData() async {
    MyDialog dialog = new MyDialog();
    dialog.waiting(context, 'Registering... Please wait awhile');

    // Getting value from Controller
    String email = emailController.text;
    String password = passwordController.text;

    dynamic result = await _auth.registerWithEmailandPassword(email, password);

    if (result == null) {
      Navigator.pop(dialog.getDialogContext());
      dialog.confirmation(context, 'Register Failed. Please Try Again later.');
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
        Navigator.pop(dialog.getDialogContext());
        FocusScope.of(context).unfocus();
        emailController.clear();
        passwordController.clear();
        confPasswordController.clear();
        dialog.registerConfirmation(context, message);
      } else {
        FocusScope.of(context).unfocus();
        emailController.clear();
        passwordController.clear();
        confPasswordController.clear();
        await _auth.signOut();
        dialog.confirmation(context, message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  //body
  _body() {
    return Center(
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
      _logo(),
      _form(),
      _footer(),
    ])));
  }

  //logo
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

  //form
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

  //email textfield
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

  //password textfield
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

  //confirm password textfield
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

  //register button
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

  //footer
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
}
