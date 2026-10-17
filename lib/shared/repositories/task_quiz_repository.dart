import '../../core/network/backend_rest_client.dart';
import '../../features/tasks/training/task_training_guide.dart';
import '../../features/tasks/training/training_progress.dart';

// Training quizzes (2026-10-17, founder-approved). Everything that knows a
// right answer stays on the server (tools/training_quiz_migration.sql):
// the app gets three questions with shuffled options, sends back the
// chosen positions, and is told only whether that passed.

class QuizQuestion {
  const QuizQuestion({required this.number, required this.text, required this.options});

  final int number;
  final String text;
  final List<String> options;
}

class QuizAttempt {
  const QuizAttempt({required this.attemptId, required this.questions});

  final int attemptId;
  final List<QuizQuestion> questions;
}

class QuizResult {
  const QuizResult({
    required this.passed,
    required this.correct,
    required this.total,
    required this.wrongQuestions,
  });

  final bool passed;
  final int correct;
  final int total;

  /// Question numbers answered wrongly (never which answer was right).
  final List<int> wrongQuestions;
}

/// Which tasks at a site have a quiz: venue-approved questions by task,
/// otherwise the standard bank by task title.
class QuizAvailability {
  const QuizAvailability({
    required this.venueLiveByTask,
    required this.venuePendingByTask,
    required this.standardByTitle,
  });

  const QuizAvailability.none()
    : venueLiveByTask = const {},
      venuePendingByTask = const {},
      standardByTitle = const {};

  final Map<int, int> venueLiveByTask;
  final Map<int, int> venuePendingByTask;
  final Map<String, int> standardByTitle;

  bool usesVenueQuestions(int templateGroupId) =>
      (venueLiveByTask[templateGroupId] ?? 0) > 0;

  bool hasQuiz(int templateGroupId, String title) =>
      usesVenueQuestions(templateGroupId)
      ? venueLiveByTask[templateGroupId]! >= 3
      : (standardByTitle[title] ?? 0) >= 3;

  int pendingFor(int templateGroupId) =>
      venuePendingByTask[templateGroupId] ?? 0;
}

class RefreshMonths {
  const RefreshMonths({this.critical = 3, this.other = 6});

  final int critical;
  final int other;

  int forTask({required bool isCritical}) => isCritical ? critical : other;
}

/// A venue's own question, as a manager reviews it (right answer first).
class VenueQuizQuestion {
  const VenueQuizQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.isPending,
  });

  final int id;
  final String text;
  final List<String> options;
  final bool isPending;

  String get rightAnswer => options.first;
}

/// The retry rule: the guide must be read again after a fail.
class QuizRereadRequired implements Exception {
  const QuizRereadRequired();
}

abstract class TaskQuizRepository {
  Future<QuizAvailability> availabilityForSite(int siteId);

  Future<List<QuizPass>> passesForSite(int siteId);

  Future<RefreshMonths> refreshMonths(int siteId);

  Future<void> setRefreshMonths(int siteId, RefreshMonths months);

  /// Null when the task has no quiz yet. Throws [QuizRereadRequired] when
  /// the last attempt failed and the guide hasn't been read since.
  Future<QuizAttempt?> start({
    required int siteId,
    required int templateGroupId,
    required String taskTitle,
    required String guideVersion,
    required int userId,
  });

  /// [answers] = the chosen option (0-based) per question, in order.
  Future<QuizResult> submit({required int attemptId, required List<int> answers});

  /// Asks VenuRite's AI for fresh questions from [guide]; they're stored
  /// as pending until a manager approves them. Returns how many.
  Future<int> draftVenueQuestions({
    required int siteId,
    required int templateGroupId,
    required String taskTitle,
    required TaskTrainingGuide guide,
    required String guideVersion,
  });

  Future<List<VenueQuizQuestion>> venueQuestions({
    required int siteId,
    required int templateGroupId,
  });

  /// Approve (keeping [keepIds], or all pending) or reject the drafts.
  Future<void> decideDrafts({
    required int siteId,
    required int templateGroupId,
    required bool approve,
    List<int>? keepIds,
    required int userId,
  });
}

class SupabaseTaskQuizRepository implements TaskQuizRepository {
  SupabaseTaskQuizRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<QuizAvailability> availabilityForSite(int siteId) async {
    final rows = await _client.rpc('task_quiz_availability', {
      'p_site_id': siteId,
    });
    final venueLive = <int, int>{};
    final venuePending = <int, int>{};
    final standard = <String, int>{};
    for (final row in rows) {
      final group = row['template_group_id'] as int?;
      if (group != null) {
        venueLive[group] = row['live_count'] as int? ?? 0;
        venuePending[group] = row['pending_count'] as int? ?? 0;
      } else if (row['task_title'] is String) {
        standard[row['task_title'] as String] = row['live_count'] as int? ?? 0;
      }
    }
    return QuizAvailability(
      venueLiveByTask: venueLive,
      venuePendingByTask: venuePending,
      standardByTitle: standard,
    );
  }

