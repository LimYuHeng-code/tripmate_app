import 'package:flutter/material.dart';

import '../viewmodels/my_trips_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyTripsView extends StatelessWidget {
  final String userId;
  const MyTripsView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final viewModel = MyTripsViewModel(userId: userId);
    final tripsStream = viewModel.tripsStream;
    if (tripsStream == null) {
      return Center(child: Text(viewModel.errorMessage ?? 'No trips found.'));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: tripsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No saved trips.'));
        }
        final trips = snapshot.data!.docs;
        return ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(trip['title'] ?? 'Untitled Trip'),
              subtitle: Text(trip['description'] ?? ''), // Preview/description if available
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ItineraryPageView(itineraryData: trip),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
