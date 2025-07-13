import 'package:flutter/material.dart';

class OnboardingJoinClubsScreen extends StatelessWidget {
  const OnboardingJoinClubsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111618),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _OnboardingDot(active: false),
                    SizedBox(width: 12),
                    _OnboardingDot(active: true),
                    SizedBox(width: 12),
                    _OnboardingDot(active: false),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF111618),
                        image: DecorationImage(
                          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAwHUXJcvukhUPsgZ524FrfERpMHDT4o2fu6RjOUn0gLNxlL1rF2r6o8zcg5q0P3kwMuw1uIXqNzghx4enOM-_sa-vkTYenWqhizts5xDPBaOSBbORD_-aGFlXWH4u3BhVeNuWbhITgpBF2LpFWc1WgctlJKdzRXHe6JAu6HqGsA5KWlHsAckde1UnspwxpFYphR5ZzJ04_6TqQWUIgABkAuONhonVE-i1vU5rSRdyDwvE2AX6dCyFkU_EJq__nGc0T0r9irE9ZqPiY'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Join Clubs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Explore a wide range of student organizations and find your community.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0cb9f2),
                        foregroundColor: const Color(0xFF111618),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.2,
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Text('Continue with Google', overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingDot extends StatelessWidget {
  final bool active;
  const _OnboardingDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? Colors.white : const Color(0xFF3b4e54),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
} 