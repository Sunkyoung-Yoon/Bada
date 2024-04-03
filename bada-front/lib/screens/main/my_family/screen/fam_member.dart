import 'dart:ui';

import 'package:bada/screens/main/alarm/alarm_list.dart';
import 'package:bada/screens/main/my_family/screen/existing_path_map.dart';
import 'package:bada/screens/main/profile_edit.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';

class FamilyMember extends StatefulWidget {
  final int memberId;
  final String name;
  final String? profileUrl;
  final int isParent;
  final int? movingState;
  const FamilyMember({
    super.key,
    required this.memberId,
    required this.name,
    required this.isParent,
    this.profileUrl,
    this.movingState,
  });

  @override
  State<FamilyMember> createState() => _FamilyMemberState();
}

class _FamilyMemberState extends State<FamilyMember>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  Future<void>? _loadMyMemberId;
  int? myMemberId;

  @override
  void initState() {
    super.initState();
    myMemberId = widget.memberId;
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = UIhelper.deviceWidth(context);
    final deviceHeight = UIhelper.deviceHeight(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            deviceWidth * 0.00,
            deviceHeight * 0.02,
            deviceWidth * 0.05,
            deviceHeight * 0.02,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff696DFF), width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                width: 125 * UIhelper.scaleWidth(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEdit(
                              nickname: widget.name,
                              profileUrl: widget.profileUrl,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: widget.profileUrl != null
                            ? NetworkImage(widget.profileUrl!)
                            : null,
                        child: widget.profileUrl == null
                            ? Image.asset('assets/img/default_profile.png')
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    Text(
                      widget.name,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              if (widget.isParent == 0)
                Column(
                  children: [
                    widget.movingState == 0
                        ? ElevatedButton(
                            onPressed: null, // 비활성화 상태로 만듭니다.
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                deviceWidth * 0.03,
                                deviceHeight * 0.003,
                                deviceWidth * 0.04,
                                deviceHeight * 0.003,
                              ),
                              surfaceTintColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              // 비활성화 상태일 때의 색상을 지정할 수 있습니다.
                            ),
                            child: Row(
                              children: [
                                Lottie.asset(
                                  'assets/lottie/walking.json',
                                  width: 45 * UIhelper.scaleWidth(context),
                                  height: 45 * UIhelper.scaleHeight(context),
                                  controller: _lottieController,
                                  onLoaded: (p0) {
                                    _lottieController.duration = p0.duration;

                                    _lottieController.stop();
                                  },
                                ),
                                SizedBox(
                                  width: 10 * UIhelper.scaleWidth(context),
                                ),
                                const Text('경로 비활성화'),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              backgroundColor: const Color(0xff696DFF),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.fromLTRB(
                                deviceWidth * 0.04,
                                deviceHeight * 0.003,
                                deviceWidth * 0.05,
                                deviceHeight * 0.003,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExistingPathMap(
                                    memberId: widget.memberId,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Lottie.asset(
                                  'assets/lottie/walking.json',
                                  width: 45 * UIhelper.scaleWidth(context),
                                  height: 45 * UIhelper.scaleHeight(context),
                                  controller: _lottieController,
                                  onLoaded: (p0) {
                                    _lottieController.duration = p0.duration;

                                    _lottieController.repeat();
                                  },
                                ),
                                SizedBox(
                                  width: 10 * UIhelper.scaleWidth(context),
                                ),
                                const Text('이동중'),
                              ],
                            ),
                          ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(
          height: UIhelper.deviceHeight(context) * 0.01,
        ),
      ],
    );
  }
}

class FamilyMember2 extends StatefulWidget {
  final String name;
  final String? profileUrl;
  final int isParent, memberId;
  final int? movingState;
  const FamilyMember2({
    super.key,
    required this.name,
    required this.isParent,
    this.profileUrl,
    this.movingState,
    required this.memberId,
  });

  @override
  State<FamilyMember2> createState() => _FamilyMember2State();
}

class _FamilyMember2State extends State<FamilyMember2>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  String myName = '';

  @override
  void initState() {
    super.initState();
    loadMyName();
    _lottieController = AnimationController(vsync: this);
  }

  void loadMyName() async {
    const storage = FlutterSecureStorage();
    String? name = await storage.read(key: 'nickname');
    if (name != null) {
      setState(() {
        myName = name;
      });
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlarmList(
                      name: widget.name,
                      memberId: widget.memberId,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 35,
                backgroundImage: widget.profileUrl != null
                    ? NetworkImage(widget.profileUrl!)
                    : null,
                child: widget.profileUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ) // Default icon for null profileUrl
                    : null,
              ),
            ),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        SizedBox(width: 20 * UIhelper.scaleWidth(context)),
      ],
    );
  }
}
