import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/View/MainScreen.dart';
import 'package:pharmasage/View/Vendors/Checkemail.dart';
import 'package:pharmasage/View/Vendors/Emailverification.dart';
import 'package:provider/provider.dart';
import '../Dashboard.dart';
import 'LoginPage.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            String? email = snapshot.data!.email;
            if (email != null) {
              print('Check role Screen');
                return CheckEmailVerified(email: email, key: UniqueKey(),);
            } else {
              // Handle case where email is null
              return const Scaffold(
                body: Center(
                  child: Text('User email is null.'),
                ),
              );
            }
          } else {
            // User is not signed in
            return const LoginPage();
          }
        }
      },
    );
  }
}
