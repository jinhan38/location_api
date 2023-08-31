import 'package:dio/dio.dart';

abstract class BaseApi {
  late final Dio _dio;

  BaseApi(this._dio);

  void setHeader({
    required String baseUrl,
    required Map<String, dynamic> header
  }) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (status) {
        return status! < 500;
      },
      contentType: Headers.jsonContentType,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
      headers:header,
    );
  }

  ///dio get
  Future<Response?> dioGet(String url) async {
    try {
      ///데이터 호출
      Response response = await _dio.get(url);

      if (response.statusCode != 200) {
        return null;
      }

      return response;
    } catch (e) {
      return null;
    }
  }

  ///dio post
  Future<Response?> dioPost(String url, {required dynamic data}) async {
    try {

      ///데이터 호출
      Response response = await _dio.post(url, data: data);

      // 잘못된 요청
      if (response.statusCode != 200) {
        return null;
      }

      return response;
    } catch (e) {
      return null;
    }
  }

}
