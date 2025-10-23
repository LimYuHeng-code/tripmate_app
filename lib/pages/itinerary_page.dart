import 'package:flutter/material.dart';
import 'dart:convert';

// ------------------ ITINERARY PAGE ------------------
class ItineraryPage extends StatefulWidget {
  final String itinerary;
  const ItineraryPage({super.key, required this.itinerary});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> with TickerProviderStateMixin {
  List<dynamic> itineraryList = [];

  @override
  void initState() {
    super.initState();
    try {
      itineraryList = jsonDecode(widget.itinerary);
    } catch (e) {
      itineraryList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (itineraryList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Itinerary')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(widget.itinerary),
        ),
      );
    }

    final tabController = TabController(length: itineraryList.length, vsync: this);

    return Theme(
      // Only override TabBarTheme here, keep other themes global
      data: Theme.of(context).copyWith(
        tabBarTheme: TabBarThemeData(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.purple,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.purple,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Itinerary'),
          backgroundColor: Colors.purple,  // Optional: can also omit if your global theme sets this
          bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            indicatorColor: Colors.transparent, // indicator handled by BoxDecoration above
            tabs: [
              for (int i = 0; i < itineraryList.length; i++)
                Tab(text: "Day ${itineraryList[i]['day']}"),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            for (var day in itineraryList)
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Day ${day['day']}: ${day['title'] ?? 'Activities'}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildActivityBlock(
                      timeLabel: "Morning",
                      title: day['morning'] ?? "No activity listed",
                      icon: Icons.wb_sunny_outlined,
                    ),
                    _buildActivityBlock(
                      timeLabel: "Afternoon",
                      title: day['afternoon'] ?? "No activity listed",
                      icon: Icons.lunch_dining_outlined,
                    ),
                    _buildActivityBlock(
                      timeLabel: "Evening",
                      title: day['evening'] ?? "No activity listed",
                      icon: Icons.nightlight_round_outlined,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityBlock({
    required String timeLabel,
    required String title,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.purple, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(title, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
