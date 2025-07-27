import 'package:flutter/material.dart';
import 'services/event_service.dart';
import 'models/event.dart';
import 'widgets/status_chip.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;
  const EventDetailsScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111618),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Event Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: FutureBuilder<Event?>(
        future: EventService().getEvent(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Event not found.', style: TextStyle(color: Colors.white70, fontSize: 18)));
          }
          final event = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    event.imageUrl ?? '',
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: const Color(0xFF293438),
                      child: const Icon(Icons.event, color: Color(0xFF47c1ea), size: 60),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  event.title,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 8),
                Text(
                  event.location,
                  style: const TextStyle(color: Color(0xFF9db2b8), fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDateTime(event.startTime, event.endTime),
                  style: const TextStyle(color: Color(0xFF47c1ea), fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Text(
                  event.description,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(icon: Icons.bookmark_border, label: 'Save', onTap: () {}),
                    _ActionButton(icon: Icons.share, label: 'Share', onTap: () {}),
                    _ActionButton(icon: Icons.event_available, label: 'Join', onTap: () {}),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _formatDateTime(DateTime start, DateTime end) {
    final date = '${start.day}/${start.month}/${start.year}';
    final startTime = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final endTime = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$date, $startTime - $endTime';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF293438),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: const Color(0xFF47c1ea)),
      label: Text(label),
    );
  }
} 