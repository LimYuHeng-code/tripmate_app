import 'package:flutter/material.dart';

class SaveTripButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool compact;
  final bool isSaved;

  const SaveTripButton({
    super.key,
    required this.onPressed,
    this.compact = false,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isSaved ? null : onPressed,
      icon: Icon(
        isSaved ? Icons.check : Icons.bookmark_add,
        size: compact ? 16 : 20,
      ),
      label: Text(
        isSaved
            ? 'Saved'
            : (compact ? 'Save' : 'Save Trip'),
        style: TextStyle(fontSize: compact ? 13 : 14),
      ),
      style: ElevatedButton.styleFrom(
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: compact ? Size.zero : null,
        tapTargetSize:
            compact ? MaterialTapTargetSize.shrinkWrap : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
