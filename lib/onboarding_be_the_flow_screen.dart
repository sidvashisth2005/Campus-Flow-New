import 'package:flutter/material.dart';

class OnboardingBeTheFlowScreen extends StatelessWidget {
  const OnboardingBeTheFlowScreen({Key? key}) : super(key: key);

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
                          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC8rQ_qf412vUCD8cZ372bJkMzcwPxCZpIDKGYJm1r0AV5EbzWPDKXXDd4GnD34tZkg_kKlb-QeyECDjGe_StM4GvVMzfioBNKZR5sZBRemiS9xxjpMd41Z-XoiE-Covq7V3o-4jszWt6XKVTHLpUQUJSb5ct1Q6nb4ana1Qp4bSLphJZiOfwBo-jsnd7wLnNUKyJM1FU9l1x14RTEQ6vepXVviiSAYI9xCZppNQAKK8GiLx3xiOZBDLsTIJ96mUTsvjwUjBDkXxKrJ'),
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
                    'Be the Flow',
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
                      child: const Text('Get Started', overflow: TextOverflow.ellipsis),
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