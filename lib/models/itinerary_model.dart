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
  final String title;
  final Map<String, ItineraryDay> days;

  ItineraryModel({required this.title, required this.days});

  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? 'Untitled Trip';
    final daysData = json['days'] as Map<String, dynamic>? ?? {};
    
    final days = <String, ItineraryDay>{};
    daysData.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        days[key] = ItineraryDay.fromJson(value);
      }
    });

    return ItineraryModel(
      title: title,
      days: days,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'days': days.map((k, v) => MapEntry(k, v.toJson())),
  };
}
