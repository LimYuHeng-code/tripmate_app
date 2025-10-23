import 'package:flutter/material.dart';


class TripPlanningPage extends StatefulWidget {
  const TripPlanningPage({super.key});

  @override
  State<TripPlanningPage> createState() => _TripPlanningPageState();
}

class _TripPlanningPageState extends State<TripPlanningPage> {
  // Form data
  String? destination;
  DateTime? travelDate;
  int days = 1;
  String? budget;
  String? companion;
  final List<String> activities = [];
  bool includeHotel = false;
  bool includeVegetarian = false;

  // List options
  final destinations = ['New York', 'Tokyo', 'Paris', 'Seoul'];
  final budgetOptions = ['Low (0–1000 USD)', 'Medium (1000–2500 USD)', 'High (2500+ USD)'];
  final companions = ['Solo', 'Couple', 'Family', 'Friends'];
  final activityOptions = [
    'Beaches',
    'City sightseeing',
    'Outdoor adventures',
    'Festivals/events',
    'Food exploration',
    'Nightlife',
    'Shopping',
    'Spa wellness'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tell us your travel preferences")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Destination
            const Text("What is destination of choice?"),
            DropdownButtonFormField<String>(
              initialValue: destination,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: destinations.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (val) => setState(() => destination = val),
            ),
            const SizedBox(height: 20),

            // Travel Date
            const Text("When are you planning to travel?"),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => travelDate = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                child: Text(
                  travelDate == null
                      ? "Select Date"
                      : "${travelDate!.day}/${travelDate!.month}/${travelDate!.year}",
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Days count
            const Text("How many days are you planning to travel?"),
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    if (days > 1) days--;
                  }),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text("$days Day${days > 1 ? 's' : ''}"),
                IconButton(
                  onPressed: () => setState(() => days++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Budget
            const Text("What is your budget?"),
            Wrap(
              spacing: 10,
              children: budgetOptions.map((b) {
                return ChoiceChip(
                  label: Text(b),
                  selected: budget == b,
                  onSelected: (_) => setState(() => budget = b),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Companion
            const Text("Who do you plan on traveling with?"),
            Wrap(
              spacing: 10,
              children: companions.map((c) {
                return ChoiceChip(
                  label: Text(c),
                  selected: companion == c,
                  onSelected: (_) => setState(() => companion = c),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Activities
            const Text("Which activities are you interested in?"),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: activityOptions.map((a) {
                final selected = activities.contains(a);
                return FilterChip(
                  label: Text(a),
                  selected: selected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        activities.add(a);
                      } else {
                        activities.remove(a);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Options
            const Text("Would you like to have these options?"),
            CheckboxListTile(
              title: const Text("Hotel"),
              value: includeHotel,
              onChanged: (val) => setState(() => includeHotel = val!),
            ),
            CheckboxListTile(
              title: const Text("Vegetarian"),
              value: includeVegetarian,
              onChanged: (val) => setState(() => includeVegetarian = val!),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                debugPrint("Destination: $destination");
                debugPrint("Date: $travelDate");
                debugPrint("Days: $days");
                debugPrint("Budget: $budget");
                debugPrint("Companion: $companion");
                debugPrint("Activities: $activities");
                debugPrint("Hotel: $includeHotel, Vegetarian: $includeVegetarian");
              },
              child: const Text("Generate Itinerary"),
            ),
          ],
        ),
      ),
    );
  }
}
