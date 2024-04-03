import 'dart:ui';

import 'package:bada/screens/main/my_place/screen/my_place_detail.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class MainLarge extends StatefulWidget {
  final String label;
  final Color backgroundColor, foregroundColor;
  final Widget? buttonImage;
  final double imageWidth, imageHeight, padRight, padBottom;
  final void Function()? onPressed;

  const MainLarge({
    super.key,
    required this.label,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.buttonImage,
    this.imageWidth = 120,
    this.imageHeight = 120,
    this.padRight = 10,
    this.padBottom = 10,
    this.onPressed,
  });

  @override
  State<MainLarge> createState() => MainLargeState();
}

class MainLargeState extends State<MainLarge> {
  @override
  Widget build(BuildContext context) {
    final hasImage = widget.buttonImage != null;
    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 5,
      padding: EdgeInsets.fromLTRB(20, 20, widget.padRight, widget.padBottom),
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
      fixedSize: Size(
        UIhelper.scaleWidth(context) * 240,
        UIhelper.scaleHeight(context) * 180,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    return ElevatedButton(
      style: style,
      onPressed: widget.onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.label,
              ),
            ],
          ),
          hasImage
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (hasImage)
                      SizedBox(
                        width: UIhelper.scaleWidth(context) * widget.imageWidth,
                        height:
                            UIhelper.scaleHeight(context) * widget.imageHeight,
                        child: Transform.translate(
                          offset: const Offset(0, 10),
                          child: widget.buttonImage!,
                        ),
                      ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class MainSmall extends StatefulWidget {
  final String label;
  final Color backgroundColor, foregroundColor;
  final Widget? buttonImage;
  final double imageWidth, imageHeight, padRight, padBottom;
  final void Function()? onPressed;

  const MainSmall({
    super.key,
    required this.label,
    this.backgroundColor = const Color(0xffFEFEFE),
    this.foregroundColor = Colors.black,
    this.buttonImage,
    this.imageWidth = 50,
    this.imageHeight = 50,
    this.padRight = 10,
    this.padBottom = 10,
    this.onPressed,
  });

  @override
  State<MainSmall> createState() => MainSmallState();
}

class MainSmallState extends State<MainSmall> {
  @override
  Widget build(BuildContext context) {
    final hasImage = widget.buttonImage != null;
    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 5,
      padding: EdgeInsets.fromLTRB(20, 20, widget.padRight, widget.padBottom),
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
      fixedSize: Size(
        UIhelper.scaleWidth(context) * 120,
        UIhelper.scaleHeight(context) * 180,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    return ElevatedButton(
      style: style,
      onPressed: widget.onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.label,
              ),
            ],
          ),
          hasImage
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (hasImage)
                      SizedBox(
                        width: UIhelper.scaleWidth(context) * widget.imageWidth,
                        height:
                            UIhelper.scaleHeight(context) * widget.imageHeight,
                        child: widget.buttonImage!,
                      ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class MainSmall2 extends StatefulWidget {
  final String label;
  final Color backgroundColor, foregroundColor;
  final Widget? buttonImage;
  final double imageWidth, imageHeight, padRight, padBottom;
  final void Function()? onPressed;
  final String unreadAlarm;

  const MainSmall2({
    super.key,
    required this.label,
    this.backgroundColor = const Color(0xffFEFEFE),
    this.foregroundColor = Colors.black,
    this.buttonImage,
    this.imageWidth = 50,
    this.imageHeight = 50,
    this.padRight = 10,
    this.padBottom = 10,
    this.onPressed,
    required this.unreadAlarm,
  });

  @override
  State<MainSmall2> createState() => MainSmall2State();
}

class MainSmall2State extends State<MainSmall2> with TickerProviderStateMixin {
  late final AnimationController _alarmController;

  @override
  void initState() {
    super.initState();
    _alarmController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _alarmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.buttonImage != null;
    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 5,
      padding: EdgeInsets.fromLTRB(20, 20, widget.padRight, widget.padBottom),
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
      fixedSize: Size(
        UIhelper.scaleWidth(context) * 120,
        UIhelper.scaleHeight(context) * 180,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    return ElevatedButton(
      style: style,
      onPressed: widget.onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
              ),
              if (widget.unreadAlarm != '0')
                CircleAvatar(
                  backgroundColor: const Color(0xffFF6969),
                  radius: 15,
                  child: Text(
                    widget.unreadAlarm,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: UIhelper.scaleWidth(context) * widget.imageWidth,
                height: UIhelper.scaleHeight(context) * widget.imageHeight,
                child: Lottie.asset(
                  'assets/lottie/notification.json',
                  controller: _alarmController,
                  onLoaded: ((p0) {
                    _alarmController.duration = p0.duration;
                    if (widget.unreadAlarm == '0') {
                      _alarmController.stop();
                    } else {
                      _alarmController.repeat();
                    }
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Button714_300 extends StatefulWidget {
  final String label;
  final Color backgroundColor, foregroundColor;
  final Widget? buttonImage;
  final double imageWidth, imageHeight, padRight, padBottom;
  final void Function()? onPressed;

  const Button714_300({
    super.key,
    required this.label,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.buttonImage,
    this.imageWidth = 50,
    this.imageHeight = 50,
    this.padRight = 10,
    this.padBottom = 10,
    this.onPressed,
  });

  @override
  State<Button714_300> createState() => _Button714_300State();
}

class _Button714_300State extends State<Button714_300> {
  @override
  Widget build(BuildContext context) {
    final hasImage = widget.buttonImage != null;

    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 5,
      padding: EdgeInsets.fromLTRB(20, 20, widget.padRight, widget.padBottom),
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
      fixedSize: Size(
        UIhelper.scaleWidth(context) * 368,
        UIhelper.scaleHeight(context) * 180,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    return ElevatedButton(
      style: style,
      onPressed: widget.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
              ),
              SizedBox(height: UIhelper.scaleHeight(context) * 10),
            ],
          ),
          hasImage
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (hasImage)
                      SizedBox(
                        width: UIhelper.scaleWidth(context) * 120,
                        height: UIhelper.scaleHeight(context) * 120,
                        child: widget.buttonImage!,
                      ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class Button714_150 extends StatefulWidget {
  final Widget label;
  final String? navigateTo;
  final Color backgroundColor, foregroundColor;
  final void Function()? onPressed;

  const Button714_150({
    super.key,
    required this.label,
    this.backgroundColor = const Color(0xff696DFF),
    this.foregroundColor = Colors.white,
    this.navigateTo,
    this.onPressed,
  });
  @override
  State<Button714_150> createState() => _Button714_150State();
}

class _Button714_150State extends State<Button714_150> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 5,
      padding: const EdgeInsets.all(20),
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      textStyle: const TextStyle(fontSize: 22),
      fixedSize: Size(
        UIhelper.scaleWidth(context) * 368,
        UIhelper.scaleHeight(context) * 80,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    return ElevatedButton(
      style: style,
      onPressed: widget.onPressed,
      child: widget.label,
    );
  }
}

class Button281_77 extends StatefulWidget {
  final Widget label;
  final String? navigateTo;
  final Color backgroundColor, foregroundColor;
  final void Function()? onPressed;
  final bool isSelected;

  const Button281_77({
    super.key,
    required this.label,
    this.backgroundColor = const Color(0xff696DFF),
    this.foregroundColor = Colors.white,
    this.navigateTo,
    this.onPressed,
    this.isSelected = false,
  });
  @override
  State<Button281_77> createState() => _Button281_77State();
}

class _Button281_77State extends State<Button281_77> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 5,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor:
          widget.isSelected ? widget.backgroundColor : Colors.white,
      foregroundColor:
          widget.isSelected ? widget.foregroundColor : widget.backgroundColor,
      textStyle: const TextStyle(fontSize: 16),
      fixedSize: Size(
        UIhelper.scaleWidth(context) * 110,
        UIhelper.scaleHeight(context) * 30,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    return ElevatedButton(
      style: style,
      onPressed: widget.onPressed,
      child: widget.label,
    );
  }
}

class Button300_115 extends StatefulWidget {
  final Widget label;
  final String? navigateTo;
  final Color backgroundColor, foregroundColor;
  final void Function()? onPressed;
  final bool isSelected;

  const Button300_115({
    super.key,
    required this.label,
    this.backgroundColor = const Color(0xff696DFF),
    this.foregroundColor = Colors.white,
    this.navigateTo,
    this.onPressed,
    this.isSelected = false,
  });
  @override
  State<Button300_115> createState() => _Button300_115State();
}

class _Button300_115State extends State<Button300_115> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 5,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor:
          widget.isSelected ? widget.backgroundColor : Colors.white,
      foregroundColor:
          widget.isSelected ? widget.foregroundColor : widget.backgroundColor,
      textStyle: const TextStyle(fontSize: 16),
      fixedSize: Size(
        UIhelper.scaleWidth(context) * 150,
        UIhelper.scaleHeight(context) * 60,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );

    return ElevatedButton(
      style: style,
      onPressed: widget.onPressed,
      child: widget.label,
    );
  }
}

class AlarmSettingButton extends StatefulWidget {
  final Widget label;
  final String? stoptime;
  final Color backgroundColor, foregroundColor;
  final void Function()? onPressed;
  final bool ischecked;

  const AlarmSettingButton({
    super.key,
    required this.label,
    this.backgroundColor = Colors.white,
    this.foregroundColor = const Color(0xff696DFF),
    this.stoptime,
    this.onPressed,
    this.ischecked = true,
  });
  @override
  State<AlarmSettingButton> createState() => _AlarmSettingButtonState();
}

class _AlarmSettingButtonState extends State<AlarmSettingButton> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 5,
      padding: const EdgeInsets.all(20),
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      textStyle: const TextStyle(fontSize: 22),
      fixedSize: Size(
        UIhelper.scaleWidth(context) * 368,
        UIhelper.scaleHeight(context) * 80,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    return ElevatedButton(
      style: style,
      onPressed: widget.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              widget.label,
            ],
          ),
          const Column(
            children: [
              Text('스위치 들어갈 자리'),
            ],
          ),
        ],
      ),
    );
  }
}

class MyPlaceButton extends StatefulWidget {
  final String placeName, icon, addressName;
  final int myPlaceId;
  final double placeLatitude, placeLongitude;

  final Color backgroundColor, foregroundColor;
  final VoidCallback onPlaceUpdate;

  const MyPlaceButton({
    super.key,
    required this.placeName,
    this.backgroundColor = const Color(0xff696DFF),
    this.foregroundColor = Colors.white,
    required this.icon,
    required this.addressName,
    required this.myPlaceId,
    required this.placeLatitude,
    required this.placeLongitude,
    required this.onPlaceUpdate,
  });
  @override
  State<MyPlaceButton> createState() => _MyPlaceButtonState();
}

class _MyPlaceButtonState extends State<MyPlaceButton> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaceDetail(
              placeName: widget.placeName,
              icon: widget.icon,
              myPlaceId: widget.myPlaceId,
              addressName: widget.addressName,
              placeLatitude: widget.placeLatitude,
              placeLongitude: widget.placeLongitude,
              onPlaceUpdate: widget.onPlaceUpdate,
            ),
          ),
        );
      },
      child: Container(
        width: UIhelper.scaleWidth(context) * 368,
        height: UIhelper.scaleHeight(context) * 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            deviceWidth * 0.05,
            deviceHeight * 0.00,
            deviceWidth * 0.00,
            deviceHeight * 0.00,
          ),
          child: Row(
            children: [
              Image.asset(
                widget.icon,
                height: UIhelper.scaleWidth(context) * 50,
              ),
              SizedBox(
                width: UIhelper.scaleWidth(context) * 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.placeName,
                      style: const TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 때 ...으로 표시
                      maxLines: 1, // 최대 표시 줄 수를 1로 설정
                    ),
                    SizedBox(height: UIhelper.scaleHeight(context) * 5),
                    Text(
                      widget.addressName,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 때 ...으로 표시
                      maxLines: 1, // 최대 표시 줄 수를 1로 설정
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlaceDetail(
                        placeName: widget.placeName,
                        icon: widget.icon,
                        myPlaceId: widget.myPlaceId,
                        addressName: widget.addressName,
                        placeLatitude: widget.placeLatitude,
                        placeLongitude: widget.placeLongitude,
                        onPlaceUpdate: widget.onPlaceUpdate,
                      ),
                    ),
                  );
                },
                child: const Align(
                  // TextButton을 Align으로 감싸줍니다.
                  alignment: Alignment.center, // 세로 방향 가운데 정렬
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
