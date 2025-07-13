import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  String? _name;
  String? _bio;
  String? _phone;
  bool _editing = false;
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    if (auth.loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF111618),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea))),
      );
    }
    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF111618),
        body: Center(child: Text('Not signed in', style: TextStyle(color: Colors.white70))),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111618),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111618),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          actions: [
            IconButton(
              icon: Icon(_editing ? Icons.close : Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _editing = !_editing;
                  _name = user.name;
                  _bio = user.bio;
                  _phone = user.phone;
                  _error = null;
                });
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  backgroundColor: const Color(0xFF293438),
                  child: user.photoUrl == null || user.photoUrl!.isEmpty
                      ? const Icon(Icons.person, color: Color(0xFF47c1ea), size: 48)
                      : null,
                ),
                const SizedBox(height: 20),
                _editing
                    ? Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: _name,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Name'),
                              onChanged: (v) => _name = v,
                              validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: _bio,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Bio'),
                              maxLines: 3,
                              onChanged: (v) => _bio = v,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: _phone,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Phone Number'),
                              keyboardType: TextInputType.phone,
                              onChanged: (v) => _phone = v,
                            ),
                            const SizedBox(height: 24),
                            if (_error != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                              ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF47c1ea),
                                  foregroundColor: const Color(0xFF111618),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                onPressed: _loading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() => _loading = true);
                                          try {
                                            await auth.updateProfile(_name!, _bio, _phone);
                                            setState(() {
                                              _editing = false;
                                              _error = null;
                                            });
                                          } catch (e) {
                                            setState(() => _error = e.toString());
                                          } finally {
                                            setState(() => _loading = false);
                                          }
                                        }
                                      },
                                child: _loading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF111618)),
                                      )
                                    : const Text('Save Changes'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(user.email, style: const TextStyle(color: Color(0xFF9db2b8), fontSize: 16)),
                          const SizedBox(height: 8),
                          if (user.role != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF47c1ea),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getRoleDisplayName(user.role!),
                                style: const TextStyle(color: Color(0xFF111618), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          const SizedBox(height: 8),
                          if (user.bio != null && user.bio!.isNotEmpty)
                            Text(user.bio!, style: const TextStyle(color: Colors.white, fontSize: 16)),
                          if (user.phone != null && user.phone!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.phone, color: Color(0xFF9db2b8), size: 16),
                                const SizedBox(width: 8),
                                Text(user.phone!, style: const TextStyle(color: Color(0xFF9db2b8), fontSize: 16)),
                              ],
                            ),
                          ],
                        ],
                      ),
                const SizedBox(height: 32),
                // Password Change Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF47c1ea),
                      side: const BorderSide(color: Color(0xFF47c1ea)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: () => _showPasswordChangeDialog(context, auth),
                    child: const Text('Change Password'),
                  ),
                ),
                const SizedBox(height: 16),
                // Admin tools button (only for admins)
                if (user.role == 'admins')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF47c1ea),
                        foregroundColor: const Color(0xFF111618),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      icon: const Icon(Icons.admin_panel_settings),
                      label: const Text('Admin Dashboard'),
                      onPressed: () => context.go('/admin'),
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF293438),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    onPressed: () async {
                      try {
                        await auth.signOut();
                        // Show success message
                        if (context.mounted) {
                          showNeonSnackbar(context, 'Successfully signed out');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showNeonSnackbar(context, 'Sign out failed: $e', error: true);
                        }
                      }
                    },
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'students':
        return 'Student';
      case 'faculty':
        return 'Faculty';
      case 'club_secretaries':
        return 'Club Secretary';
      case 'admins':
        return 'Admin';
      default:
        return 'User';
    }
  }

  void _showPasswordChangeDialog(BuildContext context, AuthProvider auth) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool loading = false;
    String? error;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1c2426),
              title: const Text(
                'Change Password',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: Form(
                key: _passwordFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: currentPasswordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Current Password'),
                      obscureText: true,
                      validator: (v) => v == null || v.isEmpty ? 'Enter current password' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: newPasswordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('New Password'),
                      obscureText: true,
                      validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: confirmPasswordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Confirm New Password'),
                      obscureText: true,
                      validator: (v) => v != newPasswordController.text ? 'Passwords do not match' : null,
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        error!,
                        style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: loading ? null : () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF9db2b8)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF47c1ea),
                    foregroundColor: const Color(0xFF111618),
                  ),
                  onPressed: loading
                      ? null
                      : () async {
                          if (_passwordFormKey.currentState!.validate()) {
                            setState(() => loading = true);
                            try {
                              await auth.changePassword(
                                currentPasswordController.text,
                                newPasswordController.text,
                              );
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                showNeonSnackbar(context, 'Password changed successfully!');
                              }
                            } catch (e) {
                              setState(() => error = e.toString());
                            } finally {
                              setState(() => loading = false);
                            }
                          }
                        },
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF111618)),
                        )
                      : const Text('Change Password'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF9db2b8)),
      filled: true,
      fillColor: const Color(0xFF1c2426),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
} 