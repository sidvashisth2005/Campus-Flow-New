import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_item.dart';

class NotificationService {
  final CollectionReference notifications = FirebaseFirestore.instance.collection('notifications');

  Future<NotificationItem?> getNotification(String id) async {
    final doc = await notifications.doc(id).get();
    if (doc.exists) {
      return NotificationItem.fromFirestore(doc);
    }
    return null;
  }

  Future<void> createNotification(NotificationItem notification) async {
    await notifications.doc(notification.id).set(notification.toMap());
  }

  Future<void> updateNotification(String id, Map<String, dynamic> data) async {
    await notifications.doc(id).update(data);
  }

  Future<void> deleteNotification(String id) async {
    await notifications.doc(id).delete();
  }

  Stream<List<NotificationItem>> notificationListStream({String? userId}) {
    Query query = notifications;
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    return query.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => NotificationItem.fromFirestore(doc)).toList()
    );
  }
} 