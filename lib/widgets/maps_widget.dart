import 'package:flutter/material.dart';

class MapsWidget extends StatelessWidget {
  const MapsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1c2426),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF293438)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF47c1ea).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF293438)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.map,
                  color: const Color(0xFF47c1ea),
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Campus Maps',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Map placeholder
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF293438),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF47c1ea).withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 48,
                      color: const Color(0xFF47c1ea).withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Campus Map',
                      style: TextStyle(
                        color: Color(0xFF9db2b8),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Interactive campus map\nwill be displayed here',
                      style: TextStyle(
                        color: Color(0xFF9db2b8),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF47c1ea).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF47c1ea),
                        ),
                      ),
                      child: const Text(
                        'Coming Soon',
                        style: TextStyle(
                          color: Color(0xFF47c1ea),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 