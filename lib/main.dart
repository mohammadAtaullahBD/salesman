import 'package:apps/utils/importer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: getTheme(),
        debugShowCheckedModeBanner: false,
        home: const LauncherScreen(),
      ),
      // routes: allRouts,
    );
  }

  Future<void> clearCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('userID');
    if (userID == null) {
      try {
        Directory cacheDir = await getTemporaryDirectory();
        if (cacheDir.existsSync()) {
          cacheDir.deleteSync(recursive: true);
        }
      } catch (e) {
        debugPrint('Error clearing cache: $e');
      }
    }
  }

  @override
  void dispose() {
    clearCache();
    super.dispose();
  }
}
