import 'package:salesman/utils/importer.dart';

class LauncherScreen extends StatelessWidget {
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      BlocProvider.of<UserBloc>(context)
          .add(FetchPreviousUserIfAvailableEvent());
    });
    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        switch (state) {
          case UserLoadedState():
            return const DashbordScreen();
          case UserInitialState():
          case UserErrorState():
            return const LoginScreen();
        }
      },
    );
  }
}
