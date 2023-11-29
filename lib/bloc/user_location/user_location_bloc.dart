import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:apps/utils/importer.dart';

part 'user_location_event.dart';
part 'user_location_state.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  UserLocationBloc() : super(UserLocationInitialState()) {
    on<UserLocationEvent>((event, emit) async {
      if (event is FetchUserLocation) {
        WidgetsFlutterBinding.ensureInitialized();
        checkAndRequestLocationPermission();
        if (!(await FlutterBackgroundService().isRunning())) {
          _initializeService();
          FlutterBackgroundService().startService();
        } else {
          FlutterBackgroundService().invoke('update');
        }

        FlutterBackgroundService().invoke('setAsForeground');
      }
    });
  }
}

void checkAndRequestLocationPermission() async {
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await Permission.location.isDenied.then((value) {
    if (value) {
      Permission.location.request();
    }
  });
  await Permission.locationAlways.isDenied.then((value) {
    if (value) {
      Permission.locationAlways.request();
    }
  });
}

void _startLocationTracking() async {
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.getInt('userID');

  int? userID = prefs.getInt('userID');
  if (userID != null) {
    geolocator.getCurrentPosition().then((value) {
      UserLocationRepository().sendCordinate(
        6,
        Cordinate(lat: value.latitude, lon: value.longitude),
      );
    });
  }
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
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      service.setForegroundNotificationInfo(
          title: 'Location', content: 'Location Cheaking');
    }
  }

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    debugPrint('background service running');
    _startLocationTracking();
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
