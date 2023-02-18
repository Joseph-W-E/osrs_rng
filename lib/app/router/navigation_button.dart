import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class Destination {
  final String route;
  final String name;

  const Destination({
    required this.route,
    required this.name,
  });
}

class NavigationButton extends StatefulWidget {
  const NavigationButton({
    super.key,
    required this.destinations,
  });

  final List<Destination> destinations;

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton>
    with SingleTickerProviderStateMixin {
  var _isShowing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Menu(
          destinations: widget.destinations,
          onDestinationSelected: (destination) {
            context.go(destination.route);
            setState(() => _isShowing = false);
          },
        )
            .animate(
              target: _isShowing ? 1 : 0,
            )
            .slideY(
              duration: 0.1.seconds,
              begin: 0.5,
              end: 0,
            )
            .scale(
              duration: 0.1.seconds,
            )
            .then()
            .shake(
              duration: 0.1.seconds,
            ),
        const SizedBox(height: 16),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => setState(() => _isShowing = !_isShowing),
        ).animate().shake(),
      ],
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({
    required this.destinations,
    required this.onDestinationSelected,
  });

  final List<Destination> destinations;
  final void Function(Destination) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 200,
        maxHeight: 200,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: TextButton(
              onPressed: () => onDestinationSelected(destinations[i]),
              child: Text(destinations[i].name),
            ),
          );
        },
        itemCount: destinations.length,
      ),
    );
  }
}
