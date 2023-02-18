import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:osrs_rng/features/activity_randomizer/activity_randomizer.dart';

class ActivityRandomizer extends StatefulWidget {
  const ActivityRandomizer({
    super.key,
    required this.activities,
    required this.onLeave,
  });

  final List<Activity> activities;
  final void Function() onLeave;

  @override
  State<ActivityRandomizer> createState() => _ActivityRandomizerState();
}

class _ActivityRandomizerState extends State<ActivityRandomizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  var _chosenIndex = 0;
  var _animationTarget = 0.0;

  int get _totalWeights => widget.activities.fold(0, (w, a) => w + a.weight);

  int get _maxWeight => widget.activities.map((a) => a.weight).fold(0, max);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Stack(
              children: [
                for (var i = 0; i < widget.activities.length; i++)
                  _AnimatedContainer(
                    animationController: _controller,
                    animationTarget: _animationTarget,
                    radians: 2 * pi * i / widget.activities.length,
                    child: _AnimatedCard(
                      animationController: _controller,
                      animationTarget: _animationTarget,
                      activity: widget.activities[i],
                      scale: _getNormalizedScale(i),
                      isTheChosenOne: i == _chosenIndex,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onLeave,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => setState(
                  () {
                    _controller
                      ..reset()
                      ..forward();
                    _chosenIndex = _getWeightedRandom();
                    _animationTarget = 1.0;
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  int _getWeightedRandom() {
    var rng = Random().nextInt(_totalWeights) + 1;
    for (var i = 0; i < widget.activities.length; i++) {
      rng -= widget.activities[i].weight;
      if (rng <= 0) return i;
    }
    return 0;
  }

  double _getNormalizedScale(int index) {
    final percent = widget.activities[index].weight / _maxWeight;
    return 0.5 + 0.5 * percent;
  }
}

class _AnimatedContainer extends StatelessWidget {
  const _AnimatedContainer({
    required this.animationController,
    required this.animationTarget,
    required this.radians,
    required this.child,
  });

  final AnimationController animationController;
  final double animationTarget;
  final double radians;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final diameter = MediaQuery.of(context).size.shortestSide / 4;
    return Container(
      alignment: Alignment.center,
      child: child,
    )
        .animate(
          controller: animationController,
          target: animationTarget,
        )
        .move(
          duration: 0.1.seconds,
          curve: Curves.easeOut,
          begin: Offset.zero,
          end: Offset(
            diameter * cos(radians),
            diameter * sin(radians),
          ),
        );
  }
}

class _AnimatedCard extends StatelessWidget {
  const _AnimatedCard({
    required this.animationController,
    required this.animationTarget,
    required this.activity,
    required this.scale,
    required this.isTheChosenOne,
  });

  final AnimationController animationController;
  final double animationTarget;
  final Activity activity;
  final double scale;
  final bool isTheChosenOne;

  @override
  Widget build(BuildContext context) {
    final assetPath = activity.assetPath;

    final width = min(MediaQuery.of(context).size.width, 200.0) * scale;

    final card = Card(
      child: Container(
        width: width,
        height: width / 2,
        padding: const EdgeInsets.all(8),
        child: assetPath == null
            ? Text(
                activity.name,
                style: Theme.of(context).textTheme.titleMedium,
              )
            : Image.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
      ),
    )
        .animate(
          controller: animationController,
          target: animationTarget,
        )
        .shake(
          delay: 0.25.seconds + Random().nextInt(250).milliseconds,
          duration: 2.seconds,
        )
        .then();

    if (isTheChosenOne) {
    } else {
      card.scale(
        duration: 1.seconds,
        curve: Curves.easeOut,
        begin: const Offset(1, 1),
        end: Offset.zero,
      );
    }

    return card;
  }
}
