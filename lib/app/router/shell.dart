import 'package:flutter/material.dart';
import 'package:osrs_rng/app/router.dart';

class Shell extends StatefulWidget {
  const Shell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  static const _destinations = [
    Destination(
      route: Routes.activityRandomizer,
      name: 'Activity Randomizer',
    ),
    Destination(
      route: Routes.rngSimulator,
      name: 'Drop Simulator',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: widget.child,
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: NavigationButton(
                  destinations: _destinations,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
