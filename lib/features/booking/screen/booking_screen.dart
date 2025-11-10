import 'package:barber_app/core/constants/colors.dart';
import 'package:barber_app/features/home/user/provider/user_provider.dart';
import 'package:barber_app/features/booking/provider/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Booking extends StatefulWidget {
  final String services;

  const Booking({super.key, required this.services});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _ensureUserLoaded();
  }

  Future<void> _ensureUserLoaded() async {
    final userProv = context.read<UserProvider>();
    if (userProv.currentUser.isEmpty) {
      await userProv.loadUser();
    }
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) {
      setState(() => _selectedDate = d);
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (t != null) {
      setState(() => _selectedTime = t);
    }
  }

  Future<void> _bookNow() async {
    final userProv = context.read<UserProvider>();
    final bookingProv = context.read<BookingProvider>();

    final user = userProv.currentUser;

    // user SHOULD be loaded now. If still empty, that means Firestore didn't save user properly.
    if (user.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please sign in again (user profile missing).',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select date & time first.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
      return;
    }

    final String dateString =
        '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
    final String timeString = _selectedTime!.format(context);

    await bookingProv.createBooking(
      user: user,
      service: widget.services,
      date: dateString,
      time: timeString,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Service has been booked successfully',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isUserLoading = context.watch<UserProvider>().isLoading;
    final isSubmitting = context.watch<BookingProvider>().isSubmitting;
    final dateLabel = _selectedDate == null
        ? 'e.g:25/12/2025'
        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';

    final timeLabel = _selectedTime == null
        ? 'Pick a time'
        : _selectedTime!.format(context);

    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: isUserLoading
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  left: 15,
                  right: 15,
                  bottom: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Let's the\njourney begin",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset('images/discount.png'),
                    const SizedBox(height: 20),
                    Text(
                      widget.services,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffb4817e),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
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
                                  onPressed: _pickDate,
                                ),
                                Text(
                                  dateLabel,
                                  style: const TextStyle(
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

                    const SizedBox(height: 25),

                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffb4817e),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
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
                                  onPressed: _pickTime,
                                ),
                                Text(
                                  timeLabel,
                                  style: const TextStyle(
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

                    const Spacer(),

                    GestureDetector(
                      onTap: isSubmitting ? null : _bookNow,
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'BOOK NOW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
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
