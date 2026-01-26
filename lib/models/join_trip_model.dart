class JoinTripModel {
  final String tripCode;
  final bool isLoading;
  final String? errorMessage;

  JoinTripModel({
    required this.tripCode,
    required this.isLoading,
    this.errorMessage,
  });

  JoinTripModel copyWith({
    String? tripCode,
    bool? isLoading,
    String? errorMessage,
  }) {
    return JoinTripModel(
      tripCode: tripCode ?? this.tripCode,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
