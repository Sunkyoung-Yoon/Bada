import 'dart:io';

import 'package:bada/api_request/member_api.dart';
import 'package:bada/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileEdit extends StatefulWidget {
  var nickname;
  var profileUrl;
  int? memberId;

  ProfileEdit({
    super.key,
    memberId,
    required this.nickname,
    required this.profileUrl,
  });

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final membersApi = MembersApi();
  TextEditingController nicknameController = TextEditingController();
  Future<void>? load;
  String? profileUrl;
  String? profileImage;

  @override
  void initState() {
    super.initState();
    profileUrl = widget.profileUrl;
    nicknameController.text = widget.nickname;
  }

  @override
  Widget build(BuildContext context) {
    // dart의 타입 추론 특성상 ImageProvider라는 타입이 명확하게 정의되지 않아서 변수로 선언하고 할당하는 방식으로 사용
    // AssetImage, NetworkImage, FileImage 중에 ImageProvider 타입이 아닌 다른 타입을 가진 변수가 있을 수 있기 때문에
    ImageProvider imageProvider;
    if (profileUrl == null || profileUrl == '') {
      imageProvider = const AssetImage('assets/img/default_profile.png');
    } else {
      imageProvider = NetworkImage(profileUrl!);
    }
    if (profileImage != null) {
      imageProvider = FileImage(File(profileImage!));
    }
    return FutureBuilder(
      future: load,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: const CustomAppBar(title: '프로필 수정'),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  '프로필 사진',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          profileImage = pickedFile.path; // 이미지 파일 기기 내 경로 저장
                        });
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent, // 배경 색상을 투명하게 설정
                          backgroundImage: imageProvider,
                        ),
                        Container(
                          width: 100, // CircleAvatar와 동일한 크기로 설정
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        const Text(
                          "수정",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  '닉네임',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '닉네임을 입력해주세요',
                  ),
                  controller: nicknameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // 닉네임과 프로필 이미지가 각각 하나씩만 입력되었을 때
                    // 또는 모두 입력 되었을 때 저장 가능
                    var isChanged = await membersApi.updateProfile(
                      profileImage,
                      nicknameController.text,
                      widget.memberId,
                      context,
                    );
                    if (isChanged) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('저장'),
                  // TODO : 413 error 발생, 이미지 사이즈 줄이거나 서버에서 제한하는 사이즈 늘리기
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
