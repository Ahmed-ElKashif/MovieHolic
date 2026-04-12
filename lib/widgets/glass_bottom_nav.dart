import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // The Positioned wrapper has been entirely removed to fix the layout crash.
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 80,
          color: const Color(0xFF353534).withOpacity(0.6),
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(icon: Icons.home_filled, label: 'Home', index: 0),
              _buildNavItem(icon: Icons.search, label: 'Explore', index: 1),
              _buildNavItem(icon: Icons.favorite, label: 'Vault', index: 2),
              _buildNavItem(icon: Icons.person, label: 'Profile', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        color: Colors.transparent, // Expands hit area for fat thumbs
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFFE50914) // Cinematic Red
                  : const Color(0xFFE5E2E1).withOpacity(0.6),
              size: isSelected ? 28 : 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? const Color(0xFFE50914)
                    : const Color(0xFFE5E2E1).withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
