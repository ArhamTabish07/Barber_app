// ignore_for_file: unused_local_variable

// import 'dart:math';

import 'package:barber_app/pages/home.dart';
import 'package:barber_app/pages/onboarding.dart';
import 'package:barber_app/pages/signin.dart';
import 'package:barber_app/services/database.dart';
import 'package:barber_app/services/shared_prefrences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? name, email, password;
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  registration() async {
    if (password != null && name != null && email != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
        final uid = userCredential.user!.uid;

        await SharedPreferencesHelper().saveUserName(nameController.text);
        await SharedPreferencesHelper().saveUserEmail(emailController.text);
        await SharedPreferencesHelper().saveUserImage(
          'https://imgs.search.brave.com/nq7mlUmoqNq-axG-yn9faHqBlxBoYTIWB5jwDhtwGN0/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi9iL2I2L0lt/YWdlX2NyZWF0ZWRf/d2l0aF9hX21vYmls/ZV9waG9uZS5wbmcv/MTIwMHB4LUltYWdl/X2NyZWF0ZWRfd2l0/aF9hX21vYmlsZV9w/aG9uZS5wbmc',
        );
        await SharedPreferencesHelper().saveUserId(uid);

        Map<String, dynamic> userInfoMap = {
          'Name': nameController.text,
          'Email': emailController.text,
          'Id': uid,
          'Image':
              'https://imgs.search.brave.com/nq7mlUmoqNq-axG-yn9faHqBlxBoYTIWB5jwDhtwGN0/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi9iL2I2L0lt/YWdlX2NyZWF0ZWRf/d2l0aF9hX21vYmls/ZV9waG9uZS5wbmcv/MTIwMHB4LUltYWdl/X2NyZWF0ZWRfd2l0/aF9hX21vYmlsZV9w/aG9uZS5wbmc',
        };
        await Database().addUserDetails(userInfoMap, uid);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registered Successfully',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Onboarding()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Provided password is too weak',
                style: TextStyle(fontSize: 24),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'The account already exist',
                style: TextStyle(fontSize: 24),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background gradient (only visible behind the header area)
        decoration: const BoxDecoration(
          gradient: const LinearGradient(
            // begin: Alignment.centerLeft,
            // end: Alignment.centerRight,
            colors: [
              Color(0xffb91635), // red
              Color(0xff621d3c), // purple
              Color(0xff311937), //
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----- HEADER (stays on gradient) -----
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Your\nAccount",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    // Text(
                    //   "Sign in!",
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 32,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                  ],
                ),
              ),

              // ----- WHITE SECTION (fills the rest) -----
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Name",
                              style: TextStyle(
                                color: Color(0xFF7B1F2B),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Name';
                                }
                                return null;
                              },
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: "Name",
                                prefixIcon: Icon(Icons.mail_outline),
                                isDense: true,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black45,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Gmail
                            const Text(
                              "Gmail",
                              style: TextStyle(
                                color: Color(0xFF7B1F2B),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Email';
                                }
                                return null;
                              },
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Gmail",
                                prefixIcon: Icon(Icons.mail_outline),
                                isDense: true,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black45,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Password
                            const Text(
                              "Password",
                              style: TextStyle(
                                color: Color(0xFF7B1F2B),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                }
                                return null;
                              },
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock_outline),
                                isDense: true,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black45,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ),

                            // const SizedBox(height: 10),

                            // const Align(
                            //   alignment: Alignment.centerRight,
                            //   child: Text(
                            //     "Forgot Password?",
                            //     style: TextStyle(
                            //       color: Colors.black87,
                            //       fontSize: 20,
                            //       fontWeight: FontWeight.w600,
                            //     ),
                            //   ),
                            // ),
                            const Spacer(),

                            // Sign In button (kept inside white area now)
                            GestureDetector(
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    email = emailController.text;
                                    name = nameController.text;
                                    password = passwordController.text;
                                  });
                                  registration();
                                }
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFB2272F), // red
                                      Color(0xFF3A153E), // purple
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Bottom text
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: "Already have an Account? ",
                                    ),
                                    TextSpan(
                                      text: "Sign In",
                                      style: const TextStyle(
                                        color: Color(0xFF6B2C7B),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SigninScreen(),
                                            ),
                                          );
                                          // handle tap
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
