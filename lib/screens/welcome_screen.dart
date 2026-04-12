import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/main_background.dart';
import '../widgets/movie_holic_logo.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Controllers to grab user input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State for tactile button animation
  bool _isPressed = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF131313), // Obsidian Base
      body: MainBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. The New Logo
                const Center(child: MovieHolicLogo(size: 110)),
                const SizedBox(height: 24),

                // 2. Cinematic Typography
                const Text(
                  'MOVIEHOLIC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6.0,
                    color: Color(0xFFE5E2E1),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Unlock your cinematic universe.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 80),

                // 3. Glassmorphic Inputs
                _buildTextField(
                  context,
                  hintText: 'Username (e.g., emilys)',
                  icon: Icons.person_outline,
                  controller: _usernameController,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  context,
                  hintText: 'Password (e.g., emilyspass)',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 40),

                // 4. Tactile "Obsidian Premiere" Sign In Button
                GestureDetector(
                  onTapDown: (_) => setState(() => _isPressed = true),
                  onTapUp: (_) => setState(() => _isPressed = false),
                  onTapCancel: () => setState(() => _isPressed = false),
                  onTap: authProvider.isLoading
                      ? null
                      : () async {
                          final success = await authProvider.login(
                            _usernameController.text.trim(),
                            _passwordController.text.trim(),
                          );

                          if (success && mounted) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Login Failed. Check credentials.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: const Color(
                                  0xFFE50914,
                                ).withOpacity(0.9), // Cinematic Red
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.all(24),
                              ),
                            );
                          }
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOutCubic,
                    transform: Matrix4.identity()
                      ..scale(_isPressed ? 0.96 : 1.0),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE50914), // Cinematic Red
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _isPressed || authProvider.isLoading
                          ? []
                          : [
                              BoxShadow(
                                color: const Color(0xFFE50914).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                    ),
                    child: Center(
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Refined Glassmorphic Text Field
  Widget _buildTextField(
    BuildContext context, {
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      cursorColor: const Color(0xFFE50914), // Red cursor
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white38,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: const Color(
          0xFF353534,
        ).withOpacity(0.5), // Glassmorphic background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE50914),
            width: 1.5,
          ), // Red highlight on focus
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
      ),
    );
  }
}
