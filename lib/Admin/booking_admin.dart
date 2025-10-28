import 'dart:convert';
import 'dart:typed_data';

import 'package:barber_app/provider/booking_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingAdmin extends StatelessWidget {
  const BookingAdmin({super.key});

  ImageProvider? _buildAvatarImage(String raw) {
    if (raw.isEmpty) return null;

    // URL case
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return NetworkImage(raw);
    }

    // base64 case
    try {
      Uint8List bytes = base64Decode(raw);
      return MemoryImage(bytes);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Bookings',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: provider.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No Bookings found',
                style: TextStyle(fontSize: 24, color: Colors.black87),
              ),
            );
          }

          final docs = snapshot.data.docs as List<DocumentSnapshot>;
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No Bookings found',
                style: TextStyle(fontSize: 24, color: Colors.black87),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final ds = docs[index];
              final data = ds.data() as Map<String, dynamic>? ?? {};

              final username = (data['Username'] ?? '').toString();
              final service = (data['Service'] ?? '').toString();
              final date = (data['Date'] ?? '').toString();
              final time = (data['Time'] ?? '').toString();
              final imgRaw = (data['Image'] ?? '').toString();

              final avatarProvider = _buildAvatarImage(imgRaw);

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(spreadRadius: 1, blurRadius: 8),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFB2272F), Color(0xFF3A153E)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black26,
                          backgroundImage: avatarProvider,
                          child: avatarProvider == null
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 40,
                                )
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Service :  $service",
                          style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Name :  $username",
                          style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Date :  $date",
                          style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Time :  $time",
                          style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            await provider.delete(ds.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Booking deleted'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
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
            },
          );
        },
      ),
    );
  }
}
