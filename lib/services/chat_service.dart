import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';
import '../config/constants.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Send DM message
  Future<void> sendDM({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String content,
  }) async {
    try {
      final message = MessageModel(
        id: _uuid.v4(),
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        content: content,
        type: 'dm',
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.messagesCollection)
          .doc(message.id)
          .set(message.toMap());
    } catch (e) {
      print('Send DM error: $e');
    }
  }

  // Send lobby message (proximity chat)
  Future<void> sendLobbyMessage({
    required String senderId,
    required String senderName,
    required String content,
  }) async {
    try {
      final message = MessageModel(
        id: _uuid.v4(),
        senderId: senderId,
        senderName: senderName,
        receiverId: 'lobby', // Special marker for lobby messages
        content: content,
        type: 'lobby',
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.messagesCollection)
          .doc(message.id)
          .set(message.toMap());

      // Auto-delete after display duration
      Future.delayed(
        Duration(seconds: AppConstants.chatBubbleDisplayDuration + 2),
        () {
          _firestore
              .collection(AppConstants.messagesCollection)
              .doc(message.id)
              .delete();
        },
      );
    } catch (e) {
      print('Send lobby message error: $e');
    }
  }

  // Get DM conversation between two users
  Stream<List<MessageModel>> getDMConversation({
    required String userId,
    required String otherUserId,
  }) {
    return _firestore
        .collection(AppConstants.messagesCollection)
        .where('type', isEqualTo: 'dm')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .where((message) =>
              (message.senderId == userId && message.receiverId == otherUserId) ||
              (message.senderId == otherUserId && message.receiverId == userId))
          .toList();
    });
  }

  // Get recent lobby messages
  Stream<List<MessageModel>> getLobbyMessages() {
    final cutoffTime = DateTime.now().subtract(
      Duration(seconds: AppConstants.chatBubbleDisplayDuration),
    );

    return _firestore
        .collection(AppConstants.messagesCollection)
        .where('type', isEqualTo: 'lobby')
        .where('timestamp', isGreaterThan: Timestamp.fromDate(cutoffTime))
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Mark messages as read
  Future<void> markAsRead(String messageId) async {
    try {
      await _firestore
          .collection(AppConstants.messagesCollection)
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      print('Mark as read error: $e');
    }
  }
}
