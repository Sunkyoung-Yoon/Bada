import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class VerificationCode extends StatefulWidget {
  const VerificationCode({super.key});

  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  String code = "";
  final _storage = const FlutterSecureStorage();
  Timer? _timer;
  int _remainingTime = 0;

  Widget _buildTimeText() {
    // Check if the remaining time is not 0
    if (_remainingTime != 0) {
      return Text(
        '남은 시간: ${_formatTime(_remainingTime)}',
        style: const TextStyle(fontSize: 16),
      );
    } else {
      // If remaining time is 0, show this text
      return const Text(
        '유효시간이 만료되었습니다. 새로 발급 받아주세요!',
        style: TextStyle(fontSize: 16, color: Colors.red),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCode();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 600; // 10 minutes in seconds
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        // Optional: Automatically refresh the code here if desired
        // _fetchCode();
      }
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = (totalSeconds ~/ 60);
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _fetchCode() async {
    final uri = Uri.parse('https://j10b207.p.ssafy.io/api/auth/authcode');
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody != null) {
          setState(() {
            code = responseBody['authCode'];
          });
        } else {}
      } else {}
    } catch (e) {
      print('조회 에러 $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const int numberOfBoxes = 5;
    List<Widget> codeWidgets;

    if (code.isNotEmpty) {
      codeWidgets = code
          .split('')
          .map(
            (char) => Container(
              alignment: Alignment.center,
              width: UIhelper.scaleHeight(context) * 60,
              height: UIhelper.scaleHeight(context) * 80,
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 15.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                char,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          .toList();
    } else {
      // If 'code' is empty, display empty boxes
      codeWidgets = List.generate(
        numberOfBoxes,
        (index) => Container(
          width: UIhelper.scaleWidth(context) * 50,
          height: UIhelper.scaleHeight(context) * 60,
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 15.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          // You might want to display something like an underscore or leave it empty
          child: const Text(
            "",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('인증코드 발급'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: UIhelper.scaleHeight(context) * 40),
            Row(
              children: [
                SizedBox(
                  width: UIhelper.scaleWidth(context) * 20,
                ),
                _buildTimeText(),
              ],
            ),
            SizedBox(height: UIhelper.scaleHeight(context) * 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: codeWidgets,
            ),
            SizedBox(
              height: UIhelper.scaleHeight(context) * 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff696DFF),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _postVerificationCode,
                  child: const Text('발급'),
                ),
                SizedBox(
                  width: UIhelper.scaleWidth(context) * 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _postVerificationCode() async {
    final uri = Uri.parse('https://j10b207.p.ssafy.io/api/auth/authcode');
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        _startTimer();
        await _fetchCode();
      } else {}
    } catch (e) {
      print('PostVerificationCode $e');
    }
  }
}
