import 'package:flutter/material.dart';
import 'package:flutter_first_proto/map_page/map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 30,
          ),
          displayMedium: TextStyle(
            fontSize: 25,
            color: Colors.orange,
          ),
        ),
      ),
      home: const MapPage(),
    );
  }
}