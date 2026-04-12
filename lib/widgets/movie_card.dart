import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../screens/movie_details_screen.dart';
import '../constants/api_constants.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final posterUrl = movie.posterPath.isNotEmpty
        ? '${ApiConstants.tmdbImageBaseUrl}${movie.posterPath}'
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. The Full-Bleed Image
              if (posterUrl != null)
                Hero(
                  tag: 'poster_${movie.id}',
                  child: CachedNetworkImage(
                    imageUrl: posterUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF1C1B1B),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE50914),
                        ), // Cinematic Red
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF1C1B1B),
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white38,
                        size: 40,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  color: const Color(0xFF1C1B1B),
                  child: const Icon(
                    Icons.movie_creation_outlined,
                    color: Colors.white38,
                    size: 40,
                  ),
                ),

              // 2. The Obsidian Gradient Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 100, // Taller gradient for smoother fade
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFF131313), // Solid Obsidian at the very bottom
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 3. The Floating Text
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title
                          .toUpperCase(), // Uppercase fits the cinematic vibe better
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFFE5E2E1),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFD700),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
