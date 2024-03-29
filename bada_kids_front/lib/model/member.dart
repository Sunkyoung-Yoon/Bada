class Member {
  int? _memberId, _isParent, _movingState;
  String? _name, _phone, _profileUrl, _familyCode, _familyName, _fcmToken;

  Member(
      {int? memberId,
      String? name,
      String? phone,
      int? isParent,
      String? profileUrl,
      String? familyCode,
      String? familyName,
      int? movingState,
      String? fcmToken}) {
    _memberId = memberId;
    _name = name;
    _phone = phone;
    _isParent = isParent;
    _profileUrl = profileUrl;
    _familyCode = familyCode;
    _familyName = familyName;
    _movingState = movingState;
    _fcmToken = fcmToken;
  }

  String get fcmToken => _fcmToken!;
  int get movingState => _movingState!;
  String get familyCode => _familyCode!;
  String get familyName => _familyName!;
  String? get profileUrl => _profileUrl;
  int get isParent => _isParent!;
  String get phone => _phone!;
  String get name => _name!;
  int get memberId => _memberId!;

  // JSON에서 Member 객체로 변환하기 위한 팩토리 생성자
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['memberId'],
      name: json['name'],
      phone: json['phone'],
      isParent: json['isParent'],
      profileUrl: json['profileUrl'],
      familyCode: json['familyCode'],
      familyName: json['familyName'],
      movingState: json['movingState'],
      fcmToken: json['fcmToken'],
    );
  }
}
