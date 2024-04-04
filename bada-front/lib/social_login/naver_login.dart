import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class NaverLogin {
  Future<bool> login() async {
    try {
      NaverLoginResult result = await FlutterNaverLogin.logIn();
      if (result.status == NaverLoginStatus.loggedIn) {
        debugPrint('네이버 로그인 성공 ${result.account}');
        return true;
      } else {
        debugPrint('네이버 로그인 실패 ${result.status}');
        return false;
      }
    } catch (e) {
      debugPrint("로그인 시도 실패");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await FlutterNaverLogin.logOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
