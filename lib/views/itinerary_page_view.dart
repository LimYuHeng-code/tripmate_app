import 'package:flutter/material.dart';
import '../viewmodels/itinerary_viewmodel.dart';
import '../widgets/share_trip_button.dart';
import '../widgets/save_trip_button.dart';

class ItineraryPageView extends StatefulWidget {
  final Map<String, dynamic> itineraryData;
  final bool isJoining;

  const ItineraryPageView({
    super.key,
    required this.itineraryData,
    this.isJoining = false,
  });

  @override
  State<ItineraryPageView> createState() => _ItineraryPageViewState();
}

class _ItineraryPageViewState extends State<ItineraryPageView> {
  late ItineraryViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ItineraryViewModel(widget.itineraryData);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final days = viewModel.itinerary.days;

        return DefaultTabController(
          length: days.length,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text('My Itinerary'),
              actions: [
                // ✅ Save if joined, Share if owner
                if (widget.isJoining)
                  SaveTripButton(
                    onSave: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Trip saved successfully!'),
                        ),
                      );
                    },
                  )
                else
                  ShareTripButton(itinerary: viewModel.itinerary),

                if (viewModel.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),

                IconButton(
                  icon: Icon(
                    viewModel.isEditing ? Icons.check : Icons.edit,
                  ),
                  tooltip: viewModel.isEditing ? 'Done' : 'Edit',
                  onPressed: viewModel.toggleEditing,
                ),

                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Regenerate Itinerary',
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          await viewModel.regenerateItinerary();
                        },
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: days.keys.map((day) => Tab(text: day)).toList(),
              ),
            ),
            body: TabBarView(
              children: days.keys.map((day) {
                final dayModel = days[day]!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$day: ${dayModel.title}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(day, 'Morning'),
                      _buildSection(day, 'Afternoon'),
                      _buildSection(day, 'Evening'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // -------------------- SECTION BUILDER --------------------
  Widget _buildSection(String day, String period) {
    final controllers = viewModel.controllers[day]![period]!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  period,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (viewModel.isEditing)
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () {
                      viewModel.addActivity(day, period);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controllers.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controllers[index],
                        readOnly: !viewModel.isEditing,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          viewModel.updateActivity(
                              day, period, index, value);
                        },
                      ),
                    ),
                    if (viewModel.isEditing)
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () {
                          viewModel.removeActivity(day, period, index);
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



