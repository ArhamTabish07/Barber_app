import 'package:barber_app/core/constants/colors.dart';
import 'package:barber_app/core/dependency_injection/di.dart';
import 'package:barber_app/core/services/navigation_service.dart';
import 'package:barber_app/features/home/screens/home.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

final _navService = DI.i<NavigationService>();

class _OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _navService.pushReplacementToScreen(nextScreen: Home());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      body: Container(
        alignment: Alignment.center,
        child: Image.asset('images/barber.png'),
      ),
    );
  }
}
