import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'services/event_service.dart';
import 'models/event.dart';
import 'main.dart';
import 'widgets/role_based_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Tech', 'Sports', 'Cultural', 'Music', 'Academic'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Pop the current route (go back to previous screen)
        return await Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111618),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar with Search
              SliverAppBar(
                backgroundColor: const Color(0xFF111618),
                elevation: 0,
                floating: true,
                expandedHeight: 120,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'CampusFlow',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF47c1ea),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Consumer<AuthProvider>(
                              builder: (context, auth, child) {
                                final userRole = auth.currentUser?.role ?? 'students';
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF47c1ea).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFF47c1ea)),
                                  ),
                                  child: Text(
                                    _getRoleDisplayName(userRole),
                                    style: const TextStyle(
                                      color: Color(0xFF47c1ea),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Discover amazing campus events',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9db2b8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1c2426),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF293438)),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        hintStyle: const TextStyle(color: Color(0xFF9db2b8)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF47c1ea)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onTap: () => context.go('/search'),
                    ),
                  ),
                ),
              ),

              // Category Filters
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category == selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategory = category),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF47c1ea) : const Color(0xFF1c2426),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF47c1ea) : const Color(0xFF293438),
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: const Color(0xFF47c1ea).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ] : null,
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Featured Events Carousel
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  margin: const EdgeInsets.only(top: 20),
                  child: StreamBuilder<List<Event>>(
                    stream: EventService().eventListStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
                      }
                      final events = (snapshot.data ?? []).where((e) => e.isApproved == true).toList();
                      if (events.isEmpty) {
                        return const Center(
                          child: Text(
                            'No featured events',
                            style: TextStyle(color: Color(0xFF9db2b8), fontSize: 16),
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: events.take(5).length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Container(
                            width: 280,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF47c1ea).withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Image.network(
                                    event.imageUrl ?? '',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: const Color(0xFF1c2426),
                                      child: const Icon(Icons.event, color: Color(0xFF47c1ea), size: 60),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    right: 16,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          event.location,
                                          style: const TextStyle(
                                            color: Color(0xFF47c1ea),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Quick Actions Section (Role-based)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer<AuthProvider>(
                        builder: (context, auth, child) {
                          final userRole = auth.currentUser?.role ?? 'students';
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              // All users can view events
                              _buildQuickActionChip(
                                context,
                                'View Events',
                                Icons.calendar_today,
                                () => context.go('/events'),
                              ),
                              // Only club_secretaries and admins can create events
                              if (userRole == 'club_secretaries' || userRole == 'admins')
                                _buildQuickActionChip(
                                  context,
                                  'Create Event',
                                  Icons.add_box,
                                  () => context.go('/create-event'),
                                ),
                              // Only admins can access admin dashboard
                              if (userRole == 'admins')
                                _buildQuickActionChip(
                                  context,
                                  'Admin Dashboard',
                                  Icons.admin_panel_settings,
                                  () => context.go('/admin'),
                                ),
                              // Only admins can create clubs
                              if (userRole == 'admins')
                                _buildQuickActionChip(
                                  context,
                                  'Create Club',
                                  Icons.group_add,
                                  () => context.go('/create-club'),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Upcoming Events Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Upcoming Events',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/events'),
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                color: Color(0xFF47c1ea),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Upcoming Events List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: StreamBuilder<List<Event>>(
                  stream: EventService().eventListStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea))),
                      );
                    }
                    final events = (snapshot.data ?? []).where((e) => e.isApproved == true).toList();
                    if (events.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              'No upcoming events',
                              style: TextStyle(color: Color(0xFF9db2b8), fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final event = events[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1c2426),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF293438)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  event.imageUrl ?? '',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 60,
                                    height: 60,
                                    color: const Color(0xFF293438),
                                    child: const Icon(Icons.event, color: Color(0xFF47c1ea)),
                                  ),
                                ),
                              ),
                              title: Text(
                                event.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    event.location,
                                    style: const TextStyle(color: Color(0xFF9db2b8)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatDateTime(event.startTime, event.endTime),
                                    style: const TextStyle(
                                      color: Color(0xFF47c1ea),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF47c1ea).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF47c1ea)),
                                ),
                                child: const Text(
                                  'Join',
                                  style: TextStyle(
                                    color: Color(0xFF47c1ea),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onTap: () => context.go('/event/${event.id}'),
                            ),
                          );
                        },
                        childCount: events.take(5).length,
                      ),
                    );
                  },
                ),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime start, DateTime end) {
    final date = '${start.day}/${start.month}/${start.year}';
    final startTime = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    return '$date at $startTime';
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

  Widget _buildQuickActionChip(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1c2426),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF293438)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF47c1ea),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 