import 'dart:convert';

import 'package:flutter/services.dart';

class Place {
  final int placeId;
  final String placeName;
  final String placeLatitude;
  final String placeLongitude;
  final String icon;
  final String familyCode;

  Place({
    required this.placeId,
    required this.placeName,
    required this.placeLatitude,
    required this.placeLongitude,
    required this.icon,
    required this.familyCode,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'],
      placeName: json['place_name'],
      placeLatitude: json['place_latitude'],
      placeLongitude: json['place_longitude'],
      icon: json['icon'],
      familyCode: json['family_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'place_name': placeName,
      'place_latitude': placeLatitude,
      'place_longitude': placeLongitude,
      'icon': icon,
      'family_code': familyCode,
    };
  }
}

class MyPlaceData {
  static Future<List<Place>> loadPlaces() async {
    final dat =
        await rootBundle.loadString('assets/dummydata/my_place_dummy.json');
    final res = json.decode(dat) as List;
    return res.map((place) => Place.fromJson(place)).toList();
  }
}
