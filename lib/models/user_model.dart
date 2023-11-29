import 'package:apps/utils/importer.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String number;
  final String email;
  final String? deviceID;
  const User({
    required this.id,
    required this.name,
    required this.number,
    required this.email,
    required this.deviceID,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      email: json['email'],
      deviceID: json['deviceId'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        number,
        email,
        deviceID,
      ];
}
