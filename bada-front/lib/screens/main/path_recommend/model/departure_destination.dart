class DepartureDestination {
  String pointKeyword;
  double pointX;
  double pointY;

  DepartureDestination({
    required this.pointKeyword,
    required this.pointX,
    required this.pointY,
  });

  factory DepartureDestination.fromJson(Map<String, dynamic> json) {
    return DepartureDestination(
      pointKeyword: json['pointKeyword'],
      pointX: json['pointX'],
      pointY: json['pointY'],
    );
  }

  Map<String, dynamic> toJson() => {
        'pointKeyword': pointKeyword,
        'pointX': pointX,
        'pointY': pointY,
      };
}
