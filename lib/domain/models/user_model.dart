class UserModel {
  final String uid;
  final String email;
  final String name;
  // Can be base64 string (your avatar) or "" if not set
  final String image;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.image,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map['uid'] ?? map['Id'] ?? '').toString(),
      email: (map['email'] ?? map['Email'] ?? '').toString(),
      name: (map['name'] ?? map['Name'] ?? '').toString(),
      image: (map['image'] ?? map['Image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'name': name, 'image': image};
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? image,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  factory UserModel.empty() =>
      const UserModel(uid: '', email: '', name: '', image: '');

  bool get isEmpty =>
      uid.isEmpty && email.isEmpty && name.isEmpty && image.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
