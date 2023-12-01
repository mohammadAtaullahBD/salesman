import 'package:apps/utils/importer.dart';

final navigatorKey = GlobalKey<NavigatorState>();

double getScreenHeight() =>
    MediaQuery.of(navigatorKey.currentState!.context).size.height;
double getScreenWidth() =>
    MediaQuery.of(navigatorKey.currentState!.context).size.width;

Widget verticalSpace({double height = 0.025}) {
  return SizedBox(
    height: getScreenHeight() * height,
  );
}

Widget horizontalSpace({double width = 0.2}) {
  return SizedBox(
    width: getScreenWidth() * width,
  );
}

String getDate(int index) {
  DateTime date = DateTime.now();
  DateTime resultDate = date.add(Duration(days: index));

  String formattedDate =
      '${resultDate.year}-${resultDate.month}-${resultDate.day}';

  return formattedDate;
}

void launchWaze(Cordinate cor) async {
  final Uri url = Uri.parse(
      'https://www.waze.com/ul?ll=${cor.lat},${cor.lon}&navigate=yes');

  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  } catch (e) {
    // window.open('https://www.waze.com/ul?ll=${cor.lat},${cor.lon}&navigate=yes',
    //     'Waze');
  }
}

Future<String?> getDeviceId() async {
  try {
    final DeviceInfoPlugin device = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await device.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await device.iosInfo;
      return iosInfo.identifierForVendor;
    }
  } catch (e) {
    throw Exception(e);
  }
  return null;
}

void showToastMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 1500),
      content: Text(
        msg, // Retrieve the error message from the state
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
    ),
  );
}
