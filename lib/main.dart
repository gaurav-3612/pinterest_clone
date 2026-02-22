import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'src/config/routing/app_router.dart';

void main() {
  runApp(
    ProviderScope(
      child: ClerkAuth(
        // Wrap your key in ClerkAuthConfig
        config: ClerkAuthConfig(
          publishableKey: "pk_test_bWVhc3VyZWQtbWFja2VyZWwtMjMuY2xlcmsuYWNjb3VudHMuZGV2JA",
        ),
        child: const PinterestCloneApp(),
      ),
    ),
  );
}


class PinterestCloneApp extends StatelessWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pinterest Clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE60023)), // Pinterest Red
        useMaterial3: true,
      ),
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}