

import 'package:paymeterjsonplaceholder/config/base_config.dart';
import 'package:paymeterjsonplaceholder/config/prod_config.dart';

import 'dev_config.dart';

enum EnvironmentType {
  dev('dev'),
  prod('prod');

  const EnvironmentType(this.value);
  final String value;

  static EnvironmentType fromString(String? raw) {
    return EnvironmentType.values.firstWhere(
      (env) => env.value == raw,
      orElse: () => EnvironmentType.dev,
    );
  }

  BaseConfig get config => switch (this) {
        EnvironmentType.prod => const ProdConfig(),
        EnvironmentType.dev => const DevConfig(),
      };
}

class Environment {
  Environment._();
  static final Environment _instance = Environment._();

  factory Environment() => _instance;

  late BaseConfig _config;

  BaseConfig get config => _config;

  void initConfig(EnvironmentType type) {
    _config = type.config;
  }
}
