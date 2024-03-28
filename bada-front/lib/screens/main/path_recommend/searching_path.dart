import 'dart:convert';
import 'package:bada/login/login_platform.dart';
import 'package:bada/screens/main/path_recommend/path_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bada/screens/main/path_recommend/model/path_search_history.dart';
import 'package:bada/models/search_results.dart';
import 'package:bada/screens/main/path_recommend/search_place_for_path.dart';

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
  final List<String> _departureKeywordList = [];
  final List<String> _destinationKeywordList = [];
  final List<String> _departureLatitudeList = [];
  final List<String> _departureLongitudeList = [];
  final List<String> _destinationLatitudeList = [];
  final List<String> _destinationLongitudeList = [];

  @override
  void initState() {
    super.initState();
    _loadPathSearchHistory();
  }

  Future<void> _loadPathSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // prefs.
      // _departureKeywordList = prefs.getStringList('departureKeywordList') ?? [];
      // _destinationKeywordList =
      //     prefs.getStringList('destinationKeywordList') ?? [];
      // _departureLatitudeList =
      //     prefs.getStringList('departureLatitudeList') ?? [];
      // _departureLongitudeList =
      //     prefs.getStringList('departureLongitudeList') ?? [];
      // _destinationLatitudeList =
      //     prefs.getStringList('destinationLatitudeList') ?? [];
      // _destinationLongitudeList =
      //     prefs.getStringList('destinationLongitudeList') ?? [];
    });
  }

  void pathRequest() async {
    var accessToken = await secureStorage.read(key: 'accessToken');
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/path');
    var requestBody = json.encode({
      "startX": _departureLongitude.toString(),
      "startY": _departureLatitude.toString(),
      "endX": _destinationLongitude.toString(),
      "endY": _destinationLatitude.toString(),
    });
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Content-Type 헤더 설정
        'Authorization': 'Bearer $accessToken',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      debugPrint('서버로부터 응답 성공: ${response.body}');
      // 경로 검색 기록 저장
      final prefs = await SharedPreferences.getInstance();
      if (_departureKeywordList.isEmpty) {
        _departureKeywordList.add(_departureController.text);
        _destinationKeywordList.add(_destinationController.text);
        _departureLatitudeList.add(_departureLatitude.toString());
        _departureLongitudeList.add(_departureLongitude.toString());
        _destinationLatitudeList.add(_destinationLatitude.toString());
        _destinationLongitudeList.add(_destinationLongitude.toString());
      } else {
        _departureKeywordList.insert(0, _departureController.text);
        _destinationKeywordList.insert(0, _destinationController.text);
        _departureLatitudeList.insert(0, _departureLatitude.toString());
        _departureLongitudeList.insert(0, _departureLongitude.toString());
        _destinationLatitudeList.insert(0, _destinationLatitude.toString());
        _destinationLongitudeList.insert(0, _destinationLongitude.toString());
      }

      prefs.setStringList('departureKeywordList', _departureKeywordList);
      prefs.setStringList('destinationKeywordList', _destinationKeywordList);
      prefs.setStringList('departureLatitudeList', _departureLatitudeList);
      prefs.setStringList('departureLongitudeList', _departureLongitudeList);
      prefs.setStringList('destinationLatitudeList', _destinationLatitudeList);
      prefs.setStringList(
        'destinationLongitudeList',
        _destinationLongitudeList,
      );

      // TODO : 경로 요청 API Response를 파라미터로 넘겨주어 PathMap으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PathMap()),
      );
    } else {
      debugPrint('요청 실패: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              deviceWidth * 0.06,
              deviceHeight * 0.07,
              deviceWidth * 0.00,
              deviceHeight * 0.00,
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
                              builder: (context) => const SearchPlaceForPath(),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              _departureController.text = result.pointKeyword;
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
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 0.1,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
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
                              builder: (context) => const SearchPlaceForPath(),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              _destinationController.text = result.pointKeyword;
                              _destinationLatitude = result.pointY;
                              _destinationLongitude = result.pointX;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: SizedBox(
                            height: deviceHeight * 0.06, // TextField의 표준 높이
                            child: TextField(
                              controller: _destinationController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 0.1,
                                  ),
                                ),
                                hintText: '도착지',
                                contentPadding: const EdgeInsets.symmetric(
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
                    angle: 90 * 3.141592653589793 / 180, // 라디안으로 변환하여 90도 회전
                    child: const Icon(Icons.compare_arrows_rounded),
                  ),
                  onPressed: () {
                    // 출발지와 도착지를 서로 바꾸기
                    String tmpText = _departureController.text;
                    double tmpLatitude = _departureLatitude;
                    double tmpLongitude = _departureLongitude;
                    setState(() {
                      _departureController.text = _destinationController.text;
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
              onPressed: () {
                pathRequest();
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
  }
}
