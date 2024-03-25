import 'dart:io';
import 'dart:typed_data';

import 'package:bada/widgets/screensize.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class PlaceDetail extends StatefulWidget {
  final String placeName;

  const PlaceDetail({super.key, required this.placeName});

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  Uint8List? _image;
  File? selectedImage;
  late TextEditingController _controller;

  LatLng center = LatLng(33.450701, 126.570667);
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.placeName);
  }

  void _onMapCreated(KakaoMapController controller) {
    setState(() {
      markers.add(
        Marker(
          markerId: 'searched_location',
          latLng: center,
          width: 30,
          height: 44,
          offsetX: 15,
          offsetY: 44,
          markerImageSrc:
              'https://w7.pngwing.com/pngs/96/889/png-transparent-marker-map-interesting-places-the-location-on-the-map-the-location-of-the-thumbnail.png',
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showIconPicker(context);
                  },
                  child: _image != null
                      ? CircleAvatar(
                          radius: UIhelper.scaleHeight(context) * 50,
                        )
                      : CircleAvatar(
                          radius: UIhelper.scaleHeight(context) * 50,
                          child: const Text('이미지 들어감'),
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
                    Row(
                      children: [
                        const Text('주소: '),
                        SizedBox(
                          width: UIhelper.scaleWidth(context) * 10,
                        ),
                        SizedBox(
                          width: UIhelper.scaleWidth(context) * 200,
                          height: UIhelper.scaleHeight(context) * 50,
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: ('주소'),
                            ),
                          ),
                        ),
                      ],
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
                  onPressed: () {},
                  child: const Text('수정'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('삭제'),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 300,
              child: KakaoMap(
                onMapCreated: _onMapCreated, // onMapCreated 콜백을 등록합니다.
                markers: markers.toList(), // 주소 마커
                center: center, // 주소로 받아온 위도, 경도
                currentLevel: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showIconPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          child: Column(
            children: [
              const Text('아이콘을 선택해주세요'),
              ElevatedButton(
                onPressed: () {
                  _pickImageFromGallery();
                },
                child: const Icon(Icons.abc),
              ),
            ],
          ),
        );
      },
    );
  }

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
  }
}
