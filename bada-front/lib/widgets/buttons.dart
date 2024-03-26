import 'package:bada/screens/main/my_place/my_place_detail.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';

class Button330_220 extends StatefulWidget {
  final String label;
  final Color backgroundColor, foregroundColor;
  final Widget? buttonImage;
  final double imageWidth, imageHeight, padRight, padBottom;
  final void Function()? onPressed;

  const Button330_220({
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
  State<Button330_220> createState() => _Button330_220State();
}

class _Button330_220State extends State<Button330_220> {
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
        UIhelper.scaleWidth(context) * 180,
        UIhelper.scaleHeight(context) * 120,
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

class Button714_300 extends StatefulWidget {
  final String label; // Add a parameter to accept text
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? buttonImage;
  final double imageWidth;
  final double imageHeight;
  final double padRight;
  final double padBottom;
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
        UIhelper.scaleHeight(context) * 150,
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
              const Text(
                'CCTV가 많은 길로 아이가 다닐 수 있도록',
                style: TextStyle(fontSize: 10),
              ),
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
        UIhelper.scaleWidth(context) * 130,
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
    return InkWell(
      onTap: () {},
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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: [
              Image.asset(
                widget.icon,
                height: UIhelper.scaleWidth(context) * 50,
              ),
              SizedBox(
                width: UIhelper.scaleWidth(context) * 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('이름: ${widget.placeName}'),
                    const Text('주소: 대전광역시 유성구 덕명로 26'),
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
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
