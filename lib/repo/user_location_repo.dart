import 'package:apps/utils/importer.dart';

class UserLocationRepository {
  // send current location
  void sendCoordinate(int userID, Coordinate cord) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Uri url = Uri.parse('$dbUrl/api/user-location/$userID');
    String body = toJson(cord);
    Response response = await put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      debugPrint('user $userID: location updated');
    } else {
      debugPrint('location failed');
    }
  }

  String toJson(Coordinate coordinate) {
    return json.encode(
      {
        'latitude': coordinate.lat.toString(),
        'longitude': coordinate.lon.toString(),
      },
    );
  }
}
