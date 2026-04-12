import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (mounted) {
      context.read<MovieProvider>().search(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        final bool isSearching = _searchController.text.isNotEmpty;

        return CustomScrollView(
          slivers: [
            // 1. Cinematic Header
            const SliverAppBar(
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'EXPLORE',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xFFE50914), // Cinematic Red
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3.0,
                ),
              ),
              centerTitle: false,
            ),

            // 2. The Glass Search Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _ExploreSearchBarDelegate(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      color: const Color(0xFF131313).withOpacity(0.8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF353534).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: const Color(0xFFE50914),
                          decoration: InputDecoration(
                            hintText: 'Search for movies, genres...',
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white54,
                            ),
                            suffixIcon: isSearching
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.white54,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged('');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Search Results or Empty State
            if (isSearching && provider.isLoadingSearch)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFE50914)),
                ),
              )
            else if (isSearching && provider.searchResults.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No movies found.',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              )
            else if (!isSearching)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie_creation_outlined,
                        size: 64,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Type a movie name to begin.',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
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
                    return MovieCard(movie: provider.searchResults[index]);
                  }, childCount: provider.searchResults.length),
                ),
              ),
          ],
        );
      },
    );
  }
}

// Helper class for the sticky search bar
class _ExploreSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _ExploreSearchBarDelegate({required this.child});

  @override
  double get minExtent => 76.0;
  @override
  double get maxExtent => 76.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_ExploreSearchBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
