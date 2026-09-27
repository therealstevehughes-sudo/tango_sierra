import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/providers/backend_providers.dart';
import 'help_screen.dart' show showAiOfflineNotice;

/// AI assistant Q&A (2026-09-27) — the real destination behind Help's
/// "Ask a question" tile, talking to the `ai-assistant` Edge Function (see
/// BACKEND_INFRA.md/DECISIONS_LOG.md for the full RAG design: pgvector
/// retrieval over compliance_library, grounded gpt-4o-mini generation,
/// never the model's general knowledge).
///
/// Single question-and-answer, not a persisted multi-turn chat — the
/// backend's semantic cache is keyed per-question, and a chat-history
/// model would complicate that for no real benefit yet.
///
/// A genuine connectivity/function failure falls through to
/// `showAiOfflineNotice` (the same offline-degrade destination the old
/// placeholder dialog served) rather than a bespoke error screen — that
/// design was agreed before this backend existed and still holds.
class AskQuestionScreen extends ConsumerStatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  ConsumerState<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

enum _AskState { idle, asking, answered, limitReached }

class _AskQuestionScreenState extends ConsumerState<AskQuestionScreen> {
  final _controller = TextEditingController();
  _AskState _state = _AskState.idle;
  String? _answer;
  String? _citationDocument;
  String? _citationUrl;
  bool _fromCache = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() => _state = _AskState.asking);

    try {
      final client = ref.read(backendRestClientProvider);
      final response = await client.invokeFunction('ai-assistant', {
        'question': question,
      });

      if (!mounted) return;

      final outcome = response['outcome'] as String?;
      switch (outcome) {
        case 'answer':
        case 'cache_hit':
          final citation = response['citation'] as Map<String, dynamic>?;
          setState(() {
            _state = _AskState.answered;
            _answer = response['answer'] as String?;
            _citationDocument = citation?['document'] as String?;
            _citationUrl = citation?['url'] as String?;
            _fromCache = outcome == 'cache_hit';
          });
        case 'limit_reached':
          setState(() {
            _state = _AskState.limitReached;
            _answer = response['answer'] as String?;
          });
        default:
          setState(() => _state = _AskState.idle);
          showAiOfflineNotice(context);
      }
    } catch (_) {
      // Genuine connectivity/function failure -- the offline-degrade
      // destination agreed before this backend existed, not a new error UI.
      if (!mounted) return;
      setState(() => _state = _AskState.idle);
      showAiOfflineNotice(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask a question')),
      body: SafeArea(
        child: ResponsiveContent(
          maxWidth: 560,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                maxLines: 3,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _ask(),
                enabled: _state != _AskState.asking,
                decoration: const InputDecoration(
                  labelText: 'What do you want to know?',
                  hintText: 'e.g. What temperature should a fridge be?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _state == _AskState.asking ? null : _ask,
                child: _state == _AskState.asking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Ask'),
              ),
              const SizedBox(height: 20),
              if (_state == _AskState.answered) _AnswerCard(
                answer: _answer!,
                citationDocument: _citationDocument,
                citationUrl: _citationUrl,
                fromCache: _fromCache,
              ),
              if (_state == _AskState.limitReached) _LimitReachedCard(
                answer: _answer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({
    required this.answer,
    required this.citationDocument,
    required this.citationUrl,
    required this.fromCache,
  });

  final String answer;
  final String? citationDocument;
  final String? citationUrl;
  final bool fromCache;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(answer, style: Theme.of(context).textTheme.bodyLarge),
          if (citationDocument != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  size: 16,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    citationDocument!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.muted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LimitReachedCard extends StatelessWidget {
  const _LimitReachedCard({this.answer});

  final String? answer;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI question limit reached this month',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: AppColors.muted),
                ),
              ),
            ],
          ),
          if (answer != null) ...[
            const SizedBox(height: 8),
            Text(answer!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
