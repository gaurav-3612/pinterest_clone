import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';

// This provider exposes a pre-configured Dio instance to the rest of the app
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.pexelsBaseUrl,
      headers: {
        'Authorization': AppConstants.pexelsApiKey,
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Optional: Add logging for debugging
  dio.interceptors.add(LogInterceptor(responseBody: true));

  return dio;
});