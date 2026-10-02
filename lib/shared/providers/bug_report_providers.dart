import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/bug_report_repository.dart';
import 'backend_providers.dart' show backendRestClientProvider;

final bugReportRepositoryProvider = Provider<BugReportRepository>(
  (ref) => SupabaseBugReportRepository(ref.watch(backendRestClientProvider)),
);
