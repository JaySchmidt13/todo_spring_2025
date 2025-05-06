// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:todo_spring_2025/home/home_screen.dart';
// import 'package:todo_spring_2025/login/login_screen.dart';
//
// class RouterScreen extends StatelessWidget {
//   const RouterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.data != null) {
//           return const HomeScreen();
//         } else {
//           return const LoginScreen();
//         }
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../home/home_screen.dart';
//
// class RouterScreen extends StatelessWidget {
//   const RouterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//       ),
//       drawer: Drawer(
//         width: MediaQuery.of(context).size.width * 0.3, // 30% of screen width
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               child: const Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             // We'll add menu items here later
//           ],
//         ),
//       ),
//       body: const HomeScreen(),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/archive_screen.dart';
import '../screens/settings_screens.dart';

class RouterScreen extends StatelessWidget {
  const RouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.45, // Increased to 45% of screen width
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              dense: true, // Makes the ListTile more compact
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.bar_chart),
              title: const Text('Stats'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsScreen()),
                );
              },
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.archive),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ArchiveScreen()),
                );
              },
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const HomeScreen(),
    );
  }
}