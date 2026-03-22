import 'package:flutter/material.dart';

class EditTripButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEditing;
  final bool compact;

  const EditTripButton({
    super.key,
    required this.onPressed,
    this.isEditing = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        isEditing ? Icons.check : Icons.edit,
        size: compact ? 16 : 20,
      ),
      label: Text(
        isEditing ? (compact ? 'Done' : 'Finish') : (compact ? 'Edit' : 'Edit Trip'),
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
