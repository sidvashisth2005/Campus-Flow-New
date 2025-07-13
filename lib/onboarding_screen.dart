import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111618),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
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
                            image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAIUzC0MuXkehM_rT4I30kLX9V_bSNrijUhOis4I6BiFn0DAwN-V27W9-0WQlLxm_-l6y8_iqhawr9cKqHCG3_UH0CXBe_eReS90Y4-ses-vGh0GY3wN1Y-iUuMF9a9Q7kKU68M91urh_hFkHilP8RtfkU-wSis-bjDlL5KQVukjFQlZlg7DwDapSkP_REpVANKUZ0ZYlfR8wCjinCg87IbG09Wvo1OV0gZmKBHydpA6ZR-aFzKz7r5QwFNriLOY6Et8IhcSZlfCgZ9'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Explore Events',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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
                        child: const Text('Sign up', overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _OnboardingDot(active: true),
                      SizedBox(width: 12),
                      _OnboardingDot(active: false),
                      SizedBox(width: 12),
                      _OnboardingDot(active: false),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
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