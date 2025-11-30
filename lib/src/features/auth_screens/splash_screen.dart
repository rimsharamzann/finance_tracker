// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart%20';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  void navigate() {
    if (FirebaseAuth.instance.currentUser != null) {
      // print('-------abc--------');
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(
            context, '/onboarding', (routes) => false);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    navigate();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
            Colors.blue.shade300,
            Colors.white,
          ])),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
                scale: animation,
                child: Center(
                  child: Container(
                    height: 160, width: 160,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    // color: Colors.red,
                    child: Image.asset(
                      "assets/images/img_8.png",
                    ),
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
                height: 60,
                child: Text("Welcome to Pocket App",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.blue.shade900,
                        decoration: TextDecoration.none)))
          ],
        ),
      ),
    );
  }
}
