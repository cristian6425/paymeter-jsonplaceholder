import 'package:flutter/material.dart';
import 'package:paymeterjsonplaceholder/config/environment.dart';

class Constants {
  const Constants._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static String apiHost = Environment().config.apiHost;
}
