import 'package:apps/utils/importer.dart';

class ShopsRepository {
  Future<List<String?>> getShopList(int uID) async {
    Response res = await get(Uri.parse('$dbUrl/api/user-date-range/$uID'));
    if (res.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(res.body)['user'];
      return [
        result['day_1'],
        result['day_2'],
        result['day_3'],
        result['day_4'],
        result['day_5'],
        result['day_6'],
        result['day_7'],
        result['day_8'],
        result['day_9'],
      ];
    } else {
      throw Exception(res.reasonPhrase);
    }
  }

  Future<List<Shop>> getShops({required String date}) async {
    Response res = await get(Uri.parse('$dbUrl/find-task/${user!.id}/$date'));
    if (res.statusCode == 200) {
      List result = jsonDecode(res.body)['task'];
      return result.map((element) => Shop.fromJson(element)).toList();
    } else {
      throw Exception(res.reasonPhrase);
    }
  }
}
