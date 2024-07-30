import 'package:dio/dio.dart';

import '../constant.dart';

class HTTPService {
  static final HTTPService _singleton = HTTPService._internal();

  final _dio = Dio();

  factory HTTPService() {
    return _singleton;
  }

  HTTPService._internal() {
    setup();
  }

  Future<void> setup({String? apiKey}) async {
    final headers = {
      "Content-Type": "application/json",
    };

   if (apiKey != null) {
    headers['X-API-KEY'] = apiKey; // Adjust the header key as needed
  }
    final options = BaseOptions(
        baseUrl: apiBaseUrl,
        headers: headers,
        validateStatus: (status) {
          if (status == null) return false;
          return status < 500;
        });

    _dio.options = options;
  }

  // function for get request
  Future<Response?> get(String path, {required Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      print(e);
    }
  }
}
