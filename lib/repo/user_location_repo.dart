import 'package:apps/utils/importer.dart';

class UserLocationRepository {
  // send current location
  void sendCordinate(int userID, Cordinate cord) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Uri url = Uri.parse('$dbUrl/api/user-location/$userID');
    String body = toJson(cord);
    Response response = await put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      debugPrint('user $userID: location updated');
    } else {
      debugPrint('location faild');
    }
  }

  String toJson(Cordinate cordinate) {
    return json.encode(
      {
        'latitude': cordinate.lat.toString(),
        'longitude': cordinate.lon.toString(),
      },
    );
  }
}
