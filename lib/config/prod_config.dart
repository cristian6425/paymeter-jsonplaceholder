

import 'package:paymeterjsonplaceholder/config/base_config.dart';

class ProdConfig extends BaseConfig {
  const ProdConfig();

  @override
  String get apiHost => 'https://jsonplaceholder.typicode.com';

  @override
  String get postUrl => '$apiHost/posts';
}
