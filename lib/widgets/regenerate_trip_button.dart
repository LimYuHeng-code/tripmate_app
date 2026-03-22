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
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: compact ? 16 : 20,
              height: compact ? 16 : 20,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(
              Icons.refresh,
              size: compact ? 16 : 20,
            ),
      label: Text(
        compact ? 'Regen' : 'Regenerate',
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
