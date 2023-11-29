import 'package:apps/utils/importer.dart';

class Cordinate extends Equatable {
  final double lat;
  final double lon;
  const Cordinate({
    required this.lat,
    required this.lon,
  });

  @override
  List<Object?> get props => [lat, lon];
}
