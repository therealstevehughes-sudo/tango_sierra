// Task training guides (2026-10-15, direct founder request) — the "How to
// do this correctly" screen behind every task on the carousel. A guide is a
// short numbered set of action steps plus two one-liners: why the check
// matters, and what to do if it fails. Deliberately small — this is a
// refresher a worker reads in 30 seconds mid-shift, not a training course.
//
// Every task has a standard guide (task_training_guide_data.dart, keyed by
// template title, with a built-from-the-task fallback for custom tasks).
// A venue manager can replace it with their own version for their site
// (different venues, different kit and house rules) — that override lives
// server-side in `task_training_guides`, see TaskTrainingGuideRepository.
class TaskTrainingGuide {
  const TaskTrainingGuide({
    required this.steps,
    this.whyItMatters,
    this.ifItFails,
  });

  final List<String> steps;
  final String? whyItMatters;
  final String? ifItFails;

  factory TaskTrainingGuide.fromJson(Map<String, dynamic> json) =>
      TaskTrainingGuide(
        steps: (json['steps'] as List<dynamic>? ?? const [])
            .map((s) => s.toString())
            .where((s) => s.trim().isNotEmpty)
            .toList(),
        whyItMatters: _blankToNull(json['why_it_matters'] as String?),
        ifItFails: _blankToNull(json['if_it_fails'] as String?),
      );

  Map<String, dynamic> toJson() => {
    'steps': steps,
    'why_it_matters': whyItMatters,
    'if_it_fails': ifItFails,
  };
}

/// A venue's own version of a task's guide, as stored server-side.
class VenueTrainingGuide {
  const VenueTrainingGuide({
    required this.siteId,
    required this.templateGroupId,
    required this.guide,
    this.updatedAt,
  });

  final int siteId;
  final int templateGroupId;
  final TaskTrainingGuide guide;
  final DateTime? updatedAt;
}

String? _blankToNull(String? s) =>
    (s == null || s.trim().isEmpty) ? null : s.trim();
