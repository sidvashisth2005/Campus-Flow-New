import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class AdminSetup {
  static final UserService _userService = UserService();

  /// Setup admin user in Firestore
  /// Call this function after creating the Firebase Auth account
  static Future<void> setupAdmin({
    required String email,
    required String name,
    String? photoUrl,
    String? phone,
    String? bio,
  }) async {
    try {
      // Get the current user (should be the admin you just created)
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user is currently signed in. Please sign in with the admin account first.');
        return;
      }

      // Verify the email matches
      if (user.email != email) {
        print('Current user email (${user.email}) does not match the provided email ($email)');
        return;
      }

      // Create admin user in Firestore
      await _userService.createAdminUser(
        id: user.uid,
        name: name,
        email: email,
        photoUrl: photoUrl,
        phone: phone,
        bio: bio,
      );

      print('✅ Admin user setup completed successfully!');
      print('User ID: ${user.uid}');
      print('Email: $email');
      print('Name: $name');
      print('Role: admin');
    } catch (e) {
      print('❌ Error setting up admin user: $e');
    }
  }

  /// Get all admin users (for verification)
  static Future<void> listAdmins() async {
    try {
      final admins = await _userService.getAdmins();
      print('📋 Current admin users:');
      for (final admin in admins) {
        print('- ${admin.name} (${admin.email}) - ID: ${admin.id}');
      }
    } catch (e) {
      print('❌ Error listing admins: $e');
    }
  }
} 