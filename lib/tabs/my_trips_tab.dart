import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../services/my_trips_service.dart';
import '../../models/trip_item.dart';
import '../views/itinerary_page_view.dart';
import 'package:tripmate_app/models/itinerary_mode.dart';

class MyTripsTab extends StatelessWidget {
  MyTripsTab({super.key});

  final MyTripsService _service = MyTripsService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('Current user UID: ${user?.uid}');

    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }

    return StreamBuilder<List<TripItem>>(
      stream: _service.getTrips(user.uid),
      builder: (context, snapshot) {
        debugPrint('Stream state: ${snapshot.connectionState}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final trips = snapshot.data ?? [];
        debugPrint('Trips count: ${trips.length}');

        if (trips.isEmpty) {
          return const Center(child: Text('No saved trips'));
        }

        return ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final item = trips[index];
            final trip = item.trip;

            return Slidable(
              key: ValueKey(item.docId),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (context) async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Trip'),
                          content: const Text(
                              'Are you sure you want to delete this trip?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed != null && confirmed) {
                        await _service.removeTrip(
                          userId: user.uid,
                          docId: item.docId,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Trip deleted')),
                          );
                        }
                      }
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.map),
                title: Text('Trip ${index + 1}'),
                subtitle: Text('${trip.days.length} Days'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItineraryPageView(
                        itineraryData: trip.toJson(),
                        mode: ItineraryMode.myTrip,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
