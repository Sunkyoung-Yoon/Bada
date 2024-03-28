import 'package:bada/widgets/alarm.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';

class AlarmList extends StatelessWidget {
  final String name;

  const AlarmList({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '$name님의 알림',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: UIhelper.scaleWidth(context) * 10,
                  ),
                  const Text(
                    '알림',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Alarm(
                iconType: 2,
                context: '도착함',
                time: '오전 9:00',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
