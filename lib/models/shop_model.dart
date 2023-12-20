import 'package:salesman/utils/importer.dart';

class Shop extends Equatable {
  final String? id;
  final String? name;
  final String? number;
  final String? status;
  final String? address;
  final Coordinate coordinate;

  const Shop({
    required this.id,
    required this.name,
    required this.number,
    required this.status,
    required this.address,
    required this.coordinate,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['assign_by_shop']['shop_code'],
      name: json['assign_by_shop']['name'],
      number: json['assign_by_shop']['number'],
      status: json['assign_by_shop']['status'],
      address: json['assign_by_shop']['address'],
      coordinate: Coordinate(
        lat: double.parse(
          json['assign_by_shop']['latitude'] ?? '0',
        ),
        lon: double.parse(
          json['assign_by_shop']['longitude'] ?? '0',
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
        coordinate,
      ];
}
