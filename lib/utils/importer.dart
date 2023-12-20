// ignore_for_file: depend_on_referenced_packages

// Dart
export 'dart:convert';
export 'dart:io';
export 'dart:async';

// Packages
export 'package:flutter/material.dart';
export 'package:flutter/widgets.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:http/http.dart';
export 'package:equatable/equatable.dart';
export 'package:bloc/bloc.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:shared_preferences/shared_preferences.dart';

// Repositories
export 'package:salesman/repo/shops_repo.dart';
export 'package:salesman/repo/user_location_repo.dart';
export 'package:salesman/repo/user_repo.dart';

// Bloc
export 'package:salesman/bloc/shops/shops_bloc.dart';
export 'package:salesman/bloc/user/user_bloc.dart';
export 'package:salesman/bloc/task_list/task_list_bloc.dart';
// export 'package:salesman/bloc/route/route_bloc.dart';

// Models
export 'package:salesman/models/user_model.dart';
export 'package:salesman/models/shop_model.dart';
export 'package:salesman/models/coordinate_model.dart';

// Pages
export 'package:salesman/pages/launcher_screen.dart';
export 'package:salesman/pages/login_screen.dart';
export 'package:salesman/pages/dashbord_screen.dart';
export 'package:salesman/pages/shops_screen.dart';
export 'package:salesman/main.dart';

// Widgets
export 'package:salesman/widgets/drawer.dart';
export 'package:salesman/widgets/alert_widget.dart';
export 'package:salesman/widgets/theme.dart';
export 'package:salesman/widgets/shop_card_widget.dart';

// Utils
export 'helper.dart';
export 'routing.dart';
export 'custom_style.dart';
export 'image_utils.dart';
export 'constants.dart';
export 'location_service.dart';
