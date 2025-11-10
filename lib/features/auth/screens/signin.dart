import 'package:barber_app/core/dependency_injection/di.dart';
import 'package:barber_app/core/services/navigation_service.dart';
import 'package:barber_app/features/auth/screens/forgot_password.dart';
import 'package:barber_app/features/auth/screens/signup.dart';
import 'package:barber_app/core/constants/colors.dart';
import 'package:barber_app/features/auth/provider/auth_provider.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  final _navService = DI.i<NavigationService>();
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authLoading = context.watch<AuthenticationProvider>().isLoading;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorConstant.gradientRed,
              ColorConstant.gradientPurple,
              ColorConstant.gradientDeepPurple,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Sign in!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Gmail",
                            style: TextStyle(
                              color: ColorConstant.headingMaroon,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter Email'
                                : null,
                            decoration: const InputDecoration(
                              hintText: "Gmail",
                              prefixIcon: Icon(Icons.mail_outline),
                              isDense: true,
                              border: UnderlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24),
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
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter Password'
                                : null,
                            decoration: const InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock_outline),
                              isDense: true,
                              border: UnderlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                _navService.navigateToScreen(
                                  nextScreen: ForgotPassword(),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: authLoading
                                ? null
                                : () {
                                    final authProv = context
                                        .read<AuthenticationProvider>();
                                    if (_formkey.currentState!.validate()) {
                                      authProv.signIn(
                                        email: emailController.text.trim(),
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: authLoading
                                      ? [
                                          ColorConstant.buttonRed.withOpacity(
                                            0.5,
                                          ),
                                          ColorConstant.buttonPurple
                                              .withOpacity(0.5),
                                        ]
                                      : const [
                                          ColorConstant.buttonRed,
                                          ColorConstant.buttonPurple,
                                        ],
                                ),
                              ),
                              child: Center(
                                child: authLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Text(
                                        "SIGN IN",
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
                          Center(
                            child: Text.rich(
                              TextSpan(
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                ),
                                children: [
                                  const TextSpan(text: "Don't have account? "),
                                  TextSpan(
                                    text: "Sign up",
                                    style: const TextStyle(
                                      color: ColorConstant.linkPurple,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _navService.navigateToScreen(
                                          nextScreen: SignUpScreen(),
                                        );
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
            ],
          ),
        ),
      ),
    );
  }
}
