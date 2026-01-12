import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../config/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with username and avatar
  Future<UserModel?> signUp({
    required String username,
    required String avatar,
  }) async {
    try {
      // Check if username already exists
      final usernameCheck = await _firestore
          .collection(AppConstants.usersCollection)
          .where('username', isEqualTo: username)
          .get();

      if (usernameCheck.docs.isNotEmpty) {
        throw Exception('Username already taken');
      }

      // Create anonymous account (we're using username, not email)
      final UserCredential result = await _auth.signInAnonymously();
      final User? user = result.user;

      if (user == null) {
        throw Exception('Failed to create user');
      }

      // Create user document in Firestore
      final userModel = UserModel(
        uid: user.uid,
        username: username,
        avatar: avatar,
        status: AppConstants.statusOnline,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(userModel.toMap());

      return userModel;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data()!);
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  // Update user status
  Future<void> updateStatus(String status) async {
    try {
      if (currentUser == null) return;

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(currentUser!.uid)
          .update({
        'status': status,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Update status error: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      if (currentUser != null) {
        await updateStatus(AppConstants.statusOffline);
      }
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Check if username is available
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final result = await _firestore
          .collection(AppConstants.usersCollection)
          .where('username', isEqualTo: username)
          .get();

      return result.docs.isEmpty;
    } catch (e) {
      print('Username check error: $e');
      return false;
    }
  }
}
