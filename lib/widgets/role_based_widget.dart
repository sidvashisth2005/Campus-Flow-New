import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class RoleBasedWidget extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;
  final Widget? fallback;

  const RoleBasedWidget({
    super.key,
    required this.child,
    required this.allowedRoles,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final userRole = auth.currentUser?.role ?? 'students';
    
    if (allowedRoles.contains(userRole)) {
      return child;
    }
    
    return fallback ?? const SizedBox.shrink();
  }
}

// Convenience widgets for common role checks
class AdminOnly extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const AdminOnly({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      allowedRoles: ['admins'],
      child: child,
      fallback: fallback,
    );
  }
}

class ClubSecretaryOrAdmin extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const ClubSecretaryOrAdmin({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      allowedRoles: ['club_secretaries', 'admins'],
      child: child,
      fallback: fallback,
    );
  }
}

class FacultyOrAdmin extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const FacultyOrAdmin({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      allowedRoles: ['faculty', 'admins'],
      child: child,
      fallback: fallback,
    );
  }
}

// Helper function to check if user has permission
bool hasPermission(BuildContext context, List<String> allowedRoles) {
  final auth = Provider.of<AuthProvider>(context, listen: false);
  final userRole = auth.currentUser?.role ?? 'students';
  return allowedRoles.contains(userRole);
}

// Helper function to get user role
String getUserRole(BuildContext context) {
  final auth = Provider.of<AuthProvider>(context, listen: false);
  return auth.currentUser?.role ?? 'students';
} 