import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
// Import all your screen files here
import 'onboarding_screen.dart';
import 'onboarding_join_clubs_screen.dart';
import 'onboarding_be_the_flow_screen.dart';
import 'home_screen.dart';
import 'event_discovery_screen.dart';
import 'event_details_screen.dart';
import 'create_event_screen.dart';
import 'admin_dashboard_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'club_details_screen.dart';
import 'search_screen.dart';
import 'add_photos_screen.dart';
import 'registration_confirmed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/user_service.dart';
import 'models/app_user.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'create_club_screen.dart';
import 'screens/admin_setup_screen.dart';
import 'debug_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Add import for EventScreen
import 'event_discovery_screen.dart' show EventScreen;
import 'community_screen.dart';

// Add a notifier to trigger GoRouter refreshes
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Listenable listenable) {
    listenable.addListener(notifyListeners);
  }
}

late final AuthProvider _globalAuthProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _globalAuthProvider = AuthProvider();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: _globalAuthProvider),
        // Add other providers here
      ],
      child: const CampusFlowApp(),
    ),
  );
}

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Campus Flow',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111618),
        fontFamily: 'Spline Sans',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF47c1ea), brightness: Brightness.dark),
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  refreshListenable: GoRouterRefreshNotifier(_globalAuthProvider),
  initialLocation: '/',
  redirect: (context, state) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    print('Router redirect called. Path: ${state.uri.path}, Loading: ${auth.loading}, User: ${auth.currentUser?.email}');
    
    // If still loading, don't redirect
    if (auth.loading) {
      print('Still loading, not redirecting');
      return null;
    }
    
    // If user is authenticated and trying to access auth pages, redirect to home
    if (auth.currentUser != null && (state.uri.path == '/login' || state.uri.path == '/register' || state.uri.path == '/')) {
      print('User authenticated, redirecting to home');
      return '/home';
    }
    
    // If user is not authenticated and trying to access protected pages, redirect to login
    if (auth.currentUser == null && state.uri.path != '/login' && state.uri.path != '/register' && state.uri.path != '/debug') {
      print('User not authenticated, redirecting to login');
      return '/login';
    }
    
    // Role-based access control
    if (auth.currentUser != null) {
      final userRole = auth.currentUser!.role;
      print('Checking role-based access. User role: $userRole, Path: ${state.uri.path}');
      
      // Admin-only routes
      if (state.uri.path == '/admin' && userRole != 'admins') {
        print('Access denied to admin route');
        return '/home';
      }
      
      // Create event - only club_secretaries and admins can create events
      if (state.uri.path == '/create-event' && userRole != 'club_secretaries' && userRole != 'admins') {
        print('Access denied to create event route');
        return '/home';
      }
      
      // Create club - only admins can create clubs
      if (state.uri.path == '/create-club' && userRole != 'admins') {
        print('Access denied to create club route');
        return '/home';
      }
    }
    
    print('No redirect needed');
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthGate()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    ShellRoute(
      builder: (context, state, child) => MainNavShell(child: child, location: state.uri.toString()),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/events', builder: (context, state) => const EventScreen()),
        GoRoute(path: '/create-event', builder: (context, state) => const CreateEventScreen()),
        GoRoute(path: '/community', builder: (context, state) => const CommunityScreen()),
        GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      ],
    ),
    // Other routes without nav bar
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/onboarding-join-clubs', builder: (context, state) => const OnboardingJoinClubsScreen()),
    GoRoute(path: '/onboarding-be-the-flow', builder: (context, state) => const OnboardingBeTheFlowScreen()),
    GoRoute(path: '/event/:id', builder: (context, state) => EventDetailsScreen(eventId: state.pathParameters['id']!)),
    GoRoute(path: '/admin', builder: (context, state) => const AdminDashboardScreen()),
    GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/club/:id', builder: (context, state) => ClubDetailsScreen(clubId: state.pathParameters['id']!)),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(path: '/add-photos', builder: (context, state) => const AddPhotosScreen()),
    GoRoute(path: '/registration-confirmed', builder: (context, state) => const RegistrationConfirmedScreen()),
    GoRoute(path: '/create-club', builder: (context, state) => const CreateClubScreen()),
    GoRoute(path: '/admin-setup', builder: (context, state) => const AdminSetupScreen()),
    GoRoute(path: '/debug', builder: (context, state) => const DebugScreen()),
    // Add route for EventScreen
    GoRoute(path: '/events', builder: (context, state) => const EventScreen()),
  ],
);

