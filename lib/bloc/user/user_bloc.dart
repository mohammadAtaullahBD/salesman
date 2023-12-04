import 'package:apps/utils/importer.dart';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = UserRepository();
  UserBloc() : super(UserInitialState()) {
    on<UserEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (event is FetchPreviousUserIfAvailableEvent) {
        int? preUserID = prefs.getInt('userID');
        String? preUserName = prefs.getString('userName');
        if (preUserID != null && preUserName != null) {
          emit(UserLoadedState(userID: preUserID, name: preUserName));
        }else{
          while (await FlutterBackgroundService().isRunning()) {
            FlutterBackgroundService().invoke('stopService');
          }
          prefs.remove('userID');
          prefs.remove('userName');
          prefs.clear();
          emit(UserInitialState());
        }
      }
      if (event is ResetUserEvent) {
        while (await FlutterBackgroundService().isRunning()) {
          FlutterBackgroundService().invoke('stopService');
        }
        prefs.remove('userID');
        prefs.remove('userName');
        prefs.clear();
        emit(UserInitialState());
      }
      if (event is FetchUserEvent) {
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

          checkAndRequestLocationPermission();
          if (!(await FlutterBackgroundService().isRunning())) {
            await initializeService();
            FlutterBackgroundService().startService();
            FlutterBackgroundService().invoke('setAsForeground');
          } else {
            FlutterBackgroundService().invoke('stopService');
            await Future.delayed(const Duration(seconds: 5));
            await initializeService();
            FlutterBackgroundService().startService();
            FlutterBackgroundService().invoke('setAsForeground');
          }
        } catch (error) {
          emit(UserErrorState(error: DateTime.now().toString()));
        }
      }
    });
  }
}

void checkAndRequestLocationPermission() async {
  PermissionStatus notificationStatus = await Permission.notification.status;

  if (notificationStatus.isDenied) {
    notificationStatus = await Permission.notification.request();
  }

  // if (!notificationStatus.isGranted) {
  //   checkAndRequestLocationPermission();
  // }

  PermissionStatus locationStatus = await Permission.location.status;

  if (locationStatus.isDenied) {
    locationStatus = await Permission.location.request();
  }
  PermissionStatus locationAlwaysStatus =
      await Permission.locationAlways.status;

  if (locationAlwaysStatus.isDenied) {
    locationAlwaysStatus = await Permission.locationAlways.request();
  }
}

void _startLocationTracking({
  required int userID,
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  required GeolocatorPlatform geolocator,
}) async {
  try {
    geolocator.getCurrentPosition().then((value) {
      UserLocationRepository().sendCordinate(
        userID,
        Cordinate(lat: value.latitude, lon: value.longitude),
      );
      // flutterLocalNotificationsPlugin.show(
      //   notificationId,
      //   'Location',
      //   'Lat: ${value.latitude}, Lon: ${value.longitude}',
      //   const NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       notificationChannelId,
      //       notificationChannelName,
      //       icon: 'ic_bg_service_small',
      //       ongoing: true,
      //     ),
      //   ),
      // );
    });
  } catch (error) {
    //
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high, // importance must be at low or higher level
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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen(
      (event) {
        service.setAsForegroundService();
      },
    );
    service.on('setAsBackground').listen(
      (event) {
        service.setAsBackgroundService();
      },
    );
  }
// stopService
  service.on('stopService').listen(
    (event) async {
      service.stopSelf();
    },
  );

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      service.setForegroundNotificationInfo(
          title: 'Location', content: 'Location Checking');
    }
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userID = prefs.getInt('userID');
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  // TODO: change the timer 5s to 30s or 60s
  Timer.periodic(
    const Duration(seconds: 5),
    (timer) async {
      // TODO: set the stop condition by uncommenting this code.
      // if (8 < DateTime.now().hour && DateTime.now().hour < 20) {
      debugPrint('background service running');
      if (userID != null) {
        _startLocationTracking(
          userID: userID,
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
          geolocator: geolocator,
        );
      } else {
        debugPrint("background service stopping");
        service.stopSelf();
        return;
      }
      // } else {
      // debugPrint("background service stopping");
      // service.stopSelf();
      // }

      // service.invoke('update');
      // FlutterBackgroundService().invoke('setAsForeground');
      // FlutterBackgroundService().invoke('setAsBackground');
      // FlutterBackgroundService().startService();
    },
  );
}
