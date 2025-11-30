import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;

  Future<void> addUser(String userId, String name, String email) async {
    final user = FirebaseFirestore.instance.collection('users').doc(userId);
    setState(() {
      _isLoading = true;
    });
    await user.set({
      'name': name,
      'email': email,
      'cashWallet': 0.0,
    });
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> signUp(
    String name,
    String email,
  
    String password,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (e.code == 'weak-password') {
        // print('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Expense wise',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Create an account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Let's get started by filling out the form below.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      //  focusColor: Colors.grey.shade200,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelText: 'Name',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 12),
                      // errorText: "Enter your name",
                      // errorStyle: const TextStyle(color: Colors.red),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter valid name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      // errorText: "Enter valid email",
                      //errorStyle: TextStyle(color: Colors.red),
                      labelText: 'Email',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 12),

                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 12),

                      fillColor: Colors.grey.shade200,
                      filled: true,
                      labelText: 'Password',
                      // errorText: "Enter valid password",
                      // errorStyle: TextStyle(color: Colors.red),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        signUp(
                          name.text,
                          email.text,
                          password.text,
                        );
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
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
                              backgroundColor: Colors.blue,
                            )
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(width: 1, color: Colors.grey.shade200)),
                    child: ElevatedButton(
                      onPressed: () {},
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
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Login()));
                    },
                    child: const Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black54),
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                          ),
                          TextSpan(
                            text: 'Sign in here',
                            style: TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'By continuing, you agree with our ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black54),
                      ),
                      TextSpan(
                        text: 'Privacy & Policy',
                        style: TextStyle(color: Colors.orange),
                      )
                    ]),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
