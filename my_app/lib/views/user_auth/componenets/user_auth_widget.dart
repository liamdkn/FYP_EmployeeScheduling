import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:my_app/views/user_auth/user_login_page.dart';
import 'package:my_app/views/main/main_screen.dart';
import 'package:my_app/views/splash_screen.dart';
import 'package:my_app/services/user_auth_service.dart';

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        /*if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }*/
        final user = snapshot.data;
        if (user != null) {
          return MainScreen();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
