import 'package:flutter/material.dart';
import '../map_page/map_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Escape Olympic Games',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 20), // Adds space between the text and the button
            ElevatedButton(
              onPressed: () {
                // Use Navigator to push to MapPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
              child: Text('Go to Map'),
            ),
          ],
        ),
      ),
    );
  }
}