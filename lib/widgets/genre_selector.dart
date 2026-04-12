import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class GenreSelector extends StatelessWidget {
  const GenreSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        // If genres haven't loaded from the API yet, just return an empty box
        if (provider.genres.isEmpty) {
          return const SizedBox(height: 40);
        }

        // We create a custom list that injects "Trending" as the first option (ID: null)
        final List<Map<String, dynamic>> genreOptions = [
          {'id': null, 'name': 'Trending'},
          ...provider.genres.map((g) => {'id': g['id'], 'name': g['name']}),
        ];

        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ), // Matches our screen padding
            itemCount: genreOptions.length,
            itemBuilder: (context, index) {
              final genre = genreOptions[index];
              final isSelected = provider.selectedGenreId == genre['id'];

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    // Only trigger a network request if they tap a NEW genre
                    if (provider.selectedGenreId != genre['id']) {
                      provider.selectGenre(genre['id']);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE50914) // Cinematic Red
                          : const Color(
                              0xFF353534,
                            ).withOpacity(0.6), // Glassmorphic Dark
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: const Color(0xFFE50914))
                          : Border.all(color: Colors.white.withOpacity(0.05)),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFE50914).withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        genre['name'].toString().toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w900
                              : FontWeight.bold,
                          letterSpacing: 1.0,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFE5E2E1),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
