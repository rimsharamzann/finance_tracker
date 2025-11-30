import 'dart:core';

import 'package:finance_tracker/src/features/auth_screens/login.dart';
import 'package:finance_tracker/src/features/onBoarding/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../config/bottom_nav_bar.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _pageController = PageController();

  // int _currentQuestion = 0;
  // int _totalQuestion = 20;
  // double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    // _progress = _currentQuestion + 1 / _totalQuestion;
    navigate();
  }

  // void nextQuestion() {
  //   setState(() {
  //     _currentQuestion++;
  //     _progress = _currentQuestion + 1 / _totalQuestion;
  //   });
  // }

  void navigate() {
    if (FirebaseAuth.instance.currentUser != null) {
      Future.delayed(const Duration(seconds: 1), () {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 80,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: const WormEffect(
                    dotWidth: 100,
                    dotHeight: 2,
                    dotColor: Colors.white54,
                    activeDotColor: Colors.white),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.61,
              child: PageView(
                controller: _pageController,
                children: const [
                  OnBoarding1(),
                  OnBoarding2(),
                  OnBoarding3(),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(22),
            topLeft: Radius.circular(22),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login or signup with",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const LoginOptions(
                    icon: Icons.mail_outline,
                    color: Colors.redAccent,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavBar()));
                  },
                  child: const LoginOptions(
                    icon: Icons.apple,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, "/homepage", (route) => false);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavBar()));
                  },
                  child: const LoginOptions(
                    icon: Icons.facebook,
                    color: Colors.blue,
                  ),
                ),
                const LoginOptions(
                  icon: Icons.email_outlined,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoginOptions extends StatelessWidget {
  const LoginOptions({super.key, required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.grey.shade100,
      child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          child: Icon(
            icon,
            color: color,
            size: 32,
          )),
    );
  }
}

class OnBoarding1 extends StatelessWidget {
  const OnBoarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Stack(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white.withValues( alpha:  0.3),
                ),
              ),
              Container(
                height: 250,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      child: ExpenseCard1("Income", "+ \$1,000",
                          Icons.monetization_on_sharp, Colors.green),
                    ),
                    Container(
                      margin: const EdgeInsets.all(0),
                      child: ExpenseCard1(
                        "Shopping",
                        "- \$800",
                        Icons.shopping_cart,
                        Colors.red,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      child: ExpenseCard1("Food & Drinks", "- \$,100",
                          Icons.emoji_food_beverage, Colors.orange),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Stay on top of your spends",
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "Easily keep track of all your income and spends at a single place",
            style: TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ExpenseCard1(String title, String amount, IconData icon, Color color) {
    return Container(
      height: 55,
      width: 370,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          Text(amount, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
