import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class NavigationCompass extends StatefulWidget {
  final double bearing;

  const NavigationCompass({super.key, required this.bearing});

  @override
  State<NavigationCompass> createState() => _NavigationCompassState();
}

class _NavigationCompassState extends State<NavigationCompass> {
  late final NavigationCompassGame _game;

  @override
  void initState() {
    super.initState();
    _game = NavigationCompassGame(initialBearing: widget.bearing);
  }

  @override
  void didUpdateWidget(covariant NavigationCompass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bearing != widget.bearing) {
      _game.updateBearing(widget.bearing);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: GameWidget(game: _game));
  }
}

class NavigationCompassGame extends FlameGame {
  NavigationCompassGame({double initialBearing = 0})
    : _bearingRadians = _toRadians(initialBearing),
      _arrow = CompassArrowComponent();

  static double _toRadians(double degrees) =>
      (degrees % 360) * math.pi / 180;

  double _bearingRadians;
  final CompassArrowComponent _arrow;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    _arrow.setBearingRadians(_bearingRadians);
    add(_arrow);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final radius = math.min(size.x, size.y) * 0.42;
    _arrow.position = size / 2;
    _arrow.size = Vector2.all(radius * 2);
  }

  void updateBearing(double bearingDegrees) {
    _bearingRadians = _toRadians(bearingDegrees);
    _arrow.setBearingRadians(_bearingRadians);
  }
}

class CompassArrowComponent extends PositionComponent {
  CompassArrowComponent() : super(anchor: Anchor.center);

  final Paint _dottedRingPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3
    ..color = const Color(0xFFD0D6E0);

  final Paint _arrowPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  final Paint _outerRingPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = const Color(0xFFE6ECF4);

  double _bearingRadians = 0;

  void setBearingRadians(double radians) {
    _bearingRadians = radians;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final center = size / 2;
    final radius = math.min(size.x, size.y) / 2;
    final dottedRadius = radius * 0.95;
    final ringRadius = radius * 0.82;
    final coreRadius = radius * 0.6;

    _drawDottedRing(canvas, center, dottedRadius);
    canvas.drawCircle(Offset(center.x, center.y), ringRadius, _outerRingPaint);

    final gradient = ui.Gradient.radial(
      Offset(center.x, center.y),
      coreRadius,
      [
        const Color(0xFF0D5CD6),
        const Color(0xFF0A3B8F),
      ],
      [0.0, 1.0],
    );
    final corePaint = Paint()..shader = gradient;
    canvas.drawCircle(Offset(center.x, center.y), coreRadius, corePaint);

    canvas.save();
    canvas.translate(center.x, center.y);
    canvas.rotate(_bearingRadians);

    final arrowLength = coreRadius * 0.75;
    final arrowWidth = coreRadius * 0.45;

    final path = Path()
      ..moveTo(0, -arrowLength)
      ..lineTo(arrowWidth / 2, arrowLength * 0.2)
      ..lineTo(0, arrowLength * 0.45)
      ..lineTo(-arrowWidth / 2, arrowLength * 0.2)
      ..close();

    canvas.drawPath(path, _arrowPaint);
    canvas.restore();
  }

  void _drawDottedRing(Canvas canvas, Vector2 center, double radius) {
    const segments = 42;
    final sweep = (2 * math.pi) / segments;
    const gapFactor = 0.55;
    final rect = Rect.fromCircle(
      center: Offset(center.x, center.y),
      radius: radius,
    );

    for (var i = 0; i < segments; i++) {
      final start = i * sweep;
      final sweepAngle = sweep * gapFactor;
      canvas.drawArc(rect, start, sweepAngle, false, _dottedRingPaint);
    }
  }
}
