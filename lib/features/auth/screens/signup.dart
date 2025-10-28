import 'dart:typed_data';
import 'package:barber_app/features/auth/screens/signin.dart';
import 'package:barber_app/features/home/screens/home.dart';
import 'package:barber_app/provider/auth_provider.dart';
import 'package:barber_app/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Uint8List? _imageBytes;
  bool _loading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() {
      _imageBytes = bytes;
    });
  }

  Future<void> _handleSignUp() async {
    if (!_formkey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    final authProv = context.read<AuthenticationProvider>();

    final err = await authProv.signUp(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      imageBytes: _imageBytes,
    );

    setState(() {
      _loading = false;
    });

    if (err != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    // Signed up successfully -> hydrate UserProvider
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
                      "Create Your\nAccount",
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
                          Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 64,
                                  backgroundImage: _imageBytes != null
                                      ? MemoryImage(_imageBytes!)
                                      : const NetworkImage(
                                              'https://i.stack.imgur.com/l60Hf.png',
                                            )
                                            as ImageProvider,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 85,
                                  child: IconButton(
                                    onPressed: _pickImage,
                                    icon: const Icon(Icons.add_a_photo),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
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
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter Name'
                                : null,
                            decoration: const InputDecoration(
                              hintText: "Name",
                              prefixIcon: Icon(Icons.person_outline),
                              isDense: true,
                              border: UnderlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24),
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
                          const SizedBox(height: 32),
                          GestureDetector(
                            onTap: _loading ? null : _handleSignUp,
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
                                            builder: (_) =>
                                                const SigninScreen(),
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
