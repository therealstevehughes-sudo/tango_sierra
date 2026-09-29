// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'VenuRite';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get personalSection => 'Persönlich';

  @override
  String get languageSettingTitle => 'Sprache';

  @override
  String get languageSettingSubtitle =>
      'Wählen Sie die Sprache, in der VenuRite für Sie angezeigt wird.';

  @override
  String get languageUpdated => 'Sprache aktualisiert.';

  @override
  String get chooseLanguageTitle => 'Sprache auswählen';

  @override
  String get languageDeviceScope =>
      'Wird auf diesem Gerät verwendet, bevor sich Mitarbeitende anmelden.';

  @override
  String languageUserScope(String name) {
    return 'Für $name gespeichert.';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get done => 'Fertig';

  @override
  String get login => 'ANMELDEN';

  @override
  String get back => 'Zurück';

  @override
  String get enterPin => 'PIN eingeben';

  @override
  String get leadershipAccess => 'Zugriff für Führungskräfte';

  @override
  String get notOnThisList =>
      'Nicht in dieser Liste? Auf andere Weise anmelden';

  @override
  String errorLoadingStaff(String error) {
    return 'Fehler beim Laden des Personals: $error';
  }

  @override
  String get incorrectPin => 'Falsche PIN';

  @override
  String tooManyWrongAttempts(int minutes) {
    return 'Zu viele falsche Versuche. Bitte in $minutes Min. erneut versuchen.';
  }

  @override
  String get accountNotFound => 'Konto nicht gefunden';

  @override
  String get getStarted => 'Starten';

  @override
  String get kitchenComplianceDoneRight =>
      'Hygienevorgaben in der Küche, zuverlässig dokumentiert';

  @override
  String get valuePointEhoReady =>
      'Immer bereit für die Lebensmittelkontrolle - Nachweise in Echtzeit statt Stress vor der Prüfung';

  @override
  String get valuePointHonestRecords =>
      'So aufgebaut, dass Ergebnisse nicht manipuliert werden können - jede Prüfung ist nachvollziehbar';

  @override
  String get valuePointAuditExport =>
      'Audit-Export mit einem Tipp - dem Prüfer sofort einen echten Nachweis vorlegen';

  @override
  String get howGetStarted => 'Wie möchten Sie starten?';

  @override
  String get setUpMyBusiness => 'Meinen Betrieb einrichten';

  @override
  String get teamAlreadyUses => 'Mein Team nutzt VenuRite bereits';

  @override
  String get alreadyHaveAccount => 'Sie haben bereits ein Konto? Anmelden';

  @override
  String get needHelpContact => 'Benötigen Sie Hilfe? VenuRite kontaktieren';

  @override
  String get signInAnotherWay => 'Auf andere Weise anmelden';

  @override
  String get deviceNotSetUp => 'Dieses Tablet ist noch nicht eingerichtet';

  @override
  String get askManagerSetupCode =>
      'Fragen Sie eine Führungskraft nach dem Einrichtungscode für diesen Standort.';

  @override
  String get setupCode => 'Einrichtungscode';

  @override
  String get connectTablet => 'Dieses Tablet verbinden';

  @override
  String get couldNotReachServer => 'Der Server konnte nicht erreicht werden';

  @override
  String get stillStuckSetupCode =>
      'Kommen Sie nicht weiter? Eine Führungskraft findet ihn unter Einstellungen -> Standortdetails.';

  @override
  String get askQuestionTitle => 'Frage stellen';

  @override
  String get askQuestionLabel => 'Was möchten Sie wissen?';

  @override
  String get askQuestionHint =>
      'z. B. welche Temperatur sollte ein Kühlschrank haben?';

  @override
  String get ask => 'Fragen';

  @override
  String get aiQuestionLimitReached =>
      'Das monatliche Limit für KI-Fragen wurde erreicht';

  @override
  String get home => 'Start';

  @override
  String get logOut => 'Abmelden';

  @override
  String get endShift => 'Schicht beenden';

  @override
  String get workerHubPrompt => 'Was möchten Sie tun?';

  @override
  String get myScheduledTasks => 'Meine geplanten Aufgaben';

  @override
  String get doAdHocTask => 'Ad-hoc-Aufgabe erledigen';

  @override
  String get logSomethingHappened => 'Einen Vorfall erfassen';

  @override
  String get claimShift => 'Schicht übernehmen';

  @override
  String get requestDayOff => 'Freien Tag anfragen';

  @override
  String get thingsIReported => 'Meine Meldungen';

  @override
  String shiftWelcome(String firstName) {
    return 'Willkommen, $firstName';
  }

  @override
  String get shiftPlanIntro => 'Das steht für Ihre Schicht an:';

  @override
  String get startOfShift => 'Schichtbeginn';

  @override
  String get duringYourShift => 'Während Ihrer Schicht';

  @override
  String get endOfShift => 'Schichtende';

  @override
  String get shiftHandoverTitle => 'Schichtübergabe';

  @override
  String get shiftHandoverNeedsAttention =>
      'Dies erfordert noch die Aufmerksamkeit der nächsten Schicht';

  @override
  String get gotIt => 'Verstanden';

  @override
  String get openIssues => 'Offene Probleme';

  @override
  String get flaggedEquipment => 'Markierte Geräte';

  @override
  String get notYetDoneToday => 'Heute noch nicht erledigt';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get uploadFromFiles => 'Aus Dateien hochladen';

  @override
  String get seeAllTasksTooltip => 'Alle Aufgaben ansehen';

  @override
  String get leaveBeforeFinishingTitle => 'Vor Abschluss verlassen?';

  @override
  String get leaveBeforeFinishingBody =>
      'Einige Prüfungen sind nicht abgeschlossen. Dies wird aufgezeichnet. Du kannst jederzeit während dieser Schicht zurückkehren und fertigstellen.';

  @override
  String get enterValue => 'Wert eingeben';

  @override
  String enterValueWithUnit(String unit) {
    return 'Wert eingeben ($unit)';
  }

  @override
  String safeRangeLabel(String min, String max) {
    return 'Sicherer Bereich: $min - $max';
  }

  @override
  String get errorNumericRequired =>
      'Ein gültiger numerischer Wert ist erforderlich';

  @override
  String get errorSelectOption => 'Bitte eine Option auswählen';

  @override
  String get errorNotesRequired => 'Notizen erforderlich';

  @override
  String get errorPhotoRequired => 'Foto erforderlich';

  @override
  String get errorCorrectiveActionRequired =>
      'Wähle, wie die Korrekturmaßnahme behandelt wurde';

  @override
  String get myTasksTitle => 'Meine Aufgaben';

  @override
  String get taskTitleFallback => 'Aufgabe';

  @override
  String get noTasksAssigned => 'Noch keine Aufgaben zugewiesen.';

  @override
  String get overdueLabel => 'Überfällig';

  @override
  String overdueSinceLabel(String date) {
    return 'Überfällig seit $date';
  }

  @override
  String get withinRangePass => 'Im Bereich - BESTANDEN';

  @override
  String get outsideRangeFail => 'Außerhalb des Bereichs - NICHT BESTANDEN';

  @override
  String get selectOptionLabel => 'Option auswählen';

  @override
  String get notesLabel => 'Notizen';

  @override
  String get spotCheckPhotoNotice =>
      'Heutige Stichprobenkontrolle - diesmal ist ein Foto erforderlich, um zu bestätigen, dass dies tatsächlich erledigt wurde.';

  @override
  String get photoAdded => 'Foto hinzugefügt';

  @override
  String get addPhoto => 'Foto hinzufügen';

  @override
  String get passLabel => 'BESTANDEN';

  @override
  String get failLabel => 'NICHT BESTANDEN';

  @override
  String get readingOutsideSafeRange =>
      'Der Messwert liegt außerhalb des sicheren Bereichs';

  @override
  String get hereIsWhatToDo => 'So gehst du vor:';

  @override
  String get correctiveActionRequired => 'Korrekturmaßnahme erforderlich';

  @override
  String get iFixedIt => 'Ich habe es behoben';

  @override
  String get reportedToManager => 'Dem Manager gemeldet';

  @override
  String get correctiveActionNoteLabel => 'Was hast du getan? (optional)';

  @override
  String get managerWillBeNotified => 'Dein Manager wird benachrichtigt.';

  @override
  String get submitButton => 'ABSENDEN';

  @override
  String availableFrom(String time) {
    return 'Verfügbar ab $time';
  }

  @override
  String get backToList => 'Zurück zur Liste';

  @override
  String get skipComesBackLater => 'Überspringen - kommt später zurück';

  @override
  String get noAdHocTaskTypesSetUp =>
      'An diesem Standort sind noch keine Ad-hoc-Aufgabentypen eingerichtet - bitte zuerst einen Manager, eine Liefer- oder Temperaturprüfungsvorlage zuzuweisen.';

  @override
  String get whatKindOfThing => 'Was für eine Sache machst du gerade?';

  @override
  String get notesOptionalLabel => 'Notizen (optional)';

  @override
  String get noteOptionalLabel => 'Notiz (optional)';

  @override
  String get temperatureCelsiusLabel => 'Temperatur (°C)';

  @override
  String get submitLabel => 'Absenden';

  @override
  String get logReadingButton => 'Messwert erfassen';

  @override
  String get loggedThanksMessage =>
      'Erfasst. Danke, dass du das festgehalten hast.';

  @override
  String get logAnotherAdHocTask => 'Weitere Ad-hoc-Aufgabe erfassen';

  @override
  String get deliveryCheckLabel => 'Lieferprüfung';

  @override
  String get temperatureCheckLabel => 'Temperaturprüfung';

  @override
  String get sessionSummaryTitle => 'Schichtzusammenfassung';

  @override
  String tasksCompletedCount(int count) {
    return 'Erledigte Aufgaben: $count';
  }

  @override
  String get passedLabel => 'Bestanden';

  @override
  String get failedLabel => 'Nicht bestanden';

  @override
  String get triggersFailedTasks => 'Auslöser / Nicht bestandene Aufgaben';

  @override
  String get yourReliability => 'Deine Zuverlässigkeit';

  @override
  String get reliabilityExplanation =>
      'Letzte 30 Tage - Prüfungen, die durchgeführt und rechtzeitig erfasst wurden. Ein erfasstes Nichtbestehen zählt genauso wie ein erfasstes Bestehen: Dies misst nur, ob und wann du geprüft hast.';

  @override
  String completedPercentChip(int percent) {
    return '$percent% abgeschlossen';
  }

  @override
  String onTimePercentChip(int percent) {
    return '$percent% pünktlich';
  }

  @override
  String get sendSummaryToManager =>
      'Diese Zusammenfassung an einen Manager senden (optional)';

  @override
  String get noManagersSetUp => 'Noch keine Manager eingerichtet.';

  @override
  String get managerLabel => 'Manager';

  @override
  String get sentLabel => 'Gesendet';

  @override
  String get sendLabel => 'Senden';

  @override
  String get leaveNoteForNextShift =>
      'Eine Notiz für die nächste Schicht hinterlassen (optional)';

  @override
  String get handoverNoteLabel => 'Übergabenotiz';

  @override
  String get doneLabel => 'Fertig';

  @override
  String get supplierOptionalLabel => 'Lieferant (optional)';

  @override
  String supplierWarningRecorded(String status) {
    return 'Dieser Lieferant ist als $status markiert - die Prüfung wird trotzdem erfasst.';
  }

  @override
  String get reportProblemWithDelivery =>
      'Ein Problem mit dieser Lieferung melden';

  @override
  String get temperatureOnArrivalLabel =>
      'Temperatur bei Ankunft (°C, optional)';

  @override
  String get problemsTickAnyApply => 'Probleme (alle Zutreffenden ankreuzen)';

  @override
  String get shortDeliveryLabel => 'Unvollständige Lieferung';

  @override
  String get damagedStockLabel => 'Beschädigte Ware';

  @override
  String get lateDeliveryLabel => 'Verspätete Lieferung';

  @override
  String get qualityProblemLabel => 'Qualitätsproblem';

  @override
  String get outcomeLabel => 'Ergebnis';

  @override
  String get acceptedLabel => 'Angenommen';

  @override
  String get rejectedLabel => 'Abgelehnt';

  @override
  String get partiallyAcceptedLabel => 'Teilweise angenommen';

  @override
  String get noCameraFound => 'Auf diesem Gerät wurde keine Kamera gefunden.';

  @override
  String couldNotStartCamera(String error) {
    return 'Die Kamera konnte nicht gestartet werden: $error';
  }

  @override
  String couldNotSwitchCamera(String error) {
    return 'Die Kamera konnte nicht gewechselt werden: $error';
  }

  @override
  String couldNotCapturePhoto(String error) {
    return 'Es konnte kein Foto aufgenommen werden: $error';
  }

  @override
  String get switchCameraTooltip => 'Kamera wechseln';

  @override
  String get allTasksTitle => 'Alle Aufgaben';

  @override
  String get otherSegmentLabel => 'Sonstiges';

  @override
  String get reorderTasksTitle => 'Aufgaben neu anordnen';

  @override
  String get ungroupedLabel => 'Nicht gruppiert';

  @override
  String get taskOrderSaved => 'Aufgabenreihenfolge gespeichert.';

  @override
  String couldNotSaveTaskOrder(String error) {
    return 'Aufgabenreihenfolge konnte nicht gespeichert werden: $error';
  }

  @override
  String get noVenueSelectedReorder =>
      'Noch kein Standort ausgewählt. Lege in den Standortdetails einen aktiven Standort fest, bevor du Aufgaben neu anordnest.';

  @override
  String get noActiveTasksToReorder =>
      'Noch keine aktiven Aufgaben zum Neuanordnen. Weise zuerst Aufgaben zu und kehre dann hierher zurück, um ihre Reihenfolge festzulegen.';

  @override
  String get savingEllipsis => 'Wird gespeichert…';

  @override
  String get saveOrderLabel => 'Reihenfolge speichern';

  @override
  String get moveUpTooltip => 'Nach oben verschieben';

  @override
  String get moveDownTooltip => 'Nach unten verschieben';

  @override
  String get accountRestrictedTitle => 'Konto eingeschränkt';

  @override
  String get accountRestrictedBody =>
      'Das Lastschriftmandat dieser Organisation benötigt Aufmerksamkeit, bevor neue Prüfungen gespeichert werden können. Deine Arbeit ist nicht verloren - bitte einen Manager oder Direktor, die Abrechnung zu klären, und versuche es dann erneut.';

  @override
  String get okLabel => 'OK';
}
