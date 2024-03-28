import 'package:flutter/material.dart';

class CategoryIconMapper {
  static const Map<String, String> _iconUrlMapping = {
    '대형마트': 'assets/icons/market.png',
    '편의점': 'assets/icons/convenience-store.png',
    '어린이집,유치원': 'assets/icons/baby.png',
    '학교': 'assets/icons/school.png',
    '학원': 'assets/icons/academy.png',
    '주차장': 'assets/icons/parking-lot.png',
    '주유소,충전소': 'assets/icons/fuel-station.png',
    '지하철역': 'assets/icons/subway.png',
    '은행': 'assets/icons/bank.png',
    '문화시설': 'assets/icons/theater.png',
    '중개업소': 'assets/icons/building.png',
    '공공기관': 'assets/icons/building.png',
    '관광명소': 'assets/icons/building.png',
    '숙박': 'assets/icons/hotel.png',
    '음식점': 'assets/icons/restaurant.png',
    '카페': 'assets/icons/cafe.png',
    '병원': 'assets/icons/hospital.png',
    '약국': 'assets/icons/drugstore.png',
    // 여기에 더 많은 카테고리와 아이콘 URL 매핑을 추가할 수 있습니다.
  };

  static String getIconUrl(String categoryGroupName) {
    debugPrint('categoryGroupName: $categoryGroupName');
    return _iconUrlMapping[categoryGroupName] ?? 'assets/icons/building.png';
  }

  static Map<String, String> get allIcons => _iconUrlMapping;
}
