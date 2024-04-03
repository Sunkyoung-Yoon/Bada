import 'dart:convert';

import 'package:bada/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart' as mime;

class MembersApi {
  static const String _baseUrl = 'https://j10b207.p.ssafy.io/api/members';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // TODO : 회원 정보 수정 (파일 업로드 부분 에러 뜸)
  Future<bool> updateProfile(
    String? filePath,
    String nickname,
    int? childId,
    BuildContext context,
  ) async {
    // _storage 인스턴스를 사용하여 accessToken을 비동기적으로 불러옵니다.
    String? accessToken = await _storage.read(key: 'accessToken');

    // 닉네임과 프로필 이미지가 각각 하나씩만 입력되었을 때
    // 또는 모두 입력 되었을 때 저장 가능
    if (nickname == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('닉네임을 입력해주세요.'),
        ),
      );
      return false;
    }

    debugPrint('액세스 토큰 : $accessToken');
    debugPrint('childId : $childId');
    debugPrint('name : $nickname');

    var uri = Uri.parse('https://j10b207.p.ssafy.io/api/members');

    http.MultipartRequest request = http.MultipartRequest('PATCH', uri);
    request.fields['name'] = nickname; // 닉네임 필드
    if (childId != null) {
      request.fields['childId'] = childId.toString(); // childId 필드, 문자열로 변환
    } else {
      request.fields['childId'] = '';
    }
    debugPrint("파일");
    debugPrint(filePath);
    // TODO : 기존 파일과 새로운 파일이 다를 경우에만 파일 추가
    if (filePath != null) {
      try {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // 서버에서 요구하는 필드명
            filePath,
            contentType: mime.MediaType('image', 'jpeg'),
          ),
        );
        debugPrint(request.fields.toString());
        debugPrint(filePath);
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    // 헤더 설정. PATCH 요청에서 'Content-Type': 'application/json'는 필요 없습니다.
    // MultipartRequest는 자동으로 'Content-Type': 'multipart/form-data' 헤더를 사용합니다.
    request.headers.addAll({
      'Authorization': 'Bearer $accessToken',
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      debugPrint('프로필 업데이트 성공');
      UserProfile userProfile = await fetchProfile();
      _storage.write(key: 'nickname', value: userProfile.name);
      _storage.write(key: 'profileImage', value: userProfile.profileUrl);
      // 성공 처리 로직
      return true;
    } else {
      debugPrint('프로필 업데이트 실패: ${response.statusCode}');
      // 실패 처리 로직
      return false;
    }
  }

  Future<UserProfile> fetchProfile() async {
    // _storage 인스턴스를 사용하여 accessToken을 비동기적으로 불러옵니다.
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 서버로부터 응답 받은 데이터를 JSON으로 디코드
      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes));
      // JSON 데이터를 UserProfile 객체로 변환
      return UserProfile.fromJson(data);
    } else {
      // 서버 응답이 200이 아닌 경우 오류 처리
      throw Exception('Failed to load profile');
    }
  }

  Future<void> deleteMember() async {
    try {
      // _storage 인스턴스를 사용하여 accessToken을 비동기적으로 불러옵니다.
      String? accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access token not found');
      }
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.delete(Uri.parse(_baseUrl), headers: headers);

      if (response.statusCode == 200) {
        debugPrint('Member deleted successfully');
      } else {
        throw Exception('Failed to delete member ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error deleting member');
    }
  }
}
