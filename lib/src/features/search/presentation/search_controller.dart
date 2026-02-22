import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest_clone/src/features/home/data/repository/photo_repository.dart';
import '../../home/data/models/photo_model.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchControllerProvider = AsyncNotifierProvider<SearchControllerNotifier, List<PhotoModel>>(
  SearchControllerNotifier.new,
);

class SearchControllerNotifier extends AsyncNotifier<List<PhotoModel>> {
  @override
  FutureOr<List<PhotoModel>> build() {
    return []; // Start empty
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncData([]);
      return;
    }
    
    state = const AsyncLoading();
    try {
      final repository = ref.read(photoRepositoryProvider);
      final results = await repository.searchPhotos(query: query);
      state = AsyncData(results);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}