import 'package:barber_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingAdmin extends StatefulWidget {
  const BookingAdmin({super.key});

  @override
  State<BookingAdmin> createState() => _BookingAdminState();
}

class _BookingAdminState extends State<BookingAdmin> {
  Stream? BookingStream;
  getontheLoad() async {
    BookingStream = await Database().getBookings();
    setState(() {});
  }

  @override
  void initState() {
    getontheLoad();
    super.initState();
  }

  Widget allBookings() {
    return StreamBuilder(
      stream: BookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 8)],
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFB2272F), // red
                            Color(0xFF3A153E), // purple
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 10,
                          right: 10,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(ds['Image']),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Service :  " + ds['Service'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "Name :  " + ds['Username'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "Date :  " + ds['Date'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "Time :  " + ds['Time'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      await Database().DeleteBooking(ds.id);
                                    },
                                    child: Container(
                                      height: 50,

                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              ' Done ',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(child: Text('data'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Bookings',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: allBookings(),
      // body: Column(children: [Expanded(child: allBookings())]),
    );
  }
}
