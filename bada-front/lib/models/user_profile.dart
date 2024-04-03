import 'dart:convert';
import 'package:http/http.dart' as http;

// 프로필 정보를 담을 클래스
// 회원정보 상세 조회 API의 응답 데이터 구조와 일치
class UserProfile {
  final int memberId; // int로 타입 변경
  final String name;
  final String phone;
  final String email;
  final String social;
  final String? profileUrl; // null 허용
  final String createdAt;
  final String familyCode;
  final String familyName;
  final int movingState;
  final String fcmToken;

  UserProfile({
    required this.memberId,
    required this.name,
    required this.phone,
    required this.email,
    required this.social,
    this.profileUrl,
    required this.createdAt,
    required this.familyCode,
    required this.familyName,
    required this.movingState,
    required this.fcmToken,
  });

  // JSON에서 UserProfile 객체로 변환
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      memberId: json['memberId'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      social: json['social'],
      profileUrl: json['profileUrl'], // null 가능성 있음
      createdAt: json['createdAt'],
      familyCode: json['familyCode'],
      familyName: json['familyName'],
      movingState: json['movingState'],
      fcmToken: json['fcmToken'],
    );
  }
}

// accessToken을 사용하여 프로필 정보를 가져오는 함수
Future<UserProfile> fetchProfile(String accessToken) async {
  final response = await http.get(
    Uri.parse('https://j10b207.p.ssafy.io/api/members'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    // 서버로부터 응답 받은 데이터를 JSON으로 디코드
    final Map<String, dynamic> data = json.decode(response.body);
    // JSON 데이터를 UserProfile 객체로 변환
    return UserProfile.fromJson(data);
  } else {
    // 서버 응답이 200이 아닌 경우 오류 처리
    throw Exception('Failed to load profile');
  }
}
