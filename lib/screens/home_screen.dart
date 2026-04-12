import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/movie_provider.dart';
import '../screens/explore_screen.dart'; // <-- Imported Explore
import '../screens/favorites_screen.dart';
import '../screens/profile_screen.dart'; // <-- Imported Profile
import '../widgets/movie_card.dart';
import '../widgets/main_background.dart';
import '../widgets/movie_holic_logo.dart';
import '../constants/api_constants.dart';
import '../widgets/glass_bottom_nav.dart';
import '../widgets/genre_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TAB 1: EXPLORE (Search)
    if (_currentIndex == 1) {
      return MainBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: const ExploreScreen(),
          extendBody: true,
          bottomNavigationBar: GlassBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        ),
      );
    }

    // TAB 2: VAULT (Favorites)
    if (_currentIndex == 2) {
      return MainBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: const FavoritesScreen(),
          extendBody: true,
          bottomNavigationBar: GlassBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        ),
      );
    }

    // TAB 3: PROFILE (Settings & Logout)
    if (_currentIndex == 3) {
      return MainBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: const ProfileScreen(),
          extendBody: true,
          bottomNavigationBar: GlassBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        ),
      );
    }

    // TAB 0: HOME (Purely Trending & Genres now!)
    return MainBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: Consumer<MovieProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingTrending && provider.trendingMovies.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              );
            }

            // Separate the first movie for the Hero header
            final heroMovie = provider.trendingMovies.isNotEmpty
                ? provider.trendingMovies.first
                : null;

            final gridMovies = provider.trendingMovies.isNotEmpty
                ? provider.trendingMovies.sublist(1)
                : [];

            return CustomScrollView(
              slivers: [
                // 1. Cinematic Hero Header OR Standard Logo Header
                if (heroMovie != null)
                  SliverAppBar(
                    expandedHeight: 500.0,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(
                        left: 24,
                        bottom: 16,
                        right: 24,
                      ),
                      title: Text(
                        heroMovie.title.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                '${ApiConstants.tmdbImageBaseUrl}${heroMovie.posterPath}',
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Color(0xFF131313)],
                                stops: [0.3, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    title: Row(
                      children: [
                        MovieHolicLogo(size: 32),
                        SizedBox(width: 12),
                        Text(
                          'MOVIEHOLIC',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFFE50914),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                // 2. Modular Genre Selector
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: GenreSelector(),
                  ),
                ),

                // 3. The Grid Content
                if (gridMovies.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No movies found.',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 8,
                      bottom:
                          100, // Bottom padding to prevent the nav bar from covering the last row
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return MovieCard(movie: gridMovies[index]);
                      }, childCount: gridMovies.length),
                    ),
                  ),
              ],
            );
          },
        ),

        // Modular Glass Navigation
        bottomNavigationBar: GlassBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
