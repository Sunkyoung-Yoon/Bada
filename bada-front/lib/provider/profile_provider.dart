import 'package:bada/login/kakao_login.dart';
import 'package:bada/login/login_platform.dart';
import 'package:bada/login/naver_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider();

  String? _nickname;
  String? _profileImage;
  String? _email;
  bool _isLogined = false;

  String? get nickname => _nickname;
  String? get profileImage => _profileImage;
  String? get email => _email;
  bool get isLogined => _isLogined;

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
      notifyListeners();
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
      notifyListeners();
    } catch (e) {
      debugPrint('initProfile error: $e');
    }
  }
}
