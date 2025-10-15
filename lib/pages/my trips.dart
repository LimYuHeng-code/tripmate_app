import 'package:flutter/material.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = [
      {'title': 'Bali Trip - Sep 2025', 'image': 'https://i.imgur.com/QsY0Gmw.jpg'},
      {'title': 'Korea Trip - Oct 2025', 'image': 'https://i.imgur.com/5M2vI6a.jpg'},
      {'title': 'Japan Trip - Nov 2025', 'image': 'https://i.imgur.com/AZlI9jW.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(trip['image']!,
                            height: 150, width: double.infinity, fit: BoxFit.cover),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            trip['title']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('New Trip'),
              onPressed: () {
                Navigator.pushNamed(context, '/newTrip');
              },
            ),
          ],
        ),
      ),
    );
  }
}
