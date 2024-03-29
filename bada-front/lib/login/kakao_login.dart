import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoLogin {
  Future<bool> login() async {
    try {
      // 카카오 로그인을 시도합니다.
      bool isInstalled = await isKakaoTalkInstalled();
      // 카카오톡이 설치되어 있다면
      if (isInstalled) {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          debugPrint('카카오톡으로 로그인 성공 ${token.accessToken}');
          return true;
        } catch (error) {
          debugPrint('카카오톡으로 로그인 실패 $error');
          return false;
        }
      } else {
        // 카카오톡이 없다면
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');
          return true;
        } catch (error) {
          debugPrint('카카오계정으로 로그인 실패 $error');
          return false;
        }
      }
    } catch (e) {
      debugPrint("로그인 시도 실패");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await UserApi.instance.logout();
      return true;
    } catch (e) {
      return false;
    }
  }
}
