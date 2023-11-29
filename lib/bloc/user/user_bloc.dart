import 'package:apps/utils/importer.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = UserRepository();
  UserBloc() : super(UserInitialState()) {
    on<UserEvent>((event, emit) async {
      if (event is ResetUserEvent) {
        emit(UserInitialState());
      }
      if (event is FetchUserEvent) {
        try {
          String deviceId = await getDeviceId() ?? 'Unable device ID';
          User user = await _userRepository.getUser(
            email: event.email,
            password: event.password,
            deviceID: deviceId,
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('userID', user.id);
          emit(UserLoadedState(user: user));
        } catch (error) {
          emit(UserErrorState(error: DateTime.now().toString()));
        }
      }
    });
  }
}