class MainNavShell extends StatelessWidget {
  final Widget child;
  final String location;
  const MainNavShell({required this.child, required this.location, Key? key}) : super(key: key);

  List<_NavTab> _getTabs(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userRole = auth.currentUser?.role ?? 'students';
    if (userRole == 'club_secretaries' || userRole == 'admins') {
      // Home, Events, (Create FAB), Community, Profile
      return [
        _NavTab('/home', Icons.home, 'Home'),
        _NavTab('/events', Icons.calendar_today, 'Events'),
        // index 2 is reserved for FAB
        _NavTab('/community', Icons.groups, 'Community'),
        _NavTab('/profile', Icons.person, 'Profile'),
      ];
    } else {
      // Home, Events, Community, Profile
      return [
        _NavTab('/home', Icons.home, 'Home'),
        _NavTab('/events', Icons.calendar_today, 'Events'),
        _NavTab('/community', Icons.groups, 'Community'),
        _NavTab('/profile', Icons.person, 'Profile'),
      ];
    }
  }

  bool _canCreate(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userRole = auth.currentUser?.role ?? 'students';
    return userRole == 'club_secretaries' || userRole == 'admins';
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _getTabs(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userRole = auth.currentUser?.role ?? 'students';
    final canCreate = userRole == 'club_secretaries' || userRole == 'admins';
    int currentIndex = tabs.indexWhere((tab) => location.startsWith(tab.route));
    if (currentIndex == -1) currentIndex = 0;
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1c2426),
        shape: canCreate ? const CircularNotchedRectangle() : null,
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < tabs.length; i++)
              if (canCreate && i == 2) ...[
                const Spacer(),
                Expanded(
                  child: IconButton(
                    icon: Icon(tabs[i].icon, color: currentIndex == i ? const Color(0xFF47c1ea) : const Color(0xFF9db2b8)),
                    onPressed: () {
                      if (currentIndex != i) {
                        GoRouter.of(context).go(tabs[i].route);
                      }
                    },
                  ),
                ),
              ]
              else
                Expanded(
                  child: IconButton(
                    icon: Icon(tabs[i].icon, color: currentIndex == i ? const Color(0xFF47c1ea) : const Color(0xFF9db2b8)),
                    onPressed: () {
                      if (currentIndex != i) {
                        GoRouter.of(context).go(tabs[i].route);
                      }
                    },
                  ),
                ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: null,
      floatingActionButton: canCreate
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF47c1ea),
              foregroundColor: const Color(0xFF111618),
              onPressed: () {
                GoRouter.of(context).go('/create-event');
              },
              child: const Icon(Icons.add_box),
              tooltip: 'Create Event',
            )
          : null,
    );
  }
}

