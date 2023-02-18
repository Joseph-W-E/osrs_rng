import 'package:flutter/material.dart';
import 'package:osrs_rng/features/rng_simulator/rng_simulator.dart';

class RngSimulatorPage extends StatefulWidget {
  const RngSimulatorPage({super.key});

  @override
  State<RngSimulatorPage> createState() => _RngSimulatorPageState();
}

class _RngSimulatorPageState extends State<RngSimulatorPage> {
  final _fraction = TextEditingController();
  var _percentage = 0.0;

  @override
  void initState() {
    super.initState();
    _fraction.addListener(
      () {
        final ints = _fraction.text.split('/').map(int.tryParse);
        var percentage = 0.0;
        if (ints.length == 2 && ints.every((i) => i != null)) {
          percentage = (ints.first! / ints.last!).abs();
        }
        if (_percentage != percentage) {
          setState(() => _percentage = percentage);
        }
      },
    );
  }

  @override
  void dispose() {
    _fraction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Curious how drop rates work?',
              ),
              const SizedBox(height: 4),
              const Text(
                'Insert a drop rate to simulate an attempt at getting it.',
              ),
              const SizedBox(height: 4),
              const Text(
                'The left-most line(s) is a successful drop, while the others are misses.',
              ),
              TextField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: InputDecoration(
                  label: Text('X/Y ($_percentage%)'),
                ),
                controller: _fraction,
              ),
              const SizedBox(height: 12),
              Simulator(
                numerator: _numerator,
                denominator: _denominator,
              ),
              const SizedBox(height: 12),
              TextButton(
                // An empty setState causes the simulator to regenerate.
                onPressed: () => setState(() {}),
                child: const Text('Run'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int? get _numerator {
    final paths = _fraction.text.split('/');
    if (paths.length != 2) return null;
    final first = int.tryParse(paths.first);
    if (first == null || first <= 0) return null;
    return first;
  }

  int? get _denominator {
    final paths = _fraction.text.split('/');
    if (paths.length != 2) return null;
    final last = int.tryParse(paths.last);
    if (last == null || last <= 0) return null;
    return last;
  }
}
