import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/itinerary_stop.dart';
import '../viewmodels/map_viewmodel.dart';

class MapView extends StatefulWidget {
  final List<ItineraryStop> stops;

  const MapView({
    super.key,
    required this.stops,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final MapViewModel _vm;

  @override
  void initState() {
    super.initState();

    // 🔹 Create ViewModel using dynamic stops
    _vm = MapViewModel(stops: widget.stops);

    // 🔹 Listen for ViewModel updates
    _vm.addListener(_onVmUpdated);
  }

  void _onVmUpdated() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _vm.removeListener(_onVmUpdated);
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Itinerary Route"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.stops.first.position,
          zoom: 13,
        ),
        markers: _vm.markers,
        polylines: _vm.polylines,

        // 🔒 Stability + performance settings
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        buildingsEnabled: false,
        trafficEnabled: false,
        indoorViewEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
  }
}
