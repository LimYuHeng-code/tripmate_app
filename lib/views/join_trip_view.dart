import 'package:flutter/material.dart';
import '../viewmodels/join_trip_viewmodel.dart';
import '../views/itinerary_page_view.dart';

class JoinTripView extends StatefulWidget {
  const JoinTripView({super.key});

  @override
  State<JoinTripView> createState() => _JoinTripViewState();
}

class _JoinTripViewState extends State<JoinTripView> {
  late JoinTripViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = JoinTripViewModel();
    vm.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    vm.removeListener(_onViewModelChanged);
    vm.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (!mounted) return;

    // 🔑 one-shot navigation event
    final itineraryData = vm.joinedItineraryData;
    if (itineraryData == null) return;

    // consume event BEFORE navigating
    vm.clearJoinedItinerary();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ItineraryPageView(
          itineraryData: itineraryData,
          isJoining: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: vm.updateTripCode,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Trip Code',
                border: const OutlineInputBorder(),
                errorText: vm.errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: vm.isLoading ? null : vm.joinTrip,
                child: vm.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Join Trip',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
