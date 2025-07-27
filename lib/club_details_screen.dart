import 'package:flutter/material.dart';
import 'services/club_service.dart';
import 'models/club.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'services/user_service.dart';
import 'models/app_user.dart';
import 'widgets/status_chip.dart';

class ClubDetailsScreen extends StatelessWidget {
  final String clubId;
  const ClubDetailsScreen({Key? key, required this.clubId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
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
          title: const Text('Club Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        body: FutureBuilder<Club?>(
          future: ClubService().getClub(clubId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Club not found.', style: TextStyle(color: Colors.white70, fontSize: 18)));
            }
            final club = snapshot.data!;
            final isMember = user != null && (club.memberIds?.contains(user.id) ?? false);
            return FutureBuilder<List<AppUser>>(
              future: _getMembers(club.memberIds ?? []),
              builder: (context, memberSnapshot) {
                final members = memberSnapshot.data ?? [];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF47c1ea), width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            club.imageUrl ?? '',
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 180,
                              color: const Color(0xFF293438),
                              child: const Icon(Icons.group, color: Color(0xFF47c1ea), size: 60),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        club.name,
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (user != null)
                        StatusChip(
                          label: (user.clubIds ?? []).contains(club.id) ? 'Member' : 'Not a Member',
                          color: (user.clubIds ?? []).contains(club.id) ? const Color(0xFF47c1ea) : Colors.grey,
                        ),
                      if (club.category != null && club.category!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF47c1ea),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            club.category!,
                            style: const TextStyle(color: Color(0xFF111618), fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        club.description,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isMember ? const Color(0xFF293438) : const Color(0xFF47c1ea),
                          foregroundColor: isMember ? Colors.white : const Color(0xFF111618),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: isMember || user == null ? null : () async {
                          try {
                            final updatedMemberIds = List<String>.from(club.memberIds ?? []);
                            updatedMemberIds.add(user.id);
                            await ClubService().updateClub(club.id, {'memberIds': updatedMemberIds});
                            // Also update user's clubIds
                            final updatedClubIds = List<String>.from(user.clubIds ?? []);
                            if (!updatedClubIds.contains(club.id)) {
                              updatedClubIds.add(club.id);
                              await UserService().updateUser(user.id, {'clubIds': updatedClubIds});
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Joined club!'), backgroundColor: Color(0xFF47c1ea)),
                            );
                            (context as Element).reassemble();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to join: $e'), backgroundColor: Colors.red),
                            );
                          }
                        },
                        child: Text(isMember ? 'Joined' : 'Join'),
                      ),
                      const SizedBox(height: 16),
                      if (members.isNotEmpty) ...[
                        const Text('Members:', style: TextStyle(color: Color(0xFF9db2b8), fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ...members.map((m) => Text(m.name, style: const TextStyle(color: Colors.white, fontSize: 15))),
                        const SizedBox(height: 16),
                      ],
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Members: ${club.memberIds?.length ?? 0}',
                            style: const TextStyle(color: Color(0xFF9db2b8), fontSize: 14),
                          ),
                          Text(
                            'Events: ${club.eventIds?.length ?? 0}',
                            style: const TextStyle(color: Color(0xFF9db2b8), fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Helper to get member AppUser objects
Future<List<AppUser>> _getMembers(List<String> memberIds) async {
  if (memberIds.isEmpty) return [];
  final userService = UserService();
  final List<AppUser> members = [];
  for (final id in memberIds) {
    final user = await userService.getUser(id);
    if (user != null) members.add(user);
  }
  return members;
} 