import 'package:bada/models/category_icon_mapper.dart';
import 'package:bada/provider/map_provider.dart';
import 'package:bada/screens/main/my_place/add_place.dart';
import 'package:bada/widgets/longText_handler.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bada/models/search_results.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart'; // SearchResultItem 모델 import 필요
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:marquee/marquee.dart'; // SearchResultItem 모델 import 필요

class SearchMapScreen extends StatefulWidget {
  final SearchResultItem item;
  final String keyword;

  const SearchMapScreen({
    super.key,
    required this.item,
    required this.keyword,
  });

  @override
  State<SearchMapScreen> createState() => _SearchMapScreenState();
}

// TODO : 지도를 켰을 때 마지막으로 검색했던 위치로 이동하도록 수정
class _SearchMapScreenState extends State<SearchMapScreen> {
  late KakaoMapController mapController;
  late MapProvider mapProvider;
  late LatLng searchedLocation;
  late String accessToken;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Set<Marker> markers = {};

  // 검색 위치 업데이트 및 검색 위치로 화면 이동
  Future<void> _updateSearchedLocation() async {
    LatLng searchedLocation =
        LatLng(double.parse(widget.item.y), double.parse(widget.item.x));
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: 'searched_location',
          latLng: searchedLocation,
          width: 30,
          height: 44,
          offsetX: 15,
          offsetY: 44,
        ),
      );
    });
  }

  void moveToSearchedLocation() async {
    searchedLocation =
        LatLng(double.parse(widget.item.y), double.parse(widget.item.x));
    await mapController.setCenter(searchedLocation);
  }

  void backToPreviousScreen() {
    Navigator.pop(context);
  }

  Future<void> sendPostRequest() async {
    accessToken = await secureStorage.read(key: 'accessToken') ?? '';
    debugPrint('accessToken: $accessToken');

    var url = Uri.parse('https://j10b207.p.ssafy.io/api/myplace');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    var requestBody = jsonEncode({
      "placeName": widget.item.placeName,
      "placeLatitude": widget.item.y,
      "placeLongitude": widget.item.x,
      "placeCategoryCode": widget.item.categoryGroupCode,
      "placeCategoryName": widget.item.categoryGroupName,
      "placePhoneNumber": widget.item.phone,
      "addressName": widget.item.addressName,
      "addressRoadName": widget.item.roadAddressName,
      // "placeCode": "placeCode",
    });

    var response = await http.post(url, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      // 요청이 성공적으로 처리되었을 때의 로직
      print('Request successful');
    } else {
      // 오류가 발생했을 때의 로직
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = UIhelper.deviceHeight(context);
    double deviceWidth = UIhelper.deviceWidth(context);

    return Scaffold(
      body: Stack(
        children: [
          // KakaoMap 위치 표시 (실제 KakaoMap 위젯으로 대체 필요)
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: KakaoMap(
                onMapCreated: (controller) {
                  mapController = controller;
                  _updateSearchedLocation(); // 검색 위치 업데이트
                  moveToSearchedLocation(); // 검색 위치로 이동
                },
                markers: markers.toList(),
              ),
            ),
          ),
          // 상단에 위치한 검색 키워드 표시
          Positioned(
            top: 40, // 상태바 높이를 고려한 여백
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: TextEditingController(text: widget.keyword),
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 0.1,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // 아이콘 버튼을 눌렀을 때 수행할 동작
                    },
                  ),
                ),
              ),
            ),
          ),
          // 하단에 위치한 주소, 카테고리, 장소이름 표시
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                deviceWidth * 0.08,
                deviceHeight * 0.03,
                deviceWidth * 0.08,
                deviceHeight * 0.03,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: UIhelper.scaleWidth(context) * 300,
                            height: UIhelper.scaleHeight(context) * 50,
                            child: OptionalScrollingText(
                              text: widget.item.placeName,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          SizedBox(height: UIhelper.scaleHeight(context) * 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: UIhelper.scaleWidth(context) * 300,
                                height: UIhelper.scaleHeight(context) * 50,
                                child: OptionalScrollingText(
                                  text: widget.item.addressName,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: UIhelper.scaleHeight(context) * 8,
                          ),
                        ],
                      ),
                      Image.asset(
                        CategoryIconMapper.getIconUrl(
                          widget.item.categoryGroupName,
                        ),
                        width: UIhelper.scaleWidth(context) * 60,
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRoute());
                      },
                      child: const Text("추가하기"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AddPlace(
        placeName: widget.item.placeName,
        addressName: widget.item.addressName,
        roadAddressName: widget.item.roadAddressName,
        categoryGroupName: widget.item.categoryGroupName,
        categoryGroupCode: widget.item.categoryGroupCode,
        phone: widget.item.phone,
        x: widget.item.x,
        y: widget.item.y,
        id: widget.item.id,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
