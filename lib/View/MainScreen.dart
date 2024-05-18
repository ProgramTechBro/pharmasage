import 'package:flutter/material.dart';
import 'package:pharmasage/View/LoginScreen.dart';
import 'package:pharmasage/View/Vendors/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RoleSelection.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final role = snapshot.data;
        if (role != null) {
          // Role selection has been made before
          // Proceed to the appropriate screen based on the role
          if (role == 'pharmacist') {
            return LoginScreen();
          } else if (role == 'vendor') {
            return LoginPage();
          } else {
            // Handle other roles or unexpected scenarios
            return Scaffold(
              body: Center(
                child: Text('Unknown role!'),
              ),
            );
          }
        }
        // If no data found, default to role selection screen
        return RoleSelectionScreen();
      },
    );
  }

  static Future<String?> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }
}
