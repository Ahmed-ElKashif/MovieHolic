import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  final Dio _dio = Dio();

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // DummyJSON login endpoint
      final response = await _dio.post(
        'https://dummyjson.com/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        // Extract token and save locally
        _token = response.data['accessToken'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Login failed: $e");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
