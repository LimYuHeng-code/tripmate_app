import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../viewmodels/itinerary_viewmodel.dart';

class ItineraryMapWidget extends StatefulWidget {
  final ItineraryViewModel viewModel;

  const ItineraryMapWidget({super.key, required this.viewModel});

  @override
  State<ItineraryMapWidget> createState() => _ItineraryMapWidgetState();
}

class _ItineraryMapWidgetState extends State<ItineraryMapWidget> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    // Listen to changes in the ViewModel
    widget.viewModel.addListener(_updateMarkers);
    _updateMarkers(); // initial load
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_updateMarkers);
    super.dispose();
  }

  Future<void> _updateMarkers() async {
    final locations = await widget.viewModel.getPlaceCoordinates();
    if (locations.isEmpty || mapController == null) {
      setState(() => markers = {});
      return;
    }

    Set<Marker> newMarkers = {};
    double minLat = locations.first["lat"];
    double maxLat = locations.first["lat"];
    double minLng = locations.first["lng"];
    double maxLng = locations.first["lng"];

    for (int i = 0; i < locations.length; i++) {
      final loc = locations[i];
      final point = LatLng(loc["lat"], loc["lng"]);

      newMarkers.add(
        Marker(
          markerId: MarkerId("place_$i"),
          position: point,
          infoWindow: InfoWindow(title: loc["name"]),
        ),
      );

      minLat = loc["lat"] < minLat ? loc["lat"] : minLat;
      maxLat = loc["lat"] > maxLat ? loc["lat"] : maxLat;
      minLng = loc["lng"] < minLng ? loc["lng"] : minLng;
      maxLng = loc["lng"] > maxLng ? loc["lng"] : maxLng;
    }

    setState(() {
      markers = newMarkers;
    });

    // Adjust camera to fit all markers
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(1.3521, 103.8198), // Default: Singapore
          zoom: 12,
        ),
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
          _updateMarkers();
        },
        zoomControlsEnabled: true,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
