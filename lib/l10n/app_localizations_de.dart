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
  String get companySection => 'Unternehmen';

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
}
