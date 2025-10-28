import 'package:barber_app/features/auth/screens/forgot_password.dart';
import 'package:barber_app/features/auth/screens/signup.dart';
import 'package:barber_app/features/home/screens/home.dart';
import 'package:barber_app/provider/auth_provider.dart';
import 'package:barber_app/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formkey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    final authProv = context.read<AuthenticationProvider>();
    final err = await authProv.signIn(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    setState(() {
      _loading = false;
    });

    if (err != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    // we are signed in now
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    await context.read<UserProvider>().loadUserByUid(uid);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffb91635), Color(0xff621d3c), Color(0xff311937)],
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
                              color: Color(0xFF7B1F2B),
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
                              color: Color(0xFF7B1F2B),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ForgotPassword(),
                                  ),
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
                            onTap: _loading ? null : _handleSignIn,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: _loading
                                      ? [
                                          const Color(
                                            0xFFB2272F,
                                          ).withOpacity(0.5),
                                          const Color(
                                            0xFF3A153E,
                                          ).withOpacity(0.5),
                                        ]
                                      : const [
                                          Color(0xFFB2272F),
                                          Color(0xFF3A153E),
                                        ],
                                ),
                              ),
                              child: Center(
                                child: _loading
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
                                      color: Color(0xFF6B2C7B),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SignUpScreen(),
                                          ),
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
