import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'services/club_service.dart';
import 'models/club.dart';
import 'create_club_screen.dart'; // Added import for CreateClubScreen
import 'club_details_screen.dart'; // Added import for ClubDetailsScreen

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final isClubSecretaryOrAdmin = user?.role == 'club_secretaries' || user?.role == 'admins';
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
              const SizedBox(height: 24),
              Expanded(
                child: StreamBuilder<List<Club>>(
                  stream: ClubService().clubListStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
                    }
                    final clubs = snapshot.data ?? [];
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
                          title: Text(
                            club.name,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 