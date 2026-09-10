import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/supabase_client.dart';
import '../repositories/tenant_provisioning_repository.dart';

// Phase C1 — always the Supabase implementation (there is no local
// equivalent to creating a real tenant + GoTrue account; this only makes
// sense against the backend). Not gated by backendDataEnabledProvider:
// a demo/dev build simply never surfaces the signup screen, but if it
// did, this would still work.
final tenantProvisioningRepositoryProvider =
    Provider<TenantProvisioningRepository>((ref) {
      return SupabaseTenantProvisioningRepository(supabase);
    });
