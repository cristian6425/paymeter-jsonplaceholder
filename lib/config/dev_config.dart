

import 'package:paymeterjsonplaceholder/config/base_config.dart';

class DevConfig extends BaseConfig {
  const DevConfig();

  @override
  String get apiHost => 'https://jsonplaceholder.typicode.com';

  @override
  String get postUrl => '$apiHost/posts';
}
