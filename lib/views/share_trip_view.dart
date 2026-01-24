import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../viewmodels/share_trip_viewmodel.dart';
import '../models/itinerary_model.dart';

class ShareTripPage extends StatefulWidget {
  final ItineraryModel itinerary;

  const ShareTripPage({super.key, required this.itinerary});

  @override
  State<ShareTripPage> createState() => _ShareTripPageState();
}

class _ShareTripPageState extends State<ShareTripPage> {
  late ShareTripViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ShareTripViewModel();
    viewModel.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: viewModel.tripCode));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip code copied')));
  }

  void _shareTrip() {
    final message = '''
Join my trip on TripMate!

Trip Code: ${viewModel.tripCode}

Open the app and enter this code to view the itinerary.
''';
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Share Trip'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.map, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Shared Trip', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('${widget.itinerary.days.length} Days', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(viewModel.tripCode, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4)),
                  IconButton(icon: const Icon(Icons.copy), onPressed: _copyCode),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: _copyCode, child: const Text('Copy Code'))),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: viewModel.isSaving
                        ? null
                        : () async {
                            if (!viewModel.isSaved) await viewModel.saveSharedTrip(widget.itinerary);
                            if (mounted && viewModel.isSaved) _shareTrip();
                          },
                    child: viewModel.isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Share Trip'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
