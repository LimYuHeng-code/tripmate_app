import 'package:flutter/material.dart';
import '../viewmodels/trip_action_viewmodel.dart';

class TripAction extends StatelessWidget {
 TripAction({super.key});

  @override
  Widget build(BuildContext context) {
    final TripActionViewModel vm = TripActionViewModel();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          /// New Trip → DestinationView
          _ActionTile(
            icon: Icons.edit_calendar,
            title: 'New Trip',
            onTap: () => vm.openNewTrip(context),
          ),

          const SizedBox(height: 12),

          /// Find Trip → JoinTripView
          _ActionTile(
            icon: Icons.group,
            title: 'Find Trip',
            onTap: () => vm.openFindTrip(context),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Colors.grey.shade100,
      leading: Icon(icon, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
