import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Place {
  final int myPlaceId;
  final String placeName;
  final String placeLatitude;
  final String placeLongitude;
  final String placeCategoryCode;
  final String placeCategoryName;
  final String placePhoneNumber;
  final String addressName;
  final String addressRoadName;

  Place({
    required this.myPlaceId,
    required this.placeName,
    required this.placeLatitude,
    required this.placeLongitude,
    required this.placeCategoryCode,
    required this.placeCategoryName,
    required this.placePhoneNumber,
    required this.addressName,
    required this.addressRoadName,
    // required this.placeCode,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      myPlaceId: json['myPlaceId'] as int,
      placeName: json['placeName'] as String,
      placeLatitude: json['placeLatitude'] as String,
      placeLongitude: json['placeLongitude'] as String,
      placeCategoryCode: json['placeCategoryCode'] as String,
      placeCategoryName: json['placeCategoryName'] as String,
      placePhoneNumber: json['placePhoneNumber'] as String,
      addressName: json['addressName'] as String,
      addressRoadName: json['addressRoadName'] as String,
      // placeCode: json['placeCode'] as String,
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
  static Future<List<Place>> loadPlaces(String accessToken) async {
    debugPrint('accessToken: $accessToken');
    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/myplace'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 응답에서 전체 JSON 객체를 디코드
      final Map<String, dynamic> decodedData = json.decode(response.body);
      // MyPlaceList 키에 접근하여 List<dynamic> 타입으로 변환
      final List<dynamic> myPlaceList = decodedData['MyPlaceList'];
      // List<dynamic>을 List<Place>로 변환
      return myPlaceList.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }
}
