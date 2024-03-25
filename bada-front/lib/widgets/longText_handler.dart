import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class OptionalScrollingText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const OptionalScrollingText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  State<OptionalScrollingText> createState() => _OptionalScrollingTextState();
}

class _OptionalScrollingTextState extends State<OptionalScrollingText> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return FutureBuilder(
          future: _calculateTextWidth(widget.text, widget.style),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final textWidth = snapshot.data as double;
              final shouldScroll = textWidth > constraints.maxWidth;

              return shouldScroll
                  ? _buildMarquee(textWidth)
                  : _buildStaticText();
            } else {
              return _buildStaticText(); // Default to static text while calculating
            }
          },
        );
      },
    );
  }

  Widget _buildMarquee(double textWidth) {
    return Marquee(
      text: widget.text,
      style: widget.style,
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 20.0,
      velocity: 80.0,
      pauseAfterRound: const Duration(seconds: 1),
      showFadingOnlyWhenScrolling: true,
      fadingEdgeStartFraction: 0.1,
      fadingEdgeEndFraction: 0.1,
    );
  }

  Widget _buildStaticText() {
    return Text(
      widget.text,
      style: widget.style,
    );
  }

  Future<double> _calculateTextWidth(String text, TextStyle? style) async {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width;
  }
}
