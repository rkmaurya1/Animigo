import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../config/constants.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all users (for friends list)
  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Get online users
  Stream<List<UserModel>> getOnlineUsers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .where('status', whereIn: [AppConstants.statusOnline, AppConstants.statusInLobby])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Search users by username
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Search users error: $e');
      return [];
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data()!);
    } catch (e) {
      print('Get user by ID error: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateProfile({
    required String uid,
    String? username,
    String? avatar,
  }) async {
    try {
      final Map<String, dynamic> updates = {};

      if (username != null) updates['username'] = username;
      if (avatar != null) updates['avatar'] = avatar;

      if (updates.isNotEmpty) {
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(uid)
            .update(updates);
      }
    } catch (e) {
      print('Update profile error: $e');
    }
  }
}
