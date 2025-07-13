import 'package:flutter/material.dart';
import 'services/event_service.dart';
import 'models/event.dart';
import 'package:go_router/go_router.dart';
import 'widgets/timetable_widget.dart';
import 'widgets/maps_widget.dart';
import 'widgets/event_requests_widget.dart';

class EventDiscoveryScreen extends StatelessWidget {
  const EventDiscoveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111618),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111618),
          elevation: 0,
          title: const Text('Events', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: StreamBuilder<List<Event>>(
          stream: EventService().eventListStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
            }
            final events = snapshot.data ?? [];
            if (events.isEmpty) {
              return const Center(
                child: Text('No events found.', style: TextStyle(color: Colors.white70, fontSize: 18)),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final event = events[i];
                return _EventCard(event: event);
              },
            );
          },
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).go('/event/${event.id}'),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                event.imageUrl ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: const Color(0xFF293438),
                  child: const Icon(Icons.event, color: Color(0xFF47c1ea), size: 40),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.location,
                      style: const TextStyle(color: Color(0xFF9db2b8), fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDateTime(event.startTime, event.endTime),
                      style: const TextStyle(color: Color(0xFF47c1ea), fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _timetableOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTimetableOpenChanged(bool open) {
    setState(() {
      _timetableOpen = open;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to home instead of closing app
        context.go('/home');
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111618),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111618),
          elevation: 0,
          title: const Text('Events', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Navigate back to home
              context.go('/home');
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF47c1ea),
            labelColor: const Color(0xFF47c1ea),
            unselectedLabelColor: Colors.white,
            tabs: const [
              Tab(text: 'Time Table & Maps'),
              Tab(text: 'Event Requests'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Time Table & Maps
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TimetableWidget(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MapsWidget(),
                  ),
                ],
              ),
            ),
            // Tab 2: Event Requests
            EventRequestsWidget(),
          ],
        ),
      ),
    );
  }
} 