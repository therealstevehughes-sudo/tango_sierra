const _months = [
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

// Extracted from manager_screen.dart (Sprint 031) when the manager log
// filter needed the same day formatting for its Date dropdown/group
// headers — genuinely shared, not just similar, so pulled out rather than
// duplicated.
String formatDate(DateTime dateTime) {
  return '${dateTime.day} ${_months[dateTime.month - 1]} ${dateTime.year}';
}

String formatDateTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '${formatDate(dateTime)} $hour:$minute';
}
