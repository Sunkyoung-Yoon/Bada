import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import 'package:bada/social_login/kakao_login.dart';
import 'package:bada/social_login/login_platform.dart';
import 'package:bada/social_login/naver_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class ProfileProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  ProfileProvider() {
    _loadProfileFromStorage();
  }

  String? _nickname,
      _profileImage,
      _email,
      _phone,
      _social,
      _createdAt,
      _familyName;

  String? get nickname => _nickname;
  String? get profileImage => _profileImage;
  String? get email => _email;
  String? get phone => _phone;
  String? get social => _social;
  String? get createdAt => _createdAt;
  String? get familyName => _familyName;

  final _nicknameKey = 'nickname';
  final _profileImageKey = 'profileImage';
  final _emailKey = 'email';
  final _phoneKey = 'phone';
  final _socialKey = 'social';
  final _createdAtKey = 'createdAt';
  final _familyNameKey = 'familyName';

  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<bool> profileDbCheck() async {
    final fcmToken = await getFcmToken();

    final Map<String, dynamic> requestBody = {
      'email': email,
      'social': social,
      'fcmToken': fcmToken,
    };
    debugPrint('email: $email, social: $social');
    final response = await http.post(
      Uri.parse('https://j10b207.p.ssafy.io/api/auth'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      debugPrint('카카오 로그인 됨 profile_provider 71번줄');
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      _storage.write(key: 'accessToken', value: data['accessToken']);
      _storage.write(key: 'refreshToken', value: data['refreshToken']);

      debugPrint('profileDbCheck data: $data');
      return true;
    } else if (response.statusCode == 204) {
      return false;
    } else {
      debugPrint(
        'Failed to fetch profile data. Status code: ${response.statusCode}',
      );
    }
    return false;
  }

  Future<void> setPhoneAndFamilyName(
    String phone,
    String familyName,
  ) async {
    _phone = phone;
    _familyName = familyName;
    notifyListeners();
  }

  Future<void> initProfile(LoginPlatform loginPlatform) async {
    switch (loginPlatform) {
      case LoginPlatform.kakao:
        await _initKakaoProfile();
        break;
      case LoginPlatform.naver:
        await _initNaverProfile();
        break;
      case LoginPlatform.none:
        break;
    }
    notifyListeners();
  }

  Future<void> _loadProfileFromStorage() async {
    _nickname = await _storage.read(key: _nicknameKey);
    _profileImage = await _storage.read(key: _profileImageKey);
    _email = await _storage.read(key: _emailKey);
    _phone = await _storage.read(key: _phoneKey);
    _social = await _storage.read(key: _socialKey);
    _createdAt = await _storage.read(key: _createdAtKey);
    _familyName = await _storage.read(key: _familyNameKey);
    notifyListeners();
  }

  Future<void> _initKakaoProfile() async {
    try {
      KakaoLogin kakaoLogin = KakaoLogin();
      await kakaoLogin.login();
      User? user = await UserApi.instance.me();
      _nickname = user.kakaoAccount?.profile?.nickname;
      _profileImage = user.kakaoAccount?.profile?.profileImageUrl;
      _email = user.kakaoAccount?.email;
      _social = 'KAKAO';
    } catch (e) {
      debugPrint('initProfile error: $e');
    }
  }

  Future<void> _initNaverProfile() async {
    try {
      NaverLogin naverLogin = NaverLogin();
      await naverLogin.login();
      NaverAccountResult result = await FlutterNaverLogin.currentAccount();
      _nickname = result.name;
      _profileImage = result.profileImage;
      _email = result.email;
      _social = 'NAVER';
    } catch (e) {
      debugPrint('initProfile error: $e');
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();

    _nickname = null;
    _profileImage = null;
    _email = null;
    _phone = null;
    _social = null;
    _createdAt = null;
    _familyName = null;

    notifyListeners();
  }

  Future<void> saveProfileToStorageWithoutRequest() async {
    await _storage.write(key: 'nickname', value: _nickname);
    await _storage.write(key: 'phone', value: _phone);
    await _storage.write(key: 'email', value: _email);
    await _storage.write(key: 'social', value: _social);
    await _storage.write(key: 'createdAt', value: _createdAt);
    await _storage.write(key: 'familyName', value: _familyName);
    await _storage.write(key: 'profileImage', value: _profileImage);
  }

  Future<void> saveProfileToStorage() async {
    final accessToken = await _storage.read(key: 'accessToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      await _storage.write(key: 'nickname', value: data['name']);
      await _storage.write(key: 'phone', value: data['phone']);
      await _storage.write(key: 'email', value: data['email']);
      await _storage.write(key: 'social', value: data['social']);
      await _storage.write(key: 'createdAt', value: data['createdAt']);
      await _storage.write(key: 'familyName', value: data['familyName']);
      await _storage.write(key: 'profileImage', value: data['profileUrl']);
    } else {
      debugPrint(
        'profile provider 193: ${response.statusCode}',
      );
    }
  }
}
