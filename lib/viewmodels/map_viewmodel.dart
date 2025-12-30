import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/itinerary_stop.dart';

class MapViewModel extends ChangeNotifier {
  final List<ItineraryStop> stops;

  Set<Polyline> polylines = {};
  bool isLoading = false;
  String? error;

  MapViewModel({required this.stops}) {
    fetchRoute();
  }

  /// 🔹 Create markers dynamically from stops
  Set<Marker> get markers {
    return stops.map((stop) {
      return Marker(
        markerId: MarkerId(stop.id),
        position: stop.position,
        draggable: true,
        onDragEnd: (newPos) {
          stop.position = newPos;
          fetchRoute();
          notifyListeners();
        },
      );
    }).toSet();
  }

  /// 🔹 Call backend Directions API
  Future<void> fetchRoute() async {
    if (stops.length < 2) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final origin = stops.first.position;
      final destination = stops.last.position;

      final waypoints = stops.length > 2
          ? stops
              .sublist(1, stops.length - 1)
              .map((s) => '${s.position.latitude},${s.position.longitude}')
              .join('|')
          : null;

      final uri = Uri.parse(
        'http://10.0.2.2:8000/directions'
        '?origin_lat=${origin.latitude}'
        '&origin_lng=${origin.longitude}'
        '&dest_lat=${destination.latitude}'
        '&dest_lng=${destination.longitude}'
        '${waypoints != null ? '&waypoints=$waypoints' : ''}',
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch route");
      }

      final data = json.decode(response.body);
      final encoded = data['polyline'];

      final points = _decodePolyline(encoded);

      polylines = {
        Polyline(
          polylineId: const PolylineId("route"),
          points: points,
          width: 5,
          color: Colors.blue,
        ),
      };
    } catch (e) {
      error = "Unable to load route";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Decode Google polyline
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
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      poly.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return poly;
  }
}
