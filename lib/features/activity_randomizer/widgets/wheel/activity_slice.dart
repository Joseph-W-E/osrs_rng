import 'package:flutter/material.dart';
import 'package:osrs_rng/features/activity_randomizer/activity_randomizer.dart';

class ActivitySlice extends StatelessWidget {
  const ActivitySlice({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final assetPath = activity.assetPath;

    return Card(
      child: assetPath == null
          ? Text(
              activity.name,
              style: Theme.of(context).textTheme.displayMedium,
            )
          : Image.asset(
              assetPath,
              fit: BoxFit.contain,
            ),
    );
  }
}
