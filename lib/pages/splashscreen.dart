import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vectormath;

import 'home.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  getUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (_, __, ___) => LoginPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 2),
      () {
        getUser().then(
          (user) {
            if (user != null) {
              // send the user to the home page
              // homePage();
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: Duration(seconds: 1),
                  pageBuilder: (_, __, ___) => Home(
                    user: user,
                  ),
                ),
              );
            } else {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: Duration(seconds: 1),
                  pageBuilder: (_, __, ___) => LoginPage(),
                ),
              );
            }
          },
        );
      },
    );
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4AD6A7), Color(0xFF4AD6CC)], transform: GradientRotation(vectormath.radians(45)))),
      child: Center(
        child: Hero(
          tag: 'logo',
          child: Image.asset(
            'assets/logo_splash.png',
            width: 180,
            height: 180,
          ),
        ),
      ),
    );
  }
}
