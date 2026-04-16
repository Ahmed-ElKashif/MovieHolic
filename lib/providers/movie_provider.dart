import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Movie> _allCloudMovies = [];
  List<Movie> _searchResults = [];
  List<Movie> _favoriteMovies = [];

  bool _isLoadingTrending = false;
  bool _isLoadingSearch = false;

  // We expose our cloud movies as "trending" so the HomeScreen doesn't have to change its code
  List<Movie> get trendingMovies => _allCloudMovies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get favoriteMovies => _favoriteMovies;

  bool get isLoadingTrending => _isLoadingTrending;
  bool get isLoadingSearch => _isLoadingSearch;

  MovieProvider() {
    fetchMoviesFromCloud(); // READ operation for global catalog

    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        loadFavorites(); // READ operation for user vault
      } else {
        _favoriteMovies = [];
        notifyListeners();
      }
    });
  }

  // ==========================================
  // GLOBAL CATALOG (READ ONLY)
  // ==========================================

  Future<void> fetchMoviesFromCloud() async {
    _isLoadingTrending = true;
    notifyListeners();

    try {
      // 1. READ: Pull all 50 movies from our seeded Firestore collection
      final snapshot = await _firestore.collection('movies').get();

      _allCloudMovies = snapshot.docs.map((doc) {
        return Movie.fromJson(doc.data());
      }).toList();
    } catch (e) {
      debugPrint("Error fetching cloud movies: $e");
    }

    _isLoadingTrending = false;
    notifyListeners();
  }

  // Instant Local Search! No API needed because all movies are in memory.
  void search(String query) {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoadingSearch = true;
    notifyListeners();

    // Search through our downloaded cloud movies instantly
    _searchResults = _allCloudMovies.where((movie) {
      return movie.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    _isLoadingSearch = false;
    notifyListeners();
  }

  // ==========================================
  // USER VAULT CRUD (CREATE, READ, DELETE)
  // ==========================================

  CollectionReference? get _userFavoritesCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;
    return _firestore.collection('users').doc(userId).collection('favorites');
  }

  Future<void> loadFavorites() async {
    final collection = _userFavoritesCollection;
    if (collection == null) return;

    try {
      final snapshot = await collection.get();
      _favoriteMovies = snapshot.docs.map((doc) {
        return Movie.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cloud favorites: $e');
    }
  }

  bool isFavorite(Movie movie) {
    return _favoriteMovies.any((m) => m.id == movie.id);
  }

  Future<void> addFavorite(Movie movie) async {
    final collection = _userFavoritesCollection;
    if (collection == null || isFavorite(movie)) return;

    _favoriteMovies.add(movie);
    notifyListeners();

    try {
      await collection.doc(movie.id.toString()).set(movie.toJson());
    } catch (e) {
      _favoriteMovies.removeWhere((m) => m.id == movie.id);
      notifyListeners();
    }
  }

  Future<void> removeFavorite(Movie movie) async {
    final collection = _userFavoritesCollection;
    if (collection == null || !isFavorite(movie)) return;

    _favoriteMovies.removeWhere((m) => m.id == movie.id);
    notifyListeners();

    try {
      await collection.doc(movie.id.toString()).delete();
    } catch (e) {
      _favoriteMovies.add(movie);
      notifyListeners();
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
