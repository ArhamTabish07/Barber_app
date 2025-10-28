class BookingModel {
  final String id;
  final String service;
  final String username;
  final String email;
  final String imageBase64OrUrl;
  final String date;
  final String time;
  final String createdAt;

  BookingModel({
    required this.id,
    required this.service,
    required this.username,
    required this.email,
    required this.imageBase64OrUrl,
    required this.date,
    required this.time,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'Service': service,
      'Username': username,
      'Email': email,
      'Image': imageBase64OrUrl,
      'Date': date,
      'Time': time,
      'CreatedAt': createdAt,
    };
  }

  factory BookingModel.fromMap(
    Map<String, dynamic> map, {
    required String docId,
  }) {
    return BookingModel(
      id: docId,
      service: (map['Service'] ?? '').toString(),
      username: (map['Username'] ?? '').toString(),
      email: (map['Email'] ?? '').toString(),
      imageBase64OrUrl: (map['Image'] ?? '').toString(),
      date: (map['Date'] ?? '').toString(),
      time: (map['Time'] ?? '').toString(),
      createdAt: (map['CreatedAt'] ?? '').toString(),
    );
  }
}
