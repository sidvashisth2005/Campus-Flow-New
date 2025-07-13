import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the appropriate subcollection based on role
  CollectionReference _getUserCollection(String role) {
    return _firestore.collection('users').doc(role).collection(role);
  }

  Future<AppUser?> getUser(String id) async {
    // Try to find user in each role subcollection
    final roles = ['students', 'faculty', 'club_secretaries', 'admins'];
    
    for (String role in roles) {
      try {
        final doc = await _getUserCollection(role).doc(id).get();
        if (doc.exists) {
          return AppUser.fromFirestore(doc);
        }
      } catch (e) {
        print('Error checking $role collection: $e');
        continue;
      }
    }
    return null;
  }

  Future<void> createUser(AppUser user) async {
    final role = user.role ?? 'students';
    final collection = _getUserCollection(role);
    await collection.doc(user.id).set(user.toMap());
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    // First find which collection the user is in
    final user = await getUser(id);
    if (user == null) throw Exception('User not found');
    
    final role = user.role ?? 'students';
    final collection = _getUserCollection(role);
    await collection.doc(id).update(data);
  }

  Future<void> deleteUser(String id) async {
    // First find which collection the user is in
    final user = await getUser(id);
    if (user == null) throw Exception('User not found');
    
    final role = user.role ?? 'students';
    final collection = _getUserCollection(role);
    await collection.doc(id).delete();
  }

  Stream<AppUser?> userStream(String id) {
    // Create a stream that checks all role collections
    final roles = ['students', 'faculty', 'club_secretaries', 'admins'];
    
    return Stream.fromFuture(getUser(id)).asBroadcastStream();
  }

  // Get all users of a specific role
  Future<List<AppUser>> getUsersByRole(String role) async {
    try {
      final snapshot = await _getUserCollection(role).get();
      return snapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting users by role $role: $e');
      return [];
    }
  }

  // Get all students
  Future<List<AppUser>> getStudents() async {
    return getUsersByRole('students');
  }

  // Get all faculty
  Future<List<AppUser>> getFaculty() async {
    return getUsersByRole('faculty');
  }

  // Get all club secretaries
  Future<List<AppUser>> getClubSecretaries() async {
    return getUsersByRole('club_secretaries');
  }

  // Get all admins
  Future<List<AppUser>> getAdmins() async {
    return getUsersByRole('admins');
  }

  // Helper method to create an admin user
  Future<void> createAdminUser({
    required String id,
    required String name,
    required String email,
    String? photoUrl,
    String? phone,
    String? bio,
  }) async {
    final adminUser = AppUser(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      phone: phone,
      bio: bio,
      role: 'admin',
      clubIds: [],
      registeredEventIds: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _getUserCollection('admins').doc(id).set(adminUser.toMap());
    print('Admin user created successfully: $email');
  }
} 