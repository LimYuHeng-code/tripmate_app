import 'package:flutter/material.dart';

class ShareTripButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool compact;

  const ShareTripButton({
    super.key,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        Icons.share,
        size: compact ? 16 : 20,
      ),
      label: Text(
        compact ? 'Share' : 'Share Trip',
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
