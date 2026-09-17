import 'package:flutter/widgets.dart';

/// Menu redesign (2026-09-17) — a stable, never-disposed context for
/// ManagementDrawer to run actions from (Back Up Now, EHO/Audit Export)
/// that need to outlive the Drawer's own closing. The Drawer's own
/// `context`/`ref` become invalid the instant it's popped (a real,
/// previously-hit crash — see ManagementDrawer's own doc comment); this
/// key's `currentContext` belongs to the root Navigator instead, which
/// persists for the app's entire lifetime.
///
/// A separate tiny file (not declared directly in app.dart) so
/// ManagementDrawer can depend on it without an import cycle back to
/// app.dart, which itself depends on screens that use ManagementDrawer.
final rootNavigatorKey = GlobalKey<NavigatorState>();
