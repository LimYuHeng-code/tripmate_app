import 'package:flutter/material.dart';
import '../models/itinerary_model.dart';
import '../views/share_trip_view.dart';

class ShareTripButton extends StatelessWidget {
  final ItineraryModel itinerary;
  const ShareTripButton({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      tooltip: 'Share Trip',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShareTripPage(itinerary: itinerary),
          ),
        );
      },
    );
  }
}
