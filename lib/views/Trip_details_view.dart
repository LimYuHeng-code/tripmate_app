import 'package:flutter/material.dart';
import 'package:tripmate_app/views/generated_itinerary_page.dart';
import '../viewmodels/input_page_viewmodel.dart';
import '../widgets/age_selector.dart';

class TripDetailsPageView extends StatefulWidget {
  final InputPageViewModel viewModel;

  const TripDetailsPageView({super.key, required this.viewModel});

  @override
  State<TripDetailsPageView> createState() => _TripDetailsPageViewState();
}

class _TripDetailsPageViewState extends State<TripDetailsPageView> {
  late InputPageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
    viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  void _handleGenerate() async {
    await viewModel.generateItinerary();
    if (viewModel.itineraryModel != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GeneratedItineraryPageView(viewModel: viewModel),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate itinerary.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final interestOptions = [
      "Culture",
      "Adventure",
      "Food",
      "Nature",
      "Relaxation",
      "Shopping",
      "Must-see Attractions",
      "History",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Trip Planner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Destination
            TextField(
              controller: viewModel.destinationController,
              decoration: const InputDecoration(labelText: "Destination"),
            ),
            const SizedBox(height: 16),

            // Days
            TextField(
              controller: viewModel.daysController,
              decoration: const InputDecoration(labelText: "Days"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Age Selector
            AgeSelector(
              initialAge: int.tryParse(viewModel.ageController.text) ?? 18,
              onChanged: (newAge) {
                viewModel.ageController.text = newAge.toString();
              },
            ),
            const SizedBox(height: 16),

            // Interests
            const Text(
              "Select Your Interests:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: interestOptions.map((e) {
                final isSelected = viewModel.interests.contains(e);
                return FilterChip(
                  label: Text(e),
                  selected: isSelected,
                  selectedColor: Colors.deepPurple,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        viewModel.interests.add(e);
                      } else {
                        viewModel.interests.remove(e);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Budget
            const Text(
              "Indicate Your Budget (float):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: viewModel.budgetController,
              decoration: const InputDecoration(
                labelText: "Budget (e.g. 1200.50)",
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 24),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.isLoading ? null : _handleGenerate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Generate Itinerary",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
