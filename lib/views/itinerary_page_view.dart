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
                Row(
                  children: [
                    IconButton(
                      icon: Icon(viewModel.isEditing ? Icons.check : Icons.edit),
                      tooltip: viewModel.isEditing ? 'Done' : 'Edit',
                      onPressed: viewModel.toggleEditing,
                    ),
                    GestureDetector(
                      onTap: viewModel.toggleEditing,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          viewModel.isEditing ? 'Done' : 'Edit',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: days.keys.map((day) => Tab(text: day)).toList(),
                labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
                      _buildEditableSection(day, 'Morning', dayModel.morning),
                      _buildEditableSection(day, 'Afternoon', dayModel.afternoon),
                      _buildEditableSection(day, 'Evening', dayModel.evening),
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

  Widget _buildEditableSection(String day, String period, List<String> details) {
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
                period,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 8),
              for (int i = 0; i < details.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: viewModel.isEditing
                            ? TextFormField(
                                initialValue: details[i],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                ),
                                style: const TextStyle(fontSize: 14, height: 1.4),
                                onChanged: (val) {
                                  viewModel.updateActivity(day, period, i, val);
                                },
                              )
                            : Text(
                                '• ${details[i]}',
                                style: const TextStyle(fontSize: 14, height: 1.4),
                              ),
                      ),
                      if (viewModel.isEditing) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            viewModel.removeActivity(day, period, i);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              if (viewModel.isEditing)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add, color: Colors.deepPurple),
                    label: const Text('Add Activity'),
                    onPressed: () {
                      viewModel.addActivity(day, period);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}