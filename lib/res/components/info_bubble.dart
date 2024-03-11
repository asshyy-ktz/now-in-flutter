import 'dart:async';

import 'package:flutter/material.dart';
import 'package:now_in_flutter/res/components/extensions.dart';

void showInfoBubble(
  String title,
  String description,
  GlobalKey focusAbleWidgetKey,
  Color bgColor, {
  double bubbleWidth = 300.0,
  double bubblePadding = 32.0,
  double bubbleTipWidth = 22.0,
  double bubbleTipHeight = 12.0,
}) {
  showDialog(
    context: focusAbleWidgetKey.currentContext!,
    builder: (BuildContext context) {
      return _InfoBubbleDialogWidget(
        title,
        description,
        focusAbleWidgetKey,
        bgColor,
        bubbleWidth: bubbleWidth,
        bubblePadding: bubblePadding,
        bubbleTipWidth: bubbleTipWidth,
        bubbleTipHeight: bubbleTipHeight,
      );
    },
  );
}

class _InfoBubbleDialogWidget extends StatefulWidget {
  final String title;
  final String description;
  final GlobalKey focusAbleWidgetKey;
  final Color bgColor;
  final double bubbleWidth;
  final double bubblePadding;
  final double bubbleTipWidth;
  final double bubbleTipHeight;

  const _InfoBubbleDialogWidget(
    this.title,
    this.description,
    this.focusAbleWidgetKey,
    this.bgColor, {
    super.key,
    required this.bubbleWidth,
    required this.bubblePadding,
    required this.bubbleTipWidth,
    required this.bubbleTipHeight,
  });

  @override
  State<_InfoBubbleDialogWidget> createState() => _InfoBubbleDialogWidgetState();
}

class _InfoBubbleDialogWidgetState extends State<_InfoBubbleDialogWidget> {
  double bubbleTipLeftPadding = 0.0;
  double? leftPosition;
  double? rightPosition;
  double? topPosition;
  double? bottomPosition;
  Rect? widgetConstraints;
  late bool showBubbleAboveWidget;
  late bool showBubbleLeftWidget;
  late double bubbleTipHalfWidth;
  var animationTopHeight = 0.0;
  var animationBottomHeight = 0.0;
  final animationDuration = const Duration(milliseconds: 900);
  final animationVerticalMotionHeight = 4.0;
  Timer? animationTimer;

  double get screenWidth =>  MediaQuery.of(widget.focusAbleWidgetKey.currentContext!).size.width;

  double get screenHeight =>  MediaQuery.of(widget.focusAbleWidgetKey.currentContext!).size.height;

  animateBubble() {
    if (animationTopHeight == 0) {
      animationTopHeight = animationVerticalMotionHeight;
      animationBottomHeight = animationVerticalMotionHeight;
    } else {
      animationTopHeight = 0;
      animationBottomHeight = 0;
    }
    setState(() {});
  }
  
  initBubblePosition() {
    widgetConstraints = widget.focusAbleWidgetKey.globalPaintBounds;
    var bubbleTipHalfWidth = widget.bubbleTipWidth / 2;
    var screenYCenter = screenHeight / 2;
    var screenXCenter = screenWidth / 2;
    var widgetLeft = widgetConstraints?.left ?? 0;
    var widgetTop = widgetConstraints?.top ?? 0;
    var widgetRight = widgetConstraints?.right ?? 0;
    var widgetCenterX = widgetLeft + ((widgetRight - widgetLeft) / 2);

    showBubbleAboveWidget = widgetTop > screenYCenter;
    showBubbleLeftWidget = widgetLeft < screenXCenter;

    if (showBubbleLeftWidget) {
      leftPosition = widget.bubblePadding;
    } else {
      rightPosition = widget.bubblePadding;
    }

    if (showBubbleAboveWidget) {
      bottomPosition = screenHeight - widgetTop;
    } else {
      topPosition = widgetTop;
    }

    if (showBubbleLeftWidget) {
      bubbleTipLeftPadding =
          widgetCenterX - widget.bubblePadding - bubbleTipHalfWidth;

      ///If widget is very close to screen.
      if (bubbleTipLeftPadding < 0) bubbleTipLeftPadding = 0;
    } else {
      var widgetLeft = screenWidth - widget.bubbleWidth - widget.bubblePadding;
      bubbleTipLeftPadding = widgetCenterX - widgetLeft - bubbleTipHalfWidth;

      ///If widget is very close to screen.
      if (bubbleTipLeftPadding > widget.bubbleWidth - widget.bubbleTipWidth) {
        bubbleTipLeftPadding = widget.bubbleWidth - widget.bubbleTipWidth;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initBubblePosition();

    ///Initialize animation
    Future.delayed(const Duration(milliseconds: 100)).then(
      (value) => animateBubble(),
    );
      
    animationTimer = Timer.periodic(animationDuration, (_) => animateBubble());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: animationDuration,
          left: leftPosition,
          right: rightPosition,
          top: topPosition != null ? topPosition! + animationTopHeight : null,
          bottom: bottomPosition != null
              ? bottomPosition! + animationBottomHeight
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!showBubbleAboveWidget)
                Padding(
                  padding: EdgeInsets.only(left: bubbleTipLeftPadding),
                  child: CustomPaint(
                    painter: TrianglePainter(
                      strokeColor: widget.bgColor,
                      strokeWidth: 10,
                      paintingStyle: PaintingStyle.fill,
                    ),
                    child: SizedBox(
                      height: widget.bubbleTipHeight,
                      width: widget.bubbleTipWidth,
                    ),
                  ),
                ),
              Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: widget.bubbleWidth,
                  decoration: BoxDecoration(
                    color: widget.bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(widget.description),
                    ],
                  ),
                ),
              ),
              if (showBubbleAboveWidget)
                Padding(
                  padding: EdgeInsets.only(left: bubbleTipLeftPadding),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: CustomPaint(
                      painter: TrianglePainter(
                        strokeColor: widget.bgColor,
                        strokeWidth: 10,
                        paintingStyle: PaintingStyle.fill,
                      ),
                      child: SizedBox(
                        height: widget.bubbleTipHeight,
                        width: widget.bubbleTipWidth,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    animationTimer?.cancel();
    super.dispose();
  }
}








class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}