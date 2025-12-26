import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../viewmodels/map_viewmodel.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final MapViewModel _vm;

  @override
  void initState() {
    super.initState();

    _vm = MapViewModel();

    // 🔔 Listen to ViewModel updates
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
      appBar: AppBar(title: const Text("Route (Backend Driven)")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(1.2840, 103.8560),
              zoom: 13,
            ),
            markers: _vm.markers,
            polylines: _vm.polylines,

            // 🔒 Stability settings
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

          if (_vm.isLoading)
            const Center(child: CircularProgressIndicator()),

          if (_vm.error != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black.withOpacity(0.7),
                child: Text(
                  _vm.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
