import 'package:salesman/utils/importer.dart';

class Coordinate extends Equatable {
  final double lat;
  final double lon;
  const Coordinate({
    required this.lat,
    required this.lon,
  });

  @override
  List<Object?> get props => [lat, lon];
}
