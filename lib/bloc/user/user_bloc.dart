import 'package:apps/utils/importer.dart';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = UserRepository();
  UserBloc() : super(UserInitialState()) {
    on<UserEvent>(
      (event, emit) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (event is FetchPreviousUserIfAvailableEvent) {
          debugPrint('FetchPreviousUserIfAvailableEvent');
          int? preUserID = prefs.getInt('userID');
          String? preUserName = prefs.getString('userName');
          if (preUserID != null && preUserName != null) {
            emit(UserLoadedState(userID: preUserID, name: preUserName));
            FlutterBackgroundService().invoke('startLocationTracking');
          } else {
            FlutterBackgroundService().invoke('stopService');
            emit(UserInitialState());
          }
        }

        if (event is ResetUserEvent) {
          debugPrint('ResetUserEvent');
          FlutterBackgroundService().invoke('stopService');
          prefs.remove('userID');
          prefs.remove('userName');
          emit(UserInitialState());
        }

        if (event is FetchUserEvent) {
          debugPrint('FetchUserEvent');
          try {
            String? deviceId = await getDeviceId();
            User user = await _userRepository.getUser(
              email: event.email,
              password: event.password,
              deviceID: deviceId,
            );
            prefs.setInt('userID', user.id);
            prefs.setString('userName', user.name);
            emit(UserLoadedState(userID: user.id, name: user.name));
            FlutterBackgroundService().startService();
            FlutterBackgroundService().invoke('setAsForeground');
            await checkAndRequestLocationPermission();
            FlutterBackgroundService().invoke('startLocationTracking');
          } catch (error) {
            emit(UserErrorState(error: DateTime.now().toString()));
          }
        }
      },
    );
  }
}

Future<bool> checkAndRequestLocationPermission() async {
  if (await Permission.notification.status.isDenied) {
    await Permission.notification.request();
  }

  if (await Permission.location.status.isDenied) {
    await Permission.location.request();
  }

  if (await Permission.locationAlways.status.isDenied) {
    await Permission.locationAlways.request();
  }

  return true;
}

void _startLocationTrackingInBackground({
  required int? userID,
  required GeolocatorPlatform geolocator,
  required ServiceInstance service,
}) {
  Timer.periodic(
    const Duration(seconds: 60),
    (timer) async {
      try {
        if (userID != null) {
          geolocator.getCurrentPosition().then(
                (value) {
              UserLocationRepository().sendCoordinate(
                userID,
                Coordinate(lat: value.latitude, lon: value.longitude),
              );
            },
          );
        }else{
          service.stopSelf();
          timer.cancel();
        }
      } catch (error) {
        //
      }
    },
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    iosConfiguration: IosConfiguration(
      onForeground: _onStart,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: _onStart,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'Location',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,
    ),
  );
}

@pragma('vm:entry-point')
void _onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen(
      (event) {
        service.setAsForegroundService();
      },
    );
  }
// stopService
  service.on('stopService').listen(
    (event) {
      service.stopSelf();
    },
  );
  service.on('startLocationTracking').listen(
    (event) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          service.setForegroundNotificationInfo(
            title: 'Location',
            content: 'Location Checking',
          );
        }
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userID = prefs.getInt('userID');
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      debugPrint('background service running');
      _startLocationTrackingInBackground(
        userID: userID,
        geolocator: geolocator,
        service: service,
      );
    },
  );

// service.invoke('update');
  // FlutterBackgroundService().invoke('setAsForeground');
  // FlutterBackgroundService().startService();
}
