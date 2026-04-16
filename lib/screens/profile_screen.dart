import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // To grab the user's email
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Dedicated logout function using our new AuthProvider
  void _logout(BuildContext context) async {
    await context.read<Authprovider>().logout();
    // No Navigator needed! The StreamBuilder in main.dart handles the kick.
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically grab the current Firebase user
    final currentUser = FirebaseAuth.instance.currentUser;
    final String displayEmail = currentUser?.email ?? 'user@movieholic.com';
    // Extract everything before the '@' symbol to use as a display name
    final String displayName = displayEmail.split('@').first.toUpperCase();

    return CustomScrollView(
      slivers: [
        // 1. Cinematic Header
        const SliverAppBar(
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'PROFILE',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xFFE50914), // Cinematic Red
              fontWeight: FontWeight.w900,
              letterSpacing: 3.0,
            ),
          ),
          centerTitle: false,
        ),

        // 2. Profile Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar with Cinematic Glow
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE50914), Color(0xFFFF4D4D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE50914).withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFF131313),
                    // We can swap this to a default icon since DummyJSON is gone
                    child: Icon(Icons.person, size: 60, color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 24),

                // Dynamic Firebase User Data
                Text(
                  displayName,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFE5E2E1),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF353534).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Text(
                    displayEmail, // Shows their actual Firebase login email!
                    style: const TextStyle(
                      color: Color(
                        0xFF00CED1,
                      ), // A touch of teal to pop against the red
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Settings Options
                _buildProfileOption(
                  Icons.settings_outlined,
                  'Account Settings',
                ),
                const SizedBox(height: 16),
                _buildProfileOption(
                  Icons.notifications_none_outlined,
                  'Notifications',
                ),
                const SizedBox(height: 16),
                _buildProfileOption(Icons.help_outline, 'Help & Support'),
                const SizedBox(height: 48),

                // Huge Logout Button
                GestureDetector(
                  onTap: () => _logout(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE50914),
                        width: 2,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Color(0xFFE50914)),
                        SizedBox(width: 12),
                        Text(
                          'SIGN OUT',
                          style: TextStyle(
                            color: Color(0xFFE50914),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 120), // Padding for the bottom nav bar
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for the glassmorphic settings rows
  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF353534).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFE5E2E1),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
        ],
      ),
    );
  }
}
