import 'package:flutter/material.dart';
import '../viewmodels/itinerary_viewmodel.dart';
import '../models/itinerary_mode.dart';
import '../views/share_trip_view.dart';
import '../widgets/save_trip_button.dart';
import '../widgets/share_trip_button.dart';
import '../widgets/edit_trip_button.dart';
import '../widgets/regenerate_trip_button.dart';
import '../widgets/itinerary_map_widget.dart';

class ItineraryPageView extends StatefulWidget {
  final Map<String, dynamic> itineraryData;
  final ItineraryMode mode;

  const ItineraryPageView({
    super.key,
    required this.itineraryData,
    required this.mode,
  });

  @override
  State<ItineraryPageView> createState() => _ItineraryPageViewState();
}

class _ItineraryPageViewState extends State<ItineraryPageView> {
  late ItineraryViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ItineraryViewModel(
      widget.itineraryData,
      mode: widget.mode,
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _onSharePressed() async {
    await viewModel.shareTrip();
    if (!mounted) return;

    if (viewModel.shareSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShareTripPage(itinerary: viewModel.itinerary),
        ),
      );
    } else if (viewModel.shareError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.shareError!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (_, __) {
        final days = viewModel.itinerary.days;

        return DefaultTabController(
          length: days.length,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text('My Itinerary'),
              actions: [
                if (viewModel.canShare)
                  ShareTripButton(
                    compact: true,
                    isSharing: viewModel.isSharing,
                    onPressed: _onSharePressed,
                  ),
                if (viewModel.canSave)
                  SaveTripButton(
                    compact: true,
                    isSaved: viewModel.isSaved,
                    onPressed: viewModel.saveTrip,
                  ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: days.keys.map((d) => Tab(text: d)).toList(),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: TabBarView(
              children: days.keys.map((day) {
                final dayModel = days[day]!;

                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------- Map --------
                      ItineraryMapWidget(viewModel: viewModel),
                      const SizedBox(height: 16),

                      // -------- Day title + Regenerate --------
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$day: ${dayModel.title}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (viewModel.canRegenerate)
                            RegenerateTripButton(
                              compact: true,
                              isLoading: viewModel.isLoading,
                              onPressed: viewModel.regenerateItinerary,
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),

                      // ✅ Only Morning has Edit button
                      _buildSection(day, 'Morning', showEdit: true),
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

  Widget _buildSection(String day, String period, {bool showEdit = false}) {
    final controllers = viewModel.controllers[day]![period]!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- Section header --------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  period,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // ✅ Edit button only in first card
                    if (showEdit && viewModel.canEdit)
                      EditTripButton(
                        compact: true,
                        isEditing: viewModel.isEditing,
                        onPressed: viewModel.toggleEditing,
                      ),

                    if (viewModel.isEditing)
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () =>
                            viewModel.addActivity(day, period),
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // -------- Activities --------
            Column(
              children: List.generate(controllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllers[index],
                          readOnly: !viewModel.isEditing,
                          maxLines: null,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.top,
                          scrollPadding:
                              const EdgeInsets.only(bottom: 120),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 8),
                          ),
                          onChanged: (v) => viewModel.updateActivity(
                            day,
                            period,
                            index,
                            v,
                          ),
                        ),
                      ),
                      if (viewModel.isEditing)
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () =>
                              viewModel.removeActivity(
                            day,
                            period,
                            index,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}