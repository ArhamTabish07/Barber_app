import 'package:barber_app/colors.dart';
import 'package:barber_app/services/database.dart';
import 'package:barber_app/services/shared_prefrences.dart';
import 'package:flutter/material.dart';

class Booking extends StatefulWidget {
  final String services;

  const Booking({super.key, required this.services});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? name, image, email;

  getTheDataFromSharedPref() async {
    name = await SharedPreferencesHelper().getUserName();
    image = await SharedPreferencesHelper().getUserImage();
    email = await SharedPreferencesHelper().getUserEmail();
    setState(() {});
  }

  getontheLoad() async {
    await getTheDataFromSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState(); // call super FIRST
    getontheLoad(); // single loader
  }

  DateTime? _selected;
  TimeOfDay? _selectedtime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15.0,
            left: 15,
            right: 15,
            bottom: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's the\njourney begin",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              Image.asset('images/discount.png'),
              SizedBox(height: 20),
              Text(
                widget.services,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffb4817e),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Set a Date',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate: _selected ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (d != null)
                                setState(() => _selected = d); // updates UI
                            },
                          ),
                          Text(
                            _selected == null
                                ? 'e.g:25/12/2025'
                                : '${_selected!.day}/${_selected!.month}/${_selected!.year}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),

              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffb4817e),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Set a Time',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.alarm,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () async {
                              final t = await showTimePicker(
                                context: context,
                                initialTime: _selectedtime ?? TimeOfDay.now(),
                              );
                              if (t != null)
                                setState(
                                  () => _selectedtime = t,
                                ); // <-- assign TimeOfDay
                            },
                          ),
                          Text(
                            _selectedtime == null
                                ? 'Pick a time'
                                : _selectedtime!.format(context),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  Map<String, dynamic> userBookingmap = {
                    'Service': widget.services,
                    'Date':
                        '${_selected!.day}/${_selected!.month}/${_selected!.year}',
                    'Time': _selectedtime!.format(context).toString(),
                    'Username': name,
                    'Image': image,
                    'Email': email,
                  };
                  await Database().addUserBooking(userBookingmap).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Service has been booked successfully',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  });
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          'BOOK NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
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
      ),
    );
  }
}
