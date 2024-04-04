class RouteInfo {
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;
  final String addressName;
  final String placeName;
  final List<Point> pointList;

  RouteInfo({
    required this.startLng,
    required this.startLat,
    required this.endLng,
    required this.endLat,
    required this.addressName,
    required this.placeName,
    required this.pointList,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    var list = json['pointList'] as List;
    List<Point> pointList = list.map((i) => Point.fromJson(i)).toList();

    return RouteInfo(
      startLng: json['startLng'],
      startLat: json['startLat'],
      endLng: json['endLng'],
      endLat: json['endLat'],
      addressName: json['addressName'],
      placeName: json['placeName'],
      pointList: pointList,
    );
  }
}

class Point {
  final double latitude;
  final double longitude;

  Point({required this.latitude, required this.longitude});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
