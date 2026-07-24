import 'package:flutter/material.dart';
import 'task_log_model.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  List<TaskLogEntry> entries = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  void loadEntries() {
    setState(() {
      entries = TaskLogStore.getEntries();
    });
  }

  Map<String, List<TaskLogEntry>> groupEntriesByStaff(
    List<TaskLogEntry> items,
  ) {
    final Map<String, List<TaskLogEntry>> grouped = {};

    for (final entry in items) {
      grouped.putIfAbsent(entry.completedBy, () => []);
      grouped[entry.completedBy]!.add(entry);
    }

    return grouped;
  }

  String formatDateTime(DateTime dateTime) {
    const months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day $month $year $hour:$minute';
  }

  String buildLogLine(TaskLogEntry entry) {
    final symbol = entry.status == 'PASS' ? '✓' : '✗';
    final statusText = entry.status == 'PASS' ? 'Pass' : 'Fail';
    final photoText = entry.photoAttached ? ' 📷' : '';

    return '$symbol ${entry.taskTitle} (${formatDateTime(entry.completedAt)}) - $statusText$photoText';
  }

  @override
  Widget build(BuildContext context) {
    final groupedEntries = groupEntriesByStaff(entries);
    final staffNames = groupedEntries.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Manager View')),
      body: entries.isEmpty
          ? const Center(child: Text('No completed tasks logged yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: staffNames.length,
              itemBuilder: (context, index) {
                final staffName = staffNames[index];
                final staffEntries = groupedEntries[staffName]!;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staffName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...staffEntries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            buildLogLine(entry),
                            style: const TextStyle(fontSize: 14, height: 1.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