  @override
  Future<List<QuizPass>> passesForSite(int siteId) async {
    final rows = await _client.select(
      'quiz_passes',
      query: 'site_id=eq.$siteId',
    );
    return [
      for (final row in rows)
        QuizPass(
          userId: row['user_id'] as int,
          siteId: row['site_id'] as int,
          templateGroupId: row['template_group_id'] as int,
          guideVersion: row['guide_version'] as String,
          passedAt: DateTime.parse(row['passed_at'] as String),
        ),
    ];
  }

  @override
  Future<RefreshMonths> refreshMonths(int siteId) async {
    final rows = await _client.select(
      'sites',
      query:
          'id=eq.$siteId'
          '&select=training_refresh_critical_months,training_refresh_other_months',
    );
    if (rows.isEmpty) return const RefreshMonths();
    return RefreshMonths(
      critical: rows.first['training_refresh_critical_months'] as int? ?? 3,
      other: rows.first['training_refresh_other_months'] as int? ?? 6,
    );
  }

  @override
  Future<void> setRefreshMonths(int siteId, RefreshMonths months) =>
      _client.rpcVoid('set_training_refresh_months', {
        'p_site_id': siteId,
        'p_critical': months.critical,
        'p_other': months.other,
      });

  @override
  Future<QuizAttempt?> start({
    required int siteId,
    required int templateGroupId,
    required String taskTitle,
    required String guideVersion,
    required int userId,
  }) async {
    final List<Map<String, dynamic>> rows;
    try {
      rows = (await _client.rpc('start_task_quiz', {
        'p_site_id': siteId,
        'p_template_group_id': templateGroupId,
        'p_task_title': taskTitle,
        'p_guide_version': guideVersion,
        'p_user_id': userId,
      })).cast<Map<String, dynamic>>();
    } catch (e) {
      if (e.toString().contains('read the guide')) {
        throw const QuizRereadRequired();
      }
      rethrow;
    }
    if (rows.length < 3) return null;
    return QuizAttempt(
      attemptId: rows.first['attempt_id'] as int,
      questions: [
        for (final row in rows)
          QuizQuestion(
            number: row['question_no'] as int,
            text: row['question'] as String,
            options: (row['options'] as List).cast<String>(),
          ),
      ]..sort((a, b) => a.number.compareTo(b.number)),
    );
  }

  @override
  Future<QuizResult> submit({
    required int attemptId,
    required List<int> answers,
  }) async {
    final rows = await _client.rpc('submit_task_quiz', {
      'p_attempt_id': attemptId,
      // Server positions are 1-based.
      'p_answers': [for (final a in answers) a + 1],
    });
    final row = rows.first as Map<String, dynamic>;
    return QuizResult(
      passed: row['passed'] as bool,
      correct: row['correct_count'] as int,
      total: row['total'] as int,
      wrongQuestions: (row['wrong_questions'] as List? ?? const []).cast<int>(),
    );
  }

  @override
  Future<int> draftVenueQuestions({
    required int siteId,
    required int templateGroupId,
    required String taskTitle,
    required TaskTrainingGuide guide,
    required String guideVersion,
  }) async {
    final response = await _client.invokeFunction('quiz-draft', {
      'site_id': siteId,
      'template_group_id': templateGroupId,
      'task_title': taskTitle,
      'guide_version': guideVersion,
      'guide': guide.toJson(),
    });
    if (response['outcome'] != 'drafted') {
      throw Exception(response['error'] ?? 'Could not draft questions');
    }
    return response['saved'] as int? ?? 0;
  }

  @override
  Future<List<VenueQuizQuestion>> venueQuestions({
    required int siteId,
    required int templateGroupId,
  }) async {
    final rows = await _client.rpc('list_task_quiz_questions', {
      'p_site_id': siteId,
      'p_template_group_id': templateGroupId,
    });
    return [
      for (final row in rows)
        VenueQuizQuestion(
          id: row['id'] as int,
          text: row['question'] as String,
          options: (row['options'] as List).cast<String>(),
          isPending: row['status'] == 'pending',
        ),
    ];
  }

  @override
  Future<void> decideDrafts({
    required int siteId,
    required int templateGroupId,
    required bool approve,
    List<int>? keepIds,
    required int userId,
  }) async {
    await _client.rpc('decide_task_quiz_drafts', {
      'p_site_id': siteId,
      'p_template_group_id': templateGroupId,
      'p_approve': approve,
      'p_keep_ids': keepIds,
      'p_user_id': userId,
    });
  }
}
