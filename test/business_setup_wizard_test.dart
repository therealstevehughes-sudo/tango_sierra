// Business Setup Wizard (2026-10-17): walks the real screen through every
// step with stand-in data — AI fill-in, single venue skipping regions,
// progress saved — and checks nothing throws on a phone-sized screen.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/core/network/backend_rest_client.dart';
import 'package:venurite/features/setup/business_setup_wizard_screen.dart';
import 'package:venurite/l10n/app_localizations.dart';
import 'package:venurite/shared/models/equipment_type.dart';
import 'package:venurite/shared/models/task_template.dart';
import 'package:venurite/shared/models/user.dart';
import 'package:venurite/shared/models/venue_type.dart';
import 'package:venurite/shared/providers/auth_providers.dart';
import 'package:venurite/shared/providers/backend_providers.dart';
import 'package:venurite/shared/providers/task_template_providers.dart';
import 'package:venurite/shared/providers/venue_setup_providers.dart';
import 'package:venurite/shared/providers/venue_type_providers.dart';
import 'package:venurite/shared/repositories/equipment_repository.dart';
import 'package:venurite/shared/repositories/task_template_repository.dart';
import 'package:venurite/shared/repositories/venue_type_repository.dart';

class _Client extends BackendRestClient {
  _Client() : super(() => null);
  final saves = <Map<String, dynamic>>[];

  @override
  Future<List<dynamic>> rpc(String name, Map<String, dynamic> params) async => [];

  @override
  Future<void> rpcVoid(String name, Map<String, dynamic> params) async {
    if (name == 'save_setup_draft') saves.add(params);
  }

  @override
  Future<Map<String, dynamic>> invokeFunction(String name, Map<String, dynamic> body) async => {
    'outcome': 'outline',
    'outline': {
      'single_site': true,
      'branches': [
        {'name': 'Greekos Gyros', 'address': '794 Holloway Rd', 'venue_types': ['Quick Service (QSR)']},
      ],
      'reply': 'Got it: one venue.',
    },
  };
}

class _VenueTypes implements VenueTypeRepository {
  @override
  Future<List<VenueType>> getAll() async => const [VenueType(id: 1, name: 'Quick Service (QSR)')];
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Equipment implements EquipmentRepository {
  @override
  Future<List<EquipmentType>> getEquipmentTypes() async =>
      const [EquipmentType(id: 1, name: 'Fridge'), EquipmentType(id: 2, name: 'Fryer')];
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Templates implements TaskTemplateRepository {
  @override
  Future<List<TaskTemplate>> getAllCurrentVersions() async => [
    TaskTemplate(
      id: 1,
      templateGroupId: 1,
      versionNumber: 1,
      title: 'Fridge temperature',
      segment: 'food_safety',
      applicableRoleTiers: const [RoleTier.base],
      method: 'data',
      requiresPhoto: false,
      requiresNotes: false,
      isCritical: true,
      requiresCorrectiveActionOnFail: true,
      createdAt: DateTime(2026),
    ),
  ];
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  testWidgets('walks every step for a single venue', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final client = _Client();
    final container = ProviderContainer(
      overrides: [
        backendRestClientProvider.overrideWithValue(client),
        venueTypeRepositoryProvider.overrideWithValue(_VenueTypes()),
        equipmentRepositoryProvider.overrideWithValue(_Equipment()),
        taskTemplateRepositoryProvider.overrideWithValue(_Templates()),
      ],
    );
    addTearDown(container.dispose);
    container.read(currentUserProvider.notifier).state = const User(
      id: 58,
      name: 'Tom',
      jobTitle: 'Owner',
      roleTier: RoleTier.executive,
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BusinessSetupWizardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'One gyros shop in London');
    await tester.tap(find.text('Fill it in for me'));
    await tester.pumpAndSettle();
    expect(find.text('Got it: one venue.'), findsOneWidget);

    final seen = <String>[];
    Future<void> next() async {
      await tester.tap(find.widgetWithText(FilledButton, 'Next').hitTestable().first);
      await tester.pumpAndSettle();
    }

    await tester.tap(find.widgetWithText(OutlinedButton, 'Next'));
    await tester.pumpAndSettle();
    for (final title in [
      'You and your role',
      'Head-office leaders',
      'Your venues', // shape
      'Your venues', // venues (regions skipped for one venue)
      'Each venue',
      'Equipment',
      'Staff',
      'Checks and tasks',
    ]) {
      expect(find.text(title), findsWidgets, reason: 'expected step "$title"');
      seen.add(title);
      if (title == 'Equipment') {
        await tester.tap(find.byIcon(Icons.add_circle_outline).first);
        await tester.pump();
      }
      if (title == 'Staff') {
        await tester.tap(find.text('Add a person'));
        await tester.pumpAndSettle();
      }
      await next();
    }
    expect(find.text('Check and create'), findsOneWidget);
    expect(find.textContaining('Greekos Gyros: 1 equipment, 0 staff'), findsOneWidget);
    expect(client.saves, isNotEmpty);
    expect(tester.takeException(), isNull);
  });
}
