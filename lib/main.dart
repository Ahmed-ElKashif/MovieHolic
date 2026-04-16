import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import 'firebase_options.dart';

import 'package:filmflow/screens/welcome_screen.dart';
import 'package:filmflow/providers/auth_provider.dart';
import 'package:filmflow/screens/home_screen.dart';
import 'package:filmflow/providers/movie_provider.dart';

void main() async {
  // Required because we are initializing Firebase before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Cloud infrastructure
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authprovider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: const MovieHolicApp(), // No more passing initialToken!
    ),
  );
}

class MovieHolicApp extends StatelessWidget {
  const MovieHolicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieHolic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Dark charcoal base
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE0E0E0),
            letterSpacing: 1.5,
          ),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
        ),
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
      // The Firebase Auto-Login Router:
      // Listens to Firebase Auth state in real-time
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. Show a loading spinner while Firebase checks the user's session
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFF131313),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              ),
            );
          }

          // 2. If snapshot has data, the user is securely logged in
          if (snapshot.hasData) {
            return const HomeScreen();
          }

          // 3. Otherwise, they are logged out, show the Welcome/Login screen
          return const WelcomeScreen();
        },
      ),
    );
  }
}
