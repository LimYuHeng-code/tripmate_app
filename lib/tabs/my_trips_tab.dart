import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/my_trips_service.dart';
import '../../models/trip_item.dart';
import '../views/itinerary_page_view.dart';

class MyTripsTab extends StatelessWidget {
  MyTripsTab({super.key});

  final MyTripsService _service = MyTripsService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print('Current user UID: ${user?.uid}');

    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }

    return StreamBuilder<List<TripItem>>(
      stream: _service.getTrips(user.uid),
      builder: (context, snapshot) {
        print('StreamBuilder connectionState: ${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final trips = snapshot.data ?? [];
        print('Trips count: ${trips.length}');

        if (trips.isEmpty) {
          return const Center(child: Text('No saved trips'));
        }

        return ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final item = trips[index];
            final trip = item.trip;
            print('Trip[$index]: ${trip.toJson()}');

            return ListTile(
              leading: const Icon(Icons.map),
              title: Text('Trip ${index + 1}'),
              subtitle: Text('${trip.days.length} Days'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ItineraryPageView(
                      itineraryData: trip.toJson(),
                    ),
                  ),
                );
              },
              onLongPress: () async {
                await _service.removeTrip(
                  userId: user.uid,
                  docId: item.docId,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip deleted')),
                );
              },
            );
          },
        );
      },
    );
  }
}
