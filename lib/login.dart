import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:back/forgot_password_screen.dart';

import 'package:back/phone.dart';
import 'package:back/registration.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  var is_obsure;
  @override
  void initState() {
    super.initState();
    is_obsure = true;
  }

  @override
  Widget build(BuildContext context) {
    String email = '', pass = '';
    final emailField = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8F9),
                border: Border.all(
                  color: const Color(0xFFE8ECF4),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: TextFormField(
                  autofocus: false,
                  onChanged: (value) => {email = value},
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Your Email");
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please Enter a valid email");
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                    ),
                  ),
                  onSaved: (value) {
                    emailController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final passwordField = SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFF7F8F9),
                border: Border.all(
                  color: const Color(0xFFE8ECF4),
                ),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: TextFormField(
                autofocus: false,
                obscureText: is_obsure,
                controller: passwordController,
                focusNode: passwordFocusNode,
                validator: (value) {
                  RegExp regex = new RegExp(r'^.{6,}$');
                  if (value!.isEmpty) {
                    return ("Password is required for login");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Please enter valid Password(Min 6 Character)");
                  }
                },
                onSaved: (value) {
                  passwordController.text = value!;
                },
                textInputAction: TextInputAction.done,
                onChanged: (value) => {pass = value},
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                    ),
                    suffixIcon: IconButton(
                      icon: is_obsure
                          ? const Icon(
                              Icons.visibility,
                              color: Color(0xFF8391A1),
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: Color(0xFF8391A1),
                            ),
                      onPressed: () {
                        setState(() {
                          is_obsure = !is_obsure;
                        });
                      },
                    )
                    // suffixIcon: Icon(
                    //   Icons.visibility_off,
                    //   color: Color(0xFF8391A1),
                    // ),
                    // suffixIcon: GestureDetector(
                    //     onTap: () {
                    //       setState(() {});
                    //     },
                    //     child: is_obsure
                    //         ? const Icon(
                    //             Icons.visibility_off,
                    //             color: Color(0xFF8391A1),
                    //           )
                    //         : const Icon(
                    //             Icons.visibility,
                    //             color: Color(0xFF8391A1),
                    //           )),
                    ),
              ),
            ),
          ),
        ),
      ],
    ));

    final forgot = SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordScreen()));
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color(0xFF6A707C),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ));

    final loginButton = SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  color: const Color(0xFF1E232C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () async {
                    // try {
                    //   final credential = await FirebaseAuth.instance
                    //       .signInWithEmailAndPassword(
                    //           email: email, password: pass)
                    //       .then((bid) => {
                    //             Fluttertoast.showToast(msg: "Login Successful"),
                    //             Navigator.pushNamed(context, 'phone'),
                    //           });
                    // } on FirebaseAuthException catch (e) {
                    //   if (e.code == 'user-not-found') {
                    //     Fluttertoast.showToast(msg: "User Not Found");
                    //     print('No user found for that email.');
                    //   } else if (e.code == 'wrong-password') {
                    //     Fluttertoast.showToast(msg: "Wrong Password");
                    //     print('Wrong password provided for that user.');
                    //   }
                    // }

                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => const MyOTP()));
                    signIn(emailController.text, passwordController.text);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
    final heading = SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.0,
            child: const Text(
              "Welcome back! Please Login",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    ));

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: WillPopScope(
            onWillPop: () async {
              // Handle back button press
              // You can exit the app using SystemNavigator.pop() from the services package
              // Make sure to import 'package:flutter/services.dart' at the top
              SystemNavigator.pop();
              return false;
            },
            child: SingleChildScrollView(
                child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            heading,
                            emailField,
                            passwordField,
                            forgot,
                            loginButton,
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Don't have an account?  ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'register');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationScreen()));
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      color: Color(0xFF35C2C1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )))));
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyPhone())),
                Navigator.pushNamed(context, 'emailotp'),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
