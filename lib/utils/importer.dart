// ignore_for_file: depend_on_referenced_packages

// Dart
export 'dart:convert';
export 'dart:io';
export 'dart:async';

// Packages
export 'package:flutter/material.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:http/http.dart';
export 'package:equatable/equatable.dart';
export 'package:bloc/bloc.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:device_info_plus/device_info_plus.dart';
export 'package:flutter_background_service/flutter_background_service.dart';
export 'package:flutter_background_service_android/flutter_background_service_android.dart';
// export 'package:location/location.dart' show Location, LocationData;
export 'package:permission_handler/permission_handler.dart';
export 'package:shared_preferences/shared_preferences.dart';

// Repositorys
export 'package:apps/repo/shops_repo.dart';
export 'package:apps/repo/user_location_repo.dart';
export 'package:apps/repo/user_repo.dart';

// Bloc
export 'package:apps/bloc/shops/shops_bloc.dart';
export 'package:apps/bloc/user_location/user_location_bloc.dart';
export 'package:apps/bloc/user/user_bloc.dart';
export 'package:apps/bloc/task_list/task_list_bloc.dart';
// export 'package:apps/bloc/route/route_bloc.dart';

// Models
export 'package:apps/models/user_model.dart';
export 'package:apps/models/shop_model.dart';
export 'package:apps/models/cordinate_model.dart';

// Pages
export 'package:apps/pages/launcher_screen.dart';
export 'package:apps/pages/login_screen.dart';
export 'package:apps/pages/dashbord_screen.dart';
export 'package:apps/pages/shops_screen.dart';

// Widgets
export 'package:apps/widgets/drawer.dart';
export 'package:apps/widgets/alert_widget.dart';
export 'package:apps/widgets/theme.dart';
export 'package:apps/widgets/shop_card_widget.dart';

// Utils
export 'helper.dart';
export 'routing.dart';
export 'custom_style.dart';
export 'image_utils.dart';
export 'constants.dart';
