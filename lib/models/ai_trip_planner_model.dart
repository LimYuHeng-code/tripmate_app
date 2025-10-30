class AiTripPlannerModel {
  final String destination;
  final int days;
  final String interests;
  final int age;
  final int budget;
  final String itinerary;

  AiTripPlannerModel({
    required this.destination,
    required this.days,
    required this.interests,
    required this.age,
    required this.budget,
    required this.itinerary,
  });

  factory AiTripPlannerModel.fromJson(Map<String, dynamic> json) {
    return AiTripPlannerModel(
      destination: json['destination'] ?? '',
      days: json['days'] ?? 0,
      interests: json['interests'] ?? '',
      age: json['age'] ?? 0,
      budget: json['budget'] ?? 0,
      itinerary: json['itinerary'] ?? '',
    );
  }
}
