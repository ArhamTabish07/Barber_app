import 'package:barber_app/Admin/booking_admin.dart';
import 'package:barber_app/pages/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
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
                      "Admin\nPanel",
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
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'Name',
                              prefixIcon: Icon(Icons.person_outline),
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black87,
                                  width: 1.5,
                                ), // <-- visible color
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                          // Gmail
                          // const Text(
                          //   "Gmail",
                          //   style: TextStyle(
                          //     color: Color(0xFF7B1F2B),
                          //     fontSize: 24,
                          //     fontWeight: FontWeight.w700,
                          //   ),
                          // ),

                          // const SizedBox(height: 24),

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
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter Password';
                            //   }
                            //   return null;
                            // },
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock_outline),
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black87,
                                  width: 1.5,
                                ), // <-- visible color
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
                              loginAdmin();
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
                                  "LOGIN",
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
                          // Center(
                          //   child: Text.rich(
                          //     TextSpan(
                          //       style: const TextStyle(
                          //         color: Colors.black87,
                          //         fontSize: 20,
                          //       ),
                          //       children: [
                          //         const TextSpan(
                          //           text: "Already have an Account? ",
                          //         ),
                          //         TextSpan(
                          //           text: "Sign In",
                          //           style: const TextStyle(
                          //             color: Color(0xFF6B2C7B),
                          //             fontWeight: FontWeight.w700,
                          //           ),
                          //           recognizer: TapGestureRecognizer()
                          //             ..onTap = () {
                          //               Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       SigninScreen(),
                          //                 ),
                          //               );
                          //               // handle tap
                          //             },
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
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

  loginAdmin() {
    FirebaseFirestore.instance.collection('Admin').get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['id'] != nameController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Your id is not correct',
                style: TextStyle(fontSize: 24),
              ),
            ),
          );
        } else if (result.data()['password'] !=
            passwordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Your password is not correct',
                style: TextStyle(fontSize: 24),
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingAdmin()),
          );
        }
      });
    });
  }
}
