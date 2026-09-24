import 'dart:convert';

/// Generic extra fields (2026-09-24, direct user request) — a manager can
/// attach a short list of reference fields to any task template (e.g. "PO
/// number", "batch/lot number", "quantity received") instead of one-off
/// special-cased columns per task type. See app_database.dart's
/// TaskTemplates.extraFieldsJson doc comment for the storage shape.
enum TaskExtraFieldType { text, number, date }

TaskExtraFieldType _typeFromString(String value) {
  return TaskExtraFieldType.values.firstWhere(
    (t) => t.name == value,
    orElse: () => TaskExtraFieldType.text,
  );
}

class TaskExtraFieldDef {
  const TaskExtraFieldDef({
    required this.key,
    required this.label,
    required this.type,
  });

  final String key;
  final String label;
  final TaskExtraFieldType type;

  Map<String, dynamic> toJson() => {
    'key': key,
    'label': label,
    'type': type.name,
  };

  factory TaskExtraFieldDef.fromJson(Map<String, dynamic> json) {
    return TaskExtraFieldDef(
      key: json['key'] as String,
      label: json['label'] as String,
      type: _typeFromString(json['type'] as String? ?? 'text'),
    );
  }
}

/// Parses TaskTemplates.extraFieldsJson. Defensive: a malformed or
/// unexpected shape (e.g. a future format this version doesn't know
/// about) yields an empty list rather than crashing the task screen -
/// same fail-open principle used everywhere else optional task metadata
/// is parsed.
List<TaskExtraFieldDef> parseExtraFieldDefs(String? json) {
  if (json == null || json.trim().isEmpty) return const [];
  try {
    final decoded = jsonDecode(json);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(TaskExtraFieldDef.fromJson)
        .toList();
  } catch (_) {
    return const [];
  }
}

String encodeExtraFieldDefs(List<TaskExtraFieldDef> defs) {
  return jsonEncode(defs.map((d) => d.toJson()).toList());
}

/// Parses TaskSubmissions.extraFieldValuesJson — a plain string map keyed
/// by each field's `key`.
Map<String, String> parseExtraFieldValues(String? json) {
  if (json == null || json.trim().isEmpty) return const {};
  try {
    final decoded = jsonDecode(json);
    if (decoded is! Map) return const {};
    return decoded.map((k, v) => MapEntry(k as String, v.toString()));
  } catch (_) {
    return const {};
  }
}

String encodeExtraFieldValues(Map<String, String> values) {
  return jsonEncode(values);
}
