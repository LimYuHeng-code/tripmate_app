import 'package:flutter/material.dart';
import '../viewmodels/itinerary_viewmodel.dart';

class ItineraryPageView extends StatefulWidget {
  final Map<String, dynamic> itineraryData;

  const ItineraryPageView({super.key, required this.itineraryData});

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
                if (viewModel.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                IconButton(
                  icon: Icon(viewModel.isEditing ? Icons.check : Icons.edit),
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
                      _buildSection(day, 'Morning', dayModel.morning),
                      _buildSection(day, 'Afternoon', dayModel.afternoon),
                      _buildSection(day, 'Evening', dayModel.evening),
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

  Widget _buildSection(String day, String period, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(period, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (int i = 0; i < items.length; i++)
              viewModel.isEditing
                  ? TextFormField(
                      initialValue: items[i],
                      onChanged: (v) =>
                          viewModel.updateActivity(day, period, i, v),
                    )
                  : Text('• ${items[i]}'),
          ],
        ),
      ),
    );
  }
}