import 'package:flutter/material.dart';
import 'package:appmolecule/main.dart'; // Ensure LoginScreen is defined here
import 'package:appmolecule/org/about.dart';
import 'package:appmolecule/org/molecule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingNow extends StatelessWidget {
  const SettingNow({super.key});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.science, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Analyzer Menu',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Molecular Analysis'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MolecularAnalyzerScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Do nothing or navigate to a different screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: const Text("Logout"),
        ),
      ),
    );
  }
}