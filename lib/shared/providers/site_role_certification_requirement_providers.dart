import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/certification_requirement.dart';
import '../repositories/site_role_certification_requirement_repository.dart';
import '../repositories/supabase_site_role_certification_requirement_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final siteRoleCertificationRequirementRepositoryProvider =
    Provider<SiteRoleCertificationRequirementRepository>(
      (ref) => SupabaseSiteRoleCertificationRequirementRepository(
        ref.watch(backendRestClientProvider),
      ),
    );

/// One-shot fetch, same reload-by-invalidate pattern as shiftsForSiteProvider
/// — callers invalidate this after add()/remove() rather than this provider
/// polling on its own, since leadership edits this rarely.
final siteRoleCertificationRequirementsForSiteProvider =
    FutureProvider.family<List<SiteRoleCertificationRequirement>, int>(
      (ref, siteId) => ref
          .watch(siteRoleCertificationRequirementRepositoryProvider)
          .getForSite(siteId),
    );
