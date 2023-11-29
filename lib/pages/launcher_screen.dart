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
          // The global user is inatialized here
          user = state.user;
          BlocProvider.of<UserLocationBloc>(context).add(FetchUserLocation(
            user: state.user,
          ));
          BlocProvider.of<TaskListBloc>(context).add(FeatchTaskList(
            uID: state.user.id,
          ));
          return DashbordScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
