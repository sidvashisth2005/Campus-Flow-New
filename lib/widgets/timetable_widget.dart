import 'package:flutter/material.dart';
import '../services/timetable_service.dart';
import '../models/timetable.dart';

class TimetableWidget extends StatefulWidget {
  final void Function(bool open)? onTimetableOpenChanged;
  const TimetableWidget({Key? key, this.onTimetableOpenChanged}) : super(key: key);

  @override
  State<TimetableWidget> createState() => _TimetableWidgetState();
}

class _TimetableWidgetState extends State<TimetableWidget> {
  String? selectedType; // 'year', 'lecture_theater', 'classroom'
  String? selectedValue; // year number, LT number, CR number
  final TimetableService _timetableService = TimetableService();

  void _notifyOpenChanged() {
    if (widget.onTimetableOpenChanged != null) {
      widget.onTimetableOpenChanged!(selectedType != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyOpenChanged());
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1c2426),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF293438)),
      ),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          // Header with day tabs
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF293438)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: const Color(0xFF47c1ea),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Timetable for ${_getValueTitle(selectedType!, selectedValue!)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Placeholder content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  size: 64,
                  color: const Color(0xFF47c1ea).withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Timetable Coming Soon',
                  style: TextStyle(
                    color: const Color(0xFF9db2b8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload timetable data via Firebase\nor JSON file to view schedule',
                  style: TextStyle(
                    color: const Color(0xFF9db2b8).withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
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