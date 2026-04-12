import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../constants/api_constants.dart';
import '../widgets/main_background.dart'; // <-- Imported our custom background

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final posterUrl = movie.posterPath.isNotEmpty
        ? '${ApiConstants.tmdbImageBaseUrl}${movie.posterPath}'
        : null;

    // 1. Wrapped the entire screen in our Custom Cinematic Glow
    return MainBackground(
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // <-- Made transparent so the glow shows
        body: CustomScrollView(
          slivers: [
            // Parallax Cinematic Poster
            SliverAppBar(
              expandedHeight: 550.0,
              pinned: true,
              backgroundColor: Colors.transparent, // <-- Made transparent
              elevation: 0,
              iconTheme: const IconThemeData(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // The Hero Image
                    if (posterUrl != null)
                      Hero(
                        tag: 'poster_${movie.id}',
                        child: CachedNetworkImage(
                          imageUrl: posterUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white38,
                              size: 50,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(color: const Color(0xFF2C2C2C)),

                    // Triple-stop Gradient for smooth blending and back-button visibility
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black54, // Dark at top for the back arrow
                            Colors.transparent,
                            Color(
                              0xFF131313,
                            ), // Blends smoothly into the MainBackground
                          ],
                          stops: [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // The Content Body
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      movie.title
                          .toUpperCase(), // <-- Uppercase for cinematic feel
                      style: const TextStyle(
                        fontFamily: 'Montserrat', // <-- Added our premium font
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE5E2E1),
                        letterSpacing: 1.2,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Meta Data Chips (Date & Rating)
                    Row(
                      children: [
                        _buildMetaChip(Icons.calendar_today, movie.releaseDate),
                        const SizedBox(width: 12),
                        _buildMetaChip(
                          Icons.star_rounded,
                          movie.voteAverage.toStringAsFixed(1),
                          iconColor: const Color(0xFFFFD700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Storyline Header
                    const Text(
                      'STORYLINE',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                        color: Color(0xFFE50914), // Cinematic Red
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Overview Text
                    Text(
                      movie.overview,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    ), // Extra padding so the FAB doesn't cover text
                  ],
                ),
              ),
            ),
          ],
        ),

        // Floating Action Button
        floatingActionButton: Consumer<MovieProvider>(
          builder: (context, provider, child) {
            final isFav = provider.isFavorite(movie);
            return FloatingActionButton(
              backgroundColor: isFav
                  ? const Color(0xFF353534)
                  : const Color(0xFFE50914),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? const Color(0xFFE50914) : Colors.white,
                size: 28,
              ),
              onPressed: () {
                provider.toggleFavorite(movie);

                // Premium SnackBar Notification
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          isFav ? Icons.heart_broken : Icons.favorite,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isFav ? 'Removed from Vault' : 'Added to Vault',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFFE50914).withOpacity(0.9),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 24,
                      left: 24,
                      right: 24,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Helper widget to build the glassmorphic info chips
  Widget _buildMetaChip(
    IconData icon,
    String label, {
    Color iconColor = Colors.white54,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF353534).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE5E2E1),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
