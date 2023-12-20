import 'package:salesman/utils/importer.dart';

class UserRepository {
  // get User
  Future<User> getUser({
    required String email,
    required String password,
    required String? deviceID,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Uri url = Uri.parse('$dbUrl/api/user-login');
    String body = toJson(email, password, deviceID);
    Response response = await post(url, headers: headers, body: body);
    debugPrint('${response.statusCode}');
    debugPrint(body);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var userJson = jsonResponse['user'];
      if (jsonResponse['validation'] != 'Failed') {
        return User.fromJson(userJson);
      }
    }
    throw Exception();
  }

  String toJson(String email, String pass, String? deviceID) {
    return json.encode({
      'email': email,
      'password': pass,
      'deviceId': deviceID,
    });
  }
}
