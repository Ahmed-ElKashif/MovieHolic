import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/main_background.dart';
import '../widgets/movie_holic_logo.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Controllers to grab user input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State for tactile button animation
  bool _isPressed = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fixed the typo here: AuthProvider (capital P)
    final authProvider = Provider.of<Authprovider>(context);

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
                  hintText: 'Email (e.g., test@test.com)',
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  context,
                  hintText: 'Password',
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
                          // Hide keyboard on submit
                          FocusScope.of(context).unfocus();

                          final success = await authProvider.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );

                          // We ONLY handle the failure case here!
                          // If successful, the StreamBuilder in main.dart takes over and handles the routing.
                          if (!success && mounted) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

                const SizedBox(height: 24),

                // 5. Divider "OR"
                const Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.white24, thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.white24, thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 6. Google Sign In Button
                GestureDetector(
                  onTap: authProvider.isLoading
                      ? null
                      : () async {
                          final success = await authProvider.signInWithGoogle();

                          if (!success && mounted) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Google Sign-In canceled or failed.",
                                ),
                                backgroundColor: const Color(
                                  0xFFE50914,
                                ).withOpacity(0.9),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Simple Google "G" logo
                        Container(
                          height: 24,
                          width: 24,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                            height: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
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
