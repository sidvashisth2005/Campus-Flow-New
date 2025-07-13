import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

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
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111618),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111618),
          elevation: 0,
          title: const Text('Settings', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (user != null) ...[
                Text('Account', style: _sectionStyle()),
                const SizedBox(height: 8),
                _SettingsTile(
                  title: 'Email',
                  subtitle: user.email,
                  icon: Icons.email,
                ),
                const SizedBox(height: 24),
              ],
              Text('Preferences', style: _sectionStyle()),
              const SizedBox(height: 8),
              _SettingsSwitch(
                title: 'Dark Mode',
                value: true,
                onChanged: (v) {}, // TODO: Implement dark mode toggle
              ),
              _SettingsSwitch(
                title: 'Push Notifications',
                value: true,
                onChanged: (v) {}, // TODO: Implement notification toggle
              ),
              const SizedBox(height: 24),
              Text('Account Actions', style: _sectionStyle()),
              const SizedBox(height: 8),
              _SettingsButton(
                title: 'Sign Out',
                icon: Icons.logout,
                color: Colors.redAccent,
                onTap: () async {
                  await auth.signOut();
                  Navigator.of(context).pop();
                },
              ),
              _SettingsButton(
                title: 'Delete Account',
                icon: Icons.delete_forever,
                color: Colors.redAccent,
                onTap: () {
                  // TODO: Implement account deletion
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _sectionStyle() => const TextStyle(
        color: Color(0xFF47c1ea), fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5);
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  const _SettingsTile({required this.title, this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: const Color(0xFF1c2426),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Icon(icon, color: const Color(0xFF47c1ea)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(color: Color(0xFF9db2b8))) : null,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsSwitch({required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      activeColor: const Color(0xFF47c1ea),
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFF293438),
      tileColor: const Color(0xFF1c2426),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SettingsButton({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: const Color(0xFF1c2426),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }
} 