import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  final VoidCallback onSignOut;
  
  const EmailVerificationScreen({
    Key? key, 
    required this.onSignOut,
  }) : super(key: key);

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _timer;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    // Check if email is already verified
    _isEmailVerified = _authService.isEmailVerified;
    
    if (!_isEmailVerified) {
      _sendVerificationEmail();
      // Start timer to check verification status periodically
      _timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => _checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    try {
      // Reload user data
      await _authService.reloadUser();
      
      setState(() {
        _isEmailVerified = _authService.isEmailVerified;
      });

      if (_isEmailVerified) {
        _timer?.cancel();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _sendVerificationEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
        backgroundColor: Colors.yellow.shade500,
        foregroundColor: Colors.blue.shade500,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: widget.onSignOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade800),
                  textAlign: TextAlign.center,
                ),
              ),
            Icon(
              _isEmailVerified ? Icons.verified_user : Icons.mark_email_unread,
              size: 100,
              color: _isEmailVerified ? Colors.green : Colors.orange,
            ),
            SizedBox(height: 24),
            Text(
              _isEmailVerified
                  ? 'Email Verified!'
                  : 'Please verify your email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isEmailVerified ? Colors.green.shade700 : Colors.orange.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              _isEmailVerified
                  ? 'You can now access all features of the app.'
                  : 'A verification email has been sent to your email address. Please check your inbox and follow the link to verify your email.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            if (!_isEmailVerified) ...[
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _sendVerificationEmail,
                icon: Icon(Icons.email),
                label: Text('Resend Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade500,
                  foregroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: _checkEmailVerified,
                child: Text('I\'ve verified my email'),
              ),
            ] else
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade500,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text('Continue to App'),
              ),
          ],
        ),
      ),
    );
  }
} 