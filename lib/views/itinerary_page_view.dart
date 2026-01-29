import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/itinerary_viewmodel.dart';
import '../viewmodels/share_trip_viewmodel.dart';
import '../widgets/save_trip_button.dart';
import '../services/my_trips_service.dart';
import '../models/itinerary_model.dart';
import '../views/share_trip_view.dart';

class ItineraryPageView extends StatefulWidget {
  final Map<String, dynamic> itineraryData;
  final String? ownerId; // optional ownerId to hide save button for owner

  const ItineraryPageView({
    super.key,
    required this.itineraryData,
    this.ownerId,
  });

  @override
  State<ItineraryPageView> createState() => _ItineraryPageViewState();
}

class _ItineraryPageViewState extends State<ItineraryPageView> {
  late ItineraryViewModel viewModel;
  bool isSaved = false; // local state for SaveTripButton
  bool canSave = false; // flag to control if Save button should show

  @override
  void initState() {
    super.initState();
    viewModel = ItineraryViewModel(widget.itineraryData);

    // compute if user can save
    final currentUser = FirebaseAuth.instance.currentUser;
    canSave = currentUser != null && widget.ownerId != currentUser.uid;
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  // ------------------- SHARE TRIP -------------------
  Future<void> _shareTrip() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login to share trips')),
      );
      return;
    }

    final shareVM = ShareTripViewModel();
    await shareVM.shareTrip(
      itinerary: viewModel.itinerary,
      ownerId: currentUser.uid,
    );

    if (shareVM.isSaved) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShareTripPage(itinerary: viewModel.itinerary),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(shareVM.errorMessage ?? 'Failed to share trip')),
      );
    }
  }

  // ------------------- SAVE TRIP -------------------
  Future<void> _saveTrip() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || !canSave) return;

    final itinerary = ItineraryModel.fromJson(widget.itineraryData);

    await MyTripsService().addTrip(
      userId: currentUser.uid,
      itinerary: itinerary,
    );

    setState(() {
      isSaved = true;
      canSave = false; // prevent double saving
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trip saved to My Trips')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final days = viewModel.itinerary.days;

        return DefaultTabController(
          length: days.keys.length,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text('My Itinerary'),
              actions: [
                // ------------------- SHARE BUTTON -------------------
                IconButton(
                  icon: const Icon(Icons.share),
                  tooltip: 'Share Trip',
                  onPressed: _shareTrip,
                ),

                // ------------------- SAVE BUTTON -------------------
                if (canSave)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SaveTripButton(
                      isSaved: isSaved,
                      compact: true,
                      onPressed: isSaved ? () {} : _saveTrip,
                    ),
                  ),

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
                  onPressed:
                      viewModel.isLoading ? null : viewModel.regenerateItinerary,
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
                Text(period, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (viewModel.isEditing)
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () => viewModel.addActivity(day, period),
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
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        onChanged: (value) =>
                            viewModel.updateActivity(day, period, index, value),
                      ),
                    ),
                    if (viewModel.isEditing)
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () =>
                            viewModel.removeActivity(day, period, index),
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
