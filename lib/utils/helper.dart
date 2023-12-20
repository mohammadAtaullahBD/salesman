import 'package:salesman/utils/importer.dart';

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

void launchWaze(Coordinate cor) async {
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
