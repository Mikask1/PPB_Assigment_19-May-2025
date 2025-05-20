import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  User? get currentUser => _auth.currentUser;
  
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Send email verification
      await result.user?.sendEmailVerification();
      return result;
      
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else if (user == null) {
        throw Exception('No user is currently signed in');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> updateEmail(String newEmail, String password) async {
    try {
      User? user = _auth.currentUser;
      
      if (user == null) {
        throw Exception('No user is currently signed in');
      }
      
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      
      await user.reauthenticateWithCredential(credential);
      await user.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      
      if (user == null) {
        throw Exception('No user is currently signed in');
      }
      
      if (user.email == null) {
        throw Exception('User does not have an email');
      }
      
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email.';
        break;
      case 'wrong-password':
        message = 'Wrong password.';
        break;
      case 'email-already-in-use':
        message = 'Email is already in use.';
        break;
      case 'weak-password':
        message = 'The password is too weak.';
        break;
      case 'invalid-email':
        message = 'The email address is invalid.';
        break;
      case 'requires-recent-login':
        message = 'This operation requires recent authentication. Please log in again.';
        break;
      default:
        message = e.message ?? 'An unknown error occurred.';
    }
    return Exception(message);
  }
} 