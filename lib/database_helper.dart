import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'book.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get booksCollection =>
      _firestore.collection('books');

  String? get currentUserId => auth.FirebaseAuth.instance.currentUser?.uid;

  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await usersCollection
          .where('firebaseUserId', isEqualTo: currentUserId)
          .get();
      
      return querySnapshot.docs
          .map((doc) => User.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future<User?> getUser(String id) async {
    try {
      final docSnapshot = await usersCollection.doc(id).get();
      if (docSnapshot.exists) {
        return User.fromMap({...docSnapshot.data()!, 'id': docSnapshot.id});
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> insertUser(User user) async {
    try {
      await usersCollection.doc(user.id).set({
        ...user.toMap(),
        'firebaseUserId': currentUserId,
      });
    } catch (e) {
      print('Error inserting user: $e');
      throw Exception('Failed to insert user');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await usersCollection.doc(user.id).update({
        ...user.toMap(),
        'firebaseUserId': currentUserId,
      });
    } catch (e) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final booksToDelete = await booksCollection
          .where('userId', isEqualTo: id)
          .get();
      
      final batch = _firestore.batch();
      for (var doc in booksToDelete.docs) {
        batch.delete(doc.reference);
      }
      
      batch.delete(usersCollection.doc(id));
      await batch.commit();
    } catch (e) {
      print('Error deleting user: $e');
      throw Exception('Failed to delete user');
    }
  }

  Future<List<Book>> getAllBooks() async {
    try {
      final users = await getAllUsers();
      final userIds = users.map((u) => u.id).toList();
      
      final querySnapshot = await booksCollection
          .where('userId', whereIn: userIds.isEmpty ? [''] : userIds)
          .get();
      
      return querySnapshot.docs
          .map((doc) => Book.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting books: $e');
      return [];
    }
  }

  Future<Book?> getBook(String id) async {
    try {
      final docSnapshot = await booksCollection.doc(id).get();
      if (docSnapshot.exists) {
        return Book.fromMap({...docSnapshot.data()!, 'id': docSnapshot.id});
      }
      return null;
    } catch (e) {
      print('Error getting book: $e');
      return null;
    }
  }

  Future<void> insertBook(Book book) async {
    try {
      await booksCollection.doc(book.id).set(book.toMap());
    } catch (e) {
      print('Error inserting book: $e');
      throw Exception('Failed to insert book');
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      await booksCollection.doc(book.id).update(book.toMap());
    } catch (e) {
      print('Error updating book: $e');
      throw Exception('Failed to update book');
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      await booksCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting book: $e');
      throw Exception('Failed to delete book');
    }
  }
}