import 'package:back/newvideo.dart';
import 'package:back/options.dart';
import 'package:back/Otp2.dart';
import 'package:back/emailotp.dart';
import 'package:back/homescreen1.dart';
import 'package:back/login.dart';
import 'package:back/phone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:back/registration.dart';
import 'package:back/welcomepage.dart';
import 'package:back/forgot_password_screen.dart';
import 'package:back/videodemo.dart';
import 'package:back/demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // title: "Brain Tumor",
    initialRoute: 'welcome',
    routes: {
      'phone': (context) => MyPhone(),
      'login': (context) => LoginScreen(),
      'register': (context) => RegistrationScreen(),
      'home1': (context) => MyHome(),
      'welcome': (context) => WelcomeScreen(),
      'otp1': (context) => MyOTP2(),
      'forgot': (context) => ForgotPasswordScreen(),
      'emailotp': (context) => MyEmail(),
      'options': (context) => MyOptions(),
      'videodemo': (context) => MyHome6(),
      'newvideoEx': (context) => MyHome1(),
      'demo': (context) => FirestoreImageDisplay()
    },
  ));
}
