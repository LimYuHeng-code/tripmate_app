import 'package:flutter/material.dart';

class RegenerateTripButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool compact;

  const RegenerateTripButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Icon(
                Icons.refresh,
                size: 24,
              ),
      tooltip: "Refresh itinerary", // optional but good UX
    );
  }
}