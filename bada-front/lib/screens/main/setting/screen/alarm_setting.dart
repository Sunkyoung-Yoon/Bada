import 'package:flutter/material.dart';
import 'dart:ui';

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
      body: Column(
        children: <Widget>[
          Text('displaySize : ${MediaQuery.of(context).size}'),
          Text('displayHeight : ${MediaQuery.of(context).size.height}'),
          Text('displayWidth : ${MediaQuery.of(context).size.width}'),
          Text(
            'devicePixelRatio : ${MediaQuery.of(context).devicePixelRatio}',
          ),
          Text('statusBarHeight : ${MediaQuery.of(context).padding.top}'),
          Text('window.physicalSize : ${window.physicalSize}'),
        ],
      ),
    );
  }
}
