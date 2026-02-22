import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';

import 'controllers/photo_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen to scroll events for pagination
    _scrollController.addListener(() {
      // Fetch next page when user scrolls within 200 pixels of the bottom
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(photoControllerProvider.notifier).fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

// Inside lib/src/features/home/presentation/home_screen.dart

  @override
  Widget build(BuildContext context) {
    final photoState = ref.watch(photoControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      // Replace the standard AppBar and Body with a CustomScrollView
      body: RefreshIndicator(
        color: const Color(0xFFE60023), // Pinterest Red
        onRefresh: () async {
          // Add haptic feedback for that polished feel
          HapticFeedback.mediumImpact();
          // Invalidate the provider to force a fresh fetch
          ref.invalidate(photoControllerProvider);
          // Wait a moment for UI to show loading
          await Future.delayed(const Duration(seconds: 1)); 
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1. The Magic Hiding App Bar
            const SliverAppBar(
              backgroundColor: Colors.white,
              floating: true, // Appears as soon as you scroll up
              snap: true,     // Snaps fully into view
              elevation: 0,
              title: Text(
                'For You', 
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              centerTitle: true,
            ),
        
            // 2. The Masonry Grid converted to a Sliver
            photoState.when(
              data: (photos) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childCount: photos.length,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.go('/home/details', extra: photo);
                      },
                      child: Hero(
                        tag: 'photo_${photo.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: photo.aspectRatio,
                            child: CachedNetworkImage(
                              imageUrl: photo.mediumUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[200]),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: Color(0xFFE60023))),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}