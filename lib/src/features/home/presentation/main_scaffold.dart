import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent, 
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_filled, color: Colors.grey),
            selectedIcon: Icon(Icons.home_filled, color: Colors.black),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search, color: Colors.grey, size: 28),
            selectedIcon: Icon(Icons.search, color: Colors.black, size: 30),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.add, color: Colors.grey, size: 32),
            selectedIcon: Icon(Icons.add, color: Colors.black, size: 32),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.chat_bubble, color: Colors.black),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.person, color: Colors.black),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}