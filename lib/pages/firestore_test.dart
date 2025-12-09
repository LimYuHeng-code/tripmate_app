import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class TestFirestorePage extends StatelessWidget {
  const TestFirestorePage({super.key});

  Future<void> testFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('test').add({
        'message': 'Test page write success!',
        'time': DateTime.now(),
      });

      print("Firestore write success!");
    } catch (e) {
      print("Firestore error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firestore Test Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await testFirestore();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data written to Firestore!")),
            );
          },
          child: const Text("Run Firestore Test"),
        ),
      ),
    );
  }
}
