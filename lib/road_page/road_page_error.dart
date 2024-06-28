import 'package:flutter/material.dart';

class ErrorRoadPage extends StatelessWidget {
  const ErrorRoadPage({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child: Text(
          'An error occur. Try again later',
        ),
      ),
    );
  }
}
