import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../models/photo_model.dart';

// Expose the repository via Riverpod
final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  final dio = ref.watch(dioProvider); // Inject Dio seamlessly
  return PhotoRepository(dio);
});

class PhotoRepository {
  final Dio _dio;

  PhotoRepository(this._dio);

  Future<List<PhotoModel>> fetchCuratedPhotos({int page = 1, int perPage = 20}) async {
    try {
      final response = await _dio.get(
        '/curated',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final List photosJson = response.data['photos'];
      return photosJson.map((json) => PhotoModel.fromJson(json)).toList();
      
    } on DioException catch (e) {
      // Handle Dio specific errors here (can throw custom domain exceptions)
      throw Exception('Failed to fetch photos: ${e.message}');
    }
  }
  Future<List<PhotoModel>> searchPhotos({required String query, int page = 1, int perPage = 20}) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'query': query,
          'page': page,
          'per_page': perPage,
        },
      );

      final List photosJson = response.data['photos'];
      return photosJson.map((json) => PhotoModel.fromJson(json)).toList();
      
    } on DioException catch (e) {
      throw Exception('Search failed: ${e.message}');
    }
  }
}