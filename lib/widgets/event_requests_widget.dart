import 'package:flutter/material.dart';
import '../services/event_service.dart';
import '../models/event.dart';
import '../main.dart';

class EventRequestsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: EventService().eventListStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
        }
        final events = (snapshot.data ?? []).where((e) => e.isApproved == false).toList();
        if (events.isEmpty) {
          return const Center(
            child: Text('No pending event requests.', style: TextStyle(color: Color(0xFF9db2b8), fontSize: 18)),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) {
            final event = events[i];
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1c2426),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF47c1ea).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: const Color(0xFF47c1ea), width: 1.2),
              ),
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
                title: Text(event.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(event.location, style: const TextStyle(color: Color(0xFF9db2b8), fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(_formatDateTime(event.startTime, event.endTime), style: const TextStyle(color: Color(0xFF47c1ea), fontSize: 12)),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Color(0xFF47c1ea)),
                      tooltip: 'Approve',
                      onPressed: () async {
                        await EventService().updateEvent(event.id, {'isApproved': true});
                        showNeonSnackbar(context, 'Event approved!');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      tooltip: 'Reject',
                      onPressed: () async {
                        await EventService().deleteEvent(event.id);
                        showNeonSnackbar(context, 'Event rejected!', error: true);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDateTime(DateTime start, DateTime end) {
    final date = '${start.day}/${start.month}/${start.year}';
    final startTime = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final endTime = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$date, $startTime - $endTime';
  }
} 