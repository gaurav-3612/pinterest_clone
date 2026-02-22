import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pinterest_clone/src/features/search/presentation/search_controller.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (query) {
              ref.read(searchControllerProvider.notifier).search(query);
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.black54),
              hintText: 'Search for ideas',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ),
      ),
      body: searchState.when(
        data: (photos) {
          if (photos.isEmpty) {
            return const Center(
              child: Text('Search for inspiration to get started', 
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // We can reuse the details route!
                    context.go('/search/details', extra: photo); 
                  },
                  child: Hero(
                    tag: 'search_photo_${photo.id}', // Unique tag for search
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: photo.aspectRatio,
                        child: CachedNetworkImage(
                          imageUrl: photo.mediumUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFE60023))),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}