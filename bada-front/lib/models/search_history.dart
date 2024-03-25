class SearchHistory {
  String keyword;
  DateTime timestamp;

  SearchHistory({
    required this.keyword,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'keyword': keyword,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SearchHistory.fromJson(Map<String, dynamic> json) => SearchHistory(
        keyword: json['keyword'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
