import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'services/event_service.dart';
import 'services/club_service.dart';
import 'models/event.dart';
import 'models/club.dart';
import 'widgets/status_chip.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedType = 'Events';
  String _selectedCategory = 'All';
  final List<String> eventCategories = ['All', 'Tech', 'Sports', 'Cultural', 'Music', 'Academic'];
  final List<String> clubCategories = ['All', 'Tech', 'Music', 'Sports', 'Cultural', 'Literary', 'Academic', 'Other'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111618),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1c2426),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search events or clubs...',
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
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Type filter
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Events'),
                    selected: _selectedType == 'Events',
                    onSelected: (selected) => setState(() => _selectedType = 'Events'),
                    selectedColor: const Color(0xFF47c1ea),
                    labelStyle: TextStyle(color: _selectedType == 'Events' ? Colors.black : Colors.white),
                    backgroundColor: const Color(0xFF1c2426),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Clubs'),
                    selected: _selectedType == 'Clubs',
                    onSelected: (selected) => setState(() => _selectedType = 'Clubs'),
                    selectedColor: const Color(0xFF47c1ea),
                    labelStyle: TextStyle(color: _selectedType == 'Clubs' ? Colors.black : Colors.white),
                    backgroundColor: const Color(0xFF1c2426),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Category filter
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedType == 'Events' ? eventCategories.length : clubCategories.length,
                  itemBuilder: (context, index) {
                    final category = _selectedType == 'Events' ? eventCategories[index] : clubCategories[index];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedCategory == category ? const Color(0xFF47c1ea) : const Color(0xFF1c2426),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedCategory == category ? const Color(0xFF47c1ea) : const Color(0xFF293438),
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: _selectedCategory == category ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _searchQuery.isEmpty
                    ? _buildSearchSuggestions()
                    : _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Searches',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              _buildSuggestionChip('Tech Events'),
              _buildSuggestionChip('Sports Clubs'),
              _buildSuggestionChip('Music Events'),
              _buildSuggestionChip('Academic Seminars'),
              _buildSuggestionChip('Social Gatherings'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ActionChip(
        label: Text(text),
        backgroundColor: const Color(0xFF1c2426),
        labelStyle: const TextStyle(color: Colors.white),
        side: const BorderSide(color: Color(0xFF293438)),
        onPressed: () {
          _searchController.text = text;
          setState(() {
            _searchQuery = text;
          });
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_selectedType == 'Events') {
      return StreamBuilder<List<Event>>(
        stream: EventService().eventListStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
          }
          var events = snapshot.data ?? [];
          events = events.where((e) => e.isApproved == true).toList();
          if (_selectedCategory != 'All') {
            events = events.where((e) => (e.tags?.contains(_selectedCategory) ?? false)).toList();
          }
          if (_searchQuery.isNotEmpty) {
            events = events.where((e) => e.title.toLowerCase().contains(_searchQuery.toLowerCase()) || (e.description.toLowerCase().contains(_searchQuery.toLowerCase()))).toList();
          }
          if (events.isEmpty) {
            return const Center(child: Text('No events found.', style: TextStyle(color: Color(0xFF9db2b8))));
          }
          return ListView.separated(
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final event = events[i];
              return Card(
                color: const Color(0xFF1c2426),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      event.imageUrl ?? '',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: const Color(0xFF293438),
                        child: const Icon(Icons.event, color: Color(0xFF47c1ea), size: 32),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(event.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      StatusChip(
                        label: event.isApproved == true
                            ? 'Approved'
                            : event.isApproved == false
                                ? 'Pending'
                                : 'Rejected',
                        color: event.isApproved == true
                            ? const Color(0xFF47c1ea)
                            : event.isApproved == false
                                ? Colors.orangeAccent
                                : Colors.redAccent,
                      ),
                    ],
                  ),
                  subtitle: Text(event.location, style: const TextStyle(color: Color(0xFF9db2b8))),
                  onTap: () => GoRouter.of(context).go('/event/${event.id}'),
                ),
              );
            },
          );
        },
      );
    } else {
      return StreamBuilder<List<Club>>(
        stream: ClubService().clubListStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
          }
          var clubs = snapshot.data ?? [];
          if (_selectedCategory != 'All') {
            clubs = clubs.where((c) => (c.category ?? '').toLowerCase() == _selectedCategory.toLowerCase()).toList();
          }
          if (_searchQuery.isNotEmpty) {
            clubs = clubs.where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()) || c.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
          }
          if (clubs.isEmpty) {
            return const Center(child: Text('No clubs found.', style: TextStyle(color: Color(0xFF9db2b8))));
          }
          return ListView.separated(
            itemCount: clubs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final club = clubs[i];
              return Card(
                color: const Color(0xFF1c2426),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const Icon(Icons.group, color: Color(0xFF47c1ea)),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(club.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      // Optionally show membership chip if user is logged in
                    ],
                  ),
                  subtitle: club.description.isNotEmpty
                      ? Text(club.description, style: const TextStyle(color: Color(0xFF9db2b8)))
                      : null,
                  onTap: () => GoRouter.of(context).go('/community'), // Or navigate to club details if available
                ),
              );
            },
          );
        },
      );
    }
  }
} 