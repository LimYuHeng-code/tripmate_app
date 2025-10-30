class InputPageModel {
  final String destination;
  final int days;
  final int age;
  final List<String> interests;
  final double budget;
  final Map<String, dynamic> itinerary;

  InputPageModel({
    required this.destination,
    required this.days,
    required this.age,
    required this.interests,
    required this.budget,
    required this.itinerary,
  });

  factory InputPageModel.fromJson(Map<String, dynamic> json) {
    return InputPageModel(
      destination: json['destination'] ?? '',
      days: json['days'] ?? 0,
      age: json['age'] ?? 0,
      interests: List<String>.from(json['interests'] ?? []),
      budget: (json['budget'] is double)
          ? json['budget']
          : double.tryParse(json['budget'].toString()) ?? 0.0,
      itinerary: Map<String, dynamic>.from(json['itinerary'] ?? {}),
    );
  }
}
