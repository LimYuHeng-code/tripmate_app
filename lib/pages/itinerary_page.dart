import 'package:flutter/material.dart';

class ItineraryPage extends StatelessWidget {
  final Map<String, dynamic> itineraryData;

  const ItineraryPage({super.key, required this.itineraryData});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: itineraryData.keys.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('My Itinerary'),
          bottom: TabBar(
            isScrollable: true,
            tabs: itineraryData.keys.map((day) => Tab(text: day)).toList(),
            labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: TabBarView(
          children: itineraryData.keys.map((day) {
            final activities = itineraryData[day];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$day: ${activities['title']}',
                    style: const TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (activities['Morning'] != null)
                    _buildSection('Morning', activities['Morning']),
                  if (activities['Afternoon'] != null)
                    _buildSection('Afternoon', activities['Afternoon']),
                  if (activities['Evening'] != null)
                    _buildSection('Evening', activities['Evening']),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<dynamic> details) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: Colors.deepPurple.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 8),
              for (var item in details)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '• $item',
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
