import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/event.dart';
import 'services/event_service.dart';
import 'main.dart';
import 'package:go_router/go_router.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _location = '';
  DateTime? _startTime;
  DateTime? _endTime;
  String? _clubId;
  bool _loading = false;
  String? _error;

  // Mock club list for dropdown
  final List<Map<String, String>> _clubs = [
    {'id': 'club1', 'name': 'AI Society'},
    {'id': 'club2', 'name': 'Robotics Club'},
    {'id': 'club3', 'name': 'Music Club'},
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _clubId == null || _startTime == null || _endTime == null) return;
    setState(() { _loading = true; _error = null; });
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        description: _description,
        imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80', // mock image
        bannerUrl: null,
        location: _location,
        startTime: _startTime!,
        endTime: _endTime!,
        clubId: _clubId!,
        tags: [],
        attendeeIds: [],
        capacity: 100,
        isApproved: false,
        createdBy: auth.currentUser?.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await EventService().createEvent(event);
      if (!mounted) return;
      context.go('/events');
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111618),
        elevation: 0,
        title: const Text('Create Event', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Title'),
                  onChanged: (v) => _title = v,
                  validator: (v) => v == null || v.isEmpty ? 'Enter event title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Description'),
                  maxLines: 3,
                  onChanged: (v) => _description = v,
                  validator: (v) => v == null || v.isEmpty ? 'Enter event description' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Location'),
                  onChanged: (v) => _location = v,
                  validator: (v) => v == null || v.isEmpty ? 'Enter event location' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _clubId,
                  decoration: _inputDecoration('Club'),
                  items: _clubs.map((club) => DropdownMenuItem(
                    value: club['id'],
                    child: Text(club['name']!, style: const TextStyle(color: Colors.white)),
                  )).toList(),
                  onChanged: (v) => setState(() => _clubId = v),
                  validator: (v) => v == null ? 'Select a club' : null,
                  dropdownColor: const Color(0xFF1c2426),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _DateTimePicker(
                        label: 'Start Time',
                        value: _startTime,
                        onChanged: (dt) => setState(() => _startTime = dt),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateTimePicker(
                        label: 'End Time',
                        value: _endTime,
                        onChanged: (dt) => setState(() => _endTime = dt),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF47c1ea),
                      foregroundColor: const Color(0xFF111618),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF111618)),
                          )
                        : const Text('Create Event'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF9db2b8)),
      filled: true,
      fillColor: const Color(0xFF1c2426),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  const _DateTimePicker({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: now,
          lastDate: DateTime(now.year + 2),
          builder: (context, child) => Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF47c1ea),
                onPrimary: Color(0xFF111618),
                surface: Color(0xFF1c2426),
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: const Color(0xFF111618),
            ),
            child: child!,
          ),
        );
        if (picked != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(value ?? now),
            builder: (context, child) => Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF47c1ea),
                  onPrimary: Color(0xFF111618),
                  surface: Color(0xFF1c2426),
                  onSurface: Colors.white,
                ),
                dialogBackgroundColor: const Color(0xFF111618),
              ),
              child: child!,
            ),
          );
          if (time != null) {
            onChanged(DateTime(picked.year, picked.month, picked.day, time.hour, time.minute));
          }
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF9db2b8)),
          filled: true,
          fillColor: const Color(0xFF1c2426),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        child: Text(
          value != null ? '${value!.toLocal()}'.split('.')[0] : 'Select $label',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
} 