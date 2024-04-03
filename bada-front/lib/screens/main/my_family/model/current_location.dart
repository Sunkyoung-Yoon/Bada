class CurrentLocation {
  final double currentLatitude;
  final double currentLongitude;
  final int childId;
  final String childName;
  final String? childProfileUrl;

  CurrentLocation({
    required this.currentLatitude,
    required this.currentLongitude,
    required this.childId,
    required this.childName,
    required this.childProfileUrl,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      currentLatitude: json['currentLatitude'],
      currentLongitude: json['currentLongitude'],
      childId: json['childId'],
      childName: json['childName'],
      childProfileUrl: json['childProfileUrl'],
    );
  }
}
