import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_holic_logo.dart'; // <-- Imported our custom logo

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        return CustomScrollView(
          slivers: [
            // Cinematic App Bar
            SliverAppBar(
              pinned: true,
              backgroundColor:
                  Colors.transparent, // <-- Made transparent for the glow
              elevation: 0,
              title: Row(
                children: [
                  const MovieHolicLogo(size: 32), // <-- Added our custom logo
                  const SizedBox(width: 12),
                  const Text(
                    'MY VAULT',
                    style: TextStyle(
                      fontFamily: 'Montserrat', // <-- Added premium typography
                      color: Color(0xFFE50914), // Cinematic Red
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3.0,
                    ),
                  ),
                ],
              ),
              centerTitle: false,
            ),

            // Condition: Empty State vs Grid
            if (provider.favoriteMovies.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(),
              )
            else
              SliverPadding(
                // Bottom padding of 100 ensures the floating nav bar doesn't cover the last row
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: 100,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return MovieCard(movie: provider.favoriteMovies[index]);
                  }, childCount: provider.favoriteMovies.length),
                ),
              ),
          ],
        );
      },
    );
  }

  // Premium Empty State Design
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing Icon Container
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF353534).withOpacity(0.4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE50914).withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.movie_filter_outlined,
              size: 64,
              color: Color(0xFFE50914),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "YOUR VAULT IS EMPTY",
            style: TextStyle(
              fontFamily: 'Montserrat', // <-- Added premium typography
              color: Color(0xFFE5E2E1),
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Explore the cinematic universe\nand save your masterpieces here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}
