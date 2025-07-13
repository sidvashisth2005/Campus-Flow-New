import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
                  hintText: 'Search events, clubs, or people...',
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
    // Placeholder for search results
    return const Center(
      child: Text(
        'Search results will appear here',
        style: TextStyle(color: Color(0xFF9db2b8)),
      ),
    );
  }
} 