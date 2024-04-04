import 'dart:convert';

class FcmMessage {
  final String token;
  final NotificationData notification;
  final Data data;

  FcmMessage({
    required this.token,
    required this.notification,
    required this.data,
  });

  factory FcmMessage.fromJson(Map<String, dynamic> json) {
    return FcmMessage(
      token: json['token'],
      notification: NotificationData.fromJson(json['notification']),
      data: Data.fromJson(json['data']),
    );
  }
}

class NotificationData {
  final String title;
  final String body;

  NotificationData({
    required this.title,
    required this.body,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'],
      body: json['body'],
    );
  }
}

class Data {
  final String childName;
  final String phone;
  final String profileUrl;
  final String destinationName;
  final String destinationIcon;

  Data({
    required this.childName,
    this.phone = '',
    this.profileUrl = '',
    required this.destinationName,
    required this.destinationIcon,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      childName: json['childName'],
      phone: json['phone'],
      profileUrl: json['profileUrl'],
      destinationName: json['destinationName'],
      destinationIcon: json['destinationIcon'],
    );
  }
}

class AlarmModel {
  final int alarmId, childId;
  final String createdAt, type;
  final bool read;

  AlarmModel({
    required this.alarmId,
    required this.createdAt,
    required this.type,
    required this.childId,
    required this.read,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      alarmId: json['alarmId'],
      createdAt: json['createAt'],
      type: json['type'],
      childId: json['childId'],
      read: json['read'],
    );
  }
}

void handleIncomingFcmMessage(String jsonString) {
  final parsedJson = json.decode(jsonString);
  final fcmMessage = FcmMessage.fromJson(parsedJson['message']);

  print(fcmMessage.data.childName);
}
