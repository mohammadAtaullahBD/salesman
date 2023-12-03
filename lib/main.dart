import 'package:apps/utils/importer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
}
