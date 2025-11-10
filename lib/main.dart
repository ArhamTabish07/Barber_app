import 'package:barber_app/core/dependency_injection/di.dart';
import 'package:barber_app/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:barber_app/features/onboarding/screen/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DI.instance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Barber App',
        navigatorKey: NavigationService.navigatorKey,

        home: OnboardingScreen(),
      ),
    );
  }
}
