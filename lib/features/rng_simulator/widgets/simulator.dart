import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:osrs_rng/features/rng_simulator/rng_simulator.dart';

class Simulator extends StatefulWidget {
  const Simulator({
    super.key,
    required this.numerator,
    required this.denominator,
  });

  final int? numerator, denominator;

  @override
  State<Simulator> createState() => _SimulatorState();
}

class _SimulatorState extends State<Simulator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  var _primaryDepths = <int>[], _secondaryDepths = <int>[];

  int get _attempts =>
      _primaryDepths.fold(0, (t, v) => t += v) +
      _secondaryDepths.fold(0, (t, v) => t += v);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: 1.seconds,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant Simulator oldWidget) {
    super.didUpdateWidget(oldWidget);
    final n = widget.numerator, d = widget.denominator;
    if (n != null && d != null && 0 < n && n < d) {
      _controller
        ..reset()
        ..forward();
      final depths = simulate(
        numerator: n,
        denominator: d,
      );
      _primaryDepths = depths.sublist(0, n);
      _secondaryDepths = depths.sublist(n);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.primary,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: PaintDripVisualizer(
                    progress: _controller.value,
                    primaryColor: Colors.green,
                    secondaryColor: Colors.red,
                    primaryDepths: _primaryDepths,
                    secondaryDepths: _secondaryDepths,
                  ),
                );
              },
            ),
          ),
          if (!_attempts.isNaN &&
              widget.numerator != null &&
              widget.denominator != null)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  'You took $_attempts attempts at a ${widget.numerator}/${widget.denominator} drop.',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
