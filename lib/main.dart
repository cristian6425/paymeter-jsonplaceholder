import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/config/environment.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/app.dart';

void main() {
  const String environment = String.fromEnvironment('app.flavor');
  Environment().initConfig(EnvironmentType.fromString(environment));
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('es', null).then((_) => runApp(const ProviderScope(child: MyApp())));
}
