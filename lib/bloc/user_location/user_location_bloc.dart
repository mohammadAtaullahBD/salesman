import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:apps/utils/importer.dart';

part 'user_location_event.dart';
part 'user_location_state.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  UserLocationBloc() : super(UserLocationInitialState()) {
    on<UserLocationEvent>((event, emit) async {
      if (event is FetchUserLocation) {
        checkAndRequestLocationPermission();
        if (!(await FlutterBackgroundService().isRunning())) {
          _initializeService();
          FlutterBackgroundService().startService();
          FlutterBackgroundService().invoke('setAsForeground');
        } else {
          FlutterBackgroundService().invoke('stopService');
          await Future.delayed(const Duration(seconds: 10));
          _initializeService();
          FlutterBackgroundService().startService();
          FlutterBackgroundService().invoke('setAsForeground');
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
}

void stopForegroundService() async {
  if (await FlutterBackgroundService().isRunning()) {
    FlutterBackgroundService().invoke('stopService');
  }
}

void _initializeService() async {
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
      autoStart: true,
      onForeground: _onStart,
      onBackground: _onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
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
Future<bool> _onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void _onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
// stopService
  service.on('stopService').listen((event) async {
    service.stopSelf();
  });

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      service.setForegroundNotificationInfo(
          title: 'Location', content: 'Location Checking');
    }
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userID;
  // TODO: change the timer 5s to 30s or 60s
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    // TODO: set the stop condition by uncommenting this code.
    // if (8 < DateTime.now().hour && DateTime.now().hour < 20) {
    debugPrint('background service running');
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    userID = prefs.getInt('userID');
    if (userID != null) {
      _startLocationTracking(
        userID: userID!,
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
  });
}
