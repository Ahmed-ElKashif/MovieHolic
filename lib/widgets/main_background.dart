import 'package:flutter/material.dart';

class MainBackground extends StatelessWidget {
  final Widget child;

  const MainBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF131313), // Base Obsidian Black
        gradient: RadialGradient(
          center: Alignment(0.8, -0.8), // Positions the glow in the top right
          radius: 1.5,
          colors: [
            Color(
              0x15E50914,
            ), // Very faint Cinematic Red glow (approx 8% opacity)
            Color(0xFF131313), // Fades smoothly into the solid obsidian
          ],
          stops: [0.0, 1.0],
        ),
      ),
      // SafeArea ensures UI doesn't overlap with phone notches or status bars
      child: SafeArea(
        bottom: false, // Let the bottom nav blur over the edge
        child: child,
      ),
    );
  }
}
