import 'package:flutter/material.dart';
import 'package:appmolecule/org/molecule.dart';
import 'package:appmolecule/org/setting.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

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
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) =>   MolecularAnalyzerScreen()),),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) =>   SettingNow()),),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AboutScreen()), // Use the correct class name
  );},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
           Positioned.fill(
            child: Opacity(
              opacity: 0.1, // Adjust transparency
              child: Center(
                child: Image.asset(
                  'assets/logo.webp', // Replace with your image path
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const Center(
            child: Column(
              children:  [
                Text(
                  'done by: bharath',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20,),
                Text(
                  'guide by: dr.kanan',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
