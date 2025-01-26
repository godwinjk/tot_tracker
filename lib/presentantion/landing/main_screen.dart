import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tot_tracker/router/route_path.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _tabs = [RoutePath.summary, RoutePath.home,RoutePath.schedule,  RoutePath.summary];
  int _currentIndex = 1;

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      context.go(_tabs[index]); // Navigate to the selected tab route
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment), label: 'Summary'),
          BottomNavigationBarItem(
              icon: Icon(Icons.child_care_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
