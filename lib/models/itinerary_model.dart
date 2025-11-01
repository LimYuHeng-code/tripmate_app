class ItineraryDay {
  final String title;
  List<String> morning;
  List<String> afternoon;
  List<String> evening;

  ItineraryDay({
    required this.title,
    required this.morning,
    required this.afternoon,
    required this.evening,
  });

  factory ItineraryDay.fromJson(Map<String, dynamic> json) {
    return ItineraryDay(
      title: json['title'] ?? '',
      morning: List<String>.from(json['Morning'] ?? []),
      afternoon: List<String>.from(json['Afternoon'] ?? []),
      evening: List<String>.from(json['Evening'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'Morning': morning,
    'Afternoon': afternoon,
    'Evening': evening,
  };
}

class ItineraryModel {
  final Map<String, ItineraryDay> days;

  ItineraryModel({required this.days});

  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    final days = <String, ItineraryDay>{};
    json.forEach((key, value) {
      days[key] = ItineraryDay.fromJson(value);
    });
    return ItineraryModel(days: days);
  }

  Map<String, dynamic> toJson() => days.map((k, v) => MapEntry(k, v.toJson()));
}
