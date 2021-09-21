///
/// Created by Claudio Oliveira
///
/// https://twitter.com/cldlvr
///

import 'package:dio/dio.dart';

class ApiClient {
  static Dio? _dioInstance;
  static BaseOptions? _options;
  static InterceptorsWrapper? _dioInterceptor;

  static Dio api() {
    if (_options == null) {
      _options = BaseOptions(
        baseUrl: "https://endereco_da_minha.api/",
        connectTimeout: 30 * 1000,
      );
    }

    _dioInstance = (_dioInstance == null ? Dio(_options) : _dioInstance);

    if (_dioInterceptor == null) {
      _dioInterceptor = AuthInterceptors();
      _dioInstance!.interceptors.add(_dioInterceptor!);
    }

    return _dioInstance!;
  }
}

class AuthInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers = await this.getHeaders();
    return super.onRequest(options, handler);
  }

  Future<Map<String, String>> getHeaders() async {
    String token = "...authToken";

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token,
    };
  }
}

///
///
///   Example of use
///
///   Response res = await ApiClient.api().post('channel/test', data: {"name" : "DevLab"});
///   if (res.statusCode != 200) {
///     throw Exception(res.data);
///   }
///   return Model.fromJson(res.data);
///
///