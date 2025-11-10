import 'dart:convert';
import 'dart:typed_data';

import 'package:barber_app/core/constants/colors.dart';
import 'package:barber_app/core/dependency_injection/di.dart';
import 'package:barber_app/core/services/navigation_service.dart';
import 'package:barber_app/features/auth/screens/signin.dart';
import 'package:barber_app/features/booking/screen/booking_screen.dart';
import 'package:barber_app/features/auth/provider/auth_provider.dart';
import 'package:barber_app/features/home/user/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barber_app/features/home/widgets/service_tile.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final userProv = context.watch<UserProvider>();
    final user = userProv.currentUser;
    final _navService = DI.i<NavigationService>();

    Uint8List? avatarBytes;
    if (user.image.trim().isNotEmpty) {
      try {
        avatarBytes = base64Decode(user.image);
      } catch (_) {
        avatarBytes = null;
      }
    }

    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // hello text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello,',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        user.isNotEmpty ? user.name : 'Guest',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // avatar
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade700,
                    backgroundImage: avatarBytes != null
                        ? MemoryImage(avatarBytes)
                        : null,
                    child: avatarBytes == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),

              const Text(
                'Services',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: ServiceTile(
                      imagePath: 'images/cutting.png',
                      name: 'Hair Cutting',
                      onTap: () {
                        _navService.navigateToScreen(
                          nextScreen: Booking(services: 'Hair Cutting'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    fit: FlexFit.tight,
                    child: ServiceTile(
                      imagePath: 'images/hair.png',
                      name: 'Hair Wash',
                      onTap: () {
                        _navService.navigateToScreen(
                          nextScreen: Booking(services: 'Hair Wash'),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: ServiceTile(
                      imagePath: 'images/shaving.png',
                      name: 'Classic Shaving',
                      onTap: () {
                        _navService.navigateToScreen(
                          nextScreen: Booking(services: 'Classic Shaving'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    fit: FlexFit.tight,
                    child: ServiceTile(
                      imagePath: 'images/facials.png',
                      name: 'Facials',
                      onTap: () {
                        _navService.navigateToScreen(
                          nextScreen: Booking(services: 'Facials'),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: ServiceTile(
                      imagePath: 'images/beard.png',
                      name: 'Beard Trimming',
                      onTap: () {
                        _navService.navigateToScreen(
                          nextScreen: Booking(services: 'Beard Trimming'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    fit: FlexFit.tight,
                    child: ServiceTile(
                      imagePath: 'images/kids.png',
                      name: 'Kids HairCutting',
                      onTap: () {
                        _navService.navigateToScreen(
                          nextScreen: Booking(services: 'Kids HairCutting'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstant.backgroundColor,
        child: const Icon(Icons.logout, color: Colors.white),
        onPressed: () async {
          await context.read<AuthenticationProvider>().signOut();
          if (!context.mounted) return;
          context.read<UserProvider>().clearUser();

          _navService.pushReplacementToScreen(nextScreen: SigninScreen());
        },
      ),
    );
  }
}
