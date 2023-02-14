import 'dart:math';

import 'package:flutter/material.dart';

class PaintDripVisualizer extends CustomPainter {
  const PaintDripVisualizer({
    required this.progress,
    required this.primaryDepths,
    required this.secondaryDepths,
    required this.primaryColor,
    required this.secondaryColor,
  }) : assert(0 <= progress && progress <= 1);

  final double progress;
  final List<int> primaryDepths, secondaryDepths;
  final Color primaryColor, secondaryColor;

  int get _length => primaryDepths.length + secondaryDepths.length;

  int get _maxDepth => max(primaryDepths.maxDepth, secondaryDepths.maxDepth);

  @override
  void paint(Canvas canvas, Size size) {
    if (_length == 0) return;

    const strokeWidth = 1.0;

    final primaryPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = strokeWidth;
    final secondaryPaint = Paint()
      ..color = secondaryColor
      ..strokeWidth = strokeWidth;

    final dripWidth = size.width / _length;
    final dripSegmentLength = size.height / _maxDepth;

    final end = (progress * _length).ceil();
    final remainder = (progress * _length) - (progress * _length).floor();

    for (var i = 0; i < end; i++) {
      final depth = i < primaryDepths.length
          ? primaryDepths[i]
          : secondaryDepths[i - primaryDepths.length];
      final x = i * dripWidth + dripWidth / 2 + strokeWidth / 2;
      var y = depth * dripSegmentLength;
      if (i == end - 1 && remainder > 0) {
        y = y * remainder;
      }
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, y),
        i < primaryDepths.length ? primaryPaint : secondaryPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension on List<int> {
  int get maxDepth => fold(0, max);
}
