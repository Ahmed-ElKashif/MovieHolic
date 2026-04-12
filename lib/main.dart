import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:filmflow/screens/welcome_screen.dart';
import 'package:filmflow/providers/auth_provider.dart';
import 'package:filmflow/screens/home_screen.dart';
import 'package:filmflow/providers/movie_provider.dart';

void main() async {
  // Required because we are reading SharedPreferences before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Check for an existing token for auto-login
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: MovieHolicApp(initialToken: token),
    ),
  );
}

class MovieHolicApp extends StatelessWidget {
  final String? initialToken; // Pass the token in

  const MovieHolicApp({super.key, this.initialToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieHolic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Dark charcoal base
        // Define common text styles here for reuse
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Montserrat', // Modern font example
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE0E0E0), // Light gray
            letterSpacing: 1.5,
          ),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        // Style all text buttons consistently
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF00CED1), // Teal accent
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      // The Auto-Login router:
      // If we have a token, bypass login and go straight to the placeholder Home
      home: initialToken != null && initialToken!.isNotEmpty
          ? const HomeScreen()
          : const WelcomeScreen(),
    );
  }
}
