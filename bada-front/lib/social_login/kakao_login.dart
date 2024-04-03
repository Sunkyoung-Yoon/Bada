import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoLogin {
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
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
