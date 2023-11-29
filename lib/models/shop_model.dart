import 'package:apps/utils/importer.dart';

class Shop extends Equatable {
  final int id;
  final String? name;
  final String? number;
  final String? status;
  final String? address;
  final Cordinate cordinate;

  const Shop({
    required this.id,
    required this.name,
    required this.number,
    required this.status,
    required this.address,
    required this.cordinate,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['assign_by_shop']['id'],
      name: json['assign_by_shop']['name'],
      number: json['assign_by_shop']['number'],
      status: json['assign_by_shop']['status'],
      address: json['assign_by_shop']['address'],
      cordinate: Cordinate(
        lat: double.parse(
          json['assign_by_shop']['latitude'] ?? '23.742382288941503',
        ),
        lon: double.parse(
          json['assign_by_shop']['longitude'] ?? '90.38655512197339',
        ),
      ),
    );
  }
  @override
  List<Object?> get props => [
        id,
        name,
        number,
        status,
        address,
        cordinate,
      ];
}
