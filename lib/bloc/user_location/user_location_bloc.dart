import 'dart:ui';
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
          FlutterBackgroundService().invoke('update');
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

  if (!notificationStatus.isGranted) {
    checkAndRequestLocationPermission();
  }

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

void _startLocationTracking(int userID) async {
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  geolocator.getCurrentPosition().then((value) {
    UserLocationRepository().sendCordinate(
      userID,
      Cordinate(lat: value.latitude, lon: value.longitude),
    );
  });
}

void stopForegroundService() {
  FlutterBackgroundService().invoke('stopService');
}

void _initializeService() async {
  final service = FlutterBackgroundService();

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

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    debugPrint('background service running');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('userID');
    if (userID != null) {
      _startLocationTracking(userID);
    } else {
      debugPrint("background service stopping");
      service.stopSelf();
      return;
    }
    // TODO: set the stop condition by uncommenting this code.
    // if (8 < DateTime.now().hour && DateTime.now().hour < 20) {
    //   debugPrint('background service running');
    //   _startLocationTracking();
    // } else {
    //   FlutterBackgroundService().invoke('stopService');
    // }

    // service.invoke('update');
    // FlutterBackgroundService().invoke('setAsForeground');
    // FlutterBackgroundService().invoke('setAsBackground');
    // FlutterBackgroundService().startService();
  });
}
