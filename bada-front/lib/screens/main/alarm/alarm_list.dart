import 'dart:convert';

import 'package:bada/models/alarm_model.dart';
import 'package:bada/widgets/alarm.dart';
import 'package:bada/widgets/appbar.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AlarmList extends StatefulWidget {
  final String name;
  final int memberId;

  const AlarmList({
    super.key,
    required this.name,
    required this.memberId,
  });

  @override
  State<AlarmList> createState() => _AlarmListState();
}

class _AlarmListState extends State<AlarmList> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<dynamic>> fetchAlarmList() async {
    String? accessToken = await _storage.read(key: 'accessToken');

    final response = await http.get(
      Uri.parse(
        'https://j10b207.p.ssafy.io/api/alarmLog/list/${widget.memberId}',
      ),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> alarmJsonList = json.decode(response.body);
      List<AlarmModel> alarms =
          alarmJsonList.map((json) => AlarmModel.fromJson(json)).toList();
      return alarms;
    } else {
      throw Exception(
        'Failed to load alarms with status code: ${response.statusCode}',
      );
    }
  }

  Future<List<dynamic>> sortAlarm() async {
    var alarms = await fetchAlarmList();
    alarms.sort(
      (a, b) {
        DateTime dateA = DateTime.parse(a.createdAt);
        DateTime dateB = DateTime.parse(b.createdAt);
        return dateB.compareTo(dateA);
      },
    );
    return alarms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: '${widget.name}님의 알림',
      ),
      body: Column(
        children: [
          const Text('최근 7일간 알림'),
          SizedBox(
            height: UIhelper.deviceHeight(context) * 0.01,
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: sortAlarm(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error.toString()}'),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var alarm = snapshot.data![index];
                      return Alarm(
                        type: alarm.type,
                        createdAt: alarm.createdAt,
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('알림 기록이 없습니다!'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
