import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItineraryStop {
  final String id;
  LatLng position;

  ItineraryStop({
    required this.id,
    required this.position,
  });
}
