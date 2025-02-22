import 'package:flutter/material.dart';

class MyTooltip extends StatelessWidget {
  const MyTooltip({required this.message, required this.child, super.key});

  final Widget child;
  final String message;

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      // use shape decoration for tooltip border
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: TooltipBorder(arrowArc: 0.1),
      ),
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 10,
      ),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      message: message,
      verticalOffset: 25,
      waitDuration: const Duration(seconds: 10),
      // to show tooltip on click
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}

// create border tooltip
class TooltipBorder extends ShapeBorder {
  const TooltipBorder({
    this.radius = 6.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;

    return Path()
      ..moveTo(rect.topCenter.dx + x / 2, rect.topCenter.dy - x + 25 / 1.25)
      ..relativeLineTo(-x / 2 * r, -y * r)
      ..relativeQuadraticBezierTo(-x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(-x / 2 * r, y * r);
  }

// set stroke color
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas
      ..drawPath(getOuterPath(rect), paint)
      ..clipPath(getOuterPath(rect));
  }

  @override
  ShapeBorder scale(double t) => this;
}
