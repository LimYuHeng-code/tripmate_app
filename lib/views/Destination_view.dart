import 'package:flutter/material.dart';
import 'package:tripmate_app/viewmodels/input_page_viewmodel.dart';
import 'trip_details_view.dart';

class DestinationViewPage extends StatefulWidget {
  const DestinationViewPage({super.key});

  @override
  State<DestinationViewPage> createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationViewPage> {
  late final InputPageViewModel viewModel;

  int selectedDays = 3; // default

  @override
  void initState() {
    super.initState();
    viewModel = InputPageViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plan Your Trip"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🌍 Destination
            const Text(
              "Where do you want to go?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: viewModel.destinationController,
              decoration: InputDecoration(
                hintText: "Enter destination...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 📅 Days Picker Title
            const Text(
              "How many days?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// 🔥 Scroll Wheel Picker
            SizedBox(
              height: 150,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 50,
                perspective: 0.003,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedDays = index + 1;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final day = index + 1;
                    final isSelected = day == selectedDays;

                    return Center(
                      child: Text(
                        "$day",
                        style: TextStyle(
                          fontSize: isSelected ? 32 : 20,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                    );
                  },
                  childCount: 14, // max 14 days
                ),
              ),
            ),

            const Spacer(),

            /// ✅ Continue Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final destination =
                      viewModel.destinationController.text.trim();

                  if (destination.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a destination"),
                      ),
                    );
                    return;
                  }

                  /// 🔥 Save selected days
                  viewModel.setFlexibleDays(selectedDays);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TripDetailsPageView(
                        viewModel: viewModel,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}