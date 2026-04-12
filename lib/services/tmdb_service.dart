import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../constants/api_constants.dart';

class TmdbService {
  static const String _apiKey = ApiConstants.tmdbApiKey;
  static const String _baseUrl = ApiConstants.tmdbBaseUrl;
  final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  TmdbService() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  Future<List<Movie>> fetchTrendingMovies() async {
    try {
      final response = await _dio.get(
        '/trending/movie/day',
        queryParameters: {'api_key': _apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] ?? [];
        return results.map((json) => Movie.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching trending movies: $e');
      return [];
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {'api_key': _apiKey, 'query': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] ?? [];
        return results.map((json) => Movie.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error searching movies: $e');
      return [];
    }
  }

  // NEW: Fetch the official list of TMDB Genres
  Future<List<dynamic>> fetchGenres() async {
    try {
      final response = await _dio.get(
        '/genre/movie/list',
        queryParameters: {'api_key': _apiKey},
      );

      if (response.statusCode == 200) {
        return response.data['genres'] ?? [];
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching genres: $e');
      return [];
    }
  }

  // NEW: Fetch movies by a specific Genre ID
  Future<List<Movie>> fetchMoviesByGenre(int genreId) async {
    try {
      final response = await _dio.get(
        '/discover/movie',
        queryParameters: {'api_key': _apiKey, 'with_genres': genreId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] ?? [];
        return results.map((json) => Movie.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching movies by genre: $e');
      return [];
    }
  }
}
