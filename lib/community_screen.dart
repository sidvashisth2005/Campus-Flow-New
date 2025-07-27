import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'services/club_service.dart';
import 'models/club.dart';
import 'widgets/status_chip.dart';
import 'create_club_screen.dart'; // Added import for CreateClubScreen
import 'club_details_screen.dart'; // Added import for ClubDetailsScreen
import 'package:flutter/foundation.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final isClubSecretaryOrAdmin = user?.role == 'club_secretaries' || user?.role == 'admins';
    final List<String> categories = ['All', 'Tech', 'Music', 'Sports', 'Cultural', 'Literary', 'Academic', 'Other'];
    final ValueNotifier<String> selectedCategory = ValueNotifier<String>('All');
    final TextEditingController searchController = TextEditingController();
    final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
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
          title: const Text('Community', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        floatingActionButton: isClubSecretaryOrAdmin
            ? FloatingActionButton(
                backgroundColor: const Color(0xFF47c1ea),
                foregroundColor: const Color(0xFF111618),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreateClubScreen()),
                  );
                },
                child: const Icon(Icons.add),
                tooltip: 'Create Club',
              )
            : null,
        // Remove floatingActionButton
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Campus Clubs & Community',
                  style: TextStyle(
                    color: Color(0xFF47c1ea),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search clubs...',
                    hintStyle: const TextStyle(color: Color(0xFF9db2b8)),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF47c1ea)),
                    filled: true,
                    fillColor: const Color(0xFF1c2426),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF293438)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF293438)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF47c1ea)),
                    ),
                  ),
                  onChanged: (value) => searchQuery.value = value,
                ),
              ),
              // Category filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ValueListenableBuilder<String>(
                        valueListenable: selectedCategory,
                        builder: (context, selected, _) => GestureDetector(
                          onTap: () => selectedCategory.value = category,
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected == category ? const Color(0xFF47c1ea) : const Color(0xFF1c2426),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected == category ? const Color(0xFF47c1ea) : const Color(0xFF293438),
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: selected == category ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Club list
              Expanded(
                child: ValueListenableBuilder2<String, String>(
                  first: selectedCategory,
                  second: searchQuery,
                  builder: (context, selected, query, _) {
                    return StreamBuilder<List<Club>>(
                      stream: ClubService().clubListStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
                        }
                        var clubs = snapshot.data ?? [];
                        if (selected != 'All') {
                          clubs = clubs.where((c) => (c.category ?? '').toLowerCase() == selected.toLowerCase()).toList();
                        }
                        if (query.isNotEmpty) {
                          clubs = clubs.where((c) => c.name.toLowerCase().contains(query.toLowerCase()) || c.description.toLowerCase().contains(query.toLowerCase())).toList();
                        }
                        if (clubs.isEmpty) {
                          return Center(
                            child: Text(
                              'No clubs found.',
                              style: TextStyle(color: Color(0xFF9db2b8), fontSize: 18),
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: clubs.length,
                          separatorBuilder: (_, __) => const Divider(color: Color(0xFF293438)),
                          itemBuilder: (context, index) {
                            final club = clubs[index];
                            return ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      club.name,
                                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  if (user != null)
                                    StatusChip(
                                      label: (user.clubIds ?? []).contains(club.id) ? 'Member' : 'Not a Member',
                                      color: (user.clubIds ?? []).contains(club.id) ? const Color(0xFF47c1ea) : Colors.grey,
                                    ),
                                ],
                              ),
                              subtitle: club.description.isNotEmpty
                                  ? Text(club.description, style: const TextStyle(color: Color(0xFF9db2b8)))
                                  : null,
                              leading: const Icon(Icons.group, color: Color(0xFF47c1ea)),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ClubDetailsScreen(clubId: club.id),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;
  final Widget? child;
  const ValueListenableBuilder2({required this.first, required this.second, required this.builder, this.child, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) => ValueListenableBuilder<B>(
        valueListenable: second,
        builder: (context, b, __) => builder(context, a, b, child),
      ),
    );
  }
} 