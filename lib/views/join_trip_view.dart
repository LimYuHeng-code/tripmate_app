import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/jointrip_viewmodel.dart';
import '../views/itinerary_page_view.dart';

class JoinTripPage extends StatefulWidget {
  const JoinTripPage({super.key});

  @override
  State<JoinTripPage> createState() => _JoinTripPageState();
}

class _JoinTripPageState extends State<JoinTripPage> {
  final _tripCodeController = TextEditingController();
  final JoinTripViewModel viewModel = JoinTripViewModel();

  @override
  void dispose() {
    _tripCodeController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _joinTrip() async {
    final user = FirebaseAuth.instance.currentUser;
    if (_tripCodeController.text.isEmpty || user == null) return;

    setState(() {}); // trigger loading indicator

    await viewModel.joinTrip(
      tripCode: _tripCodeController.text.trim(),
      userId: user.uid,
    );

    setState(() {}); // stop loading

    if (viewModel.errorMessage != null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage!)),
      );
    } else if (viewModel.itinerary != null) {
      // Navigate to the itinerary page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ItineraryPageView(
            itineraryData: viewModel.itinerary!.toJson(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Trip')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _tripCodeController,
              decoration: const InputDecoration(
                labelText: 'Enter Trip Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: viewModel.isJoining ? null : _joinTrip,
              child: viewModel.isJoining
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Join Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
