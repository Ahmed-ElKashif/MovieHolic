import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Needed for our seeding script
import '../providers/movie_provider.dart';
import '../services/tmdb_service.dart'; // <-- Needed to fetch the initial data
import '../models/movie.dart'; // <-- Needed for the movie model
import '../screens/explore_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/profile_screen.dart';
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
  bool _isSeeding = false; // Tracks if the upload is currently running

  // =====================================================================
  // THE ONE-TIME SEEDING SCRIPT (WE WILL DELETE THIS LATER)
  // =====================================================================
  Future<void> _seedDatabaseToFirestore() async {
    setState(() => _isSeeding = true);

    try {
      final tmdb = TmdbService();
      final firestore = FirebaseFirestore.instance;

      // 1. Fetch movies from a few different endpoints to get a big, diverse list
      final trending = await tmdb.fetchTrendingMovies();
      final action = await tmdb.fetchMoviesByGenre(28); // 28 is Action
      final comedy = await tmdb.fetchMoviesByGenre(35); // 35 is Comedy

      // 2. Combine them and remove any duplicates (in case a trending movie is also an action movie)
      final Map<int, Movie> uniqueMovies = {};
      for (var movie in [...trending, ...action, ...comedy]) {
        uniqueMovies[movie.id] = movie;
      }

      // 3. Upload them all to a brand new global "movies" collection using a Firestore Batch (Super fast!)
      final batch = firestore.batch();
      for (var movie in uniqueMovies.values) {
        final docRef = firestore.collection('movies').doc(movie.id.toString());
        batch.set(docRef, movie.toJson());
      }

      await batch.commit(); // Executes the massive upload

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "SUCCESS: Uploaded ${uniqueMovies.length} movies to Firestore!",
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      debugPrint("Seeding failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("FAILED: $e"), backgroundColor: Colors.red),
        );
      }
    }

    setState(() => _isSeeding = false);
  }
  // =====================================================================

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

    // TAB 0: HOME
    return MainBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,

        // TEMPORARY: A giant floating button to trigger the seeding!
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _isSeeding ? null : _seedDatabaseToFirestore,
          backgroundColor: const Color(0xFF00CED1),
          icon: _isSeeding
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.cloud_upload, color: Colors.black),
          label: Text(
            _isSeeding ? "UPLOADING TO CLOUD..." : "SEED DATABASE",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: Consumer<MovieProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingTrending && provider.trendingMovies.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              );
            }

            final heroMovie = provider.trendingMovies.isNotEmpty
                ? provider.trendingMovies.first
                : null;

            final gridMovies = provider.trendingMovies.isNotEmpty
                ? provider.trendingMovies.sublist(1)
                : [];

            return CustomScrollView(
              slivers: [
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

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: GenreSelector(),
                  ),
                ),

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
                      bottom: 100,
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

        bottomNavigationBar: GlassBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
