import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/src/features/home/data/repository/photo_repository.dart';
import '../../data/models/photo_model.dart';

// The Notifier exposing the state to the UI
final photoControllerProvider = AsyncNotifierProvider<PhotoController, List<PhotoModel>>(
  PhotoController.new,
);

class PhotoController extends AsyncNotifier<List<PhotoModel>> {
  int _currentPage = 1;
  bool _isFetchingMore = false;

  @override
  FutureOr<List<PhotoModel>> build() async {
    // Initial fetch when the provider is first watched
    _currentPage = 1;
    return _fetchPhotos(page: _currentPage);
  }

  Future<List<PhotoModel>> _fetchPhotos({required int page}) async {
    final repository = ref.read(photoRepositoryProvider);
    return await repository.fetchCuratedPhotos(page: page, perPage: 20);
  }

  // Method to trigger pagination from the UI
  Future<void> fetchNextPage() async {
    if (_isFetchingMore || !state.hasValue) return;
    
    _isFetchingMore = true;
    _currentPage++;

    try {
      final newPhotos = await _fetchPhotos(page: _currentPage);
      // Append new photos to the existing state
      state = AsyncData([...state.value!, ...newPhotos]);
    } catch (e, stackTrace) {
      // Handle pagination error without destroying the existing grid
      state = AsyncError(e, stackTrace);
    } finally {
      _isFetchingMore = false;
    }
  }
}