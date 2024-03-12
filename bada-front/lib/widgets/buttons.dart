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
      fixedSize: const Size(180, 120),
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
                        width: widget.imageWidth,
                        height: widget.imageHeight,
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
      fixedSize: const Size(368, 150),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    return ElevatedButton(
      style: style,
      onPressed: () {},
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
              const SizedBox(height: 10),
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
                        width: 120,
                        height: 120,
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
      fixedSize: const Size(368, 80),
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

  const Button281_77({
    super.key,
    required this.label,
    this.backgroundColor = const Color(0xff696DFF),
    this.foregroundColor = Colors.white,
    this.navigateTo,
    this.onPressed,
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
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      textStyle: const TextStyle(fontSize: 16),
      fixedSize: const Size(130, 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    return ElevatedButton(
      style: style,
      onPressed: widget.onPressed,
      child: widget.label,
    );
  }
}
