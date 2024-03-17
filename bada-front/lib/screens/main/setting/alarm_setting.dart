import 'package:bada/widgets/alarm.dart';
import 'package:flutter/material.dart';

class AlarmSetting extends StatelessWidget {
  const AlarmSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알람 설정'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
    );
  }
}
