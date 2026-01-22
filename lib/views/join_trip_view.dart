import 'package:flutter/material.dart';
import '../viewmodels/join_trip_viewmodel.dart';

class JoinTripView extends StatefulWidget {
  const JoinTripView({super.key});

  @override
  State<JoinTripView> createState() => _JoinTripViewState();
}

class _JoinTripViewState extends State<JoinTripView> {
  late JoinTripViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = JoinTripViewModel();
    vm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: vm.updateTripCode,
              decoration: InputDecoration(
                labelText: 'Trip Code',
                border: const OutlineInputBorder(),
                errorText: vm.errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: vm.isLoading ? null : () => vm.joinTrip(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: vm.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Join Trip',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
