import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/dashboard_page.dart';
import '../screens/profile_page.dart';
import '../screens/issue_reporting.dart';
import '../screens/login_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A8A);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // DRAWER HEADER
          DrawerHeader(
            decoration: const BoxDecoration(color: primaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 40,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Raksha Setu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tourist Safety App',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          // DASHBOARD
          ListTile(
            leading: const Icon(Icons.dashboard, color: primaryColor),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),

          // PROFILE
          ListTile(
            leading: const Icon(Icons.person, color: primaryColor),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),

          // REPORT ISSUE
          ListTile(
            leading: const Icon(Icons.error_outline, color: primaryColor),
            title: const Text('Report Issue'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const IssueReporting()),
              );
            },
          ),

          const Divider(),

          // SETTINGS
          ListTile(
            leading: const Icon(Icons.settings, color: primaryColor),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Add settings page later
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
          ),

          // HELP & FEEDBACK
          ListTile(
            leading: const Icon(Icons.help_outline, color: primaryColor),
            title: const Text('Help & Feedback'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help page coming soon')),
              );
            },
          ),

          const Spacer(),

          // LOGOUT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
