import 'package:apps/utils/importer.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = UserRepository();
  UserBloc() : super(UserInitialState()) {
    on<UserEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (event is FetchPreviousIfAvailableEvent) {
        int? preUserID = prefs.getInt('userID');
        if (preUserID != null) {
          emit(UserLoadedState(userID: preUserID));
        }
      }
      if (event is ResetUserEvent) {
        stopForegroundService();
        prefs.remove('userID');
        prefs.remove('userName');
        emit(UserInitialState());
      }
      // if(event is Us)
      if (event is FetchUserEvent) {
        try {
          String deviceId = await getDeviceId() ?? 'Unable device ID';
          User user = await _userRepository.getUser(
            email: event.email,
            password: event.password,
            deviceID: deviceId,
          );
          prefs.remove('userID');
          prefs.remove('userName');
          prefs.setInt('userID', user.id);
          prefs.setString('userName', user.name);
          emit(UserLoadedState(userID: user.id));
        } catch (error) {
          emit(UserErrorState(error: DateTime.now().toString()));
        }
      }
    });
  }
}
