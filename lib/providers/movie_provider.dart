import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieProvider with ChangeNotifier {
  final TmdbService _service = TmdbService();

  List<Movie> _trendingMovies =
      []; // We will use this for both Trending AND Genre filtering
  List<Movie> _searchResults = [];
  List<Movie> _favoriteMovies = [];

  // NEW: Genre State
  List<dynamic> _genres = [];
  int? _selectedGenreId; // Null means "All" (Trending)

  bool _isLoadingTrending = false;
  bool _isLoadingSearch = false;

  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get favoriteMovies => _favoriteMovies;

  // NEW: Genre Getters
  List<dynamic> get genres => _genres;
  int? get selectedGenreId => _selectedGenreId;

  bool get isLoadingTrending => _isLoadingTrending;
  bool get isLoadingSearch => _isLoadingSearch;

  static const String _favoritesKey = 'favoriteMovies';

  MovieProvider() {
    loadFavorites();
    fetchGenres(); // Load genres immediately
    fetchTrending();
  }

  // NEW: Fetch genres on startup
  Future<void> fetchGenres() async {
    _genres = await _service.fetchGenres();
    notifyListeners();
  }

  // NEW: The filtering logic
  Future<void> selectGenre(int? genreId) async {
    _selectedGenreId = genreId;
    _isLoadingTrending = true; // Show loading spinner
    notifyListeners();

    if (genreId == null) {
      // If "All" is selected, fetch normal trending
      _trendingMovies = await _service.fetchTrendingMovies();
    } else {
      // If a specific genre is selected, fetch those movies
      _trendingMovies = await _service.fetchMoviesByGenre(genreId);
    }

    _isLoadingTrending = false;
    notifyListeners();
  }

  Future<void> fetchTrending() async {
    _isLoadingTrending = true;
    notifyListeners();

    _trendingMovies = await _service.fetchTrendingMovies();

    _isLoadingTrending = false;
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoadingSearch = true;
    notifyListeners();

    _searchResults = await _service.searchMovies(query);

    _isLoadingSearch = false;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(favoritesJson);
        _favoriteMovies = decodedList
            .map((json) => Movie.fromJson(json))
            .toList();
        notifyListeners();
      } catch (e) {
        debugPrint('Error decoding favorites: $e');
      }
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(
      _favoriteMovies.map((m) => m.toJson()).toList(),
    );
    await prefs.setString(_favoritesKey, encodedList);
  }

  bool isFavorite(Movie movie) {
    return _favoriteMovies.any((m) => m.id == movie.id);
  }

  Future<void> addFavorite(Movie movie) async {
    if (!isFavorite(movie)) {
      _favoriteMovies.add(movie);
      notifyListeners();
      await _saveFavorites();
    }
  }

  Future<void> removeFavorite(Movie movie) async {
    if (isFavorite(movie)) {
      _favoriteMovies.removeWhere((m) => m.id == movie.id);
      notifyListeners();
      await _saveFavorites();
    }
  }

  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie)) {
      await removeFavorite(movie);
    } else {
      await addFavorite(movie);
    }
  }
}
