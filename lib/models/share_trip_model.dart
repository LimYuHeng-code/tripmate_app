class ShareTripModel {
  final String tripLink;
  final bool isSharing;
  final String? errorMessage;

  ShareTripModel({
    required this.tripLink,
    required this.isSharing,
    this.errorMessage,
  });

  ShareTripModel copyWith({
    String? tripLink,
    bool? isSharing,
    String? errorMessage,
  }) {
    return ShareTripModel(
      tripLink: tripLink ?? this.tripLink,
      isSharing: isSharing ?? this.isSharing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
