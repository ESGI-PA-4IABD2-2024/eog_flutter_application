import 'package:flutter/material.dart';

class RoadPage extends StatelessWidget {
  final dynamic responseData;

  const RoadPage({required this.responseData});

  @override
  Widget build(BuildContext context) {
    List<Widget> nodes = [];

    // Add top padding to account for Dynamic Island
    nodes.add(const SizedBox(height: 60));

    // Get the keys in the order they appear in the JSON
    List<String> keys = responseData.keys.toList();

    // Add all items from the JSON in the order they appear
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      bool isChangement = key.contains('changement');
      bool isDeparture = key.contains('departure');
      bool isArrival = key.contains('arrival');
      bool isError = key.contains('error');

      nodes.add(Text(
        responseData[key],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: (isChangement | isDeparture | isArrival | isError) ? 18 : 14,
          fontWeight: (isChangement | isDeparture | isArrival | isError) ? FontWeight.bold : FontWeight.normal,
        ),
      ));

      // Add a point if this is not the last element
      if (i < keys.length - 1) {
        nodes.add(const Text(
          '•',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ));
      }
    }

    // Build the UI
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: nodes,
        ),
      ),
    );
  }
}
