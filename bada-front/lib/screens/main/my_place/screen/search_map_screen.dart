import 'package:bada/models/category_icon_mapper.dart';
import 'package:bada/screens/main/my_place/screen/add_place.dart';
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
  final VoidCallback onDataUpdate;
  const SearchMapScreen({
    super.key,
    required this.item,
    required this.keyword,
    required this.onDataUpdate,
  });

  @override
  State<SearchMapScreen> createState() => _SearchMapScreenState();
}

// TODO : 지도를 켰을 때 마지막으로 검색했던 위치로 이동하도록 수정
class _SearchMapScreenState extends State<SearchMapScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late KakaoMapController mapController;
  late LatLng searchedLocation;
  late String accessToken;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late Marker marker;
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
      debugPrint('Request successful');
    } else {
      // 오류가 발생했을 때의 로직
      debugPrint('Request failed with status: ${response.statusCode}.');
    }
  }

  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observer 등록
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Observer를 해제합니다.
    _lottieController.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 앱이 다시 활성화될 때 애니메이션을 재시작합니다.
    if (state == AppLifecycleState.resumed) {
      _lottieController.repeat();
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
              padding: EdgeInsets.all(deviceWidth * 0.05),
              child: GestureDetector(
                onTap: () {
                  backToPreviousScreen();
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(text: widget.keyword),
                    readOnly: true,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                        onPressed: () {},
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        iconSize: deviceWidth * 0.04,
                        onPressed: () {
                          backToPreviousScreen();
                        },
                      ),
                    ),
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
                deviceHeight * 0.04,
                deviceWidth * 0.07,
                deviceHeight * 0.02,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        // Column 위젯을 Expanded로 감싸서 사용 가능한 공간을 모두 차지하도록 함
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: UIhelper.scaleWidth(context) * 260,
                              height: UIhelper.scaleHeight(context) * 50,
                              child: OptionalScrollingText(
                                text: widget.item.placeName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: UIhelper.scaleWidth(context) * 260,
                                  height: UIhelper.scaleHeight(context) * 50,
                                  child: OptionalScrollingText(
                                    text: widget.item.addressName,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        // 아이콘 배치
                        CategoryIconMapper.getIconUrl(
                          widget.item.categoryGroupName,
                        ),
                        width: UIhelper.scaleWidth(context) * 60,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(_createRoute());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff7B79FF),
                          foregroundColor: Colors.white,
                          fixedSize:
                              Size(deviceWidth * 0.85, deviceHeight * 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("추가하기"),
                      ),
                    ],
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
        onDataUpdate: widget.onDataUpdate,
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
