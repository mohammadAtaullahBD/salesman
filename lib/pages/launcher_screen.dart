import 'package:apps/utils/importer.dart';

class LauncherScreen extends StatelessWidget {
  static const String route = '/launch';
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is UserLoadedState) {
          BlocProvider.of<UserLocationBloc>(context)
              .add(const FetchUserLocation());
          BlocProvider.of<TaskListBloc>(context).add(FeatchTaskList());
          return DashbordScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
