import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/branding_config.dart';
import '../repositories/branding_config_repository.dart';
import 'site_providers.dart' show organisationRepositoryProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final brandingConfigRepositoryProvider = Provider<BrandingConfigRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return DriftBrandingConfigRepository(db);
});

// Live re-theme mechanism (Sprint 031, finalized beta build order item 7):
// app.dart watches this directly and feeds its value into AppTheme.light's
// brandAccent parameter, so saving a new brand colour anywhere updates the
// whole app's theme immediately, no restart. Resolves the default
// Organisation first (async), then streams that organisation's current
// BrandingConfig — null (no row yet) means "use AppTheme's own default
// teal," handled at the read site in app.dart, not here.
final brandingConfigProvider = StreamProvider<BrandingConfig?>((ref) async* {
  final orgRepo = ref.watch(organisationRepositoryProvider);
  final repo = ref.watch(brandingConfigRepositoryProvider);
  final org = await orgRepo.getDefault();
  yield* repo.watchCurrent(org.id);
});
