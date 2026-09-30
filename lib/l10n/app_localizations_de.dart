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

  @override
  String get troubleshootingTitle => 'Problembehandlung';

  @override
  String get faqTitle => 'Häufige Fragen';

  @override
  String get helpTitle => 'Hilfe';

  @override
  String get couldntReachAssistant =>
      'Der Assistent konnte nicht erreicht werden';

  @override
  String get aiOfflineBody =>
      'Der KI-Assistent ist gerade nicht erreichbar - das kann an deiner Verbindung liegen oder der Dienst ist vorübergehend nicht verfügbar. In der Zwischenzeit decken die häufigen Fragen und die Problembehandlung unten die gängigsten Fragen ab, oder kontaktiere VenuRite direkt.';

  @override
  String get askQuestionSubtitle =>
      'Erhalte eine klare Antwort in einfacher Sprache';

  @override
  String get faqSubtitle => 'Häufige Fragen, beantwortet';

  @override
  String get troubleshootingSubtitle =>
      'Funktioniert etwas nicht? Hier anfangen';

  @override
  String get contactVenuriteTitle => 'VenuRite kontaktieren';

  @override
  String get contactVenuriteSubtitle => 'Direkt Kontakt aufnehmen';

  @override
  String get topTierViewTitle => 'Ansicht oberste Ebene';

  @override
  String get everythingsDone => 'Alles erledigt. Gute Arbeit.';

  @override
  String tasksNotCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben nicht abgeschlossen:',
      one: '1 Aufgabe nicht abgeschlossen:',
    );
    return '$_temp0';
  }

  @override
  String get backToShiftLabel => 'Zurück zur Schicht';

  @override
  String get finishShiftLabel => 'Schicht beenden';

  @override
  String get ehoAuditExportTitle => 'EHO-/Prüfungsexport';

  @override
  String get ehoExportDescription =>
      'Erstellt ein PDF der Compliance-Aufzeichnungen dieses Standorts für den gewählten Zeitraum.';

  @override
  String dateRangeValue(String start, String end) {
    return '$start - $end';
  }

  @override
  String get selectDateRangeLabel => 'Zeitraum auswählen';

  @override
  String get tapToChooseDates =>
      'Tippen, um ein Start- und Enddatum auszuwählen.';

  @override
  String get includeFullDetailedLog =>
      'Vollständiges detailliertes Protokoll einschließen';

  @override
  String get fullLogSubtitle =>
      'Standardmäßig deaktiviert - die obige Zusammenfassung und die Ausnahmen sind das, was ein Prüfer tatsächlich überprüft; dies fügt jede einzelne Prüfung hinzu.';

  @override
  String get generateLabel => 'Erstellen';

  @override
  String get exportFailedTitle => 'Export fehlgeschlagen';

  @override
  String exportFailedBody(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get exportCreatedTitle => 'Export erstellt';

  @override
  String savedToLabel(String path) {
    return 'Gespeichert unter:\n$path';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get noVenueFound => 'Kein Standort gefunden.';

  @override
  String get allPermittedVenuesLast30Days =>
      'Alle berechtigten Standorte · letzte 30 Tage';

  @override
  String get last30Days => 'Letzte 30 Tage';

  @override
  String failCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NICHT BESTANDEN (30 Tage)',
      one: '1 NICHT BESTANDEN (30 Tage)',
    );
    return '$_temp0';
  }

  @override
  String overdueCountLabel(int count) {
    return '$count überfällig';
  }

  @override
  String get venuesSectionTitle => 'Standorte';

  @override
  String get teamSectionTitle => 'Team';

  @override
  String get noStaffAtVenue => 'Noch kein Personal an diesem Standort.';

  @override
  String get notEnoughDataYet => 'Nicht genug Daten';

  @override
  String get venueFallbackLabel => 'Standort';

  @override
  String get trendsTitle => 'Trends';

  @override
  String get trendNeedsHistory =>
      'Trenddaten: es werden mindestens 4 Wochen Verlauf benötigt, um einen Trend anzuzeigen.';

  @override
  String perVenueWeeklyCompletion(int weeks) {
    return 'Wöchentliche Abschlussrate pro Standort · letzte $weeks Wochen';
  }

  @override
  String get allVenuesCombined => 'Alle Standorte kombiniert';

  @override
  String get noVenuesYet => 'Noch keine Standorte.';

  @override
  String get otherVenuesLabel => 'Andere Standorte';

  @override
  String lowLoggingFlagLabel(int completed, int total) {
    return '$completed von $total Prüfungen erfasst';
  }

  @override
  String regionFallbackLabel(int id) {
    return 'Region #$id';
  }

  @override
  String get dashboardOverviewTitle => 'Dashboard-Übersicht';

  @override
  String get gradedBarsOnTooltip => 'Bewertete Balken pro Mitarbeiter: ein';

  @override
  String get gradedBarsOffTooltip => 'Bewertete Balken pro Mitarbeiter: aus';

  @override
  String get noBranchesToShow => 'Noch keine Filialen zum Anzeigen.';

  @override
  String get supervisorNoScopeMessage =>
      'Dir wurde noch keine Abteilung oder kein Team zugewiesen - bitte einen Manager, dies in der Personalverwaltung einzurichten, bevor dieses Dashboard etwas anzeigen kann.';

  @override
  String get individualViewNotice =>
      'Einzelansicht - zur Risikoüberwachung, keine Rangliste.';

  @override
  String get branchLabel => 'Filiale';

  @override
  String get allBranchesLabel => 'Alle Filialen';

  @override
  String get yourSectionLabel => 'Deine Abteilung';

  @override
  String get noneAssignedLabel => 'Keine zugewiesen';

  @override
  String get areaLabel => 'Bereich';

  @override
  String get allAreasLabel => 'Alle Bereiche';

  @override
  String get employeeLabel => 'Mitarbeiter';

  @override
  String get allEmployeesLabel => 'Alle Mitarbeiter';

  @override
  String get monthLabel => 'Monat';

  @override
  String get weekLabel => 'Woche';

  @override
  String get dayLabel => 'Tag';

  @override
  String get noTaskActivityPeriod =>
      'Keine Aufgabenaktivität in diesem Zeitraum.';

  @override
  String get taskOverviewTitle => 'Aufgabenübersicht';

  @override
  String get incidentsTitle => 'Vorfälle';

  @override
  String get noIncidentsPeriod =>
      'In diesem Zeitraum wurden keine Vorfälle gemeldet.';

  @override
  String urgentCountLabel(int count) {
    return '$count dringend';
  }

  @override
  String get tapForDetailsHint =>
      'Tippe auf einen Farbabschnitt oder Legendeneintrag für Details';

  @override
  String get employeeFallbackLabel => 'Mitarbeiter';

  @override
  String get plainLookupNotice =>
      'Eine einfache Abfrage, keine Bewertung - Abschlussfarbe und Problem-Tags werden hier niemals pro Person bewertet.';

  @override
  String tasksCompletedCountParens(int count) {
    return 'Erledigte Aufgaben ($count)';
  }

  @override
  String issuesRaisedCountParens(int count) {
    return 'Gemeldete Probleme ($count)';
  }

  @override
  String get doneOnTimeNoIssues => 'Pünktlich erledigt (keine Probleme)';

  @override
  String get doneOnTimeIssuesLogged => 'Pünktlich erledigt (Probleme erfasst)';

  @override
  String get doneEarlyLateNoIssues => 'Früher/später erledigt (keine Probleme)';

  @override
  String get doneEarlyLateIssuesLogged =>
      'Früher/später erledigt (Probleme erfasst)';

  @override
  String get notDoneLabel => 'Nicht erledigt';

  @override
  String get resolvedLabel => 'Gelöst';

  @override
  String get unresolvedLabel => 'Ungelöst';

  @override
  String get escalatedLabel => 'Eskaliert';

  @override
  String get urgentLabel => 'Dringend';

  @override
  String get signInFailed => 'Anmeldung fehlgeschlagen';

  @override
  String get twoFactorRequiredNoFactor =>
      'Zwei-Faktor-Verifizierung ist erforderlich, aber es wurde kein Faktor gefunden.';

  @override
  String get couldNotVerifyCode =>
      'Dieser Code konnte nicht verifiziert werden';

  @override
  String get codeDidntWork => 'Dieser Code hat nicht funktioniert.';

  @override
  String get accountNotLinkedToStaff =>
      'Dieses Konto ist noch keinem Mitarbeiterprofil zugeordnet - kontaktiere einen Administrator.';

  @override
  String get resetPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get enterEmailForResetCode =>
      'Gib deine E-Mail-Adresse ein und wir senden dir einen Code zum Zurücksetzen deines Passworts.';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get sendCodeButton => 'CODE SENDEN';

  @override
  String get backToSignIn => 'Zurück zur Anmeldung';

  @override
  String sentCodeToEmail(String email) {
    return 'Wir haben einen Code an $email gesendet. Gib ihn unten zusammen mit deinem neuen Passwort ein.';
  }

  @override
  String get sixDigitCodeLabel => '6-stelliger Code';

  @override
  String get newPasswordLabel => 'Neues Passwort';

  @override
  String get resetPasswordButton => 'PASSWORT ZURÜCKSETZEN';

  @override
  String get twoFactorVerificationTitle => 'Zwei-Faktor-Verifizierung';

  @override
  String get enterAuthenticatorCode =>
      'Gib den Code aus deiner Authenticator-App ein.';

  @override
  String get verifyButton => 'VERIFIZIEREN';

  @override
  String get regionalDirectorSignIn =>
      'Anmeldung für Regional- und Direktionsebene.';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get signInButton => 'ANMELDEN';

  @override
  String get forgotPasswordLink => 'Passwort vergessen?';

  @override
  String get noBackendConfiguredPin =>
      'Für diese Installation ist kein Backend konfiguriert - melde dich wie alle anderen mit einer PIN an.';

  @override
  String get noDirectorRegionalAccounts =>
      'Keine Direktions-/Regionalkonten auf diesem Gerät.';

  @override
  String get directorLabel => 'Direktor';

  @override
  String get regionalManagerLabel => 'Regionalleiter';

  @override
  String get whoAreYouTitle => 'Wer bist du?';

  @override
  String get searchLabel => 'Suchen';

  @override
  String get noMatchesLabel => 'Keine Treffer';

  @override
  String get leadershipSectionTitle => 'Führung';

  @override
  String get kitchenStaffSectionTitle => 'Küchenpersonal';

  @override
  String get chooseASectionTitle => 'Wähle einen Bereich';

  @override
  String get unassignedLabel => 'Nicht zugewiesen';

  @override
  String personCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Personen',
      one: '$count Person',
    );
    return '$_temp0';
  }

  @override
  String get goodMorning => 'Guten Morgen';

  @override
  String get goodAfternoon => 'Guten Tag';

  @override
  String get goodEvening => 'Guten Abend';

  @override
  String get welcomeToVenurite => 'Willkommen bei VenuRite';

  @override
  String get helpAssistantTooltip => 'Hilfe & Assistent';

  @override
  String get couldntLoadScreen =>
      'Dieser Bildschirm konnte nicht geladen werden.';

  @override
  String get retryLabel => 'Erneut versuchen';

  @override
  String get microphonePermissionDenied => 'Mikrofonzugriff wurde verweigert.';

  @override
  String get couldntRecordTryAgain =>
      'Aufnahme nicht möglich - versuche es erneut.';

  @override
  String get couldntTranscribe => 'Das konnte nicht transkribiert werden.';

  @override
  String get couldntReachTranscriptionService =>
      'Der Transkriptionsdienst konnte nicht erreicht werden.';

  @override
  String get dictateANote => 'Notiz diktieren';

  @override
  String get stoppingSoonTapToStop =>
      'Stoppt bald - zum sofortigen Stoppen tippen';

  @override
  String get stopLabel => 'Stopp';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String alertsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Warnungen',
      one: '1 Warnung',
    );
    return '$_temp0';
  }

  @override
  String unacknowledgedCountLabel(int count) {
    return '$count unbestätigt';
  }

  @override
  String get allAcknowledgedLabel => 'Alle bestätigt';

  @override
  String overdueUnacknowledgedMinutes(int minutes) {
    return 'ÜBERFÄLLIG - seit $minutes Min. unbestätigt';
  }

  @override
  String get escalatedToTopTier => 'An die oberste Ebene eskaliert';

  @override
  String get acknowledgeLabel => 'Bestätigen';

  @override
  String get nothingInCategory => 'Nichts in dieser Kategorie.';

  @override
  String categoryWithCountLabel(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get leadershipOverview => 'Führungsübersicht';

  @override
  String get photoEvidence => 'Fotonachweise';

  @override
  String get staffManagement => 'Personalverwaltung';

  @override
  String get addTeamMember => 'Teammitglied hinzufügen';

  @override
  String get shiftLog => 'Schichtprotokoll';

  @override
  String get branchTeamStructure => 'Teamstruktur der Filiale';

  @override
  String get departmentManagement => 'Abteilungsverwaltung';

  @override
  String get rosterBoard => 'Dienstplan';

  @override
  String get claimShifts => 'Schichten übernehmen';

  @override
  String get requestADayOff => 'Freien Tag beantragen';

  @override
  String get shiftFairnessReview => 'Überprüfung der Schichtfairness';

  @override
  String get venueDetails => 'Standortdetails';

  @override
  String get assignTasks => 'Aufgaben zuweisen';

  @override
  String get taskPresets => 'Aufgabenvorlagen';

  @override
  String get supplierManagement => 'Lieferantenverwaltung';

  @override
  String get serviceProviders => 'Dienstleister';

  @override
  String get notificationRules => 'Benachrichtigungsregeln';

  @override
  String get documentCentre => 'Dokumentenzentrale';

  @override
  String get setupWizard => 'Einrichtungsassistent';

  @override
  String get organisationLabel => 'Organisation';

  @override
  String get branchesLabel => 'Filialen';

  @override
  String get homeLabel => 'Startseite';

  @override
  String get oversightLabel => 'Aufsicht';

  @override
  String get problemsAndIssues => 'Probleme & Vorfälle';

  @override
  String get twoFactorAuthentication => 'Zwei-Faktor-Authentifizierung';

  @override
  String get backUpNow => 'Jetzt sichern';

  @override
  String get dailySection => 'Täglich';

  @override
  String get insightsSection => 'Einblicke';

  @override
  String get peopleSection => 'Personal';

  @override
  String get rosterSection => 'Dienstplan';

  @override
  String get venueSetupSection => 'Standort-Einrichtung';

  @override
  String get companySection => 'Firma';

  @override
  String get accountSection => 'Konto';

  @override
  String get settingsLabel => 'Einstellungen';

  @override
  String percentCompletedTodayChip(int percent) {
    return '$percent% heute abgeschlossen';
  }

  @override
  String activeStaffCountLabel(int count) {
    return '$count aktives Personal';
  }

  @override
  String failCountTodayBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NICHT BESTANDEN heute',
      one: '1 NICHT BESTANDEN heute',
    );
    return '$_temp0';
  }

  @override
  String get managerViewTitle => 'Manager-Ansicht';

  @override
  String showingScopeLabel(String scope) {
    return 'Angezeigt: $scope';
  }

  @override
  String get supervisorNoScopeMessageLog =>
      'Dir wurde noch keine Abteilung oder kein Team zugewiesen - bitte einen Manager, dies in der Personalverwaltung einzurichten, bevor dieses Protokoll etwas anzeigen kann.';

  @override
  String entriesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String failCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NICHT BESTANDEN',
      one: '1 NICHT BESTANDEN',
    );
    return '$_temp0';
  }

  @override
  String get noFailsLabel => 'Keine Fehlschläge';

  @override
  String get noCompletedTasksLoggedYet =>
      'Noch keine abgeschlossenen Aufgaben erfasst';

  @override
  String sessionSummariesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schichtzusammenfassungen',
      one: '1 Schichtzusammenfassung',
    );
    return '$_temp0';
  }

  @override
  String passFailCountLabel(int passCount, int failCount) {
    return '$passCount bestanden / $failCount nicht bestanden';
  }

  @override
  String get workerFixedIt => 'Mitarbeiter hat es behoben';

  @override
  String get noCorrectiveActionRecorded => 'Keine Korrekturmaßnahme erfasst';

  @override
  String get taskAlertFallback => 'Aufgabenwarnung';

  @override
  String get loggedByLabel => 'Erfasst von';

  @override
  String get resultLabel => 'Ergebnis';

  @override
  String get correctiveActionLabel => 'Korrekturmaßnahme';

  @override
  String get noteLabel => 'Notiz';

  @override
  String get closeLabel => 'Schließen';

  @override
  String get notCompletedSuffix => '- NICHT ABGESCHLOSSEN (Schicht beendet)';

  @override
  String get todayAllFails => 'Heute + alle Fehlschläge';

  @override
  String byAxisLabel(String axis) {
    return 'Nach $axis';
  }

  @override
  String get nameAxisLabel => 'Name';

  @override
  String get dateAxisLabel => 'Datum';

  @override
  String get taskAxisLabel => 'Aufgabe';

  @override
  String get filterLabel => 'Filter';

  @override
  String get filterByLabel => 'Filtern nach:';

  @override
  String get clearFiltersLabel => 'Filter zurücksetzen';

  @override
  String get staffLabel => 'Personal';

  @override
  String get issueTypeComplaint => 'Beschwerde';

  @override
  String get issueTypeAccident => 'Unfall';

  @override
  String get issueTypeIncident => 'Vorfall';

  @override
  String get issueTypeSupplyProblem => 'Lieferproblem';

  @override
  String get issueTypeVenueProblem => 'Standortproblem';

  @override
  String get issueTypeOther => 'Sonstiges';

  @override
  String get incorrectDeliveryLabel => 'Falsche Lieferung';

  @override
  String get driverProblemLabel => 'Fahrerproblem';

  @override
  String get otherLabel => 'Sonstiges';

  @override
  String get whatKindOfThingHappened => 'Was für eine Sache ist passiert?';

  @override
  String get whichOneLabel => 'Welches?';

  @override
  String get supplierLabel => 'Lieferant';

  @override
  String get whatWasWrongWithDelivery => 'Was war falsch an der Lieferung?';

  @override
  String get receivedByLabel => 'Entgegengenommen von';

  @override
  String get whichSectionOptional => 'Um welche Abteilung geht es? (optional)';

  @override
  String get noSectionLabel => 'Keine Abteilung';

  @override
  String get teamOptionalLabel => 'Team (optional)';

  @override
  String get noSpecificTeamLabel => 'Kein bestimmtes Team';

  @override
  String get whatHappenedLabel => 'Was ist passiert?';

  @override
  String get markAsUrgentLabel => 'Als dringend markieren';

  @override
  String get markUrgentSubtitle =>
      'Benötigt sofortige Aufmerksamkeit, unabhängig davon, wie lange es unerledigt bleibt';

  @override
  String get logItButton => 'Erfassen';

  @override
  String get escalateToTitle => 'Eskalieren an';

  @override
  String get sendToLabel => 'Senden an';

  @override
  String get escalateButton => 'Eskalieren';

  @override
  String get savedLabel => 'Gespeichert.';

  @override
  String remindedMessage(String name) {
    return '$name wurde erinnert.';
  }

  @override
  String get couldNotSendReminder =>
      'Die Erinnerung konnte nicht gesendet werden.';

  @override
  String get viewSupplierScorecard => 'Lieferanten-Scorecard ansehen';

  @override
  String raisedAtLabel(String date) {
    return 'Gemeldet $date';
  }

  @override
  String escalatedToColonLabel(String name) {
    return 'Eskaliert an: $name';
  }

  @override
  String get historyLabel => 'Verlauf';

  @override
  String get addAnUpdateLabel => 'Update hinzufügen';

  @override
  String get addProcessNoteButton => 'Prozessnotiz hinzufügen';

  @override
  String get resolveButton => 'Lösen';

  @override
  String get reopenThisIssueTitle => 'Diesen Vorfall wieder öffnen';

  @override
  String get whyReopenLabel => 'Warum sollte dies wieder geöffnet werden?';

  @override
  String get reopenButton => 'Wieder öffnen';

  @override
  String sentToLabel(String name) {
    return 'Gesendet an $name';
  }

  @override
  String get remindButton => 'Erinnern';

  @override
  String get phaseRaisedLabel => 'Gemeldet';

  @override
  String get phaseUpdateLabel => 'Update';

  @override
  String get phaseOutcomeLabel => 'Ergebnis';

  @override
  String get allLabel => 'Alle';

  @override
  String get dateRangeLabel => 'Zeitraum';

  @override
  String get allDatesLabel => 'Alle Daten';

  @override
  String get typeLabel => 'Typ';

  @override
  String get anyTypeLabel => 'Beliebiger Typ';

  @override
  String get anyoneLabel => 'Jeder';

  @override
  String staffFallback(String id) {
    return 'Mitarbeiter #$id';
  }

  @override
  String get nothingHereGoodSign => 'Hier gibt es nichts - ein gutes Zeichen.';

  @override
  String escalatedToNameLabel(String name) {
    return 'Eskaliert an $name';
  }

  @override
  String get havenReportedYet => 'Du hast noch nichts gemeldet.';

  @override
  String get failsAndProblemsRegisterTitle => 'Fehlschläge- & Problemregister';

  @override
  String get taskProblemsTab => 'Aufgabenprobleme';

  @override
  String get issuesAndIncidentsTab => 'Vorfälle & Zwischenfälle';

  @override
  String get failFilterLabel => 'Nicht bestanden';

  @override
  String get reportedFilterLabel => 'Gemeldet';

  @override
  String get notCompletedFilterLabel => 'Nicht abgeschlossen';

  @override
  String get abandonedLabel => 'Abgebrochen';

  @override
  String get noActionTakenLabel => 'Keine Maßnahme ergriffen';

  @override
  String get markResolvedButton => 'Als gelöst markieren';

  @override
  String get openLabel => 'Offen';

  @override
  String get enableRosterQuestion => 'Dienstplan aktivieren?';

  @override
  String rosterQuoteBody(String amount) {
    return 'Basierend auf deiner aktuellen Mitarbeiterzahl wird dies $amount zu deinem monatlichen Lastschrifteinzug hinzufügen, beginnend mit der nächsten Zahlung.';
  }

  @override
  String get confirmAndEnable => 'Bestätigen und aktivieren';

  @override
  String couldNotReachVenurite(String error) {
    return 'VenuRite konnte nicht erreicht werden: $error';
  }

  @override
  String get letStaffClaimShifts =>
      'Lass Mitarbeiter ihre eigenen Schichten übernehmen';

  @override
  String get rosterPitchBody =>
      'Veröffentliche offene Schichten und lass Mitarbeiter sie selbst übernehmen - keine Telefonrunden oder WhatsApp-Gruppen mehr, wenn jemand nicht kommen kann. Mitarbeiter können auch freie Tage beantragen, und du genehmigst oder lehnst sie am selben Ort ab.';

  @override
  String get pricingLabel => 'Preise';

  @override
  String get priceUnder10Staff =>
      '6 £/Monat pro Filiale mit weniger als 10 Mitarbeitern';

  @override
  String get price10PlusStaff =>
      '10 £/Monat pro Filiale mit 10 oder mehr Mitarbeitern';

  @override
  String get addedToDirectDebitNote =>
      'Wird zu deinem bestehenden Lastschrifteinzug hinzugefügt - keine neue Zahlungsmethode erforderlich. Du siehst den genauen Betrag vor der Bestätigung.';

  @override
  String get enableRosterButton => 'Dienstplan aktivieren';

  @override
  String get availableShiftsTitle => 'Verfügbare Schichten';

  @override
  String get shiftClaimingNotEnabled =>
      'Die Schichtübernahme ist für diesen Standort noch nicht aktiviert. Bitte deinen Manager, sie in den Einstellungen zu aktivieren.';

  @override
  String couldNotLoadShifts(String error) {
    return 'Schichten konnten nicht geladen werden: $error';
  }

  @override
  String get noShiftsPostedYet => 'Noch keine Schichten veröffentlicht.';

  @override
  String get someoneElseClaimedShift =>
      'Jemand anderes hat diese Schicht gerade übernommen - sorry!';

  @override
  String get shiftClaimedMessage => 'Schicht übernommen.';

  @override
  String get cancelThisShiftTitle => 'Diese Schicht stornieren?';

  @override
  String get cancelShiftLateWarning =>
      '\n\nEs sind weniger als 24 Stunden bis Schichtbeginn - eine Stornierung jetzt kann sich auf deinen Zuverlässigkeitsverlauf auswirken.';

  @override
  String willNoLongerBeClaimed(String warning) {
    return 'Du wirst für diese Schicht nicht mehr eingetragen sein.$warning';
  }

  @override
  String get keepShiftButton => 'Schicht behalten';

  @override
  String get cancelShiftButton => 'Schicht stornieren';

  @override
  String get yourShiftRecordReliable => 'Dein Schichtverlauf: Zuverlässig';

  @override
  String get yourShiftRecordNeedsImprovement =>
      'Dein Schichtverlauf: Verbesserung nötig';

  @override
  String get yourShiftRecordBuilding => 'Dein Schichtverlauf: Wird aufgebaut';

  @override
  String get claimLabel => 'Übernehmen';

  @override
  String get claimedLabel => 'Übernommen';

  @override
  String requestDateOffTitle(String date) {
    return '$date freinehmen beantragen';
  }

  @override
  String get reasonOptionalLabel => 'Grund (optional)';

  @override
  String get submitRequestButton => 'Antrag senden';

  @override
  String get offDayRequestsNotEnabled =>
      'Freistellungsanträge sind für diesen Standort noch nicht aktiviert. Bitte deinen Manager, den Dienstplan in den Einstellungen zu aktivieren.';

  @override
  String get noOffDayRequestsYet => 'Du hast noch keine Freistellungsanträge.';

  @override
  String get yourRequestsLabel => 'Deine Anträge';

  @override
  String get approvedLabel => 'Genehmigt';

  @override
  String get deniedLabel => 'Abgelehnt';

  @override
  String get pendingLabel => 'Ausstehend';

  @override
  String get postAShiftTitle => 'Schicht veröffentlichen';

  @override
  String get categoryHint => 'z. B. Kühlungsreparatur, Schädlingsbekämpfung';

  @override
  String get pickStartTime => 'Startzeit wählen';

  @override
  String get pickEndTime => 'Endzeit wählen';

  @override
  String get postLabel => 'Veröffentlichen';

  @override
  String get assignShiftToTitle => 'Diese Schicht zuweisen an';

  @override
  String get unknownLabel => 'Unbekannt';

  @override
  String get shiftsTabLabel => 'Schichten';

  @override
  String get offDayRequestsTabLabel => 'Freistellungsanträge';

  @override
  String get rosterAddonNotEnabledManager =>
      'Das Dienstplan-Add-on ist für diesen Standort nicht aktiviert. Aktiviere es unter Einstellungen > Unternehmen, um Schichten zu veröffentlichen.';

  @override
  String get noShiftsTapPlus =>
      'Noch keine Schichten veröffentlicht. Tippe auf +, um eine hinzuzufügen.';

  @override
  String get openStatusLabel => 'Offen';

  @override
  String get assignedStatusPrefix => 'Zugewiesen';

  @override
  String get claimedStatusPrefix => 'Übernommen';

  @override
  String get assignDirectlyLabel => 'Direkt zuweisen';

  @override
  String get removeClaimLabel => 'Übernahme entfernen';

  @override
  String couldNotLoadOffDayRequests(String error) {
    return 'Freistellungsanträge konnten nicht geladen werden: $error';
  }

  @override
  String get noOffDayRequests => 'Keine Freistellungsanträge.';

  @override
  String get approveLabel => 'Genehmigen';

  @override
  String get denyLabel => 'Ablehnen';

  @override
  String get rosterAddonNotEnabledPlain =>
      'Das Dienstplan-Add-on ist für diesen Standort nicht aktiviert.';

  @override
  String get noActiveStaffVenue =>
      'Noch kein aktives Personal an diesem Standort.';

  @override
  String get last90DaysAlphabetical =>
      'Letzte 90 Tage, nach Schichtkategorie. Alphabetisch - keine Rangliste.';

  @override
  String shiftsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schichten',
      one: '1 Schicht',
    );
    return '$_temp0';
  }

  @override
  String get noShiftsInPeriod => 'Keine Schichten in diesem Zeitraum.';

  @override
  String categoryCountLabel(String category, int count) {
    return '$category: $count';
  }

  @override
  String get backupExplanation =>
      'Dies erstellt eine vollständige Kopie der lokalen Datenbank in deinem Dokumente-Ordner. Sie anschließend auf ein USB-Laufwerk oder einen Cloud-synchronisierten Ordner zu verschieben, ist ein separater manueller Schritt.';

  @override
  String get backupNameOptional => 'Backup-Name (optional)';

  @override
  String get backupNameHint => 'z. B. Backup vor der Inspektion';

  @override
  String get backupCreatedTitle => 'Backup erstellt';

  @override
  String get tierTeamMember => 'Teammitglied';

  @override
  String get tierSupervisor => 'Vorgesetzter';

  @override
  String get tierManager => 'Manager';

  @override
  String get tierRegionalManager => 'Regionalleiter';

  @override
  String get tierDirector => 'Direktor';

  @override
  String get anyTaskFail => 'Beliebige nicht bestandene Aufgabe';

  @override
  String taskFailLabel(String title) {
    return 'Nicht bestanden: $title';
  }

  @override
  String get taskFailTemplateStale =>
      'Aufgabe nicht bestanden (Vorlage nicht mehr aktuell)';

  @override
  String get unknownUserLabel => 'Unbekannter Benutzer';

  @override
  String tierSuffixLabel(String tier) {
    return 'Ebene $tier';
  }

  @override
  String get unsetLabel => 'Nicht festgelegt';

  @override
  String get pushChannelLabel => 'Push';

  @override
  String get emailChannelLabel => 'E-Mail';

  @override
  String get inAppOnlyLabel => 'nur in der App';

  @override
  String inAppPlusChannelsLabel(String channels) {
    return 'In-App + $channels';
  }

  @override
  String get tierColumnTeam => 'Team';

  @override
  String get tierColumnSupv => 'Vorg.';

  @override
  String get tierColumnMgr => 'Mgr';

  @override
  String get tierColumnRegnl => 'Region';

  @override
  String get tierColumnDir => 'Dir';

  @override
  String get quickSetupSectionTitle =>
      'Schnelleinrichtung: Benachrichtigungen bei nicht bestandenen Aufgaben';

  @override
  String get tickTierNotified =>
      'Wähle aus, welche Ebene benachrichtigt wird, wenn eine bestimmte Aufgabe nicht besteht.';

  @override
  String get noTaskTemplatesSetUp =>
      'Noch keine Aufgabenvorlagen eingerichtet.';

  @override
  String notifyPrefixLabel(String target, String channels) {
    return 'Benachrichtigen: $target ($channels)';
  }

  @override
  String setByTierLabel(String tier) {
    return 'Festgelegt von Ebene $tier';
  }

  @override
  String get inactiveSuffixLabel => ' - inaktiv';

  @override
  String get deactivateButton => 'Deaktivieren';

  @override
  String get reactivateButton => 'Reaktivieren';

  @override
  String get newRuleTitle => 'Neue Regel';

  @override
  String get triggerLabel => 'Auslöser';

  @override
  String get notifyLabel => 'Benachrichtigen';

  @override
  String get wholeRoleTierOption => 'Eine ganze Rollenebene';

  @override
  String get specificPersonOption => 'Eine bestimmte Person';

  @override
  String get roleTierLabel => 'Rollenebene';

  @override
  String get personLabel => 'Person';

  @override
  String get pushLabel => 'Push';

  @override
  String get rulesInAppNotice =>
      'Regeln werden jetzt nur in der App angezeigt; Push-/E-Mail-Zustellung ist noch nicht mit einem Backend verbunden und wird in einem späteren Sprint hinzugefügt.';

  @override
  String get saveRuleButton => 'Regel speichern';

  @override
  String get addRuleButton => 'Regel hinzufügen';

  @override
  String get noNotificationRulesYet =>
      'Noch keine Benachrichtigungsregeln eingerichtet.';

  @override
  String get stepYourAccount => 'Dein Konto';

  @override
  String get stepCompanyDetails => 'Firmendetails';

  @override
  String get stepOrgStructure => 'Organisationsstruktur';

  @override
  String get stepFirstVenue => 'Erste Filiale';

  @override
  String get stepStarterSetup => 'Deine Starterausstattung';

  @override
  String get stepSubscription => 'Abonnement';

  @override
  String get stepPayment => 'Zahlung';

  @override
  String get termsOfServiceTitle => 'Nutzungsbedingungen';

  @override
  String get companySignupGenericError =>
      'Beim Erstellen deiner Firma ist etwas schiefgelaufen. Bitte versuche es erneut - wenn es weiter passiert, wende dich an VenuRite.';

  @override
  String get directDebitStartError =>
      'Wir konnten die Einrichtung des Lastschrifteinzugs nicht automatisch starten - du kannst das jederzeit in den Einstellungen nachholen, sobald du angemeldet bist.';

  @override
  String get continueButton => 'Weiter';

  @override
  String get creatingEllipsis => 'Wird erstellt...';

  @override
  String get startFreeTrialButton => 'Kostenlose Testversion starten';

  @override
  String get companyCreatedTitle => 'Firma erstellt';

  @override
  String get adminAccountIntro =>
      'Lass uns dein Konto einrichten. Du wirst der Administrator dieser Firma bei VenuRite sein und kannst dein Team einladen, sobald du drin bist.';

  @override
  String get firstNameLabel => 'Vorname';

  @override
  String get lastNameLabel => 'Nachname';

  @override
  String get passwordMinCharsHelper => 'Mindestens 8 Zeichen';

  @override
  String get companyDetailsIntro => 'Erzähl uns von deiner Firma.';

  @override
  String get tradingCompanyNameLabel => 'Handels-/Firmenname';

  @override
  String get legalCompanyNameLabel => 'Rechtlicher Firmenname (optional)';

  @override
  String get legalCompanyNameHelper =>
      'Leer lassen, um den obigen Handelsnamen zu verwenden';

  @override
  String get countryLabel => 'Land';

  @override
  String get registeredAddressLabel =>
      'Eingetragene Geschäftsadresse (optional)';

  @override
  String get vatNumberLabel => 'USt-IdNr. / Steuernummer (falls zutreffend)';

  @override
  String get billingContactEmailLabel =>
      'E-Mail für Rechnungskontakt (optional)';

  @override
  String get structureIntro =>
      'So organisiert VenuRite deine Firma. Du musst jetzt noch nichts einrichten - das dient nur dazu, dass der nächste Schritt Sinn ergibt.';

  @override
  String get structureYourCompanyLabel => 'Deine Firma';

  @override
  String get structureYourCompanySublabel =>
      'Ein zusammengefasstes Konto und eine Rechnung';

  @override
  String get structureRegionsLabel => 'Regionen (optional)';

  @override
  String get structureRegionsSublabel =>
      'Filialen nach Land oder Gebiet gruppieren - überspringen, falls nicht benötigt';

  @override
  String get structureVenuesLabel => 'Standorte';

  @override
  String get structureVenuesSublabel =>
      'Heute eine Filiale, später Hunderte - jederzeit weitere hinzufügen';

  @override
  String get structureStaffLabel => 'Mitarbeiter';

  @override
  String get structureStaffSublabel =>
      'Das Team jedes Standorts, eingeladen sobald er existiert';

  @override
  String get structureOutro =>
      'Als Nächstes richten wir deine erste Filiale ein - Regionen und weitere Standorte kannst du später in der App hinzufügen.';

  @override
  String get wizardFirstVenueHeroTitle =>
      'Lass uns deine erste Filiale hinzufügen';

  @override
  String get addMoreVenuesLaterText =>
      'Du kannst später weitere Standorte hinzufügen.';

  @override
  String get venueNameLabel => 'Name der Filiale';

  @override
  String get addressOptionalLabel => 'Adresse (optional)';

  @override
  String get regionAreaOptionalLabel => 'Region / Gebiet (optional)';

  @override
  String get regionAreaHelper =>
      'z. B. \"Berlin\" - nur nötig, wenn du mehr als einen Standort hast (oder haben wirst)';

  @override
  String get venueTypeOptionalLabel => 'Filialtyp (optional)';

  @override
  String get venueTypeHelper =>
      'Die Auswahl zeigt dir eine fertige Starterausstattung - für Aufgaben und Ausrüstung, die du bereits kennst.';

  @override
  String get payoffSkippedText =>
      'Du hast die Auswahl eines Filialtyps übersprungen, daher gibt es noch keine Starterausstattung zu zeigen - du kannst Aufgaben und Ausrüstung selbst hinzufügen, sobald du drin bist.';

  @override
  String get payoffErrorText =>
      'Die Starterausstattung für diesen Filialtyp konnte nicht geladen werden - du kannst Aufgaben und Ausrüstung selbst hinzufügen, sobald du drin bist.';

  @override
  String get payoffHeroTitle => 'Hier ist deine Compliance, einsatzbereit';

  @override
  String get equipmentSectionLabel => 'Ausrüstung';

  @override
  String get subscriptionBannerText =>
      'Ein Firmenkonto, eine zusammengefasste Rechnung - abgerechnet pro Filiale, nie pro Person.';

  @override
  String get subscriptionIntroText =>
      'Wie viele Filialen hast du heute, einschließlich Hauptsitz, falls vorhanden? Du richtest jetzt nur deine erste Filiale ein - den Rest fügst du jederzeit in der App hinzu.';

  @override
  String get perBranchPriceLabel => '39 £/Filiale/Monat';

  @override
  String get headOfficeIncludedLabel => '+ 1 Hauptsitz-Filiale (4+ Filialen)';

  @override
  String get discountCodeHint =>
      'Hast du einen Rabattcode? Du kannst ihn bei der Einrichtung des Lastschrifteinzugs eingeben.';

  @override
  String get trialBannerText =>
      'Du startest eine 14-tägige kostenlose Testversion - heute wird keine Karte benötigt.';

  @override
  String get paymentStepIntro =>
      'Wir bitten dich, die Zahlung vor Ablauf deiner Testphase in den Einstellungen der App einzurichten. Jetzt wird nichts berechnet - sag uns einfach, wie du bevorzugt zahlen möchtest.';

  @override
  String get cardPaymentTitle => 'Kartenzahlung (Stripe)';

  @override
  String get cardPaymentSubtitle =>
      'Debit-/Kreditkarte, monatlich oder jährlich abgerechnet';

  @override
  String get directDebitTitle => 'Lastschrift (GoCardless)';

  @override
  String get directDebitSubtitle =>
      'Bank-zu-Bank-Zahlung, keine Karte erforderlich';

  @override
  String get decideLaterButton => 'Ich entscheide später';

  @override
  String get decideLaterSnackbar =>
      'Kein Problem - du kannst das jederzeit in den Einstellungen einrichten.';

  @override
  String get agreeToTermsPrefix => 'Ich habe die ';

  @override
  String get successActivatedBanner =>
      'Deine Firma und deine erste Filiale sind eingerichtet, und du bist angemeldet.';

  @override
  String get successNotActivatedBanner =>
      'Deine Firma und deine erste Filiale sind eingerichtet. Melde dich mit deiner E-Mail und dem gerade gewählten Passwort an.';

  @override
  String get directDebitSettingUp => 'Lastschrifteinzug wird eingerichtet...';

  @override
  String get directDebitOpenedBrowser =>
      'Wir haben deinen Browser geöffnet, um die Einrichtung des Lastschrifteinzugs abzuschließen.';

  @override
  String get inviteYourTeamTitle => 'Lade dein Team ein';

  @override
  String get inviteYourTeamSubtitle =>
      'Optional - füge hinzu, wer gerade Dienst hat, oder überspringe dies und mache es später in der Personalverwaltung.';

  @override
  String get jobTitleLabel => 'Position';

  @override
  String get tierFieldLabel => 'Ebene';

  @override
  String get addTeamMemberButton => 'Teammitglied hinzufügen';

  @override
  String get goToDashboardButton => 'Zum Dashboard';

  @override
  String get goToSignInButton => 'Zur Anmeldung';

  @override
  String wizardStepOfLabel(String title, int step, int total) {
    return '$title - Schritt $step von $total';
  }

  @override
  String billingContactEmailHelper(String email) {
    return 'Leer lassen, um $email zu verwenden';
  }

  @override
  String payoffNoStarterSet(String venueType) {
    return 'Wir haben noch keine vorgefertigte Starterausstattung für $venueType - du kannst Aufgaben und Ausrüstung selbst hinzufügen, sobald du drin bist.';
  }

  @override
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  ) {
    return '$totalTasks Aufgaben in $sectionCount Abschnitten und $equipmentCount Ausrüstungstypen bereits eingerichtet für eine $venueType.';
  }

  @override
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  ) {
    return '$totalTasks Aufgaben in $sectionCount Abschnitten bereits eingerichtet für eine $venueType.';
  }

  @override
  String totalPerMonthLabel(String total, int units) {
    return '£$total/Monat gesamt ($units Filialen abgerechnet)';
  }

  @override
  String staffPinLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get jobRoleChefCook => 'Koch/Köchin';

  @override
  String get jobRoleKitchenPorter => 'Küchenhilfe';

  @override
  String get jobRoleFrontOfHouse => 'Service';

  @override
  String get jobRoleBar => 'Bar';

  @override
  String get jobRoleManagement => 'Management';

  @override
  String get jobRoleEveryone => 'Alle';

  @override
  String get jobRoleMaintenance => 'Wartung';

  @override
  String get jobRoleHousekeeping => 'Reinigung';

  @override
  String get jobRoleReception => 'Rezeption';

  @override
  String get jobRoleSecurity => 'Sicherheit';

  @override
  String get segmentFoodSafety =>
      'Lebensmittelsicherheit und Temperaturkontrolle';

  @override
  String get segmentAllergen => 'Allergenmanagement';

  @override
  String get segmentPersonalHygienePpe => 'Persönliche Hygiene & PSA';

  @override
  String get segmentRefrigerationColdStorage => 'Kühlung & Kühllagerung';

  @override
  String get segmentCookingLineEquipment => 'Kochlinienausrüstung';

  @override
  String get segmentWashupDishwash => 'Spülküche / Geschirrspülen';

  @override
  String get segmentCleaningSanitation => 'Reinigung & Hygiene';

  @override
  String get segmentCleaningChemicals =>
      'Reinigungschemikalien & Verbrauchsmaterial';

  @override
  String get segmentDryAmbientStorage => 'Trocken- & Raumtemperaturlagerung';

  @override
  String get segmentDeliveriesGoodsIn => 'Lieferungen & Wareneingang';

  @override
  String get segmentUtilitiesSafety => 'Versorgung & Sicherheit';

  @override
  String get segmentWastePestControl => 'Abfall & Schädlingsbekämpfung';

  @override
  String get segmentPreventiveMaintenance =>
      'Vorbeugende Wartung (Küchengeräte)';

  @override
  String get segmentStockControl => 'Bestandskontrolle';

  @override
  String get segmentOpeningProcedures => 'Öffnungsverfahren';

  @override
  String get segmentClosingProcedures => 'Schließverfahren';

  @override
  String get segmentServiceReadiness => 'Serviceeinsatzbereitschaft';

  @override
  String get segmentFrontOfHouse => 'Service / Gastraum';

  @override
  String get segmentBarBeverage => 'Bar & Getränke';

  @override
  String get segmentHotelSpecific => 'Hotelspezifisch';

  @override
  String get segmentManagementComplianceOversight =>
      'Management & Compliance-Aufsicht';

  @override
  String get segmentMaintenance => 'Wartung';

  @override
  String get segmentHousekeeping => 'Reinigung';

  @override
  String get segmentReception => 'Rezeption';

  @override
  String get segmentSecurity => 'Sicherheit';

  @override
  String get freqDaily => 'Täglich';

  @override
  String get freqWeekly => 'Wöchentlich';

  @override
  String get freqPerShift => 'Pro Schicht';

  @override
  String get freqThreeXDaily => '3x täglich';

  @override
  String get freqTwoXDaily => '2x täglich';

  @override
  String get freqPerBatch => 'Pro Charge';

  @override
  String get freqPerDelivery => 'Pro Lieferung';

  @override
  String get freqPerUse => 'Pro Nutzung';

  @override
  String get freqPerService => 'Pro Service';

  @override
  String get freqTwoXPerService => '2x pro Service';

  @override
  String get freqEventBased => 'Ereignisbasiert';

  @override
  String get freqAsNeeded => 'Nach Bedarf';

  @override
  String get freqMonthly => 'Monatlich';

  @override
  String get freqCustom => 'Benutzerdefiniert';

  @override
  String get jobRoleFieldLabel => 'Jobrolle';

  @override
  String get pinFieldLabel => 'PIN';

  @override
  String get addStaffMemberTitle => 'Mitarbeiter hinzufügen';

  @override
  String get addLabel => 'Hinzufügen';

  @override
  String get assignTasksTitle => 'Aufgaben zuweisen';

  @override
  String get noActiveSiteFoundError => 'Kein aktiver Standort gefunden.';

  @override
  String get byPersonLabel => 'Nach Person';

  @override
  String get byTaskLabel => 'Nach Aufgabe';

  @override
  String get noEquipmentOfTypeSetUp =>
      'Noch keine Ausrüstung dieses Typs eingerichtet.';

  @override
  String get applyButton => 'Anwenden';

  @override
  String get assignToTitle => 'Zuweisen an';

  @override
  String get noStaffMatchTiers =>
      'Kein Mitarbeiter passt zu den Ebenen, für die diese Aufgaben gelten.';

  @override
  String get assignButton => 'Zuweisen';

  @override
  String get showInstructionsTooltip => 'Anleitung anzeigen';

  @override
  String get selectTasksToAssignLabel => 'Aufgaben zum Zuweisen auswählen';

  @override
  String get taskPresetsSectionTitle => 'Aufgaben-Vorlagen';

  @override
  String get showAllPresetsButton => 'Alle Vorlagen anzeigen';

  @override
  String get showTasksInGroupTooltip => 'Aufgaben in dieser Gruppe anzeigen';

  @override
  String get applyToMultipleButton => 'Auf mehrere anwenden';

  @override
  String get addCustomTaskButton => 'Individuelle Aufgabe hinzufügen';

  @override
  String get customTaskSectionTitle => 'Individuelle Aufgabe';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get departmentSectionLabel => 'Abteilung / Bereich';

  @override
  String get methodLabel => 'Methode';

  @override
  String get methodTick => 'Häkchen';

  @override
  String get methodData => 'Daten';

  @override
  String get methodDataTick => 'Daten + Häkchen';

  @override
  String get methodTickPhoto => 'Häkchen + Foto';

  @override
  String get methodDataPhoto => 'Daten + Foto';

  @override
  String get methodNote => 'Notiz';

  @override
  String get methodDataNote => 'Daten + Notiz';

  @override
  String get methodNotePhoto => 'Notiz + Foto';

  @override
  String get methodTickNote => 'Häkchen + Notiz';

  @override
  String get methodMulti => 'Mehrfach';

  @override
  String get requiresPhotoLabel => 'Foto erforderlich';

  @override
  String get requiresNotesLabel => 'Notizen erforderlich';

  @override
  String get minLimitLabel => 'Mindestgrenze';

  @override
  String get maxLimitLabel => 'Höchstgrenze';

  @override
  String get unitHintLabel => 'Einheit (z. B. Celsius)';

  @override
  String get equipmentTypeOptionalLabel => 'Ausrüstungstyp (optional)';

  @override
  String get noneLabel => 'Keiner';

  @override
  String get priorityLabel => 'Priorität';

  @override
  String get priorityCritical => 'Kritisch';

  @override
  String get priorityHigh => 'Hoch';

  @override
  String get priorityStandard => 'Standard';

  @override
  String get requiresCorrectiveActionLabel =>
      'Korrekturmaßnahme bei Fehlschlag erforderlich';

  @override
  String get fixInstructionsLabel => 'Korrekturanweisungen';

  @override
  String get customFieldsJsonLabel =>
      'Benutzerdefinierte Felder (JSON, optional)';

  @override
  String get extraFieldsSectionTitle => 'Zusätzliche Felder (optional)';

  @override
  String get removeTooltip => 'Entfernen';

  @override
  String get fieldLabelHint => 'Feldbezeichnung (z. B. Bestellnummer)';

  @override
  String get extraFieldTypeText => 'Text';

  @override
  String get extraFieldTypeNumber => 'Zahl';

  @override
  String get extraFieldTypeDate => 'Datum';

  @override
  String get addFieldTooltip => 'Feld hinzufügen';

  @override
  String get saveCustomTaskButton => 'Individuelle Aufgabe speichern';

  @override
  String get adHocLabel => 'Ad hoc';

  @override
  String get timeAllocatedLabel => 'Feste Zeit zugewiesen';

  @override
  String get frequencyPrefixLabel => 'Häufigkeit: ';

  @override
  String get atATimeLabel => 'Zu einer bestimmten Uhrzeit';

  @override
  String get fromStartOfShiftLabel => 'Ab Schichtbeginn';

  @override
  String get fromClockInLabel => 'Ab Einstempeln';

  @override
  String get availableFromEllipsis => 'Verfügbar ab…';

  @override
  String get untilEllipsis => 'bis…';

  @override
  String assignTasksForStaffTitle(String name) {
    return 'Aufgaben zuweisen - $name';
  }

  @override
  String applyPresetToWhichOneTitle(String name) {
    return '\"$name\" auf welches anwenden?';
  }

  @override
  String allPresetTasksAlreadyAssigned(String name) {
    return 'Alle $name-Aufgaben waren bereits zugewiesen';
  }

  @override
  String addedTasksFromPreset(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '$count Aufgabe',
    );
    return '$_temp0 von $name hinzugefügt';
  }

  @override
  String applyPresetToTitle(String name) {
    return '\"$name\" anwenden auf';
  }

  @override
  String assignTasksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben an Mitarbeiter zuweisen…',
      one: '$count Aufgabe an Mitarbeiter zuweisen…',
    );
    return '$_temp0';
  }

  @override
  String addedTasksAcrossStaffLabel(int count, int staffCount) {
    return '$count Zuweisungen für $staffCount Mitarbeiter hinzugefügt';
  }

  @override
  String presetSectionPrefix(String segment) {
    return 'Abschnitt: $segment';
  }

  @override
  String taskCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '$count Aufgabe',
    );
    return '$_temp0';
  }

  @override
  String showAllRolesLabel(String jobRole) {
    return 'Alle Rollen anzeigen (Standard: nur $jobRole)';
  }

  @override
  String extraFieldSummary(String label, String type) {
    return '$label ($type)';
  }

  @override
  String noEquipmentSetUpForTemplate(String title) {
    return '$title - dafür ist noch keine Ausrüstung eingerichtet';
  }

  @override
  String fromTimeLabel(String time) {
    return 'Ab $time';
  }

  @override
  String untilTimeLabel(String time) {
    return 'bis $time';
  }

  @override
  String createdAssignmentsLabel(int count, String skippedNote) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zuweisungen erstellt',
      one: '$count Zuweisung erstellt',
    );
    return '$_temp0$skippedNote.';
  }

  @override
  String skippedNoteLabel(int count) {
    return ' ($count übersprungen - bereits zugewiesen oder Rolle passt nicht)';
  }

  @override
  String get serviceProvidersTitle => 'Dienstleister';

  @override
  String get myProvidersTab => 'Meine Dienstleister';

  @override
  String get findProviderTab => 'Dienstleister finden';

  @override
  String get noBackendProviderNotice1 =>
      'Das Durchsuchen der von anderen Standorten geteilten Dienstleister erfordert ein angemeldetes echtes Firmenkonto - das funktioniert nicht nur mit der lokalen Demo-Anmeldung. Deine eigenen Kontakte unter \"Meine Dienstleister\" funktionieren so oder so.';

  @override
  String get noBackendProviderNotice2 =>
      'Melde dich über Leitungszugang mit einem echten Firmenkonto an, um dies zu nutzen.';

  @override
  String get providerDisclaimerText =>
      'VenuRite prüft oder empfiehlt keinen gelisteten Dienstleister. Bewertungen stammen von anderen Standorten, nicht von VenuRite.';

  @override
  String get addProviderButton => 'Dienstleister hinzufügen';

  @override
  String get noProvidersYetText =>
      'Du hast noch keine Dienstleister hinzugefügt.';

  @override
  String get addServiceProviderDialogTitle => 'Dienstleister hinzufügen';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get phoneOptionalLabel => 'Telefon (optional)';

  @override
  String get emailOptionalLabel => 'E-Mail (optional)';

  @override
  String get notesOptionalPrivateLabel =>
      'Notizen (optional, nur für dich sichtbar)';

  @override
  String get happyToReviewShareLabel => 'Ich bewerte und teile gerne';

  @override
  String get shareVisibilityExplanation =>
      'Andere Standorte sehen deine Bewertungen und Rezensionen, wobei Name/Kontakt unkenntlich bleiben, bis sie sie freischalten.';

  @override
  String get rateThisProviderLabel => 'Diesen Dienstleister bewerten';

  @override
  String get priceRatingLabel => 'Preis';

  @override
  String get punctualityRatingLabel => 'Pünktlichkeit';

  @override
  String get qualityRatingLabel => 'Qualität';

  @override
  String get availabilityRatingLabel => 'Verfügbarkeit';

  @override
  String get reviewOptionalLabel => 'Rezension (optional)';

  @override
  String get reviewHintText =>
      'Beschreibe deine Erfahrung - bitte nenne nicht den Firmennamen oder Kontaktdaten.';

  @override
  String get sessionExpiredMessage =>
      'Deine Sitzung ist abgelaufen - bitte melde dich erneut an.';

  @override
  String get sharedWithOtherVenuesLabel => 'Mit anderen Standorten geteilt';

  @override
  String get privateLabel => 'Privat';

  @override
  String get rateReviewsButton => 'Bewerten / Rezensionen';

  @override
  String get searchByCategoryOrNameHint => 'Nach Kategorie oder Name suchen';

  @override
  String get noContactsUnlockedThisMonth =>
      'Diesen Monat noch keine Kontakte freigeschaltet.';

  @override
  String get noSharedProvidersYetText =>
      'Noch keine geteilten Dienstleister - teile den ersten über \"Meine Dienstleister.\"';

  @override
  String get noProvidersMatchSearchText =>
      'Kein Dienstleister entspricht deiner Suche.';

  @override
  String get noRatingsYetText => 'Noch keine Bewertungen';

  @override
  String get hiddenUntilUnlockedText => 'Verborgen bis zur Freischaltung';

  @override
  String get unnamedPlaceholder => '(unbenannt)';

  @override
  String get readReviewsButton => 'Rezensionen lesen';

  @override
  String get unlockContactDetailsButton => 'Kontaktdaten freischalten';

  @override
  String get reviewsTitle => 'Rezensionen';

  @override
  String get noReviewsYetText => 'Noch keine Rezensionen.';

  @override
  String get addYourRatingLabel => 'Deine Bewertung hinzufügen';

  @override
  String get submittingEllipsis => 'Wird gesendet...';

  @override
  String get submitRatingButton => 'Bewertung senden';

  @override
  String reviewContainsInfoWarningShort(String found) {
    return 'Deine Rezension scheint $found zu enthalten. Bitte entferne Kontaktdaten oder Firmennamen vor dem Absenden.';
  }

  @override
  String reviewContainsInfoWarningLong(String found) {
    return 'Deine Rezension scheint $found zu enthalten. Bitte entferne Kontaktdaten oder Firmennamen vor dem Absenden - Rezensionen bleiben nützlich (und fair), wenn sie die Erfahrung beschreiben, nicht wen man direkt anrufen soll.';
  }

  @override
  String contactsUnlockedThisMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kontakte diesen Monat freigeschaltet.',
      one: '$count Kontakt diesen Monat freigeschaltet.',
    );
    return '$_temp0';
  }

  @override
  String priceValueLabel(String value) {
    return 'Preis $value';
  }

  @override
  String punctualityValueLabel(String value) {
    return 'Pünktlichkeit $value';
  }

  @override
  String qualityValueLabel(String value) {
    return 'Qualität $value';
  }

  @override
  String availabilityValueLabel(String value) {
    return 'Verfügbarkeit $value';
  }

  @override
  String ratingReviewCountSuffix(String parts, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rezensionen',
      one: '$count Rezension',
    );
    return '$parts ($_temp0)';
  }

  @override
  String reviewRatingsLine(
    int price,
    int punctuality,
    int quality,
    int availability,
  ) {
    return 'Preis $price - Pünktlichkeit $punctuality - Qualität $quality - Verfügbarkeit $availability';
  }

  @override
  String phonePrefixLabel(String value) {
    return 'Telefon: $value';
  }

  @override
  String emailPrefixLabel(String value) {
    return 'E-Mail: $value';
  }

  @override
  String get supplierCategoryFreshProduce => 'Frische Produkte';

  @override
  String get supplierCategoryMeatPoultry => 'Fleisch & Geflügel';

  @override
  String get supplierCategoryDairyEggs => 'Milchprodukte & Eier';

  @override
  String get supplierCategoryFrozenGoods => 'Tiefkühlwaren';

  @override
  String get supplierCategoryDryAmbientGoods =>
      'Trocken- & Raumtemperaturwaren';

  @override
  String get supplierCategoryDrinksBeverages => 'Getränke';

  @override
  String get supplierCategoryChemicalsCleaningSupplies =>
      'Chemikalien & Reinigungsmittel';

  @override
  String get supplierCategoryEquipmentMaintenance => 'Ausrüstung & Wartung';

  @override
  String get supplierCategoryOther => 'Sonstiges';

  @override
  String get supplierStatusApproved => 'Genehmigt';

  @override
  String get supplierStatusPending => 'Ausstehend';

  @override
  String get supplierStatusSuspended => 'Gesperrt';

  @override
  String get addEquipmentTitle => 'Ausrüstung hinzufügen';

  @override
  String get venueSetupTitle => 'Standort-Einrichtung';

  @override
  String get nextButton => 'Weiter';

  @override
  String get finishSetupButton => 'Einrichtung abschließen';

  @override
  String get renameAreaTitle => 'Bereich umbenennen';

  @override
  String get renameEquipmentTitle => 'Ausrüstung umbenennen';

  @override
  String get saveButton => 'Speichern';

  @override
  String get retireEquipmentTitle => 'Ausrüstung außer Betrieb nehmen';

  @override
  String get retireEquipmentConfirmText =>
      'Das Außerbetriebnehmen dieser Ausrüstung hebt auch alle ihr aktuell zugewiesenen Aufgaben auf. Der bisherige Verlauf bleibt erhalten. Fortfahren?';

  @override
  String get retireButton => 'Außer Betrieb nehmen';

  @override
  String get areasStepTitle => 'Bereiche';

  @override
  String get areasStepIntro =>
      'Füge die Betriebsbereiche dieses Standorts hinzu.';

  @override
  String get areaSuggestionKitchen => 'Küche';

  @override
  String get areaSuggestionStorage => 'Lager';

  @override
  String get areaSuggestionReceiving => 'Wareneingang';

  @override
  String get areaSuggestionFrontOfHouse => 'Service';

  @override
  String get areaNameLabel => 'Bereichsname';

  @override
  String get addAreaTooltip => 'Bereich hinzufügen';

  @override
  String get renameTooltip => 'Umbenennen';

  @override
  String get equipmentStepTitle => 'Ausrüstung';

  @override
  String get equipmentStepIntro =>
      'Füge benannte Ausrüstungsinstanzen hinzu, z. B. \"Kühlschrank 1\", \"Kühlschrank 2\".';

  @override
  String get showAllEquipmentTypesButton => 'Alle Ausrüstungstypen anzeigen';

  @override
  String get equipmentTypeLabel => 'Ausrüstungstyp';

  @override
  String get somethingElseOption => 'Etwas anderes...';

  @override
  String get newEquipmentTypeNameLabel => 'Name des neuen Ausrüstungstyps';

  @override
  String get confirmNewEquipmentTypeTooltip =>
      'Neuen Ausrüstungstyp bestätigen';

  @override
  String get noAreasForDeptText =>
      'Für deine Abteilung sind noch keine Bereiche eingerichtet - Ausrüstung kann trotzdem ohne einen hinzugefügt werden.';

  @override
  String get noAreasAddOneText =>
      'Noch keine Bereiche hinzugefügt - geh zurück, um einen hinzuzufügen.';

  @override
  String get equipmentNameLabel => 'Ausrüstungsname';

  @override
  String get equipmentNameHint =>
      'z. B. Fleisch-Kühlraum, Dessert-Kühlschrank, Bar-Fritteuse';

  @override
  String get modelOptionalLabel => 'Modell (optional)';

  @override
  String get serialNumberOptionalLabel => 'Seriennummer (optional)';

  @override
  String get retireTooltip => 'Außer Betrieb nehmen';

  @override
  String get reactivateTooltip => 'Reaktivieren';

  @override
  String get unknownTypeLabel => 'Unbekannter Typ';

  @override
  String get unknownAreaLabel => 'Unbekannter Bereich';

  @override
  String get staffStepTitle => 'Personal';

  @override
  String get staffStepIntro =>
      'Füge Mitarbeiter hinzu und weise ihnen eine Rollenebene zu.';

  @override
  String get addStaffMemberButton => 'Mitarbeiter hinzufügen';

  @override
  String get suppliersStepTitle => 'Lieferanten';

  @override
  String get suppliersStepIntro =>
      'Füge die Lieferanten hinzu, mit denen dieser Standort zusammenarbeitet. Genehmigungsmarkierungen erscheinen im EHO-Export - gesperrte Lieferanten werden Managern angezeigt, nicht stillschweigend versteckt.';

  @override
  String get supplierNameLabel => 'Lieferantenname';

  @override
  String get contactOptionalLabel => 'Kontakt (optional)';

  @override
  String get phoneOrEmailHint => 'Telefon oder E-Mail';

  @override
  String get approvalStatusLabel => 'Genehmigungsstatus';

  @override
  String get addSupplierButton => 'Lieferant hinzufügen';

  @override
  String venueSetupStepTitle(int step) {
    return 'Standort-Einrichtung - Schritt $step von 4';
  }

  @override
  String modelPrefixLabel(String value) {
    return 'Modell: $value';
  }

  @override
  String serialPrefixLabel(String value) {
    return 'S/N: $value';
  }

  @override
  String retiredSuffixLabel(String name) {
    return '$name (außer Betrieb)';
  }

  @override
  String get addEquipmentTooltip => 'Ausrüstung hinzufügen';

  @override
  String get newPinLabel => 'Neue PIN';

  @override
  String get editDetailsTitle => 'Details bearbeiten';

  @override
  String get sectionLabel => 'Abteilung';

  @override
  String get noSectionOption => 'Keine Abteilung';

  @override
  String get inactiveParenSuffix => ' (inaktiv)';

  @override
  String get noSpecificTeamOption => 'Kein bestimmtes Team';

  @override
  String get noSectionsSetupText =>
      'Für diesen Standort sind noch keine Abteilungen eingerichtet - füge zuerst eine in der Abteilungsverwaltung hinzu.';

  @override
  String get reportsToFieldLabel => 'Berichtet an';

  @override
  String get notSetOption => 'Nicht festgelegt';

  @override
  String get deactivateStaffMemberTitle => 'Mitarbeiter deaktivieren';

  @override
  String get staffManagementTitle => 'Personalverwaltung';

  @override
  String get addStaffTooltip => 'Mitarbeiter hinzufügen';

  @override
  String get bulkImportTooltip => 'Massenimport';

  @override
  String get deactivatedSuffixLabel => '(deaktiviert)';

  @override
  String get moreActionsTooltip => 'Weitere Aktionen';

  @override
  String get changeTierMenuItem => 'Ebene ändern';

  @override
  String get changeSectionMenuItem => 'Abteilung ändern';

  @override
  String get assignSupervisionMenuItem => 'Aufsicht zuweisen';

  @override
  String get reportsToMenuItem => 'Berichtet an';

  @override
  String get resetPinMenuItem => 'PIN zurücksetzen';

  @override
  String get trainingRecordsMenuItem => 'Schulungsnachweise';

  @override
  String unknownUserIdFallback(String id) {
    return 'Benutzer #$id';
  }

  @override
  String resetPinForUserTitle(String name) {
    return 'PIN zurücksetzen - $name';
  }

  @override
  String pinResetForUserMessage(String name) {
    return 'PIN für $name zurückgesetzt';
  }

  @override
  String changeRoleTierTitle(String name) {
    return 'Rollenebene ändern - $name';
  }

  @override
  String changeSectionTitle(String name) {
    return 'Abteilung ändern - $name';
  }

  @override
  String assignSupervisionTitle(String name) {
    return 'Aufsicht zuweisen - $name';
  }

  @override
  String supervisionScopeUpdatedMessage(String name) {
    return 'Aufsichtsbereich für $name aktualisiert';
  }

  @override
  String reportsToTitle(String name) {
    return 'Berichtet an - $name';
  }

  @override
  String deactivateStaffConfirmText(String name) {
    return '$name kann sich nicht mehr anmelden. Ihre aktiven Aufgabenzuweisungen werden aufgehoben. Ihr Einreichungsverlauf ist nicht betroffen. Dies kann später rückgängig gemacht werden.';
  }

  @override
  String reportsToSubtitle(String name) {
    return 'Berichtet an $name';
  }

  @override
  String deactivatedOnByLabel(String date, String name) {
    return 'am $date von $name';
  }

  @override
  String get darkModeLabel => 'Dunkelmodus';

  @override
  String get brandIdentityIntro =>
      'Eine Markenidentität, unternehmensweit geteilt - gilt für jeden Standort, nicht pro Standort.';

  @override
  String get companyNameLabel => 'Firmenname';

  @override
  String get companyLogoLabel => 'Firmenlogo';

  @override
  String get chooseLogoButton => 'Logo wählen';

  @override
  String get changeLogoButton => 'Logo ändern';

  @override
  String get brandColourLabel => 'Markenfarbe';

  @override
  String get customHexColourLabel => 'Benutzerdefinierte Hex-Farbe';

  @override
  String get enterValidHexColourError => 'Gib eine gültige Hex-Farbe ein';

  @override
  String get contactPhoneLabel => 'Kontakttelefon';

  @override
  String get contactEmailLabel => 'Kontakt-E-Mail';

  @override
  String get savingEllipsisLabel => 'Wird gespeichert...';

  @override
  String get saveBrandingButton => 'Branding speichern';

  @override
  String get brandingSavedMessage => 'Branding gespeichert';

  @override
  String get customSwatchTooltip => 'Benutzerdefiniert';

  @override
  String get rosterAddonTitle =>
      'Personal-Schicht/Dienstplan (+6-10 £/Filiale/Monat)';

  @override
  String get rosterAddonSubtitle =>
      'Lass Mitarbeiter offene Schichten selbst sehen und übernehmen - ein Manager stellt Schichten ein, Mitarbeiter greifen zu. 6 £/Monat pro Filiale unter 10 Mitarbeitern, 10 £/Monat für 10 oder mehr.';

  @override
  String get enableRosterTitle => 'Dienstplan aktivieren?';

  @override
  String get confirmButton => 'Bestätigen';

  @override
  String get clearDemoDataTitle => 'Demo-Daten löschen?';

  @override
  String get clearDemoDataConfirmText =>
      'Dies löscht dauerhaft jeden Demo-Mitarbeiter, jede Filiale und Abteilung und meldet dich ab. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get clearEverythingButton => 'Alles löschen';

  @override
  String get clearDemoDataCardTitle => 'Demo-Daten löschen';

  @override
  String get clearDemoDataCardBody =>
      'Entferne jeden Demo-Mitarbeiter, jede Filiale und Abteilung, damit du deine eigenen von Grund auf einrichten kannst.';

  @override
  String get clearDemoDataButton => 'Demo-Daten löschen';

  @override
  String get temperatureUnitLabel => 'Temperatureinheit';

  @override
  String get celsiusLabel => 'Celsius (°C)';

  @override
  String get fahrenheitLabel => 'Fahrenheit (°F)';

  @override
  String get comingSoonLabel => 'Demnächst';

  @override
  String get presetColorOceanTeal => 'Ozeanblau';

  @override
  String get presetColorNavy => 'Marineblau';

  @override
  String get presetColorIndigo => 'Indigo';

  @override
  String get presetColorSlate => 'Schiefer';

  @override
  String get presetColorPlum => 'Pflaume';

  @override
  String get presetColorForest => 'Waldgrün';

  @override
  String get presetColorUmber => 'Umbra';

  @override
  String get presetColorCharcoal => 'Anthrazit';

  @override
  String couldNotGetPriceError(String error) {
    return 'Preis konnte nicht abgerufen werden: $error';
  }

  @override
  String enableRosterConfirmText(String amount) {
    return 'Basierend auf deiner aktuellen Mitarbeiterzahl wird dies $amount zu deinem monatlichen Lastschrifteinzug hinzufügen.';
  }

  @override
  String get departmentLabel => 'Abteilung';

  @override
  String get noDepartmentOption => 'Keine Abteilung';

  @override
  String get removeAnywayButton => 'Trotzdem entfernen';

  @override
  String get branchTeamStructureTitle => 'Team-Struktur der Filiale';

  @override
  String get noStaffAtBranchText => 'Noch kein Personal in dieser Filiale.';

  @override
  String get changeManagerMenuItem => 'Vorgesetzten ändern';

  @override
  String get moveDepartmentMenuItem => 'Abteilung/Team verschieben';

  @override
  String get editJobTitleMenuItem => 'Position bearbeiten';

  @override
  String get removeFromBranchMenuItem => 'Aus dieser Filiale entfernen';

  @override
  String changeManagerTitle(String name) {
    return 'Vorgesetzten ändern - $name';
  }

  @override
  String moveDepartmentTitle(String name) {
    return 'Abteilung/Team verschieben - $name';
  }

  @override
  String changeTierTitle2(String name) {
    return 'Ebene ändern - $name';
  }

  @override
  String editJobTitleTitle(String name) {
    return 'Position bearbeiten - $name';
  }

  @override
  String removeFromBranchTitle(String name) {
    return '$name aus dieser Filiale entfernen';
  }

  @override
  String removeFromBranchConfirmText(String name) {
    return '$name kann sich nicht mehr anmelden. Dies kann später rückgängig gemacht werden.';
  }

  @override
  String reportsWillBeUnassignedText(int count, String name, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Personen berichten',
      one: '$count Person berichtet',
    );
    return '$_temp0 derzeit an $name: $names. Das Entfernen von $name lässt sie bis zur Neuzuweisung ohne Zuordnung.';
  }

  @override
  String reassignToManagerLabel(String name) {
    return 'Sie stattdessen dem eigenen Vorgesetzten von $name neu zuweisen';
  }

  @override
  String reportsCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Untergebene',
      one: '$count Untergebener',
    );
    return '$_temp0';
  }

  @override
  String get regionalManagerAssignedTitle => 'Regionalleiter zugewiesen';

  @override
  String get noOrganisationOnSessionError => 'Keine Firma in dieser Sitzung.';

  @override
  String get newRegionNameTitle => 'Neuer Regionsname';

  @override
  String get renameRegionTitle => 'Region umbenennen';

  @override
  String get renameVenueTitle => 'Standort umbenennen';

  @override
  String get newVenueNameTitle => 'Neuer Standortname';

  @override
  String get doneButton => 'Fertig';

  @override
  String get resetPasswordQuestionTitle => 'Passwort zurücksetzen?';

  @override
  String get resetButton => 'Zurücksetzen';

  @override
  String get passwordResetTitle => 'Passwort zurückgesetzt';

  @override
  String get giveNewTempPasswordText =>
      'Gib dieser Person ihr neues temporäres Passwort.';

  @override
  String get organisationTitle => 'Firma';

  @override
  String get headOfficeLabel => 'Hauptsitz';

  @override
  String get addRegionMenuItem => 'Region hinzufügen';

  @override
  String get addVenueNoRegionMenuItem => 'Standort hinzufügen (keine Region)';

  @override
  String get venuesNoRegionLabel => 'Standorte (keine Region)';

  @override
  String get resetPasswordTooltip => 'Passwort zurücksetzen';

  @override
  String get addVenueMenuItem => 'Standort hinzufügen';

  @override
  String get assignRegionalManagerMenuItem => 'Regionalleiter zuweisen';

  @override
  String get reassignRegionalManagerMenuItem => 'Regionalleiter neu zuweisen';

  @override
  String get noRegionalManagerYetText => 'Noch kein Regionalleiter';

  @override
  String get noVenuesInRegionText => 'Noch keine Standorte in dieser Region.';

  @override
  String get noVenueManagerYetText => 'Noch kein Standortleiter';

  @override
  String assignRegionalManagerTitle(String region) {
    return 'Regionalleiter zuweisen - $region';
  }

  @override
  String accountLiveGiveSignInDetails(String name) {
    return 'Das Konto ist jetzt aktiv. Gib $name die Anmeldedaten - sie nutzen den Leitungszugang.';
  }

  @override
  String emailColonLabel(String email) {
    return 'E-Mail: $email';
  }

  @override
  String temporaryPasswordColonLabel(String password) {
    return 'Temporäres Passwort: $password';
  }

  @override
  String resetPasswordConfirmText(String name) {
    return 'Dies macht sofort das aktuelle Passwort von $name ungültig. Du erhältst ein neues temporäres Passwort zum Weitergeben.';
  }

  @override
  String venueManagerSuffixLabel(String name) {
    return '$name  ·  Standortleiter';
  }

  @override
  String get noSignedInUserError => 'Kein angemeldeter Benutzer gefunden.';

  @override
  String get customCategoryTitleLabel => 'Benutzerdefinierter Kategorietitel';

  @override
  String get approvalNoteLabel =>
      'Genehmigungs-/Sorgfaltspflicht-Notiz (optional)';

  @override
  String get supplierManagementTitle => 'Lieferantenverwaltung';

  @override
  String get noSuppliersAddedYetText => 'Noch keine Lieferanten hinzugefügt.';

  @override
  String get inactiveStandaloneLabel => '(inaktiv)';

  @override
  String get changeApprovalStatusMenuItem => 'Genehmigungsstatus ändern';

  @override
  String editDetailsForSupplierTitle(String name) {
    return 'Details bearbeiten - $name';
  }

  @override
  String changeApprovalStatusTitle(String name) {
    return 'Genehmigungsstatus ändern - $name';
  }

  @override
  String get newVenueTypeTitle => 'Neuer Standorttyp';

  @override
  String get renameOrganisationTitle => 'Firma umbenennen';

  @override
  String get resetSetupCodeTitle => 'Einrichtungscode zurücksetzen?';

  @override
  String get resetSetupCodeConfirmText =>
      'Dies trennt jedes Tablet, das derzeit diesen Standort verwendet, bis ihm der neue Code gegeben wird. Fortfahren?';

  @override
  String get resetCodeButton => 'Code zurücksetzen';

  @override
  String get createNewVenueTitle => 'Neuen Standort erstellen';

  @override
  String get multiSiteSupportPartialText =>
      'Die Unterstützung mehrerer Standorte ist teilweise: Ausrüstung, Personal und Aufgabenlisten werden noch nicht nach Standort gefiltert, daher wird die tägliche Nutzung eines zweiten Standorts noch nicht vollständig unterstützt. Einen zu erstellen ist sicher, aber du wirst die Daten dieses Standorts und des ursprünglichen Standorts in gemeinsamen Listen vermischt sehen, bis das gebaut ist.';

  @override
  String get createButton => 'Erstellen';

  @override
  String get venueDetailsTitle => 'Standortdetails';

  @override
  String get billingLabel => 'Abrechnung';

  @override
  String get billingSubtitleText => 'Plan, Status, Lastschrift';

  @override
  String get activeLabel => 'Aktiv';

  @override
  String get setAsActiveButton => 'Als aktiv festlegen';

  @override
  String get tabletSetupCodeTitle => 'Tablet-Einrichtungscode';

  @override
  String get tabletSetupCodeExplanation =>
      'Gib dies einmal auf einem neuen Tablet ein, damit es die Mitarbeiterliste dieses Standorts anzeigen kann.';

  @override
  String get generateCodeButton => 'Code generieren';

  @override
  String get venueTypeSectionTitle => 'Standorttyp';

  @override
  String get renamePresetTitle => 'Vorlage umbenennen';

  @override
  String get noTaskTemplatesExistYetText =>
      'Es gibt noch keine Aufgabenvorlagen.';

  @override
  String get addTaskToPresetTitle => 'Aufgabe zur Vorlage hinzufügen';

  @override
  String get taskFieldLabel => 'Aufgabe';

  @override
  String get defaultFrequencyLabel => 'Standardhäufigkeit';

  @override
  String get noPresetsYetText => 'Noch keine Vorlagen.';

  @override
  String get createPresetButton => 'Vorlage erstellen';

  @override
  String get presetVerificationBannerText =>
      'Aufgabengrenzwerte sind recherchiert und belegt (mit [LAW]/[FSA]/[BEST] in den Anweisungen jeder Aufgabe gekennzeichnet), aber noch nicht von einer qualifizierten Lebensmittelsicherheitsfachkraft abgezeichnet. Behandle sie erst nach Verifizierung als rechtlich maßgeblich.';

  @override
  String get equipmentPresetsSectionTitle => 'Ausrüstungsvorlagen';

  @override
  String get sectionPresetsSectionTitle => 'Abteilungsvorlagen';

  @override
  String get addTaskButton => 'Aufgabe hinzufügen';

  @override
  String get newPresetSectionTitle => 'Neue Vorlage';

  @override
  String get sectionSegmentOptionalLabel => 'Abteilung / Bereich (optional)';

  @override
  String get setEquipmentOrSectionHint =>
      'Lege einen Ausrüstungstyp oder eine Abteilung fest (mindestens eines).';

  @override
  String equipmentTypeFallback(String id) {
    return 'Ausrüstungstyp #$id';
  }

  @override
  String taskFallback(String id) {
    return 'Aufgabe #$id';
  }

  @override
  String get departmentCategoryKitchen => 'Küche';

  @override
  String get departmentCategoryFrontOfHouse => 'Service';

  @override
  String get departmentCategoryBar => 'Bar';

  @override
  String get departmentCategoryManagement => 'Management';

  @override
  String get departmentCategoryMaintenance => 'Wartung';

  @override
  String get departmentCategoryHousekeeping => 'Reinigung';

  @override
  String get departmentCategoryReception => 'Rezeption';

  @override
  String get departmentCategorySecurity => 'Sicherheit';

  @override
  String get addDepartmentButton => 'Abteilung hinzufügen';

  @override
  String get departmentManagementTitle => 'Abteilungsverwaltung';

  @override
  String get noDepartmentsAddedYetText => 'Noch keine Abteilungen hinzugefügt.';

  @override
  String get noTeamsYetText => 'Noch keine Teams';

  @override
  String get editMenuItem => 'Bearbeiten';

  @override
  String get addTeamButton => 'Team hinzufügen';

  @override
  String editDepartmentTitle(String name) {
    return 'Bearbeiten - $name';
  }

  @override
  String addTeamTitle(String name) {
    return 'Team hinzufügen - $name';
  }

  @override
  String renameTeamTitle(String name) {
    return 'Umbenennen - $name';
  }

  @override
  String teamCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Teams',
      one: '$count Team',
    );
    return '$_temp0';
  }

  @override
  String get documentCategoryPolicy => 'Richtlinie';

  @override
  String get documentCategoryCertificate => 'Zertifikat';

  @override
  String get documentCategoryProcedure => 'Verfahren';

  @override
  String get documentCategoryEhoReport => 'EHO-Bericht';

  @override
  String get addDocumentTitle => 'Dokument hinzufügen';

  @override
  String get noExpiryDateText => 'Kein Ablaufdatum';

  @override
  String get setExpiryButton => 'Ablauf festlegen';

  @override
  String get couldNotOpenFileText =>
      'Diese Datei konnte nicht geöffnet werden.';

  @override
  String get documentCentreTitle => 'Dokumentenzentrale';

  @override
  String get validLabel => 'Gültig';

  @override
  String get expiringSoonLabel => 'Läuft bald ab';

  @override
  String get expiredLabel => 'Abgelaufen';

  @override
  String get allFilterLabel => 'Alle';

  @override
  String get noDocumentsYetText => 'Noch keine Dokumente.';

  @override
  String get openMenuItem => 'Öffnen';

  @override
  String expiresOnLabel(String date) {
    return 'Läuft ab am $date';
  }

  @override
  String get planFriends => 'Friends';

  @override
  String get planStandard => 'Standard';

  @override
  String get planPremier => 'Premier';

  @override
  String get noPlanSelectedText => 'Kein Plan ausgewählt';

  @override
  String get codeNotRecognisedText => 'Dieser Code wurde nicht erkannt.';

  @override
  String get couldNotReachServerText => 'Server konnte nicht erreicht werden.';

  @override
  String get discountAppliedText => 'Rabattcode angewendet.';

  @override
  String get couldNotOpenBrowserText => 'Browser konnte nicht geöffnet werden';

  @override
  String get noSubscriptionFoundText =>
      'Kein Abonnement für diese Firma gefunden.';

  @override
  String get discountAppliedBadge => 'Rabatt angewendet';

  @override
  String get directDebitSetUpText =>
      'Der Lastschrifteinzug ist für diese Firma eingerichtet.';

  @override
  String get directDebitNotSetUpText =>
      'Du hast den Lastschrifteinzug noch nicht eingerichtet. Du wirst zu GoCardless weitergeleitet - VenuRite sieht deine Bankdaten niemals direkt.';

  @override
  String get discountCodeOptionalLabel => 'Rabattcode (optional)';

  @override
  String get discountCodeHintText =>
      'Hast du einen \'Friends\'-Code? Gib ihn hier ein';

  @override
  String get setUpDirectDebitButton => 'Lastschrifteinzug einrichten';

  @override
  String get freeAccessCodeTitle => 'Kostenloser Zugangscode';

  @override
  String get freeAccessActiveText =>
      'Der kostenlose Zugang ist für diese Firma aktiv - kein Lastschrifteinzug oder Kartenzahlung erforderlich.';

  @override
  String get freeAccessPromptText =>
      'Hast du einen kostenlosen Zugangscode? Gib ihn hier ein, um die App ohne Zahlungseinrichtung vollständig zu nutzen.';

  @override
  String get redeemCodeButton => 'Code einlösen';

  @override
  String get onTrialText => 'In der Testphase';

  @override
  String get paymentFailedGraceText =>
      'Eine kürzliche Zahlung ist fehlgeschlagen. Bitte aktualisiere deinen Lastschrifteinzug - der Zugang bleibt während dieser Nachfrist bestehen.';

  @override
  String get directDebitCancelledRestrictedText =>
      'Dein Lastschrifteinzug wurde gekündigt. Der Zugang ist auf Nur-Lesen beschränkt, bis die Abrechnung erneut eingerichtet wird.';

  @override
  String get paymentOverdueRestrictedText =>
      'Die Zahlung ist zu lange überfällig. Der Zugang ist auf Nur-Lesen beschränkt, bis dies behoben ist.';

  @override
  String couldNotLoadBillingDetailsError(String error) {
    return 'Abrechnungsdetails konnten nicht geladen werden: $error';
  }

  @override
  String pricePerMonthBilledLabel(String price, int units) {
    return '$price £/Monat ($units Filialen abgerechnet)';
  }

  @override
  String onTrialUntilText(String date) {
    return 'In der Testphase bis $date';
  }

  @override
  String get reportedIssuesTitle => 'Gemeldete Probleme';

  @override
  String get noDeliveriesLoggedText =>
      'Für diesen Lieferanten sind in diesem Zeitraum keine Lieferungen erfasst.';

  @override
  String get scorecardCategoriesExplanation =>
      'Jede Kategorie unten zählt unabhängig - eine Lieferung kann in mehr als einer Zeile erscheinen (z. B. verspätet UND beschädigt).';

  @override
  String get rejectedOutrightLabel => 'Vollständig abgelehnt';

  @override
  String get acceptedPartiallyLabel => 'Teilweise angenommen';

  @override
  String get reportedIssuesExplanation =>
      'Gegen diesen Lieferanten gemeldete Lieferprobleme - ein separates Protokoll von der obigen Liefer-Scorecard, nicht damit zusammengeführt.';

  @override
  String deliveryScorecardTitle(int count) {
    return 'Liefer-Scorecard ($count Lieferungen)';
  }

  @override
  String countPercentLabel(int count, int rate) {
    return '$count ($rate %)';
  }

  @override
  String get missingNameError => 'Name fehlt';

  @override
  String get missingJobTitleError => 'Position fehlt';

  @override
  String get pinMustBe4DigitsError =>
      'PIN muss genau 4 Ziffern haben (oder leer bleiben)';

  @override
  String get bulkStaffImportTitle => 'Massenimport von Mitarbeitern';

  @override
  String get csvColumnsInstructionsText =>
      'CSV-Spalten: Name, Position, Rollenebene, Jobrolle (optional), PIN (optional). Eine Kopfzeile ist in Ordnung - sie wird automatisch erkannt. Lasse die PIN leer, damit eine für dich generiert wird.';

  @override
  String get chooseCsvFileButton => 'CSV-Datei wählen';

  @override
  String get chooseDifferentFileButton => 'Andere Datei wählen';

  @override
  String get noteDownPinsText =>
      ' Notiere jede PIN unten, bevor du diesen Bildschirm verlässt.';

  @override
  String get importingEllipsisLabel => 'Wird importiert...';

  @override
  String roleTierMustBeOneOfError(String list) {
    return 'Die Rollenebene muss eine der folgenden sein: $list';
  }

  @override
  String notAllowedToCreateTierError(String tier) {
    return 'Du darfst kein $tier-Konto erstellen';
  }

  @override
  String jobRoleMustBeOneOfError(String list) {
    return 'Die Jobrolle muss eine der folgenden sein: $list';
  }

  @override
  String csvExampleText(String example) {
    return 'Beispiel: $example';
  }

  @override
  String rowsFoundLabel(String fileName, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zeilen gefunden',
      one: '$count Zeile gefunden',
    );
    return '$fileName - $_temp0';
  }

  @override
  String needFixingSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count müssen korrigiert werden',
      one: '$count muss korrigiert werden',
    );
    return ', $_temp0';
  }

  @override
  String createdCountLabel(int count) {
    return '$count erstellt';
  }

  @override
  String failedSuffixLabel(int count) {
    return ', $count fehlgeschlagen';
  }

  @override
  String importStaffCountButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitarbeiter importieren',
      one: '$count Mitarbeiter importieren',
    );
    return '$_temp0';
  }

  @override
  String rowNumberFallback(int number) {
    return 'Zeile $number';
  }

  @override
  String jobTitleTierLabel(String jobTitle, String tier) {
    return '$jobTitle - $tier';
  }

  @override
  String pinSuffixLabel(String pin) {
    return ' - PIN: $pin';
  }

  @override
  String get trainingLevel2FoodHygiene =>
      'Stufe 2 Lebensmittelhygiene & -sicherheit';

  @override
  String get trainingAllergenAwareness => 'Allergenbewusstsein';

  @override
  String get trainingCoshh =>
      'COSHH (Kontrolle gesundheitsgefährdender Stoffe)';

  @override
  String get trainingFireSafety => 'Brandschutz';

  @override
  String get trainingManualHandling => 'Manuelle Handhabung';

  @override
  String get trainingFirstAid => 'Erste Hilfe am Arbeitsplatz';

  @override
  String get trainingInduction => 'Einarbeitung abgeschlossen';

  @override
  String get itemFieldLabel => 'Element';

  @override
  String get customItemTitleLabel => 'Benutzerdefinierter Elementtitel';

  @override
  String get expiryNoneLabel => 'Ablauf: keiner';

  @override
  String get clearExpiryTooltip => 'Ablauf löschen';

  @override
  String get certificateReferenceLabel => 'Zertifikatsreferenz (optional)';

  @override
  String get certificateReferenceHint => 'z. B. Zertifikatsnummer, Anbieter';

  @override
  String get noTrainingRecordsYetText => 'Noch keine Schulungsnachweise.';

  @override
  String get addRecordButton => 'Eintrag hinzufügen';

  @override
  String get currentLabel => 'Aktuell';

  @override
  String get supersededLabel => '(ersetzt)';

  @override
  String get noExpiryLabel => 'Kein Ablauf';

  @override
  String addTrainingRecordTitle(String name) {
    return 'Schulungsnachweis hinzufügen - $name';
  }

  @override
  String completedOnLabel(String date) {
    return 'Abgeschlossen: $date';
  }

  @override
  String expiryOnLabel(String date) {
    return 'Ablauf: $date';
  }

  @override
  String trainingRecordsTitle(String name) {
    return 'Schulungsnachweise - $name';
  }

  @override
  String fullHistoryLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vollständiger Verlauf ($count frühere Einträge)',
      one: 'Vollständiger Verlauf ($count früherer Eintrag)',
    );
    return '$_temp0';
  }

  @override
  String completedDateLabel(String date) {
    return 'Abgeschlossen am $date';
  }

  @override
  String certRefLabel(String ref) {
    return 'Ref.: $ref';
  }

  @override
  String get twoFactorNowOnText =>
      'Die Zwei-Faktor-Authentifizierung ist jetzt aktiviert.';

  @override
  String get turnOffTwoFactorTitle =>
      'Zwei-Faktor-Authentifizierung deaktivieren?';

  @override
  String get turnOffTwoFactorConfirmText =>
      'Dieses Konto meldet sich wieder nur mit einem Passwort an.';

  @override
  String get turnOffButton => 'Deaktivieren';

  @override
  String get twoFactorAuthTitle => 'Zwei-Faktor-Authentifizierung';

  @override
  String get twoFactorOnText =>
      'Die Zwei-Faktor-Authentifizierung ist für dieses Konto AKTIVIERT.';

  @override
  String get twoFactorOffText =>
      'Die Zwei-Faktor-Authentifizierung ist DEAKTIVIERT - aktiviere sie für eine zusätzliche Schutzebene für dieses Führungskonto.';

  @override
  String get enableTwoFactorButton =>
      'Zwei-Faktor-Authentifizierung aktivieren';

  @override
  String get scanAuthenticatorText =>
      'Scanne dies mit deiner Authenticator-App (Google Authenticator, Authy usw.) und gib dann den angezeigten 6-stelligen Code ein.';

  @override
  String get cantScanManualEntryText =>
      'Kannst du nicht scannen? Gib diesen Code manuell ein:';

  @override
  String get requiredFieldError => 'Erforderlich';

  @override
  String get joinExistingCompanyTitle => 'Bestehender Firma beitreten';

  @override
  String get enterInviteCodeText =>
      'Gib den Einladungscode ein, den dir dein Manager gegeben hat.';

  @override
  String get inviteCodeLabel => 'Einladungscode';

  @override
  String get yourNameLabel => 'Dein Name';

  @override
  String get yourEmailLabel => 'Deine E-Mail';

  @override
  String get enterValidEmailError => 'Gib eine gültige E-Mail ein';

  @override
  String get choosePasswordLabel => 'Wähle ein Passwort';

  @override
  String get joinButton => 'Beitreten';

  @override
  String get youreInSignInText =>
      'Du bist drin. Melde dich mit deiner E-Mail und dem gerade gewählten Passwort an.';

  @override
  String get newBranchNameTitle => 'Name der neuen Filiale';

  @override
  String get renameBranchTitle => 'Filiale umbenennen';

  @override
  String get branchManagerNameTitle => 'Name des Filialleiters';

  @override
  String get accountCreatedTitle => 'Konto erstellt';

  @override
  String get giveNameAndPinText =>
      'Gib dieser Person ihren Namen (zum Antippen auf dem Anmeldebildschirm) und diese PIN.';

  @override
  String get branchesTitle => 'Filialen';

  @override
  String get noRegionSetText =>
      'Für dein Konto ist keine Region festgelegt - wende dich an deinen Direktor.';

  @override
  String get noBranchesInRegionText => 'Noch keine Filialen in deiner Region.';

  @override
  String get addBranchManagerMenuItem => 'Filialleiter hinzufügen';

  @override
  String nameColonLabel(String name) {
    return 'Name: $name';
  }

  @override
  String pinColonLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get deleteSelectedEvidenceTitle => 'Ausgewählte Nachweise löschen?';

  @override
  String get deleteButton => 'Löschen';

  @override
  String get photoEvidenceTitle => 'Fotonachweis';

  @override
  String get onThisDeviceLabel => 'Auf diesem Gerät';

  @override
  String get deletingFreesSpaceText =>
      'Das Löschen gibt auch Gerätespeicher frei. Exportierte EHO-PDFs enthalten bereits ihre eigenen Kopien und sind nicht betroffen.';

  @override
  String get noEvidencePhotosYetText => 'Noch keine Nachweisfotos.';

  @override
  String deleteEvidenceConfirmText(int count, String bytes) {
    return 'Dies löscht dauerhaft $count Fotos ($bytes) von diesem Gerät. Bereits exportierte PDFs sind nicht betroffen. Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String evidencePhotosCountLabel(int count, String bytes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Nachweisfotos',
      one: '$count Nachweisfoto',
    );
    return '$_temp0 · $bytes insgesamt';
  }

  @override
  String deleteSelectedButton(int count, String bytes) {
    return '$count ausgewählte löschen ($bytes)';
  }

  @override
  String get addTeamMemberTitle => 'Teammitglied hinzufügen';

  @override
  String get createsTapNamePinAccountText =>
      'Erstellt ein Konto mit Namensauswahl + PIN für deinen eigenen Standort.';

  @override
  String get createAccountButton => 'Konto erstellen';

  @override
  String get shiftLogTitle => 'Schichtprotokoll';

  @override
  String get noClockInsYetText => 'Noch keine Einstempelungen erfasst.';

  @override
  String get stillClockedInText => 'Noch eingestempelt';

  @override
  String clockInLabel(String time) {
    return 'Ein: $time';
  }

  @override
  String clockOutLabel(String time) {
    return 'Aus: $time';
  }

  @override
  String durationHoursMinutesLabel(int hours, int minutes) {
    return '${hours}Std ${minutes}Min';
  }

  @override
  String get inviteCreatedTitle => 'Einladung erstellt';

  @override
  String get orShareCodeText =>
      'Oder teile diesen Code - er wird auf dem Bildschirm \"Bestehender Firma beitreten\" eingegeben:';

  @override
  String shareInviteExpiresText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other:
          'Teile dies mit der beitretenden Person - es funktioniert einmal und läuft in $days Tagen ab.',
      one:
          'Teile dies mit der beitretenden Person - es funktioniert einmal und läuft in $days Tag ab.',
    );
    return '$_temp0';
  }

  @override
  String get contactVenuRiteTitle => 'VenuRite kontaktieren';

  @override
  String get contactVenuRiteIntroText =>
      'Egal ob du eine große Gruppe bist, die Hilfe bei der Einrichtung möchte, oder einfach eine Frage hast - wir helfen gerne.';

  @override
  String get emailUsButton => 'E-Mail senden';

  @override
  String taskCountOverdueLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count überfällige Aufgaben',
      one: '$count überfällige Aufgabe',
    );
    return '$_temp0';
  }

  @override
  String acrossStaffMembersLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bei $count Mitarbeitern',
      one: 'Bei $count Mitarbeiter',
    );
    return '$_temp0';
  }

  @override
  String moreStaffMembersLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count weitere Mitarbeiter',
      one: '+$count weiterer Mitarbeiter',
    );
    return '$_temp0';
  }

  @override
  String failCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fehlschläge',
      one: '$count Fehlschlag',
    );
    return '$_temp0';
  }

  @override
  String notCompletedCountLabel(int count) {
    return '$count nicht abgeschlossen';
  }

  @override
  String issuesRaisedCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gemeldete Probleme',
      one: '$count gemeldetes Problem',
    );
    return '$_temp0';
  }

  @override
  String shiftSummaryTitle(String name) {
    return 'Schichtzusammenfassung - $name';
  }

  @override
  String get faqQ1 => 'Wer kann sehen, was ich protokolliere?';

  @override
  String get faqA1 =>
      'Dein Manager und alle über ihm in deinem Standort können die Aufgaben sehen, die du erledigst. Einer namentlich genannten Person wird niemals eine bewertete Punktzahl oder eine Rangliste gezeigt - nur eine einfache Liste dessen, was sie wann getan hat.';

  @override
  String get faqQ2 =>
      'Was passiert, wenn ich eine Aufgabe während meiner Schicht verpasse?';

  @override
  String get faqA2 =>
      'Sie wird als nicht abgeschlossen erfasst, nicht als Fehlschlag - eine mitten in der Schicht abgebrochene Aufgabe ist erwartetes, erlaubtes Verhalten, nur nie versteckt. Dein Manager sieht sie als eigenen, eindeutigen Status.';

  @override
  String get faqQ3 =>
      'Kann ich zurückgehen und eine übersprungene Aufgabe fertigstellen?';

  @override
  String get faqA3 =>
      'Ja, jederzeit vor Ende deiner Schicht - sie bleibt in deiner Aufgabenliste verfügbar, bis du sie abschließt oder deine Schicht endet.';

  @override
  String get faqQ4 =>
      'Was, wenn ich eine Prüfung nicht bestehe (z. B. ein Kühlschrank ist zu warm)?';

  @override
  String get faqA4 =>
      'Protokolliere es als FEHLSCHLAG, notiere die Korrekturmaßnahme, die du ergriffen hast (oder dass du es gemeldet hast), und füge bei Bedarf ein Foto hinzu. Genau dafür ist das System da - ein protokollierter FEHLSCHLAG mit einer Behebung ist eine Erfolgsgeschichte für einen Inspektor, kein Problem für dich.';

  @override
  String get faqQ5 =>
      'Muss ich getrennt von der Anmeldung ein- und ausstempeln?';

  @override
  String get faqA5 =>
      'Nein - die Anmeldung mit deiner PIN zu Beginn deiner Schicht ist dein Einstempeln. Verwende \'Schicht beenden\', wenn du fertig bist, was dir auch alles zeigt, was du noch erledigen musst.';

  @override
  String get faqQ6 => 'Ich habe ein Problem gemeldet - was passiert damit?';

  @override
  String get faqA6 =>
      'Es geht an deinen Manager (oder wird weiter eskaliert, wenn es nicht rechtzeitig bearbeitet wird). Du kannst den Status jederzeit unter \"Meine gemeldeten Probleme\" prüfen.';

  @override
  String get troubleQ1 => 'Meine PIN funktioniert nicht';

  @override
  String get troubleA1 =>
      'Überprüfe, ob du zuerst auf deinen eigenen Namen tippst und dann die PIN eingibst - eine falsche PIN beim richtigen Namen gibt eine klare Ablehnungsmeldung. Wenn es immer noch nicht funktioniert, bitte einen Manager, zu prüfen, ob dein Konto aktiv ist, und deine PIN bei Bedarf zurückzusetzen.';

  @override
  String get troubleQ2 =>
      'Eine Aufgabe, die ich haben sollte, fehlt in meiner Liste';

  @override
  String get troubleA2 =>
      'Bitte deinen Manager zu prüfen, ob sie deiner Rolle/Abteilung in Aufgaben zuweisen zugewiesen ist. Aufgaben erscheinen nur für die Rollen und Abteilungen, für die sie aktiviert wurden.';

  @override
  String get troubleQ3 => 'Die App lässt mich kein Foto machen';

  @override
  String get troubleA3 =>
      'Stelle sicher, dass die App Kamerazugriff hat (prüfe deine Geräteeinstellungen). Unter Windows wird dir stattdessen eine Dateiauswahl angeboten, wenn keine Kamera erkannt wird.';

  @override
  String get troubleQ4 =>
      'Ich kann eine Prüfung nicht absenden / nichts passiert, wenn ich auf Absenden drücke';

  @override
  String get troubleA4 =>
      'Das kann passieren, wenn das Konto deiner Firma Aufmerksamkeit bei der Abrechnung benötigt - du wirst in diesem Fall eine klare Meldung sehen. Andernfalls prüfe, ob jedes Pflichtfeld (einschließlich eines etwaigen Fotos) ausgefüllt ist.';

  @override
  String get troubleQ5 =>
      'Die App scheint hängen geblieben / eingefroren zu sein';

  @override
  String get troubleA5 =>
      'Versuche, sie zu schließen und wieder zu öffnen. Dein Fortschritt bis zu deiner letzten abgeschlossenen Aufgabe wird immer laufend gespeichert, sodass nichts bereits Gesendetes verloren geht.';

  @override
  String get troubleQ6 => 'Ich sehe nicht dieselben Aufgaben wie gestern';

  @override
  String get troubleA6 =>
      'Das ist zu erwarten, wenn dein Zeitplan Ad-hoc-Aufgaben oder an ein Zeitfenster gebundene Aufgaben enthält - sie erscheinen nur, wenn sie fällig sind. Frag deinen Manager, wenn etwas wirklich falsch aussieht.';

  @override
  String taskOverdueSinceLabel(String title, String date) {
    return '$title - überfällig seit $date';
  }

  @override
  String get uploadCertificateDocumentButton => 'Zertifikatsfoto hochladen';

  @override
  String get certificateDocumentUploadedLabel => 'Zertifikat hochgeladen';

  @override
  String get viewCertificateDocumentTooltip => 'Zertifikatsdokument ansehen';

  @override
  String get certificateUploadFailed =>
      'Zertifikat konnte nicht hochgeladen werden. Bitte erneut versuchen.';

  @override
  String get certificationRequirementsTitle => 'Zertifizierungsanforderungen';

  @override
  String get certificationRequirementsFloorNotice =>
      'Einige Zertifizierungen sind für bestimmte Rollen immer erforderlich und können hier nicht entfernt werden (z. B. benötigen Rollen im Lebensmittelbereich immer Lebensmittelhygiene Level 2 und Allergenbewusstsein). Unten können Sie zusätzliche Anforderungen hinzufügen.';

  @override
  String get noExtraCertificationRequirementsText =>
      'Noch keine zusätzlichen Anforderungen hinzugefügt.';

  @override
  String get addRequirementButton => 'Anforderung hinzufügen';

  @override
  String get addCertificationRequirementTitle =>
      'Zertifizierungsanforderung hinzufügen';

  @override
  String get removeCertificationRequirementTitle =>
      'Diese Anforderung entfernen?';

  @override
  String get removeCertificationRequirementBody =>
      'Mitarbeiter in dieser Rolle benötigen dieses Zertifikat dann nicht mehr, um eingeteilt zu werden. Dies betrifft nicht die immer erforderlichen Zertifizierungen.';

  @override
  String get removeButton => 'Entfernen';
}
