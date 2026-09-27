import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.timeout,
        receiveTimeout: ApiConstants.timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 1. İstek ve Hata Detaylarını Konsola Basan Interceptor
    dio.interceptors.add(
      LogInterceptor(
        request: true,   // Atılan tam URL'i gösterir
        requestHeader: false,
        requestBody: true,  // Gönderilen veriyi gösterir
        responseBody: true, // Sunucudan dönen cevabı gösterir
        error: true,        // Hata detayını gösterir
        logPrint: (object) => debugPrint('🔍 [DIO]: $object'),
      ),
    );

    // 2. Auth Token Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }
}