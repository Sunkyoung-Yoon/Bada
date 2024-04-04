class PathSearchHistory {
  String departureKeyword;
  double departureX;
  double departureY;
  String destinationKeyword;
  double destinationX;
  double destinationY;
  DateTime timestamp;

  PathSearchHistory({
    required this.departureKeyword,
    required this.departureX,
    required this.departureY,
    required this.destinationKeyword,
    required this.destinationX,
    required this.destinationY,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'departureKeyword': departureKeyword,
        'departureX': departureX,
        'departureY': departureY,
        'destinationKeyword': destinationKeyword,
        'destinationX': destinationX,
        'destinationY': destinationY,
        'timestamp': timestamp.toIso8601String(),
      };

  factory PathSearchHistory.fromJson(Map<String, dynamic> json) =>
      PathSearchHistory(
        departureKeyword: json['departureKeyword'],
        departureX: json['departureX'],
        departureY: json['departureY'],
        destinationKeyword: json['destinationKeyword'],
        destinationX: json['destinationX'],
        destinationY: json['destinationY'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
