import 'package:flutter/material.dart';
import 'services/event_service.dart';
import 'models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'widgets/status_chip.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Pending', 'Approved', 'Owned'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111618),
        elevation: 0,
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF47c1ea),
          labelColor: const Color(0xFF47c1ea),
          unselectedLabelColor: Colors.white,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _EventList(filter: (e) => e.isApproved == false),
          _EventList(filter: (e) => e.isApproved == true),
          _EventList(filter: (e) => true), // All events for now
        ],
      ),
    );
  }
}

class _EventList extends StatelessWidget {
  final bool Function(Event) filter;
  const _EventList({required this.filter});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: EventService().eventListStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
        }
        final events = (snapshot.data ?? []).where(filter).toList();
        if (events.isEmpty) {
          return const Center(child: Text('No events found.', style: TextStyle(color: Colors.white70, fontSize: 18)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) {
            final event = events[i];
            return _AdminEventCard(event: event);
          },
        );
      },
    );
  }
}

class _AdminEventCard extends StatelessWidget {
  final Event event;
  const _AdminEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: event.isApproved == true
          ? () async {
              await Future.delayed(const Duration(seconds: 2));
              showDialog(
                context: context,
                builder: (context) => _EventActionDialog(event: event),
              );
            }
          : null,
      child: Container(
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
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
          trailing: event.isApproved == false
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Color(0xFF47c1ea)),
                      onPressed: () async {
                        await EventService().updateEvent(event.id, {'isApproved': true});
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      onPressed: () async {
                        await EventService().deleteEvent(event.id);
                      },
                    ),
                  ],
                )
              : null,
          onTap: () {},
        ),
      ),
    );
  }
}

class _EventActionDialog extends StatelessWidget {
  final Event event;
  const _EventActionDialog({required this.event});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1c2426),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(event.title, style: const TextStyle(color: Color(0xFF47c1ea), fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF47c1ea),
              foregroundColor: const Color(0xFF111618),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.schedule),
            label: const Text('Reschedule'),
            onPressed: () async {
              final result = await showDialog<Map<String, DateTime>>(
                context: context,
                builder: (context) => _RescheduleDialog(event: event),
              );
              if (result != null) {
                await EventService().updateEvent(event.id, {
                  'startTime': Timestamp.fromDate(result['start']!),
                  'endTime': Timestamp.fromDate(result['end']!),
                  'updatedAt': Timestamp.now(),
                });
                Navigator.of(context).pop();
                showNeonSnackbar(context, 'Event rescheduled!');
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.close),
            label: const Text('Reject'),
            onPressed: () async {
              await EventService().updateEvent(event.id, {'isApproved': false});
              Navigator.of(context).pop();
              showNeonSnackbar(context, 'Event moved to pending');
            },
          ),
        ],
      ),
    );
  }
}

class _RescheduleDialog extends StatefulWidget {
  final Event event;
  const _RescheduleDialog({required this.event});

  @override
  State<_RescheduleDialog> createState() => _RescheduleDialogState();
}

class _RescheduleDialogState extends State<_RescheduleDialog> {
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    super.initState();
    _start = widget.event.startTime;
    _end = widget.event.endTime;
  }

  Future<void> _pickStart() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_start),
    );
    if (time == null) return;
    setState(() {
      _start = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (_end.isBefore(_start)) {
        _end = _start.add(const Duration(hours: 1));
      }
    });
  }

  Future<void> _pickEnd() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _end,
      firstDate: _start,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_end),
    );
    if (time == null) return;
    setState(() {
      _end = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (_end.isBefore(_start)) {
        _end = _start.add(const Duration(hours: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1c2426),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Reschedule Event', style: TextStyle(color: Color(0xFF47c1ea), fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Start', style: TextStyle(color: Colors.white)),
            subtitle: Text('${_start.year}-${_start.month.toString().padLeft(2, '0')}-${_start.day.toString().padLeft(2, '0')}  ${_start.hour.toString().padLeft(2, '0')}:${_start.minute.toString().padLeft(2, '0')}', style: const TextStyle(color: Color(0xFF47c1ea))),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF47c1ea)),
              onPressed: _pickStart,
            ),
          ),
          ListTile(
            title: const Text('End', style: TextStyle(color: Colors.white)),
            subtitle: Text('${_end.year}-${_end.month.toString().padLeft(2, '0')}-${_end.day.toString().padLeft(2, '0')}  ${_end.hour.toString().padLeft(2, '0')}:${_end.minute.toString().padLeft(2, '0')}', style: const TextStyle(color: Color(0xFF47c1ea))),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF47c1ea)),
              onPressed: _pickEnd,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF9db2b8))),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF47c1ea),
            foregroundColor: const Color(0xFF111618),
          ),
          onPressed: () {
            Navigator.of(context).pop({'start': _start, 'end': _end});
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
} 