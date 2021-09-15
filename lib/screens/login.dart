import 'package:flutter/material.dart';
import 'package:flutter_contactlist_application/screens/register.dart';
import 'package:flutter_contactlist_application/components/MyDialog.dart';
import 'package:flutter_contactlist_application/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  //initialize the auth service
  final AuthService _auth = AuthService();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Future login() async {
    MyDialog dialog = new MyDialog();
    dialog.waiting(context, 'Logining... Please wait awhile');

    // Getting value from Controller
    String email = emailController.text;
    String password = passwordController.text;

    dynamic result = await _auth.signInWithEmailandPassword(email, password);

    if (result == null) {
      Navigator.pop(dialog.getDialogContext());
      dialog.confirmation(context, 'Login Failed. Please Try Again later.');
    } else {
      Navigator.pop(dialog.getDialogContext());
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
            color: Colors.blue,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Icon(Icons.call, size: 50, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
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
              _loginButton(),
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
          }
          return null;
        });
  }

  //register button
  _loginButton() {
    return Container(
        padding: EdgeInsets.all(20),
        child: SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  login();
                }
              },
              child: const Text('Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )));
  }

  //footer
  _footer() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      },
      child: Text('Create New Account',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              decoration: TextDecoration.underline,
              color: Colors.blue)),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return Scaffold(
  //       resizeToAvoidBottomInset: false,
  //       body: Container(
  //           width: size.width,
  //           height: size.height,
  //           child: Stack(children: <Widget>[
  //             Positioned.fill(
  //                 top: (size.height / 2) - 250,
  //                 child: Align(
  //                     alignment: Alignment.topCenter,
  //                     child: Container(
  //                         width: size.width / 4 + 20,
  //                         height: size.height / 7 + 10,
  //                         child: Card(
  //                             color: Colors.blue,
  //                             semanticContainer: true,
  //                             clipBehavior: Clip.antiAliasWithSaveLayer,
  //                             child: Icon(Icons.call,
  //                                 size: 50, color: Colors.white),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10.0),
  //                             ),
  //                             elevation: 5,
  //                             margin: EdgeInsets.all(20))))),
  //             Positioned.fill(
  //                 top: (size.height / 2) - 90,
  //                 child: Align(
  //                     alignment: Alignment.bottomCenter,
  //                     child: Container(
  //                         margin: EdgeInsets.only(left: 20, right: 20),
  //                         child: Form(
  //                             key: _formKey,
  //                             child: Column(children: <Widget>[
  //                               TextFormField(
  //                                 controller: emailController,
  //                                 decoration: const InputDecoration(
  //                                     labelText: 'Email',
  //                                     hintText: 'Enter your email address'),
  //                                 validator: (value) {
  //                                   if (value == null || value.isEmpty) {
  //                                     return 'Please enter email address';
  //                                   } else if (!RegExp(
  //                                           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //                                       .hasMatch(value)) {
  //                                     return 'Invalid email address';
  //                                   }
  //                                   return null;
  //                                 },
  //                               ),
  //                               SizedBox(height: 25),
  //                               TextFormField(
  //                                   controller: passwordController,
  //                                   obscureText: true,
  //                                   enableSuggestions: false,
  //                                   autocorrect: false,
  //                                   decoration: const InputDecoration(
  //                                       hintText: 'Enter your password',
  //                                       labelText: 'Password'),
  //                                   validator: (value) {
  //                                     if (value == null || value.isEmpty) {
  //                                       return 'Please enter password';
  //                                     }
  //                                     return null;
  //                                   }),
  //                             ]))))),
  //             Positioned.fill(
  //                 top: (size.height / 2) + 100,
  //                 child: Container(
  //                     padding: EdgeInsets.all(20),
  //                     child: Align(
  //                         alignment: Alignment.topCenter,
  //                         child: SizedBox(
  //                             width: double.infinity,
  //                             height: 50,
  //                             child: ElevatedButton(
  //                               onPressed: () {
  //                                 if (_formKey.currentState!.validate()) {}
  //                               },
  //                               child: const Text('Login',
  //                                   style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 20)),
  //                             ))))),
  //             Positioned.fill(
  //                 bottom: 20,
  //                 child: Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => RegisterPage()));
  //                     },
  //                     child: Text('Create New Account',
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 20,
  //                             decoration: TextDecoration.underline,
  //                             color: Colors.blue)),
  //                   ),
  //                 ))
  //           ])));
  // }
}
