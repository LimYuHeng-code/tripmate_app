import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TourPackagesPage extends StatefulWidget {
  const TourPackagesPage({super.key});

  @override
  State<TourPackagesPage> createState() => _TourPackagesPageState();
}

class _TourPackagesPageState extends State<TourPackagesPage> {
  List<dynamic> _packages = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    final url = Uri.parse("http://10.0.2.2:8000/packages"); // ← replace with your LAN IP

    try {
      // Backend expects POST for this endpoint. Send an empty JSON body
      // or include filters/pagination as needed by your API.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({}),
      ).timeout(const Duration(seconds: 15));

      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _packages = data['packages'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Failed to load packages: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error fetching packages: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tour Packages')),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())

          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))

              : _packages.isEmpty
                  ? const Center(child: Text('No packages found'))

                  : ListView.builder(
                      itemCount: _packages.length,
                      itemBuilder: (context, index) {
                        final pkg = _packages[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pkg['name'] ?? 'No name',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text("Duration: ${pkg['duration'] ?? '-'}"),
                                Text("Price: S\$${pkg['price'] ?? '-'}"),
                                Text("Accessibility: ${pkg['accessibility'] ?? '-'}"),
                                const SizedBox(height: 8),
                                Text(pkg['description'] ?? ''),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

