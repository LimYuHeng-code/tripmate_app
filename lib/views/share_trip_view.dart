import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../viewmodels/share_trip_viewmodel.dart';

class ShareTripPage extends StatefulWidget {
  final Map<String, dynamic> itineraryData;

  const ShareTripPage({
    super.key,
    required this.itineraryData,
  });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Share Trip Code'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// Trip Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.map, size: 40),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2-Day Johor Bahru Trip',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('2 Days · 1 Night'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            /// Trip Code
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    viewModel.tripCode,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copyCode,
                  ),
                ],
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _copyCode,
                    child: const Text('Copy Code'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: viewModel.isSaving || viewModel.isSaved
                        ? null
                        : () async {
                            await viewModel.saveSharedTrip(
                              widget.itineraryData,
                            );

                            if (mounted && viewModel.isSaved) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Trip shared successfully!'),
                                ),
                              );
                            }
                          },
                    child: viewModel.isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            viewModel.isSaved ? 'Shared' : 'Share Trip',
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyCode() {
    Clipboard.setData(
      ClipboardData(text: viewModel.tripCode),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trip code copied')),
    );
  }
}
