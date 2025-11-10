import 'package:barber_app/features/auth/provider/auth_provider.dart';
import 'package:barber_app/core/constants/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  late TextEditingController nameController = TextEditingController();

  late TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    nameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background gradient (only visible behind the header area)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // begin: Alignment.centerLeft,
            // end: Alignment.centerRight,
            colors: [
              ColorConstant.gradientRed, // red
              ColorConstant.gradientPurple, // purple
              ColorConstant.gradientDeepPurple, //
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
                      "Admin\nLogin",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
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
                              color: ColorConstant.headingMaroon,
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

                          // Password
                          const Text(
                            "Password",
                            style: TextStyle(
                              color: ColorConstant.headingMaroon,
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

                          const Spacer(),

                          // Sign In button
                          GestureDetector(
                            onTap: () {
                              context.read<AuthenticationProvider>().loginAdmin(
                                id: nameController.text,
                                password: passwordController.text,
                              );
                            },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    ColorConstant.buttonRed, // red
                                    ColorConstant.buttonPurple, // purple
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
}
