import 'package:apps/utils/importer.dart';

class LauncherScreen extends StatelessWidget {
  static const String route = '/launch';
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      BlocProvider.of<UserBloc>(context).add(FetchPreviousUserIfAvailableEvent());
    });
    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is UserLoadedState) {
          return const DashbordScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
