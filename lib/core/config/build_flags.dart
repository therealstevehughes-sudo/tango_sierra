// Compile-time build flags, set via --dart-define.
//
// Phase C1a — the demo/dev flavour (the default) still auto-seeds a fake
// "My Organisation" / "Main Site" and ~40 named demo staff on first open,
// exactly as it always has, so the app is immediately explorable. A real
// install is built with:
//
//   flutter build windows --dart-define=SEED_DEMO_DATA=false
//
// and opens completely empty — no organisation, no site, no staff — so
// the only way forward is the tenant-signup flow (Phase C1b). Shipped
// REFERENCE content (the ~150-task library, equipment types, venue types)
// is NOT gated by this — every tenant needs it — only the fake company,
// fake venue, fake people, and the illustrative example preset are.
const bool kSeedDemoData = bool.fromEnvironment(
  'SEED_DEMO_DATA',
  defaultValue: true,
);
