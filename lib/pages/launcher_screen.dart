import 'package:apps/utils/importer.dart';

class LauncherScreen extends StatefulWidget {
  static const String route = '/launch';
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    initilize();
    super.initState();
  }
  void initilize() async{
    WidgetsFlutterBinding.ensureInitialized();
    await initializeService();
  }
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      BlocProvider.of<UserBloc>(context).add(FetchPreviousUserIfAvailableEvent());
    });
    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        switch(state) {
          case UserLoadedState():
            return const DashbordScreen();
          case UserInitialState():
          case UserErrorState():
          default:
          return const LoginScreen();
        }
      },
    );
  }
}