class _NavTab {
  final String route;
  final IconData icon;
  final String label;
  const _NavTab(this.route, this.icon, this.label);
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF111618),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea))),
      );
    }
    // The router redirect will handle navigation
    return const Scaffold(
      backgroundColor: Color(0xFF111618),
      body: Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea))),
    );
  }
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool _loading = false;
  bool get loading => _loading;
  String? _error;
  String? get error => _error;

  AuthProvider() {
    // Initialize with current user if already signed in
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      print('Found existing user on app start: ${currentUser.email}');
      _onAuthStateChanged(currentUser);
    }
    
    // Listen to auth state changes
    _auth.authStateChanges().listen((user) {
      print('Auth state changed: ${user?.email}');
      _onAuthStateChanged(user);
    });
  }

  String _getRoleForEmail(String email) {
    // Check for admin emails first
    if (email.contains('admin') || email.endsWith('@admin.com') || email.endsWith('@gmail.com') && email.contains('admin')) {
      return 'admins';
    } else if (RegExp(r'^\d{3}[A-Za-z]\d{3}@juetguna\.in$').hasMatch(email)) {
      return 'students';
    } else if (RegExp(r'^[^@]+\.[^@]+@juetguna\.in$').hasMatch(email)) {
      return 'faculty';
    } else if (email.endsWith('@juetguna.in')) {
      return 'club_secretaries';
    } else {
      return 'students'; // Default to students for unknown emails
    }
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    print('Auth state changed. User: ${firebaseUser?.email}');
    if (firebaseUser == null) {
      print('User is null, clearing current user');
      _currentUser = null;
      _error = null;
      _loading = false;
      notifyListeners();
      return;
    }

    if (!_loading) {
      _loading = true;
      notifyListeners();
    }

    try {
      print('Looking up user in Firestore: ${firebaseUser.uid}');
      final userDoc = await _userService.getUser(firebaseUser.uid);
      print('Firestore lookup result: $userDoc');
      if (userDoc != null) {
        print('Found existing user: ${userDoc.name} with role: ${userDoc.role}');
        _currentUser = userDoc;
      } else {
        print('User not found in Firestore, creating new user');
        // Check if user exists in admin collection first
        final email = firebaseUser.email ?? '';
        String role = 'students'; // default
        try {
          print('Checking admin collection for user...');
          final adminDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc('admins')
              .collection('admins')
              .doc(firebaseUser.uid)
              .get();
          print('Admin collection lookup result: ${adminDoc.exists}');
          if (adminDoc.exists) {
            role = 'admins';
            print('User found in admin collection');
          } else {
            role = _getRoleForEmail(email);
            print('User role determined by email: $role');
          }
        } catch (e, stack) {
          print('Error checking admin collection: $e');
          print('Stack trace: $stack');
          role = _getRoleForEmail(email);
        }
        final newUser = AppUser(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: email,
          photoUrl: firebaseUser.photoURL,
          role: role,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        try {
          print('Creating new user in Firestore...');
          await _userService.createUser(newUser);
          print('User creation logic executed');
          _currentUser = newUser;
          print('Created new user: ${newUser.name} with role: ${newUser.role}');
        } catch (e, stack) {
          print('Error creating user in Firestore: $e');
          print('Stack trace: $stack');
          _error = 'Failed to create user: $e';
        }
      }
      _error = null;
    } catch (e, stack) {
      print('Error in _onAuthStateChanged: $e');
      print('Stack trace: $stack');
      _error = 'Failed to load user profile: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail(String name, String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await cred.user!.updateDisplayName(name);
      final role = _getRoleForEmail(email);
      final newUser = AppUser(
        id: cred.user!.uid,
        name: name,
        email: email,
        photoUrl: cred.user!.photoURL,
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _userService.createUser(newUser);
      _currentUser = newUser;
      _error = null; // Clear any errors on success
    } on FirebaseAuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Registration failed: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      print('Attempting to sign in with email: $email');
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Sign in successful for email: $email');
      print('Current user after sign in: ${_auth.currentUser?.email}');
      print('Current user in provider: ${_currentUser?.email}');
      _error = null; // Clear any errors on success
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during sign in: ${e.message}');
      _error = e.message;
    } catch (e) {
      print('General exception during sign in: $e');
      _error = 'Sign in failed: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> signOut() async {
    _loading = true;
    notifyListeners();
    try {
      print('Signing out user: ${_currentUser?.email}');
      await _auth.signOut();
      _currentUser = null;
      _error = null;
      print('Sign out successful');
      // The router redirect will automatically navigate to login
    } catch (e) {
      print('Sign out error: $e');
      _error = 'Sign out failed: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Stub for Google sign-in (implement with google_sign_in package if needed)
  Future<void> signInWithGoogle() async {
    _error = 'Google sign-in not implemented.';
    notifyListeners();
  }

  Future<void> updateProfile(String name, String? bio, String? phone) async {
    if (_currentUser == null) return;
    _loading = true;
    notifyListeners();
    try {
      await _userService.updateUser(_currentUser!.id, {
        'name': name,
        'bio': bio,
        'phone': phone,
        'updatedAt': DateTime.now(),
      });
      _currentUser = AppUser(
        id: _currentUser!.id,
        name: name,
        email: _currentUser!.email,
        photoUrl: _currentUser!.photoUrl,
        phone: phone,
        bio: bio,
        role: _currentUser!.role,
        clubIds: _currentUser!.clubIds,
        registeredEventIds: _currentUser!.registeredEventIds,
        createdAt: _currentUser!.createdAt,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    if (_currentUser == null) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');
      
      // Re-authenticate user before changing password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      
      // Change password
      await user.updatePassword(newPassword);
      
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

void showNeonSnackbar(BuildContext context, String message, {Color? backgroundColor, IconData? icon, bool error = false}) {
  final theme = Theme.of(context);
  final fabHeight = 72.0; // FAB + margin
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? (error ? Colors.redAccent : const Color(0xFF47c1ea)),
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: fabHeight + 16, // float above FAB
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: error ? Colors.redAccent : const Color(0xFF47c1ea), width: 1.5),
      ),
      duration: const Duration(seconds: 2),
      showCloseIcon: true,
      closeIconColor: Colors.white,
    ),
  );
}
