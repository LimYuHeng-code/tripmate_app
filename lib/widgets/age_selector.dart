import 'package:flutter/material.dart';

class AgeSelector extends StatefulWidget {
  final int initialAge;
  final ValueChanged<int>? onChanged;

  const AgeSelector({super.key, this.initialAge = 25, this.onChanged});

  @override
  State<AgeSelector> createState() => _AgeSelectorState();
}

class _AgeSelectorState extends State<AgeSelector> {
  late int age;

  @override
  void initState() {
    super.initState();
    age = widget.initialAge;
  }

  void updateAge(int newAge) {
    setState(() => age = newAge);
    widget.onChanged?.call(age); // optional callback
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Age",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle),
                color: Colors.deepPurpleAccent,
                iconSize: 30,
                onPressed: () {
                  if (age > 0) updateAge(age - 1);
                },
              ),
              Text(
                "$age",
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                color: Colors.deepPurpleAccent,
                iconSize: 30,
                onPressed: () => updateAge(age + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
