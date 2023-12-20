import 'package:salesman/utils/importer.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitialState()) {
    on<FetchPreviousUserIfAvailableEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      debugPrint('FetchPreviousUserIfAvailableEvent');
      int? preUserID = prefs.getInt('userID');
      String? preUserName = prefs.getString('userName');
      if (preUserID != null && preUserName != null) {
        emit(UserLoadedState(userID: preUserID, name: preUserName));
      } else {
        emit(UserInitialState());
      }
    });
    on<ResetUserEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      debugPrint('ResetUserEvent');
      MyForegroundService.stopForegroundService();
      prefs.remove('userID');
      prefs.remove('userName');
      emit(UserInitialState());
    });
    on<FetchUserEvent>((event, emit) async {
      UserRepository userRepository = UserRepository();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      debugPrint('FetchUserEvent');
      try {
        String? deviceId = await MyForegroundService.getDeviceID();
        User user = await userRepository.getUser(
          email: event.email,
          password: event.password,
          deviceID: deviceId,
        );
        prefs.setInt('userID', user.id);
        prefs.setString('userName', user.name);
        emit(UserLoadedState(userID: user.id, name: user.name));
        MyForegroundService.startForegroundService(userID: '${user.id}');
      } catch (error) {
        emit(UserErrorState(error: DateTime.now().toString()));
      }
    });
  }
}
