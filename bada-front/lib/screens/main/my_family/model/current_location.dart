class CurrentLocation {
  final double currentLatitude;
  final double currentLongitude;
  final int childId;
  final String name;
  final String profileUrl;

  CurrentLocation({
    required this.currentLatitude,
    required this.currentLongitude,
    required this.childId,
    required this.name,
    required this.profileUrl,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      currentLatitude: json['currentLatitude'],
      currentLongitude: json['currentLongitude'],
      childId: json['childId'],
      name: json['name'],
      profileUrl: json['profileUrl'],
    );
  }
}
