import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111618),
        appBar: AppBar(
          title: const Text('Debug Info'),
          backgroundColor: const Color(0xFF111618),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loading: ${auth.loading}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Current User: ${auth.currentUser?.email ?? "null"}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'User Role: ${auth.currentUser?.role ?? "null"}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: ${auth.error ?? "null"}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  print('Manual navigation to home');
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Force Navigate to Home'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  print('Signing out...');
                  await auth.signOut();
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 