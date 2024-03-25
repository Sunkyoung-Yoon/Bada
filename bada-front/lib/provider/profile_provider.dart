import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bada/login/kakao_login.dart';
import 'package:bada/login/login_platform.dart';
import 'package:bada/login/naver_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ProfileProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  ProfileProvider() {
    _loadProfileFromStorage();
  }

  // String? _memberId,
  String? _nickname,
      _profileImage,
      _email,
      _phone,
      _social,
      _createdAt,
      _familyName;
  bool _isLogined = false;

  // String? get memberId => _memberId;
  String? get nickname => _nickname;
  String? get profileImage => _profileImage;
  String? get email => _email;
  String? get phone => _phone;
  String? get social => _social;
  String? get createdAt => _createdAt;
  String? get familyName => _familyName;
  bool get isLogined => _isLogined;

  // Define keys for storage
  // final _memberIdKey = 'memberId';
  final _nicknameKey = 'nickname';
  final _profileImageKey = 'profileImage';
  final _emailKey = 'email';
  final _phoneKey = 'phone';
  final _socialKey = 'social';
  final _createdAtKey = 'createdAt';
  final _familyNameKey = 'familyName';
  final _isLoginedKey = 'isLogined';

  Future<bool> profileDbCheck() async {
    // requestBody 설정
    final Map<String, dynamic> requestBody = {
      'email': email,
      'social': social,
    };
    debugPrint('email: $email, social: $social');
    // HTTP POST 요청 수행
    // ISSUE : 현재 서버에서 GET 요청으로 구현되어 있어 재대로 작동하지 않음
    final response = await http.post(
      Uri.parse('https://j10b207.p.ssafy.io/api/auth'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Decode the JSON response
      debugPrint('카카오 로그인 됨 profile_provider 71번줄');
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      _storage.write(key: 'accessToken', value: data['accessToken']);
      _storage.write(key: 'refreshToken', value: data['refreshToken']);
      debugPrint('profileDbCheck data: $data');
      return true;
    } else if (response.statusCode == 204) {
      return false;
    } else {
      // Handle errors or unsuccessful responses
      debugPrint(
        'Failed to fetch profile data. Status code: ${response.statusCode}',
      );
    }
    return false;
  }

  Future<void> initProfile(LoginPlatform loginPlatform) async {
    switch (loginPlatform) {
      case LoginPlatform.kakao:
        await _initKakaoProfile();
        break;
      case LoginPlatform.google:
        break;
      case LoginPlatform.naver:
        await _initNaverProfile();
        break;
      case LoginPlatform.none:
        break;
    }
    // TODO : memberID 가져오기(FCM용 기기ID)
    _phone = await SmsAutoFill().hint;
    notifyListeners();
  }

  Future<void> _loadProfileFromStorage() async {
    // _memberId = await _storage.read(key: _memberIdKey);
    _nickname = await _storage.read(key: _nicknameKey);
    _profileImage = await _storage.read(key: _profileImageKey);
    _email = await _storage.read(key: _emailKey);
    _phone = await _storage.read(key: _phoneKey);
    _social = await _storage.read(key: _socialKey);
    _createdAt = await _storage.read(key: _createdAtKey);
    _familyName = await _storage.read(key: _familyNameKey);
    _isLogined = await _storage.read(key: _isLoginedKey) == 'true';
    notifyListeners();
  }

  Future<void> _initKakaoProfile() async {
    try {
      // final viewModel = MainViewModel(KakaoLogin() as SocialLogin);
      KakaoLogin kakaoLogin = KakaoLogin();
      await kakaoLogin.login();
      User? user = await UserApi.instance.me();
      _nickname = user.kakaoAccount?.profile?.nickname;
      _profileImage = user.kakaoAccount?.profile?.profileImageUrl;
      _email = user.kakaoAccount?.email;
      _isLogined = true;
      _social = 'KAKAO';
      saveProfileToStorage();
    } catch (e) {
      debugPrint('initProfile error: $e');
    }
  }

  Future<void> _initNaverProfile() async {
    try {
      NaverLogin naverLogin = NaverLogin();
      await naverLogin.login();
      NaverAccountResult result = await FlutterNaverLogin.currentAccount();
      _nickname = result.nickname;
      _profileImage = result.profileImage;
      _email = result.email;
      _isLogined = true;
      _social = 'NAVER';
      saveProfileToStorage();
    } catch (e) {
      debugPrint('initProfile error: $e');
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();

    // _memberId = null;
    _nickname = null;
    _profileImage = null;
    _email = null;
    _phone = null;
    _social = null;
    _createdAt = null;
    _familyName = null;
    _isLogined = false;

    notifyListeners();
  }

  Future<void> saveProfileToStorage() async {
    // Fetch accessToken from secure storage
    final accessToken = await _storage.read(key: 'accessToken');

    // Set up headers for the GET request
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // Perform the GET request to fetch the profile data
    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: headers,
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Decode the JSON response
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      // Save the data to local storage
      // await _storage.write(key: 'memberId', value: data['memberId'].toString());
      await _storage.write(key: 'nickname', value: data['name']);
      await _storage.write(key: 'phone', value: data['phone']);
      await _storage.write(key: 'email', value: data['email']);
      await _storage.write(key: 'social', value: data['social']);
      await _storage.write(key: 'createdAt', value: data['createdAt']);
      await _storage.write(key: 'familyName', value: data['familyName']);
      await _storage.write(key: 'profileImage', value: data['profileUrl']);
    } else {
      // Handle errors or unsuccessful responses
      debugPrint(
        'Failed to fetch profile data. Status code: ${response.statusCode}',
      );
    }
  }
}
