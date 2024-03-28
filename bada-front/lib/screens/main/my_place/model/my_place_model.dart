import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Place {
  final int myPlaceId;
  final double placeLatitude, placeLongitude;
  final String placeName,
      icon,
      placeCode,
      placePhoneNumber,
      addressName,
      addressRoadName,
      placeCategoryCode,
      placeCategoryName;

  Place({
    required this.placeCode,
    required this.placeName,
    required this.placeLatitude,
    required this.placeLongitude,
    required this.icon,
    required this.myPlaceId,
    required this.placePhoneNumber,
    required this.addressName,
    required this.addressRoadName,
    required this.placeCategoryCode,
    required this.placeCategoryName,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeCode: json['placeCode'],
      myPlaceId: json['myPlaceId'],
      placeName: json['placeName'],
      placeLatitude: json['placeLatitude'],
      placeLongitude: json['placeLongitude'],
      icon: json['icon'],
      placePhoneNumber: json['placePhoneNumber'],
      addressName: json['addressName'],
      addressRoadName: json['addressRoadName'],
      placeCategoryCode: json['placeCategoryCode'],
      placeCategoryName: json['placeCategoryName'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'myPlaceId': myPlaceId,
      'placeName': placeName,
      'placeLatitude': placeLatitude,
      'placeLongitude': placeLongitude,
      'placeCategoryCode': placeCategoryCode,
      'placeCategoryName': placeCategoryName,
      'placePhoneNumber': placePhoneNumber,
      'addressName': addressName,
      'addressRoadName': addressRoadName,
      // 'placeCode': placeCode,
    };
  }
}

class MyPlaceData {
  static Future<List<Place>> loadPlaces() async {
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    debugPrint('my_place_model.dart 62번줄: $accessToken');
    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/myplace'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('my_place_model 82번줄 성공');
      final Map<String, dynamic> decodedData =
          json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> myPlaceList = decodedData['MyPlaceList'];
      return myPlaceList.map((place) => Place.fromJson(place)).toList();
    } else {
      print('my_place_model 88번줄 ${response.statusCode} ');
      print('my_place_model 89번줄, $accessToken');
      throw Exception('Failed to load places');
    }
  }
}

// class MyPlaceData {
//   static Future<List<Place>> loadPlaces(accessToken) async {
    

//     debugPrint('load places API: $accessToken');
//     final response = await http.get(
//       Uri.parse('https://j10b207.p.ssafy.io/api/myplace'),
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//       },
//     );

//     if (response.statusCode == 200) {
//       // 응답에서 전체 JSON 객체를 디코드
//       final Map<String, dynamic> decodedData = json.decode(response.body);
//       // MyPlaceList 키에 접근하여 List<dynamic> 타입으로 변환
//       final List<dynamic> myPlaceList = decodedData['MyPlaceList'];
//       // List<dynamic>을 List<Place>로 변환
//       return myPlaceList.map((place) => Place.fromJson(place)).toList();
//     } else {
//       print(
//         'my_place_model 69번줄 ${response.statusCode} ',
//       );
//       print('my_place_model 71번줄, $accessToken');
//       throw Exception('failed');
//     }
//   }
// }
