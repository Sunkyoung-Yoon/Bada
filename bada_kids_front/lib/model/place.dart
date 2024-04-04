import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Place {
  final int myPlaceId;
  final String placeName;
  final double placeLatitude;
  final double placeLongitude;
  final String placeCategoryCode;
  final String placeCategoryName;
  final String placePhoneNumber;
  final String addressName;
  final String addressRoadName;
  final String placeCode;
  final String icon;

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
    required this.placeCode,
    required this.icon,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      myPlaceId: json['myPlaceId'],
      placeName: json['placeName'],
      placeLatitude: json['placeLatitude'].toDouble(),
      placeLongitude: json['placeLongitude'].toDouble(),
      placeCategoryCode: json['placeCategoryCode'],
      placeCategoryName: json['placeCategoryName'],
      placePhoneNumber: json['placePhoneNumber'],
      addressName: json['addressName'],
      addressRoadName: json['addressRoadName'],
      placeCode: json['placeCode'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'my_place_id': myPlaceId,
      'place_name': placeName,
      'place_latitude': placeLatitude,
      'place_longitude': placeLongitude,
      'place_category_code': placeCategoryCode,
      'place_category_name': placeCategoryName,
      'place_phone_number': placePhoneNumber,
      'address_name': addressName,
      'address_road_name': addressRoadName,
      'place_code': placeCode,
      'icon': icon,
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
      final Map<String, dynamic> decodedData =
          json.decode(utf8.decode(response.bodyBytes));
      // MyPlaceList 키에 접근하여 List<dynamic> 타입으로 변환
      final List<dynamic> myPlaceList = decodedData['MyPlaceList'];
      // List<dynamic>을 List<Place>로 변환
      return myPlaceList.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }
}
