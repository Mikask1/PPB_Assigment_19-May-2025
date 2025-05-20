import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'email_verification_screen.dart';
import '../services/auth_service.dart';

class AuthWrapper extends StatefulWidget {
  final Widget homeScreen;
  final bool requireEmailVerification;
  
  const AuthWrapper({
    Key? key,
    required this.homeScreen,
    this.requireEmailVerification = false,
  }) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _showLogin = true;

  void _toggleView() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          
          if (user != null) {
            // If email verification is required and email is not verified
            if (widget.requireEmailVerification && !user.emailVerified) {
              return EmailVerificationScreen(
                onSignOut: () async {
                  await _authService.signOut();
                },
              );
            }
            return widget.homeScreen;
          } else {
            return _showLogin
                ? LoginScreen(onRegisterClicked: _toggleView)
                : RegisterScreen(onLoginClicked: _toggleView);
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
} 