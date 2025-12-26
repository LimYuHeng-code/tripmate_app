import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapViewModel extends ChangeNotifier {
  static const String _backendBaseUrl =
      "http://10.0.2.2:8000"; // Android emulator localhost

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  bool isLoading = false;
  bool _isUpdating = false;
  String? error;

  MapViewModel() {
    _initMarkers();
    fetchRoute();
  }

  void _initMarkers() {
    markers = {
      Marker(
        markerId: const MarkerId("1"),
        position: const LatLng(1.2834, 103.8607),
        draggable: true,
        onDragEnd: (pos) => onMarkerDragged("1", pos),
      ),
      Marker(
        markerId: const MarkerId("2"),
        position: const LatLng(1.2850, 103.8520),
        draggable: true,
        onDragEnd: (pos) => onMarkerDragged("2", pos),
      ),
    };
  }

  Future<void> onMarkerDragged(String id, LatLng newPos) async {
    if (_isUpdating) return;
    _isUpdating = true;

    markers = markers.map((m) {
      if (m.markerId.value == id) {
        return m.copyWith(positionParam: newPos);
      }
      return m;
    }).toSet();

    notifyListeners();

    await fetchRoute();
    _isUpdating = false;
  }

  Future<void> fetchRoute() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final list = markers.toList()
        ..sort((a, b) => a.markerId.value.compareTo(b.markerId.value));

      final origin = list.first.position;
      final destination = list.last.position;

      final uri = Uri.parse(
        '$_backendBaseUrl/directions'
        '?origin_lat=${origin.latitude}'
        '&origin_lng=${origin.longitude}'
        '&dest_lat=${destination.latitude}'
        '&dest_lng=${destination.longitude}',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception("Backend error: ${response.body}");
      }

      final data = jsonDecode(response.body);
      final encoded = data["polyline"];

      final points = _decodePolyline(encoded);

      polylines = {
        Polyline(
          polylineId: const PolylineId("route"),
          points: points,
          width: 6,
          color: Colors.blue,
          geodesic: true,
        )
      };
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Google polyline decoder
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }
}
