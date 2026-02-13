import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    SearchScreen(showBackButton: false),
    CartScreen(showBackButton: false),
    ProfileScreen(showBackButton: false),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _pages.length - 1).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(CupertinoIcons.house),
            selectedIcon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.search),
            selectedIcon: Icon(CupertinoIcons.search_circle_fill),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.cart),
            selectedIcon: Icon(CupertinoIcons.cart_fill),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.person),
            selectedIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
