import 'package:flutter/material.dart';
import 'package:tripmate_app/viewmodels/input_page_viewmodel.dart';
import 'trip_details_view.dart';

class DestinationPageView extends StatefulWidget {
  const DestinationPageView({super.key});

  @override
  State<DestinationPageView> createState() => _DestinationPageViewState();
}

class _DestinationPageViewState extends State<DestinationPageView> {
  late final InputPageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = InputPageViewModel(); // ✅ ONLY HERE
  }

  @override
  void dispose() {
    viewModel.dispose(); // ✅ dispose once
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Destination")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: viewModel.destinationController,
              decoration: const InputDecoration(labelText: "Destination"),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Next"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TripDetailsPageView(viewModel: viewModel),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
