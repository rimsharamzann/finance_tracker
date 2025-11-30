// ignore_for_file: use_build_context_synchronously

import 'package:finance_tracker/src/features/auth_screens/sign_up_screen.dart';
import 'package:finance_tracker/config/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<User?> loginUser(String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setState(() {
        _isLoading = false;
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
      } else {
        // print('Error: ${e.message}');
      }
      return null;
    }
  }

  void login(String email, String password) async {
    User? user = await loginUser(email, password);

    if (user != null) {
      // print('Login successful! User ID: ${user.uid}');
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      // print('Login failed. Please check your credentials.');
    }
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Expense wise',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Let's get started by filling out the form below.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelText: 'Email',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade500, fontSize: 15),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter  email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      labelText: 'Password',
                      hintText: 'Enter valid password',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade500, fontSize: 15),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: const Icon(Icons.visibility_off),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter valid password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        login(email.text, password.text);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNavBar()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10)),
                          maximumSize: Size(
                              MediaQuery.of(context).size.width * 0.5, 45)),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey.shade200),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomNavBar(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          maximumSize: Size(
                              MediaQuery.of(context).size.width * 0.5, 45)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "G",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Continue with google",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black54),
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                          ),
                          TextSpan(
                            text: 'Sign up here',
                            style: TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black54),
                      children: [
                        TextSpan(
                          text: 'By continuing, you agree with our ',
                        ),
                        TextSpan(
                          text: 'privacy policy',
                          style: TextStyle(color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ),
        ));
  }
}
