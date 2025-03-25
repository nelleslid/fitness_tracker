// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/user_provider.dart';
import '../providers/body_metrics_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // No AppBar here as it's handled by HomePage
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            // User Profile Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 64, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    Text(
                      Supabase.instance.client.auth.currentUser?.email ?? 'Benutzer',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 24),
                    _buildProfileMenuItem(
                      context,
                      icon: Icons.settings,
                      title: 'Einstellungen',
                      onTap: () {
                        // Navigate to settings page
                      },
                    ),
                    _buildProfileMenuItem(
                      context,
                      icon: Icons.scale,
                      title: 'Körperwerte',
                      onTap: () {
                        // Navigate to body metrics page
                      },
                    ),
                    _buildProfileMenuItem(
                      context,
                      icon: Icons.restaurant_menu,
                      title: 'Ernährungsziele',
                      onTap: () {
                        // Navigate to nutrition goals page
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        await Supabase.instance.client.auth.signOut();
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      child: Text('Abmelden'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 24),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}