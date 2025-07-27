import 'package:flutter/material.dart';
import '../services/timetable_service.dart';
import '../models/timetable.dart';

class TimetableWidget extends StatefulWidget {
  const TimetableWidget({Key? key}) : super(key: key);

  @override
  State<TimetableWidget> createState() => _TimetableWidgetState();
}

class _TimetableWidgetState extends State<TimetableWidget> {
  String? selectedType; // 'year', 'lecture_theater', 'classroom'
  String? selectedValue; // year number, LT number, CR number
  final TimetableService _timetableService = TimetableService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const Text(
            'Timetable & Maps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Main selection buttons
          if (selectedType == null) ...[
            _buildMainSelectionButtons(),
          ] else ...[
            // Back button
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedType = null;
                      selectedValue = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF47c1ea)),
                ),
                Text(
                  _getTypeTitle(selectedType!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Sub-selection options
            if (selectedValue == null) ...[
              _buildSubSelectionOptions(),
            ] else ...[
              // Back to sub-selection
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedValue = null;
                      });
                    },
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF47c1ea)),
                  ),
                  Text(
                    _getValueTitle(selectedType!, selectedValue!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Timetable content
              _buildTimetableContent(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildMainSelectionButtons() {
    return Column(
      children: [
        _buildSelectionButton(
          'Year-wise Timetable',
          Icons.school,
          () => setState(() => selectedType = 'year'),
        ),
        const SizedBox(height: 8),
        _buildSelectionButton(
          'Lecture Theater Timetable',
          Icons.meeting_room,
          () => setState(() => selectedType = 'lecture_theater'),
        ),
        const SizedBox(height: 8),
        _buildSelectionButton(
          'Classroom Timetable',
          Icons.class_,
          () => setState(() => selectedType = 'classroom'),
        ),
      ],
    );
  }

  Widget _buildSelectionButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF47c1ea).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF47c1ea),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF47c1ea),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubSelectionOptions() {
    if (selectedType == 'year') {
      return Column(
        children: List.generate(4, (index) {
          final year = index + 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildSubSelectionButton(
              'Year $year',
              () => setState(() => selectedValue = year.toString()),
            ),
          );
        }),
      );
    } else if (selectedType == 'lecture_theater') {
      return SizedBox(
        height: 180,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemCount: 20,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final ltNumber = index + 1;
            return _buildGridButton(
              'LT$ltNumber',
              () => setState(() => selectedValue = 'LT$ltNumber'),
            );
          },
        ),
      );
    } else if (selectedType == 'classroom') {
      return SizedBox(
        height: 180,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemCount: 30,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final crNumber = index + 1;
            return _buildGridButton(
              'CR$crNumber',
              () => setState(() => selectedValue = 'CR$crNumber'),
            );
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSubSelectionButton(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1c2426),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF293438)),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF47c1ea),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1c2426),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF293438)),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimetableContent() {
    // Determine Firestore query based on selectedType/selectedValue
    if (selectedType == null || selectedValue == null) {
      return const SizedBox.shrink();
    }
    // For demo: assume 'room' field is used for LT/CR, and 'year' is in description or subject
    Stream<List<TimetableEntry>> stream;
    if (selectedType == 'year') {
      stream = _timetableService.getTimetableStream();
    } else if (selectedType == 'lecture_theater' || selectedType == 'classroom') {
      stream = _timetableService.getTimetableStream();
    } else {
      return const SizedBox.shrink();
    }
    return StreamBuilder<List<TimetableEntry>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF47c1ea)));
        }
        final entries = (snapshot.data ?? []).where((entry) {
          if (selectedType == 'year') {
            // Try to match year in subject or description
            return entry.subject.contains(selectedValue!) || (entry.description?.contains(selectedValue!) ?? false);
          } else if (selectedType == 'lecture_theater') {
            return entry.room == selectedValue;
          } else if (selectedType == 'classroom') {
            return entry.room == selectedValue;
          }
          return false;
        }).toList();
        if (entries.isEmpty) {
          // Show a static demo timetable as a placeholder
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Monday', style: const TextStyle(color: Color(0xFF47c1ea), fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                },
                border: TableBorder.all(color: const Color(0xFF293438)),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFF1c2426)),
                    children: const [
                      Padding(padding: EdgeInsets.all(8), child: Text('Time', style: TextStyle(color: Color(0xFF47c1ea), fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.all(8), child: Text('Subject', style: TextStyle(color: Color(0xFF47c1ea), fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.all(8), child: Text('Room', style: TextStyle(color: Color(0xFF47c1ea), fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.all(8), child: Text('Teacher', style: TextStyle(color: Color(0xFF47c1ea), fontWeight: FontWeight.bold))),
                    ],
                  ),
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFF111618)),
                    children: [
                      Padding(padding: EdgeInsets.all(8), child: Text('9:00-10:00', style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text('Math', style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text('LT1', style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text('Dr. Smith', style: TextStyle(color: Colors.white))),
                    ],
                  ),
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFF111618)),
                    children: [
                      Padding(padding: EdgeInsets.all(8), child: Text('10:00-11:00', style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text('Physics', style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text('LT2', style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text('Dr. Jane', style: TextStyle(color: Colors.white))),
                    ],
                  ),
                ],
              ),
            ],
          );
        }
        // Group by day
        final days = entries.map((e) => e.day).toSet().toList()..sort();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: days.map((day) {
            final dayEntries = entries.where((e) => e.day == day).toList()..sort((a, b) => a.timeSlot.compareTo(b.timeSlot));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(day, style: const TextStyle(color: Color(0xFF47c1ea), fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                  },
                  border: TableBorder.all(color: const Color(0xFF293438)),
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFF1c2426)),
                      children: const [
                        Padding(padding: EdgeInsets.all(8), child: Text('Time', style: TextStyle(color: Color(0xFF47c1ea), fontWeight: FontWeight.bold))),
                        Padding(padding: EdgeInsets.all(8), child: Text('Subject', style: TextStyle(color: Color(0xFF47c1ea), fontWeight: FontWeight.bold))),
                        Padding(padding: EdgeInsets.all(8), child: Text('Room', style: TextStyle(color: Color(0xFF47c1ea), fontWeight: FontWeight.bold))),
                        Padding(padding: EdgeInsets.all(8), child: Text('Teacher', style: TextStyle(color: Color(0xFF47c1ea), fontWeight: FontWeight.bold))),
                      ],
                    ),
                    ...dayEntries.map((entry) => TableRow(
                      decoration: const BoxDecoration(color: Color(0xFF111618)),
                      children: [
                        Padding(padding: EdgeInsets.all(8), child: Text(entry.timeSlot, style: const TextStyle(color: Colors.white))),
                        Padding(padding: EdgeInsets.all(8), child: Text(entry.subject, style: const TextStyle(color: Colors.white))),
                        Padding(padding: EdgeInsets.all(8), child: Text(entry.room, style: const TextStyle(color: Colors.white))),
                        Padding(padding: EdgeInsets.all(8), child: Text(entry.teacher, style: const TextStyle(color: Colors.white))),
                      ],
                    )),
                  ],
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  String _getTypeTitle(String type) {
    switch (type) {
      case 'year':
        return 'Year-wise Timetable';
      case 'lecture_theater':
        return 'Lecture Theater Timetable';
      case 'classroom':
        return 'Classroom Timetable';
      default:
        return 'Timetable';
    }
  }

  String _getValueTitle(String type, String value) {
    switch (type) {
      case 'year':
        return 'Year $value';
      case 'lecture_theater':
        return value; // LT1, LT2, etc.
      case 'classroom':
        return value; // CR1, CR2, etc.
      default:
        return value;
    }
  }
} 