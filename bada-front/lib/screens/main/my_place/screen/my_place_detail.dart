import 'dart:io';
import 'package:bada/widgets/appbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bada/models/category_icon_mapper.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:typed_data';
// import 'package:bada/screens/main/my_place.dart';

class PlaceDetail extends StatefulWidget {
  final String placeName, icon, addressName;
  final int myPlaceId;
  final double placeLatitude, placeLongitude;
  final VoidCallback onPlaceUpdate;

  const PlaceDetail({
    super.key,
    required this.placeName,
    required this.icon,
    required this.addressName,
    required this.myPlaceId,
    required this.placeLatitude,
    required this.placeLongitude,
    required this.onPlaceUpdate,
  });

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  File? selectedImage;
  late TextEditingController _controller;
  late String _selectedIcon;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.placeName);
    _selectedIcon = widget.icon;
  }

  void _onMapCreated(KakaoMapController controller) {
    setState(() {
      controller.setCenter(LatLng(widget.placeLatitude, widget.placeLongitude));
      debugPrint(
        "위도(가로) : ${widget.placeLatitude}, 경도(세로) : ${widget.placeLongitude}",
      );
      markers.add(
        Marker(
          markerId: 'searched_location',
          latLng: LatLng(
            widget.placeLatitude,
            widget.placeLongitude,
          ),
          width: 30,
          height: 44,
          offsetX: 15,
          offsetY: 44,
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: widget.placeName),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              deviceWidth * 0.05,
              deviceHeight * 0.02,
              deviceWidth * 0.05,
              0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showIconSelection();
                      },
                      child: SizedBox(
                        width: UIhelper.scaleWidth(context) * 80,
                        height: UIhelper.scaleHeight(context) * 80,
                        child: Image.asset(_selectedIcon),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: 0.5)),
                          ),
                          child: Row(
                            children: [
                              const Text('이름: '),
                              SizedBox(
                                width: UIhelper.scaleWidth(context) * 10,
                              ),
                              SizedBox(
                                width: UIhelper.scaleWidth(context) * 200,
                                height: UIhelper.scaleHeight(context) * 50,
                                child: TextField(
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('주소: '),
                              SizedBox(
                                width: UIhelper.scaleWidth(context) * 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: UIhelper.scaleWidth(context) * 200,
                                height: UIhelper.scaleHeight(context) * 50,
                                child: Text(widget.addressName),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        editMyPlace(
                          widget.myPlaceId,
                          _selectedIcon,
                          _controller.text,
                        ).then((value) => Navigator.of(context).pop());
                      },
                      child: const Text('수정'),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('마이 플레이스 삭제'),
                              content: Text(
                                '"${widget.placeName}"을 내 목록에서 삭제하시겠습니까?',
                              ),
                              actions: <Widget>[
                                // Cancel button
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Dismiss the dialog
                                  },
                                  child: const Text('취소'),
                                ),
                                // Continue button
                                TextButton(
                                  onPressed: () {
                                    deleteMyPlace(widget.myPlaceId)
                                        .then(
                                          (value) => widget.onPlaceUpdate(),
                                        ) // Notice the parentheses here
                                        .then(
                                          (value) => Navigator.pop(
                                            context,
                                          ),
                                        ) // Pops the alert/dialog
                                        .then(
                                          (value) => Navigator.pop(
                                            context,
                                          ),
                                        ); // Pops back to MyPlace
                                  },
                                  child: const Text('삭제'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: KakaoMap(
              onMapCreated: _onMapCreated, // onMapCreated 콜백을 등록합니다.
              markers: markers.toList(), // 주소 마커
              center: LatLng(
                widget.placeLatitude,
                widget.placeLongitude,
              ), // 주소로 받아온 위도, 경도
              currentLevel: 4,
            ),
          ),
        ],
      ),
    );
  }

  void _showIconSelection() {
    debugPrint('252 iconSelectino');

    final deviceHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(top: deviceHeight * 0.05),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
            ),
            itemCount: CategoryIconMapper.allIcons.length,
            itemBuilder: (context, index) {
              String key = CategoryIconMapper.allIcons.keys.elementAt(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = CategoryIconMapper.allIcons[key]!;
                  });
                  Navigator.of(context).pop();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      CategoryIconMapper.allIcons[key]!,
                      width: 60,
                    ),
                    Text(key),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> deleteMyPlace(int myPlaceId) async {
    String? token = await const FlutterSecureStorage().read(key: 'accessToken');

    if (token == null) {
      print('Token is not available');
      return;
    }

    final response = await http.delete(
      Uri.parse(
        'https://j10b207.p.ssafy.io/api/myplace/${myPlaceId.toString()}',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Delete successful');
    } else {
      print('Failed to delete myPlace. Status code: ${response.statusCode}');
    }
  }

  Future<void> editMyPlace(int myPlaceId, String icon, String placeName) async {
    String? token = await const FlutterSecureStorage().read(key: 'accessToken');

    if (token == null) {
      print('Token is not available');
      return;
    }

    final response = await http.patch(
      Uri.parse(
        'https://j10b207.p.ssafy.io/api/myplace/${myPlaceId.toString()}',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'placeName': placeName,
        'icon': icon,
      }),
    );

    if (response.statusCode == 200) {
      print('Delete successful');
      widget.onPlaceUpdate();
    } else {
      print('Failed to delete myPlace. Status code: ${response.statusCode}');
    }
  }
}
