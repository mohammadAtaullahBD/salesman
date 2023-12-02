import 'package:apps/utils/importer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: getTheme(),
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                UserBloc()..add(FetchPreviousUserIfAvailableEvent()),
          ),
          BlocProvider(
            create: (context) => UserLocationBloc(),
          ),
          BlocProvider(
            create: (context) => TaskListBloc(),
          ),
        ],
        child: const LauncherScreen(),
      ),
      // routes: allRouts,
    );
  }
}
