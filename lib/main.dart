import 'package:apps/utils/importer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc()..add(FetchPreviousIfAvailableEvent()),
        ),
        BlocProvider(
          create: (context) => UserLocationBloc(),
        ),
        BlocProvider(
          create: (context) => TaskListBloc(),
        ),
        BlocProvider(
          create: (context) => ShopsBloc(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: getTheme(),
        debugShowCheckedModeBanner: false,
        home: const LauncherScreen(),
        routes: allRouts,
      ),
    );
  }
}
