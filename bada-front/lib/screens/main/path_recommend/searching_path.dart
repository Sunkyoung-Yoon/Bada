import 'dart:convert';
import 'package:bada/screens/main/path_recommend/model/path_response.dart';
import 'package:bada/social_login/login_platform.dart';
import 'package:bada/screens/main/path_recommend/screen/path_map.dart';
import 'package:bada/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bada/screens/main/path_recommend/model/path_search_history.dart';
import 'package:bada/models/search_results.dart';
import 'package:bada/screens/main/path_recommend/screen/search_place_for_path.dart';

class SearchingPath extends StatefulWidget {
  const SearchingPath({super.key});

  @override
  State<SearchingPath> createState() => _SearchingPathState();
}

class _SearchingPathState extends State<SearchingPath> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final TextEditingController _departureController = TextEditingController();
  double _departureLatitude = 0.0;
  double _departureLongitude = 0.0;
  final TextEditingController _destinationController = TextEditingController();
  double _destinationLatitude = 0.0;
  double _destinationLongitude = 0.0;
  List<String> _departureKeywordList = [];
  List<String> _destinationKeywordList = [];
  List<String> _departureLatitudeList = [];
  List<String> _departureLongitudeList = [];
  List<String> _destinationLatitudeList = [];
  List<String> _destinationLongitudeList = [];
  bool _isLoading = false;

  Future<void> _loadPathSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _departureKeywordList = prefs.getStringList('departureKeywordList') ?? [];
      _destinationKeywordList =
          prefs.getStringList('destinationKeywordList') ?? [];
      _departureLatitudeList =
          prefs.getStringList('departureLatitudeList') ?? [];
      _departureLongitudeList =
          prefs.getStringList('departureLongitudeList') ?? [];
      _destinationLatitudeList =
          prefs.getStringList('destinationLatitudeList') ?? [];
      _destinationLongitudeList =
          prefs.getStringList('destinationLongitudeList') ?? [];
    });
  }

  Future<void> pathRequest() async {
    try {
      _isLoading = true;
      var accessToken = await secureStorage.read(key: 'accessToken');
      var url = Uri.parse('https://j10b207.p.ssafy.io/api/path');
      var requestBody = json.encode({
        "startLng": _departureLongitude.toStringAsFixed(5),
        "startLat": _departureLatitude.toStringAsFixed(5),
        "endLng": _destinationLongitude.toStringAsFixed(5),
        "endLat": _destinationLatitude.toStringAsFixed(5),
        "addressName": '현재 위치',
        "placeName": '목적지',
      });
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Content-Type 헤더 설정
          'Authorization': 'Bearer $accessToken',
        },
        body: requestBody,
      );
      debugPrint("액세스 토큰 : $accessToken");
      debugPrint("요청 바디 : $requestBody");

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        PathResponse pathResponse = PathResponse.fromJson(jsonResponse);
        Point startPoint = Point(
          latitude: pathResponse.startLat,
          longitude: pathResponse.startLng,
        );
        Point endPoint = Point(
          latitude: pathResponse.endLat,
          longitude: pathResponse.endLng,
        );
        List<Point> pointList = pathResponse.pointList;
        pointList.insert(0, startPoint);
        pointList.add(endPoint);

        // 경로 검색 기록 저장
        final prefs = await SharedPreferences.getInstance();

        setState(() {
          if (_departureKeywordList.isEmpty) {
            _departureKeywordList.add(_departureController.text);
            _destinationKeywordList.add(_destinationController.text);
            _departureLatitudeList.add(_departureLatitude.toString());
            _departureLongitudeList.add(_departureLongitude.toString());
            _destinationLatitudeList.add(_destinationLatitude.toString());
            _destinationLongitudeList.add(_destinationLongitude.toString());
          } else {
            if (_departureKeywordList.contains(_departureController.text) &&
                _destinationKeywordList.contains(_destinationController.text)) {
              _departureKeywordList.remove(_departureController.text);
              _destinationKeywordList.remove(_destinationController.text);
              _departureLatitudeList.remove(_departureLatitude.toString());
              _departureLongitudeList.remove(_departureLongitude.toString());
              _destinationLatitudeList.remove(_destinationLatitude.toString());
              _destinationLongitudeList
                  .remove(_destinationLongitude.toString());
            }
            if (_departureKeywordList.length >= 20) {
              _departureKeywordList.removeAt(19);
              _destinationKeywordList.removeAt(19);
              _departureLatitudeList.removeAt(19);
              _departureLongitudeList.removeAt(19);
              _destinationLatitudeList.removeAt(19);
              _destinationLongitudeList.removeAt(19);
            }

            _departureKeywordList.insert(0, _departureController.text);
            _destinationKeywordList.insert(0, _destinationController.text);
            _departureLatitudeList.insert(0, _departureLatitude.toString());
            _departureLongitudeList.insert(0, _departureLongitude.toString());
            _destinationLatitudeList.insert(0, _destinationLatitude.toString());
            _destinationLongitudeList.insert(
              0,
              _destinationLongitude.toString(),
            );
          }
        });

        prefs.setStringList('departureKeywordList', _departureKeywordList);
        prefs.setStringList('destinationKeywordList', _destinationKeywordList);
        prefs.setStringList('departureLatitudeList', _departureLatitudeList);
        prefs.setStringList('departureLongitudeList', _departureLongitudeList);
        prefs.setStringList(
          'destinationLatitudeList',
          _destinationLatitudeList,
        );
        prefs.setStringList(
          'destinationLongitudeList',
          _destinationLongitudeList,
        );

        // TODO : 경로 요청 API Response를 파라미터로 넘겨주어 PathMap으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PathMap(
              pathList: pointList,
              departure: _departureController.text,
              destination: _destinationController.text,
            ),
          ),
        );
      } else {
        debugPrint('요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('에러 발생: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: _loadPathSearchHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: const CustomAppBar(title: '경로 검색'),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.06,
                        deviceHeight * 0.02,
                        deviceWidth * 0.00,
                        deviceHeight * 0.02,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SearchPlaceForPath(),
                                      ),
                                    );
                                    if (result != null) {
                                      setState(() {
                                        _departureController.text =
                                            result.pointKeyword;
                                        _departureLatitude = result.pointY;
                                        _departureLongitude = result.pointX;
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: SizedBox(
                                      height: deviceHeight * 0.06,
                                      child: TextField(
                                        controller: _departureController,
                                        decoration: InputDecoration(
                                          hintText: '출발지',
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 0.1,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: deviceHeight * 0.005),
                                GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SearchPlaceForPath(),
                                      ),
                                    );
                                    if (result != null) {
                                      setState(() {
                                        _destinationController.text =
                                            result.pointKeyword;
                                        _destinationLatitude = result.pointY;
                                        _destinationLongitude = result.pointX;
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: SizedBox(
                                      height: deviceHeight *
                                          0.06, // TextField의 표준 높이
                                      child: TextField(
                                        controller: _destinationController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 0.1,
                                            ),
                                          ),
                                          hintText: '도착지',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Transform.rotate(
                              angle: 90 *
                                  3.141592653589793 /
                                  180, // 라디안으로 변환하여 90도 회전
                              child: const Icon(
                                Icons.compare_arrows_rounded,
                                size: 30,
                              ),
                            ),
                            onPressed: () {
                              // 출발지와 도착지를 서로 바꾸기
                              String tmpText = _departureController.text;
                              double tmpLatitude = _departureLatitude;
                              double tmpLongitude = _departureLongitude;
                              setState(() {
                                _departureController.text =
                                    _destinationController.text;
                                _departureLatitude = _destinationLatitude;
                                _departureLongitude = _destinationLongitude;
                                _destinationController.text = tmpText;
                                _destinationLatitude = tmpLatitude;
                                _destinationLongitude = tmpLongitude;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.02,
                        deviceHeight * 0.01,
                        deviceWidth * 0.02,
                        deviceHeight * 0.01,
                      ),
                      width: deviceWidth * 0.928,
                      height: deviceHeight * 0.08,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff696DFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // 둥근 정도 조정
                          ),
                        ),
                        onPressed: () async {
                          await pathRequest();
                        },
                        child: const Text('경로 요청'),
                      ),
                    ),
                    Expanded(
                      child: _departureKeywordList.isEmpty
                          ? const Center(
                              // 검색 기록이 없을 때 표시될 위젯
                              child: Text("경로 검색 기록이 없습니다."),
                            )
                          : ListView.builder(
                              itemCount: _departureKeywordList.length,
                              itemBuilder: (context, index) {
                                if (_departureKeywordList.length > index &&
                                    _destinationKeywordList.length > index) {
                                  return ListTile(
                                    title: Text(
                                      '${_departureKeywordList[index]} -> ${_destinationKeywordList[index]}',
                                    ),
                                    trailing: const Icon(Icons.history),
                                    onTap: () {
                                      // 해당 검색 기록으로 다시 검색
                                      _departureController.text =
                                          _departureKeywordList[index];
                                      _destinationController.text =
                                          _destinationKeywordList[index];
                                      _departureLatitude = double.parse(
                                        _departureLatitudeList[index],
                                      );
                                      _departureLongitude = double.parse(
                                        _departureLongitudeList[index],
                                      );
                                      _destinationLatitude = double.parse(
                                        _destinationLatitudeList[index],
                                      );
                                      _destinationLongitude = double.parse(
                                        _destinationLongitudeList[index],
                                      );
                                    },
                                  );
                                }
                                return null;
                              },
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
