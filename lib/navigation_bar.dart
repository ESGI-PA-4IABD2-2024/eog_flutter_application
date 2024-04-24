import 'package:flutter/material.dart';
import 'package:flutter_first_proto/map_page/map_page.dart';
import 'package:flutter_first_proto/not_implemented_page/not_implemented_page.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const Navigation(),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  final List<Widget> _pages = [
    MenuMapPage(),
    MenuHistoryPage(),
    MenuSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.green[200],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.map),
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: _pages[currentPageIndex], // Display the page based on the selected index
    );
  }
}

// Simple placeholder widgets for each page
class MenuMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MapPage());
  }
}

class MenuHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NotImplementedPage());
  }
}

class MenuSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NotImplementedPage());
  }
}