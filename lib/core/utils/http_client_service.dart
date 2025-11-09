import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/utils/constants.dart';

class DioHttpClientService {
  Dio get client {
    return _dio;
  }

  static final _dio = Dio(
    BaseOptions(
      baseUrl: Constants.apiHost,
      connectTimeout: const Duration(milliseconds: 10000),
      sendTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 60000),
    ),
  );
}

final dioHttpClientService = Provider<DioHttpClientService>((ref) => DioHttpClientService());
