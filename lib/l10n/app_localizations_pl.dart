// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'VenuRite';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get personalSection => 'Osobiste';

  @override
  String get languageSettingTitle => 'Język';

  @override
  String get languageSettingSubtitle =>
      'Wybierz język, w którym VenuRite ma się wyświetlać.';

  @override
  String get languageUpdated => 'Język został zaktualizowany.';

  @override
  String get chooseLanguageTitle => 'Wybierz język';

  @override
  String get languageDeviceScope =>
      'Używany na tym urządzeniu przed zalogowaniem pracownika.';

  @override
  String languageUserScope(String name) {
    return 'Zapisano dla: $name.';
  }

  @override
  String get cancel => 'Anuluj';

  @override
  String get done => 'Gotowe';

  @override
  String get login => 'ZALOGUJ';

  @override
  String get back => 'Wstecz';

  @override
  String get enterPin => 'Wpisz PIN';

  @override
  String get leadershipAccess => 'Dostęp dla kierownictwa';

  @override
  String get notOnThisList => 'Nie ma Cię na liście? Zaloguj się w inny sposób';

  @override
  String errorLoadingStaff(String error) {
    return 'Błąd wczytywania pracowników: $error';
  }

  @override
  String get incorrectPin => 'Nieprawidłowy PIN';

  @override
  String tooManyWrongAttempts(int minutes) {
    return 'Za dużo nieudanych prób. Spróbuj ponownie za $minutes min.';
  }

  @override
  String get accountNotFound => 'Nie znaleziono konta';

  @override
  String get getStarted => 'Rozpocznij';

  @override
  String get kitchenComplianceDoneRight =>
      'Zgodność w kuchni, jasno i rzetelnie';

  @override
  String get valuePointEhoReady =>
      'Zawsze gotowi na kontrolę sanitarną - zapisy w czasie rzeczywistym, bez pośpiechu na ostatnią chwilę';

  @override
  String get valuePointHonestRecords =>
      'Zaprojektowane tak, aby wyników nie dało się naginać - każda kontrola ma wiarygodny zapis';

  @override
  String get valuePointAuditExport =>
      'Eksport audytu jednym dotknięciem - natychmiast przekaż inspektorowi prawdziwy zapis';

  @override
  String get howGetStarted => 'Jak chcesz zacząć?';

  @override
  String get setUpMyBusiness => 'Skonfiguruj mój lokal';

  @override
  String get teamAlreadyUses => 'Mój zespół już używa VenuRite';

  @override
  String get alreadyHaveAccount => 'Masz już konto? Zaloguj się';

  @override
  String get needHelpContact =>
      'Potrzebujesz pomocy? Skontaktuj się z VenuRite';

  @override
  String get signInAnotherWay => 'Zaloguj się w inny sposób';

  @override
  String get deviceNotSetUp => 'Ten tablet nie jest jeszcze skonfigurowany';

  @override
  String get askManagerSetupCode =>
      'Poproś kierownika o kod konfiguracji tego lokalu.';

  @override
  String get setupCode => 'Kod konfiguracji';

  @override
  String get connectTablet => 'Połącz ten tablet';

  @override
  String get couldNotReachServer => 'Nie udało się połączyć z serwerem';

  @override
  String get stillStuckSetupCode =>
      'Nadal nie możesz przejść dalej? Kierownik znajdzie kod w Ustawienia -> Szczegóły lokalu.';

  @override
  String get askQuestionTitle => 'Zadaj pytanie';

  @override
  String get askQuestionLabel => 'Co chcesz wiedzieć?';

  @override
  String get askQuestionHint => 'np. jaka powinna być temperatura w lodówce?';

  @override
  String get ask => 'Zapytaj';

  @override
  String get aiQuestionLimitReached => 'Osiągnięto miesięczny limit pytań AI';

  @override
  String get home => 'Start';

  @override
  String get logOut => 'Wyloguj';

  @override
  String get endShift => 'Zakończ zmianę';

  @override
  String get workerHubPrompt => 'Co chcesz zrobić?';

  @override
  String get myScheduledTasks => 'Moje zaplanowane zadania';

  @override
  String get doAdHocTask => 'Wykonaj zadanie ad hoc';

  @override
  String get logSomethingHappened => 'Zgłoś coś, co właśnie się stało';

  @override
  String get claimShift => 'Przejmij zmianę';

  @override
  String get requestDayOff => 'Poproś o dzień wolny';

  @override
  String get thingsIReported => 'Moje zgłoszenia';

  @override
  String shiftWelcome(String firstName) {
    return 'Witaj, $firstName';
  }

  @override
  String get shiftPlanIntro => 'Oto, co jest zaplanowane na Twoją zmianę:';

  @override
  String get startOfShift => 'Początek zmiany';

  @override
  String get duringYourShift => 'W trakcie zmiany';

  @override
  String get endOfShift => 'Koniec zmiany';

  @override
  String get shiftHandoverTitle => 'Przekazanie zmiany';

  @override
  String get shiftHandoverNeedsAttention =>
      'To nadal wymaga uwagi następnej zmiany';

  @override
  String get gotIt => 'Rozumiem';

  @override
  String get openIssues => 'Otwarte problemy';

  @override
  String get flaggedEquipment => 'Oznaczony sprzęt';

  @override
  String get notYetDoneToday => 'Jeszcze nie wykonane dzisiaj';

  @override
  String get takePhoto => 'Zrób zdjęcie';

  @override
  String get uploadFromFiles => 'Prześlij z plików';

  @override
  String get seeAllTasksTooltip => 'Zobacz wszystkie zadania';

  @override
  String get leaveBeforeFinishingTitle => 'Wyjść przed zakończeniem?';

  @override
  String get leaveBeforeFinishingBody =>
      'Niektóre kontrole nie są ukończone. Zostanie to zapisane. Możesz wrócić i dokończyć w dowolnym momencie tej zmiany.';

  @override
  String get enterValue => 'Wprowadź wartość';

  @override
  String enterValueWithUnit(String unit) {
    return 'Wprowadź wartość ($unit)';
  }

  @override
  String safeRangeLabel(String min, String max) {
    return 'Bezpieczny zakres: $min - $max';
  }

  @override
  String get errorNumericRequired =>
      'Wymagana jest prawidłowa wartość liczbowa';

  @override
  String get errorSelectOption => 'Wybierz opcję';

  @override
  String get errorNotesRequired => 'Wymagane są notatki';

  @override
  String get errorPhotoRequired => 'Wymagane jest zdjęcie';

  @override
  String get errorCorrectiveActionRequired =>
      'Wybierz, jak rozwiązano działanie naprawcze';

  @override
  String get myTasksTitle => 'Moje zadania';

  @override
  String get taskTitleFallback => 'Zadanie';

  @override
  String get noTasksAssigned => 'Nie przypisano jeszcze żadnych zadań.';

  @override
  String get overdueLabel => 'Zaległe';

  @override
  String overdueSinceLabel(String date) {
    return 'Zaległe od $date';
  }

  @override
  String get withinRangePass => 'W normie - ZALICZONE';

  @override
  String get outsideRangeFail => 'Poza normą - NIEZALICZONE';

  @override
  String get selectOptionLabel => 'Wybierz opcję';

  @override
  String get notesLabel => 'Notatki';

  @override
  String get spotCheckPhotoNotice =>
      'Dzisiejsza kontrola wyrywkowa - tym razem potrzebne jest zdjęcie, aby potwierdzić, że to naprawdę zostało zrobione.';

  @override
  String get photoAdded => 'Zdjęcie dodane';

  @override
  String get addPhoto => 'Dodaj zdjęcie';

  @override
  String get passLabel => 'ZALICZONE';

  @override
  String get failLabel => 'NIEZALICZONE';

  @override
  String get readingOutsideSafeRange => 'Odczyt jest poza bezpiecznym zakresem';

  @override
  String get hereIsWhatToDo => 'Co należy zrobić:';

  @override
  String get correctiveActionRequired => 'Wymagane działanie naprawcze';

  @override
  String get iFixedIt => 'Naprawiłem/am to';

  @override
  String get reportedToManager => 'Zgłoszono kierownikowi';

  @override
  String get correctiveActionNoteLabel => 'Co zrobiłeś/aś? (opcjonalnie)';

  @override
  String get managerWillBeNotified => 'Twój kierownik zostanie powiadomiony.';

  @override
  String get submitButton => 'WYŚLIJ';

  @override
  String availableFrom(String time) {
    return 'Dostępne od $time';
  }

  @override
  String get backToList => 'Wróć do listy';

  @override
  String get skipComesBackLater => 'Pomiń - wróci później';

  @override
  String get noAdHocTaskTypesSetUp =>
      'W tym miejscu nie skonfigurowano jeszcze żadnych zadań doraźnych - poproś kierownika o przypisanie szablonu kontroli dostawy lub kontroli temperatury.';

  @override
  String get whatKindOfThing => 'Jakiego rodzaju czynność wykonujesz?';

  @override
  String get notesOptionalLabel => 'Notatki (opcjonalnie)';

  @override
  String get noteOptionalLabel => 'Notatka (opcjonalnie)';

  @override
  String get temperatureCelsiusLabel => 'Temperatura (°C)';

  @override
  String get submitLabel => 'Wyślij';

  @override
  String get logReadingButton => 'Zapisz odczyt';

  @override
  String get loggedThanksMessage => 'Zapisano. Dziękujemy za odnotowanie tego.';

  @override
  String get logAnotherAdHocTask => 'Zarejestruj kolejne zadanie doraźne';

  @override
  String get deliveryCheckLabel => 'Kontrola dostawy';

  @override
  String get temperatureCheckLabel => 'Kontrola temperatury';

  @override
  String get sessionSummaryTitle => 'Podsumowanie zmiany';

  @override
  String tasksCompletedCount(int count) {
    return 'Ukończone zadania: $count';
  }

  @override
  String get passedLabel => 'Zaliczone';

  @override
  String get failedLabel => 'Niezaliczone';

  @override
  String get triggersFailedTasks => 'Wyzwalacze / Niezaliczone zadania';

  @override
  String get yourReliability => 'Twoja rzetelność';

  @override
  String get reliabilityExplanation =>
      'Ostatnie 30 dni - kontrole wykonane i zapisane na czas. Zapisana porażka liczy się tak samo jak zapisany sukces: to mierzy tylko, czy i kiedy sprawdzono.';

  @override
  String completedPercentChip(int percent) {
    return '$percent% ukończono';
  }

  @override
  String onTimePercentChip(int percent) {
    return '$percent% na czas';
  }

  @override
  String get sendSummaryToManager =>
      'Wyślij to podsumowanie do kierownika (opcjonalnie)';

  @override
  String get noManagersSetUp =>
      'Nie skonfigurowano jeszcze żadnych kierowników.';

  @override
  String get managerLabel => 'Kierownik';

  @override
  String get sentLabel => 'Wysłano';

  @override
  String get sendLabel => 'Wyślij';

  @override
  String get leaveNoteForNextShift =>
      'Zostaw notatkę dla następnej zmiany (opcjonalnie)';

  @override
  String get handoverNoteLabel => 'Notatka przekazania zmiany';

  @override
  String get doneLabel => 'Gotowe';

  @override
  String get supplierOptionalLabel => 'Dostawca (opcjonalnie)';

  @override
  String supplierWarningRecorded(String status) {
    return 'Ten dostawca jest oznaczony jako $status - kontrola zostanie mimo to zapisana.';
  }

  @override
  String get reportProblemWithDelivery => 'Zgłoś problem z tą dostawą';

  @override
  String get temperatureOnArrivalLabel =>
      'Temperatura przy odbiorze (°C, opcjonalnie)';

  @override
  String get problemsTickAnyApply =>
      'Problemy (zaznacz wszystkie, które dotyczą)';

  @override
  String get shortDeliveryLabel => 'Niekompletna dostawa';

  @override
  String get damagedStockLabel => 'Uszkodzony towar';

  @override
  String get lateDeliveryLabel => 'Spóźniona dostawa';

  @override
  String get qualityProblemLabel => 'Problem z jakością';

  @override
  String get outcomeLabel => 'Wynik';

  @override
  String get acceptedLabel => 'Przyjęto';

  @override
  String get rejectedLabel => 'Odrzucono';

  @override
  String get partiallyAcceptedLabel => 'Przyjęto częściowo';

  @override
  String get noCameraFound => 'Nie znaleziono kamery na tym urządzeniu.';

  @override
  String couldNotStartCamera(String error) {
    return 'Nie udało się uruchomić kamery: $error';
  }

  @override
  String couldNotSwitchCamera(String error) {
    return 'Nie udało się przełączyć kamery: $error';
  }

  @override
  String couldNotCapturePhoto(String error) {
    return 'Nie udało się zrobić zdjęcia: $error';
  }

  @override
  String get switchCameraTooltip => 'Przełącz kamerę';

  @override
  String get allTasksTitle => 'Wszystkie zadania';

  @override
  String get otherSegmentLabel => 'Inne';

  @override
  String get reorderTasksTitle => 'Zmień kolejność zadań';

  @override
  String get ungroupedLabel => 'Niezgrupowane';

  @override
  String get taskOrderSaved => 'Kolejność zadań zapisana.';

  @override
  String couldNotSaveTaskOrder(String error) {
    return 'Nie udało się zapisać kolejności zadań: $error';
  }

  @override
  String get noVenueSelectedReorder =>
      'Nie wybrano jeszcze lokalu. Ustaw aktywny lokal w Szczegółach lokalu przed zmianą kolejności zadań.';

  @override
  String get noActiveTasksToReorder =>
      'Brak aktywnych zadań do uporządkowania. Najpierw przypisz zadania, a następnie wróć tutaj, aby ustalić ich kolejność.';

  @override
  String get savingEllipsis => 'Zapisywanie…';

  @override
  String get saveOrderLabel => 'Zapisz kolejność';

  @override
  String get moveUpTooltip => 'Przesuń w górę';

  @override
  String get moveDownTooltip => 'Przesuń w dół';

  @override
  String get accountRestrictedTitle => 'Konto ograniczone';

  @override
  String get accountRestrictedBody =>
      'Polecenie zapłaty tej organizacji wymaga uwagi, zanim nowe kontrole będą mogły zostać zapisane. Twoja praca nie jest stracona - poproś kierownika lub dyrektora o uregulowanie rozliczeń, a następnie spróbuj ponownie.';

  @override
  String get okLabel => 'OK';

  @override
  String get troubleshootingTitle => 'Rozwiązywanie problemów';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get helpTitle => 'Pomoc';

  @override
  String get couldntReachAssistant => 'Nie udało się połączyć z asystentem';

  @override
  String get aiOfflineBody =>
      'Asystent AI jest obecnie niedostępny - może to być Twoje połączenie lub chwilowa awaria usługi. W międzyczasie sekcje FAQ i Rozwiązywanie problemów poniżej obejmują najczęstsze pytania, albo skontaktuj się bezpośrednio z VenuRite.';

  @override
  String get askQuestionSubtitle => 'Uzyskaj jasną odpowiedź, prostym językiem';

  @override
  String get faqSubtitle => 'Najczęstsze pytania, z odpowiedziami';

  @override
  String get troubleshootingSubtitle => 'Coś nie działa? Zacznij tutaj';

  @override
  String get contactVenuriteTitle => 'Skontaktuj się z VenuRite';

  @override
  String get contactVenuriteSubtitle => 'Skontaktuj się bezpośrednio';

  @override
  String get topTierViewTitle => 'Widok najwyższego poziomu';

  @override
  String get everythingsDone => 'Wszystko zrobione. Dobra robota.';

  @override
  String tasksNotCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zadań nieukończonych:',
      one: '1 zadanie nieukończone:',
    );
    return '$_temp0';
  }

  @override
  String get backToShiftLabel => 'Wróć do zmiany';

  @override
  String get finishShiftLabel => 'Zakończ zmianę';

  @override
  String get ehoAuditExportTitle => 'Eksport EHO / Audyt';

  @override
  String get ehoExportDescription =>
      'Generuje plik PDF z zapisami zgodności tego lokalu dla wybranego zakresu dat.';

  @override
  String dateRangeValue(String start, String end) {
    return '$start - $end';
  }

  @override
  String get selectDateRangeLabel => 'Wybierz zakres dat';

  @override
  String get tapToChooseDates =>
      'Dotknij, aby wybrać datę początkową i końcową.';

  @override
  String get includeFullDetailedLog => 'Uwzględnij pełny szczegółowy dziennik';

  @override
  String get fullLogSubtitle =>
      'Domyślnie wyłączone - podsumowanie i wyjątki powyżej to to, co inspektor faktycznie sprawdza; ta opcja dodaje każdą pojedynczą kontrolę.';

  @override
  String get generateLabel => 'Generuj';

  @override
  String get exportFailedTitle => 'Eksport nie powiódł się';

  @override
  String exportFailedBody(String error) {
    return 'Eksport nie powiódł się: $error';
  }

  @override
  String get exportCreatedTitle => 'Eksport utworzony';

  @override
  String savedToLabel(String path) {
    return 'Zapisano w:\n$path';
  }

  @override
  String get dashboardTitle => 'Panel';

  @override
  String get noVenueFound => 'Nie znaleziono lokalu.';

  @override
  String get allPermittedVenuesLast30Days =>
      'Wszystkie dozwolone lokale · ostatnie 30 dni';

  @override
  String get last30Days => 'Ostatnie 30 dni';

  @override
  String failCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NIEZALICZONYCH (30 dni)',
      one: '1 NIEZALICZONE (30 dni)',
    );
    return '$_temp0';
  }

  @override
  String overdueCountLabel(int count) {
    return '$count zaległych';
  }

  @override
  String get venuesSectionTitle => 'Lokale';

  @override
  String get teamSectionTitle => 'Zespół';

  @override
  String get noStaffAtVenue => 'Brak personelu w tym lokalu.';

  @override
  String get notEnoughDataYet => 'Za mało danych';

  @override
  String get venueFallbackLabel => 'Lokal';

  @override
  String get trendsTitle => 'Trendy';

  @override
  String get trendNeedsHistory =>
      'Dane trendu: potrzeba co najmniej 4 tygodni historii, aby pokazać trend.';

  @override
  String perVenueWeeklyCompletion(int weeks) {
    return 'Tygodniowa realizacja wg lokalu · ostatnie $weeks tyg.';
  }

  @override
  String get allVenuesCombined => 'Wszystkie lokale łącznie';

  @override
  String get noVenuesYet => 'Brak lokali.';

  @override
  String get otherVenuesLabel => 'Inne lokale';

  @override
  String lowLoggingFlagLabel(int completed, int total) {
    return 'Zarejestrowano $completed z $total kontroli';
  }

  @override
  String regionFallbackLabel(int id) {
    return 'Region #$id';
  }

  @override
  String get dashboardOverviewTitle => 'Przegląd panelu';

  @override
  String get gradedBarsOnTooltip => 'Oceniane paski dla pracowników: wł.';

  @override
  String get gradedBarsOffTooltip => 'Oceniane paski dla pracowników: wył.';

  @override
  String get noBranchesToShow => 'Brak oddziałów do wyświetlenia.';

  @override
  String get supervisorNoScopeMessage =>
      'Nie zostałeś jeszcze przypisany do sekcji ani zespołu - poproś kierownika o skonfigurowanie tego w Zarządzaniu personelem, zanim ten panel będzie miał cokolwiek do pokazania.';

  @override
  String get individualViewNotice =>
      'Widok indywidualny - do nadzoru ryzyka, nie tabela wyników.';

  @override
  String get branchLabel => 'Oddział';

  @override
  String get allBranchesLabel => 'Wszystkie oddziały';

  @override
  String get yourSectionLabel => 'Twoja sekcja';

  @override
  String get noneAssignedLabel => 'Nie przypisano';

  @override
  String get areaLabel => 'Obszar';

  @override
  String get allAreasLabel => 'Wszystkie obszary';

  @override
  String get employeeLabel => 'Pracownik';

  @override
  String get allEmployeesLabel => 'Wszyscy pracownicy';

  @override
  String get monthLabel => 'Miesiąc';

  @override
  String get weekLabel => 'Tydzień';

  @override
  String get dayLabel => 'Dzień';

  @override
  String get noTaskActivityPeriod => 'Brak aktywności zadań w tym okresie.';

  @override
  String get taskOverviewTitle => 'Przegląd zadań';

  @override
  String get incidentsTitle => 'Incydenty';

  @override
  String get noIncidentsPeriod => 'Brak zgłoszonych incydentów w tym okresie.';

  @override
  String urgentCountLabel(int count) {
    return '$count pilnych';
  }

  @override
  String get tapForDetailsHint =>
      'Dotknij sekcji koloru lub legendy, aby zobaczyć szczegóły';

  @override
  String get employeeFallbackLabel => 'Pracownik';

  @override
  String get plainLookupNotice =>
      'Zwykłe wyszukiwanie, nie ocena - kolor realizacji i etykiety problemów nigdy nie są tu oceniane per osoba.';

  @override
  String tasksCompletedCountParens(int count) {
    return 'Ukończone zadania ($count)';
  }

  @override
  String issuesRaisedCountParens(int count) {
    return 'Zgłoszone problemy ($count)';
  }

  @override
  String get doneOnTimeNoIssues => 'Zrobione na czas (bez problemów)';

  @override
  String get doneOnTimeIssuesLogged => 'Zrobione na czas (zgłoszono problemy)';

  @override
  String get doneEarlyLateNoIssues =>
      'Zrobione wcześniej/później (bez problemów)';

  @override
  String get doneEarlyLateIssuesLogged =>
      'Zrobione wcześniej/później (zgłoszono problemy)';

  @override
  String get notDoneLabel => 'Niezrobione';

  @override
  String get resolvedLabel => 'Rozwiązane';

  @override
  String get unresolvedLabel => 'Nierozwiązane';

  @override
  String get escalatedLabel => 'Eskalowane';

  @override
  String get urgentLabel => 'Pilne';

  @override
  String get signInFailed => 'Logowanie nie powiodło się';

  @override
  String get twoFactorRequiredNoFactor =>
      'Wymagana jest weryfikacja dwuetapowa, ale nie znaleziono metody.';

  @override
  String get couldNotVerifyCode => 'Nie udało się zweryfikować tego kodu';

  @override
  String get codeDidntWork => 'Ten kod nie zadziałał.';

  @override
  String get accountNotLinkedToStaff =>
      'To konto nie jest jeszcze powiązane z profilem pracownika - skontaktuj się z administratorem.';

  @override
  String get resetPasswordTitle => 'Resetuj hasło';

  @override
  String get enterEmailForResetCode =>
      'Podaj swój e-mail, a wyślemy Ci kod do zresetowania hasła.';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get sendCodeButton => 'WYŚLIJ KOD';

  @override
  String get backToSignIn => 'Wróć do logowania';

  @override
  String sentCodeToEmail(String email) {
    return 'Wysłaliśmy kod na adres $email. Wpisz go poniżej razem z nowym hasłem.';
  }

  @override
  String get sixDigitCodeLabel => '6-cyfrowy kod';

  @override
  String get newPasswordLabel => 'Nowe hasło';

  @override
  String get resetPasswordButton => 'ZRESETUJ HASŁO';

  @override
  String get twoFactorVerificationTitle => 'Weryfikacja dwuetapowa';

  @override
  String get enterAuthenticatorCode =>
      'Wprowadź kod z aplikacji uwierzytelniającej.';

  @override
  String get verifyButton => 'ZWERYFIKUJ';

  @override
  String get regionalDirectorSignIn => 'Logowanie dla regionu i dyrekcji.';

  @override
  String get passwordLabel => 'Hasło';

  @override
  String get signInButton => 'ZALOGUJ SIĘ';

  @override
  String get forgotPasswordLink => 'Zapomniałeś hasła?';

  @override
  String get noBackendConfiguredPin =>
      'Dla tej instalacji nie skonfigurowano backendu - zaloguj się kodem PIN, tak jak wszyscy inni.';

  @override
  String get noDirectorRegionalAccounts =>
      'Brak kont dyrektora/regionalnego na tym urządzeniu.';

  @override
  String get directorLabel => 'Dyrektor';

  @override
  String get regionalManagerLabel => 'Kierownik regionalny';

  @override
  String get whoAreYouTitle => 'Kim jesteś?';

  @override
  String get searchLabel => 'Szukaj';

  @override
  String get noMatchesLabel => 'Brak wyników';

  @override
  String get leadershipSectionTitle => 'Kierownictwo';

  @override
  String get kitchenStaffSectionTitle => 'Personel kuchni';

  @override
  String get chooseASectionTitle => 'Wybierz sekcję';

  @override
  String get unassignedLabel => 'Nieprzypisani';

  @override
  String personCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count osób',
      one: '$count osoba',
    );
    return '$_temp0';
  }

  @override
  String get goodMorning => 'Dzień dobry';

  @override
  String get goodAfternoon => 'Dzień dobry';

  @override
  String get goodEvening => 'Dobry wieczór';

  @override
  String get welcomeToVenurite => 'Witamy w VenuRite';

  @override
  String get helpAssistantTooltip => 'Pomoc i asystent';

  @override
  String get couldntLoadScreen => 'Nie udało się załadować tego ekranu.';

  @override
  String get retryLabel => 'Ponów';

  @override
  String get microphonePermissionDenied => 'Odmówiono dostępu do mikrofonu.';

  @override
  String get couldntRecordTryAgain =>
      'Nie udało się nagrać - spróbuj ponownie.';

  @override
  String get couldntTranscribe => 'Nie udało się przetworzyć nagrania.';

  @override
  String get couldntReachTranscriptionService =>
      'Nie udało się połączyć z usługą transkrypcji.';

  @override
  String get dictateANote => 'Podyktuj notatkę';

  @override
  String get stoppingSoonTapToStop =>
      'Zatrzyma się wkrótce - dotknij, aby zatrzymać teraz';

  @override
  String get stopLabel => 'Zatrzymaj';

  @override
  String get somethingWentWrong => 'Coś poszło nie tak';

  @override
  String alertsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertów',
      one: '1 alert',
    );
    return '$_temp0';
  }

  @override
  String unacknowledgedCountLabel(int count) {
    return '$count nieodczytanych';
  }

  @override
  String get allAcknowledgedLabel => 'Wszystkie potwierdzone';

  @override
  String overdueUnacknowledgedMinutes(int minutes) {
    return 'ZALEGŁE - nieodczytane od $minutes min';
  }

  @override
  String get escalatedToTopTier => 'Eskalowano do najwyższego szczebla';

  @override
  String get acknowledgeLabel => 'Potwierdź';

  @override
  String get nothingInCategory => 'Brak wpisów w tej kategorii.';

  @override
  String categoryWithCountLabel(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get leadershipOverview => 'Przegląd kierownictwa';

  @override
  String get photoEvidence => 'Dowody fotograficzne';

  @override
  String get staffManagement => 'Zarządzanie personelem';

  @override
  String get addTeamMember => 'Dodaj członka zespołu';

  @override
  String get shiftLog => 'Dziennik zmian';

  @override
  String get branchTeamStructure => 'Struktura zespołu oddziału';

  @override
  String get departmentManagement => 'Zarządzanie działami';

  @override
  String get rosterBoard => 'Tablica grafiku';

  @override
  String get claimShifts => 'Zgłoś się do zmiany';

  @override
  String get requestADayOff => 'Poproś o dzień wolny';

  @override
  String get shiftFairnessReview => 'Przegląd sprawiedliwości grafiku';

  @override
  String get venueDetails => 'Szczegóły lokalu';

  @override
  String get assignTasks => 'Przypisz zadania';

  @override
  String get taskPresets => 'Szablony zadań';

  @override
  String get supplierManagement => 'Zarządzanie dostawcami';

  @override
  String get serviceProviders => 'Usługodawcy';

  @override
  String get notificationRules => 'Reguły powiadomień';

  @override
  String get documentCentre => 'Centrum dokumentów';

  @override
  String get setupWizard => 'Kreator konfiguracji';

  @override
  String get organisationLabel => 'Organizacja';

  @override
  String get branchesLabel => 'Oddziały';

  @override
  String get homeLabel => 'Strona główna';

  @override
  String get oversightLabel => 'Nadzór';

  @override
  String get problemsAndIssues => 'Problemy i zgłoszenia';

  @override
  String get twoFactorAuthentication => 'Uwierzytelnianie dwuskładnikowe';

  @override
  String get backUpNow => 'Utwórz kopię zapasową teraz';

  @override
  String get dailySection => 'Codzienne';

  @override
  String get insightsSection => 'Analizy';

  @override
  String get peopleSection => 'Personel';

  @override
  String get rosterSection => 'Grafik';

  @override
  String get venueSetupSection => 'Konfiguracja lokalu';

  @override
  String get companySection => 'Firma';

  @override
  String get accountSection => 'Konto';

  @override
  String get settingsLabel => 'Ustawienia';

  @override
  String percentCompletedTodayChip(int percent) {
    return '$percent% ukończono dzisiaj';
  }

  @override
  String activeStaffCountLabel(int count) {
    return '$count aktywnych pracowników';
  }

  @override
  String failCountTodayBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NIEZALICZONYCH dzisiaj',
      one: '1 NIEZALICZONE dzisiaj',
    );
    return '$_temp0';
  }

  @override
  String get managerViewTitle => 'Widok kierownika';

  @override
  String showingScopeLabel(String scope) {
    return 'Wyświetlane: $scope';
  }

  @override
  String get supervisorNoScopeMessageLog =>
      'Nie zostałeś jeszcze przypisany do sekcji ani zespołu - poproś kierownika o skonfigurowanie tego w Zarządzaniu personelem, zanim ten dziennik będzie miał cokolwiek do pokazania.';

  @override
  String entriesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wpisów',
      one: '1 wpis',
    );
    return '$_temp0';
  }

  @override
  String failCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NIEZALICZONYCH',
      one: '1 NIEZALICZONE',
    );
    return '$_temp0';
  }

  @override
  String get noFailsLabel => 'Brak niezaliczonych';

  @override
  String get noCompletedTasksLoggedYet =>
      'Brak zarejestrowanych ukończonych zadań';

  @override
  String sessionSummariesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count podsumowań zmian',
      one: '1 podsumowanie zmiany',
    );
    return '$_temp0';
  }

  @override
  String passFailCountLabel(int passCount, int failCount) {
    return '$passCount zaliczone / $failCount niezaliczone';
  }

  @override
  String get workerFixedIt => 'Pracownik to naprawił';

  @override
  String get noCorrectiveActionRecorded =>
      'Nie zarejestrowano działania naprawczego';

  @override
  String get taskAlertFallback => 'Alert zadania';

  @override
  String get loggedByLabel => 'Zarejestrował(a)';

  @override
  String get resultLabel => 'Wynik';

  @override
  String get correctiveActionLabel => 'Działanie naprawcze';

  @override
  String get noteLabel => 'Notatka';

  @override
  String get closeLabel => 'Zamknij';

  @override
  String get notCompletedSuffix => '- NIEUKOŃCZONE (zmiana zakończona)';

  @override
  String get todayAllFails => 'Dzisiaj + wszystkie niezaliczone';

  @override
  String byAxisLabel(String axis) {
    return 'Wg $axis';
  }

  @override
  String get nameAxisLabel => 'Nazwa';

  @override
  String get dateAxisLabel => 'Data';

  @override
  String get taskAxisLabel => 'Zadanie';

  @override
  String get filterLabel => 'Filtr';

  @override
  String get filterByLabel => 'Filtruj wg:';

  @override
  String get clearFiltersLabel => 'Wyczyść filtry';

  @override
  String get staffLabel => 'Pracownik';
}
