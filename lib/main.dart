import 'package:barber_app/data/datasource/booking_remote_data_soure.dart';
import 'package:barber_app/data/repo_impl/booking_repo_impl.dart';
import 'package:barber_app/data/repo_impl/user_repo_impl.dart';
import 'package:barber_app/features/onboarding/screen/onboarding_screen.dart';

import 'package:barber_app/provider/auth_provider.dart';
import 'package:barber_app/provider/booking_provider.dart';

import 'package:barber_app/provider/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',

        home: OnboardingScreen(),
      ),
    );
  }
}
