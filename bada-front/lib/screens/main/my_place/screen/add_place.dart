import 'dart:convert';

import 'package:bada/models/category_icon_mapper.dart';
import 'package:bada/screens/main/my_place/model/my_place_model.dart';
import 'package:bada/screens/main/my_place/my_place.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class AddPlace extends StatefulWidget {
  final String addressName, placeName, x, y, id;
  final String? categoryGroupCode, categoryGroupName, roadAddressName, phone;

  final VoidCallback onDataUpdate;
  const AddPlace({
    super.key,
    required this.id,
    required this.addressName,
    required this.placeName,
    this.roadAddressName,
    required this.x,
    required this.y,
    this.phone,
    this.categoryGroupCode,
    this.categoryGroupName,
    required this.onDataUpdate,
  });

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  late TextEditingController _titleController;
  late String _selectedIcon;
  Future<List<Place>>? myPlaces;
  bool _checkPlace = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.placeName);
    _selectedIcon =
        CategoryIconMapper.getIconUrl(widget.categoryGroupName ?? '빌딩');
    myPlaces = MyPlaceData.loadPlaces();

    myPlaces?.then((places) {
      setState(() {
        _checkPlace = places.any((place) => place.placeCode == widget.id);
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> back() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MyPlace()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: deviceWidth * 0.08,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          // 여기서 오른쪽 여백을 추가합니다.
          SizedBox(width: deviceWidth * 0.08),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(
          deviceWidth * 0.1,
          deviceHeight * 0.02,
          deviceWidth * 0.1,
          deviceHeight * 0.02,
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
                      width: 200,
                      child: TextField(
                        controller: _titleController,
                      ),
                    ),
                    SizedBox(height: UIhelper.scaleHeight(context) * 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.addressName,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: UIhelper.scaleHeight(context) * 8,
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                  width: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: _showIconSelection,
                        child: Image.asset(
                          _selectedIcon,
                          width: UIhelper.scaleWidth(context) * 60,
                        ),
                      ),
                      if (!_checkPlace)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Lottie.asset(
                            'assets/lottie/changeIcon.json',
                            width: 35,
                            height: 35,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!_checkPlace)
                  ElevatedButton(
                    onPressed: () async {
                      await _postPlace(
                        placeName: _titleController.text,
                        placeLatitude: widget.x,
                        placeLongitude: widget.y,
                        placeCategoryCode: widget.categoryGroupCode ?? '',
                        placeCategoryName: widget.categoryGroupName ?? '',
                        placePhoneNumber: widget.phone ?? '',
                        icon: _selectedIcon,
                        addressName: widget.addressName,
                        addressRoadName: widget.roadAddressName ?? '',
                        placeCode: widget.id,
                      );
                      await back();
                    },
                    child: const Text('추가하기'),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('저장됨', style: TextStyle(fontSize: 16)),
                  ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.categoryGroupName != null &&
                          widget.categoryGroupName != ''
                      ? Text('분류: ${widget.categoryGroupName}')
                      : const SizedBox(),
                  widget.phone != null && widget.phone != ''
                      ? Text('전화번호: ${widget.phone}')
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _postPlace({
    required String placeName,
    required String placeLatitude,
    required String placeLongitude,
    required String placeCategoryCode,
    required String placeCategoryName,
    required String placePhoneNumber,
    required String icon,
    required String addressName,
    required String addressRoadName,
    required String placeCode,
  }) async {
    final uri = Uri.parse('https://j10b207.p.ssafy.io/api/myplace');
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'placeName': placeName,
          'placeLatitude': placeLatitude,
          'placeLongitude': placeLongitude,
          'placeCategoryCode': placeCategoryCode,
          'placeCategoryName': placeCategoryName,
          'placePhoneNumber': placePhoneNumber,
          'icon': icon,
          'addressName': addressName,
          'addressRoadName': addressRoadName,
          'placeCode': placeCode,
        }),
      );
      if (response.statusCode == 200) {
        print('add_place 225번줄, 성공');
        setState(() {
          _checkPlace = true;
        });
        widget.onDataUpdate();
      } else {
        print("add_place 231번줄, 실패 ${response.statusCode}");
      }
    } catch (e) {
      print('PostVerificationCode $e');
    }
  }

  void _showIconSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GridView.builder(
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
        );
      },
    );
  }
}
