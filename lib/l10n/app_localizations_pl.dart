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
  String get shortDeliveryLabel => 'Niepełna dostawa';

  @override
  String get damagedStockLabel => 'Uszkodzony towar';

  @override
  String get lateDeliveryLabel => 'Opóźniona dostawa';

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

  @override
  String get issueTypeComplaint => 'Skarga';

  @override
  String get issueTypeAccident => 'Wypadek';

  @override
  String get issueTypeIncident => 'Incydent';

  @override
  String get issueTypeSupplyProblem => 'Problem z dostawą';

  @override
  String get issueTypeVenueProblem => 'Problem z lokalem';

  @override
  String get issueTypeOther => 'Inne';

  @override
  String get incorrectDeliveryLabel => 'Niewłaściwa dostawa';

  @override
  String get driverProblemLabel => 'Problem z kierowcą';

  @override
  String get otherLabel => 'Inne';

  @override
  String get whatKindOfThingHappened => 'Co się stało?';

  @override
  String get whichOneLabel => 'Który?';

  @override
  String get supplierLabel => 'Dostawca';

  @override
  String get whatWasWrongWithDelivery => 'Co było nie tak z dostawą?';

  @override
  String get receivedByLabel => 'Odebrane przez';

  @override
  String get whichSectionOptional => 'Której sekcji to dotyczy? (opcjonalnie)';

  @override
  String get noSectionLabel => 'Brak sekcji';

  @override
  String get teamOptionalLabel => 'Zespół (opcjonalnie)';

  @override
  String get noSpecificTeamLabel => 'Brak konkretnego zespołu';

  @override
  String get whatHappenedLabel => 'Co się stało?';

  @override
  String get markAsUrgentLabel => 'Oznacz jako pilne';

  @override
  String get markUrgentSubtitle =>
      'Wymaga natychmiastowej uwagi, niezależnie od tego, jak długo pozostaje nierozwiązane';

  @override
  String get logItButton => 'Zarejestruj';

  @override
  String get escalateToTitle => 'Eskaluj do';

  @override
  String get sendToLabel => 'Wyślij do';

  @override
  String get escalateButton => 'Eskaluj';

  @override
  String get savedLabel => 'Zapisano.';

  @override
  String remindedMessage(String name) {
    return 'Przypomniano $name.';
  }

  @override
  String get couldNotSendReminder => 'Nie udało się wysłać przypomnienia.';

  @override
  String get viewSupplierScorecard => 'Zobacz kartę oceny dostawcy';

  @override
  String raisedAtLabel(String date) {
    return 'Zgłoszono $date';
  }

  @override
  String escalatedToColonLabel(String name) {
    return 'Eskalowano do: $name';
  }

  @override
  String get historyLabel => 'Historia';

  @override
  String get addAnUpdateLabel => 'Dodaj aktualizację';

  @override
  String get addProcessNoteButton => 'Dodaj notatkę procesową';

  @override
  String get resolveButton => 'Rozwiąż';

  @override
  String get reopenThisIssueTitle => 'Otwórz ponownie to zgłoszenie';

  @override
  String get whyReopenLabel => 'Dlaczego należy to ponownie otworzyć?';

  @override
  String get reopenButton => 'Otwórz ponownie';

  @override
  String sentToLabel(String name) {
    return 'Wysłano do $name';
  }

  @override
  String get remindButton => 'Przypomnij';

  @override
  String get phaseRaisedLabel => 'Zgłoszono';

  @override
  String get phaseUpdateLabel => 'Aktualizacja';

  @override
  String get phaseOutcomeLabel => 'Wynik';

  @override
  String get allLabel => 'Wszystkie';

  @override
  String get dateRangeLabel => 'Zakres dat';

  @override
  String get allDatesLabel => 'Wszystkie daty';

  @override
  String get typeLabel => 'Typ';

  @override
  String get anyTypeLabel => 'Dowolny typ';

  @override
  String get anyoneLabel => 'Ktokolwiek';

  @override
  String staffFallback(String id) {
    return 'Pracownik #$id';
  }

  @override
  String get nothingHereGoodSign => 'Nic tu nie ma - to dobry znak.';

  @override
  String escalatedToNameLabel(String name) {
    return 'Eskalowano do $name';
  }

  @override
  String get havenReportedYet => 'Nie zgłosiłeś jeszcze niczego.';

  @override
  String get failsAndProblemsRegisterTitle => 'Rejestr niezaliczeń i problemów';

  @override
  String get taskProblemsTab => 'Problemy z zadaniami';

  @override
  String get issuesAndIncidentsTab => 'Zgłoszenia i incydenty';

  @override
  String get failFilterLabel => 'Niezaliczone';

  @override
  String get reportedFilterLabel => 'Zgłoszone';

  @override
  String get notCompletedFilterLabel => 'Niedokończone';

  @override
  String get abandonedLabel => 'Porzucone';

  @override
  String get noActionTakenLabel => 'Brak działania';

  @override
  String get markResolvedButton => 'Oznacz jako rozwiązane';

  @override
  String get openLabel => 'Otwarte';

  @override
  String get enableRosterQuestion => 'Włączyć Grafik?';

  @override
  String rosterQuoteBody(String amount) {
    return 'Na podstawie obecnej liczby pracowników doda to $amount do Twojego miesięcznego polecenia zapłaty, począwszy od następnej płatności.';
  }

  @override
  String get confirmAndEnable => 'Potwierdź i włącz';

  @override
  String couldNotReachVenurite(String error) {
    return 'Nie udało się połączyć z VenuRite: $error';
  }

  @override
  String get letStaffClaimShifts =>
      'Pozwól pracownikom samodzielnie zgłaszać się do zmian';

  @override
  String get rosterPitchBody =>
      'Publikuj wolne zmiany i pozwól pracownikom samodzielnie je zajmować - koniec z obdzwanianiem lub grupą na WhatsAppie, gdy ktoś nie może przyjść. Pracownicy mogą też prosić o dni wolne, a Ty zatwierdzasz lub odrzucasz z tego samego miejsca.';

  @override
  String get pricingLabel => 'Cennik';

  @override
  String get priceUnder10Staff =>
      '6 GBP/miesiąc za oddział z mniej niż 10 pracownikami';

  @override
  String get price10PlusStaff =>
      '10 GBP/miesiąc za oddział z 10 lub więcej pracownikami';

  @override
  String get addedToDirectDebitNote =>
      'Dodane do istniejącego polecenia zapłaty - nie jest potrzebna nowa metoda płatności. Przed potwierdzeniem zobaczysz dokładną kwotę.';

  @override
  String get enableRosterButton => 'Włącz Grafik';

  @override
  String get availableShiftsTitle => 'Dostępne zmiany';

  @override
  String get shiftClaimingNotEnabled =>
      'Zgłaszanie się do zmian nie jest jeszcze włączone dla tego lokalu. Poproś kierownika o włączenie tego w Ustawieniach.';

  @override
  String couldNotLoadShifts(String error) {
    return 'Nie udało się załadować zmian: $error';
  }

  @override
  String get noShiftsPostedYet => 'Nie opublikowano jeszcze żadnych zmian.';

  @override
  String get someoneElseClaimedShift =>
      'Ktoś inny właśnie zgłosił się do tej zmiany - przepraszamy!';

  @override
  String get shiftClaimedMessage => 'Zmiana zgłoszona.';

  @override
  String get cancelThisShiftTitle => 'Anulować tę zmianę?';

  @override
  String get cancelShiftLateWarning =>
      '\n\nZostało mniej niż 24 godziny do rozpoczęcia zmiany - anulowanie teraz może wpłynąć na Twoją historię niezawodności.';

  @override
  String willNoLongerBeClaimed(String warning) {
    return 'Nie będziesz już zgłoszony(a) do tej zmiany.$warning';
  }

  @override
  String get keepShiftButton => 'Zachowaj zmianę';

  @override
  String get cancelShiftButton => 'Anuluj zmianę';

  @override
  String get yourShiftRecordReliable => 'Twoja historia zmian: Niezawodny(a)';

  @override
  String get yourShiftRecordNeedsImprovement =>
      'Twoja historia zmian: Wymaga poprawy';

  @override
  String get yourShiftRecordBuilding =>
      'Twoja historia zmian: Budowanie historii';

  @override
  String get claimLabel => 'Zgłoś się';

  @override
  String get claimedLabel => 'Zgłoszono';

  @override
  String requestDateOffTitle(String date) {
    return 'Poproś o wolne $date';
  }

  @override
  String get reasonOptionalLabel => 'Powód (opcjonalnie)';

  @override
  String get submitRequestButton => 'Wyślij prośbę';

  @override
  String get offDayRequestsNotEnabled =>
      'Prośby o dzień wolny nie są jeszcze włączone dla tego lokalu. Poproś kierownika o włączenie Grafiku w Ustawieniach.';

  @override
  String get noOffDayRequestsYet =>
      'Nie masz jeszcze żadnych próśb o dzień wolny.';

  @override
  String get yourRequestsLabel => 'Twoje prośby';

  @override
  String get approvedLabel => 'Zatwierdzono';

  @override
  String get deniedLabel => 'Odrzucono';

  @override
  String get pendingLabel => 'Oczekujące';

  @override
  String get postAShiftTitle => 'Opublikuj zmianę';

  @override
  String get categoryHint => 'np. Naprawa chłodnictwa, Zwalczanie szkodników';

  @override
  String get pickStartTime => 'Wybierz godzinę rozpoczęcia';

  @override
  String get pickEndTime => 'Wybierz godzinę zakończenia';

  @override
  String get postLabel => 'Opublikuj';

  @override
  String get assignShiftToTitle => 'Przypisz tę zmianę do';

  @override
  String get unknownLabel => 'Nieznany';

  @override
  String get shiftsTabLabel => 'Zmiany';

  @override
  String get offDayRequestsTabLabel => 'Prośby o dzień wolny';

  @override
  String get rosterAddonNotEnabledManager =>
      'Dodatek Grafik nie jest włączony dla tego lokalu. Włącz go w Ustawienia > Firma, aby zacząć publikować zmiany.';

  @override
  String get noShiftsTapPlus =>
      'Nie opublikowano jeszcze żadnych zmian. Dotknij +, aby dodać.';

  @override
  String get openStatusLabel => 'Wolna';

  @override
  String get assignedStatusPrefix => 'Przypisana';

  @override
  String get claimedStatusPrefix => 'Zgłoszona';

  @override
  String get assignDirectlyLabel => 'Przypisz bezpośrednio';

  @override
  String get removeClaimLabel => 'Usuń zgłoszenie';

  @override
  String couldNotLoadOffDayRequests(String error) {
    return 'Nie udało się załadować próśb o dzień wolny: $error';
  }

  @override
  String get noOffDayRequests => 'Brak próśb o dzień wolny.';

  @override
  String get approveLabel => 'Zatwierdź';

  @override
  String get denyLabel => 'Odrzuć';

  @override
  String get rosterAddonNotEnabledPlain =>
      'Dodatek Grafik nie jest włączony dla tego lokalu.';

  @override
  String get noActiveStaffVenue => 'Brak aktywnego personelu w tym lokalu.';

  @override
  String get last90DaysAlphabetical =>
      'Ostatnie 90 dni, według kategorii zmian. Alfabetycznie - nie ranking.';

  @override
  String shiftsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zmian',
      one: '1 zmiana',
    );
    return '$_temp0';
  }

  @override
  String get noShiftsInPeriod => 'Brak zmian w tym okresie.';

  @override
  String categoryCountLabel(String category, int count) {
    return '$category: $count';
  }

  @override
  String get backupExplanation =>
      'Tworzy to pełną kopię lokalnej bazy danych w folderze Dokumenty. Przeniesienie jej na dysk USB lub folder synchronizowany z chmurą to osobny, ręczny krok.';

  @override
  String get backupNameOptional => 'Nazwa kopii zapasowej (opcjonalnie)';

  @override
  String get backupNameHint => 'np. Kopia przed inspekcją';

  @override
  String get backupCreatedTitle => 'Kopia zapasowa utworzona';

  @override
  String get tierTeamMember => 'Członek zespołu';

  @override
  String get tierSupervisor => 'Kierownik zmiany';

  @override
  String get tierManager => 'Kierownik';

  @override
  String get tierRegionalManager => 'Kierownik regionalny';

  @override
  String get tierDirector => 'Dyrektor';

  @override
  String get anyTaskFail => 'Dowolne niezaliczenie zadania';

  @override
  String taskFailLabel(String title) {
    return 'Niezaliczenie: $title';
  }

  @override
  String get taskFailTemplateStale =>
      'Niezaliczenie zadania (szablon nieaktualny)';

  @override
  String get unknownUserLabel => 'Nieznany użytkownik';

  @override
  String tierSuffixLabel(String tier) {
    return 'poziom $tier';
  }

  @override
  String get unsetLabel => 'Nieustawione';

  @override
  String get pushChannelLabel => 'powiadomienie push';

  @override
  String get emailChannelLabel => 'e-mail';

  @override
  String get inAppOnlyLabel => 'tylko w aplikacji';

  @override
  String inAppPlusChannelsLabel(String channels) {
    return 'w aplikacji + $channels';
  }

  @override
  String get tierColumnTeam => 'Zespół';

  @override
  String get tierColumnSupv => 'Kier.zm.';

  @override
  String get tierColumnMgr => 'Kier.';

  @override
  String get tierColumnRegnl => 'Region.';

  @override
  String get tierColumnDir => 'Dyr.';

  @override
  String get quickSetupSectionTitle =>
      'Szybka konfiguracja: powiadomienia o niezaliczeniu zadań';

  @override
  String get tickTierNotified =>
      'Zaznacz, który poziom ma być powiadamiany, gdy dane zadanie zostanie niezaliczone.';

  @override
  String get noTaskTemplatesSetUp =>
      'Nie skonfigurowano jeszcze żadnych szablonów zadań.';

  @override
  String notifyPrefixLabel(String target, String channels) {
    return 'Powiadom: $target ($channels)';
  }

  @override
  String setByTierLabel(String tier) {
    return 'Ustawione przez poziom $tier';
  }

  @override
  String get inactiveSuffixLabel => ' - nieaktywne';

  @override
  String get deactivateButton => 'Dezaktywuj';

  @override
  String get reactivateButton => 'Reaktywuj';

  @override
  String get newRuleTitle => 'Nowa reguła';

  @override
  String get triggerLabel => 'Wyzwalacz';

  @override
  String get notifyLabel => 'Powiadom';

  @override
  String get wholeRoleTierOption => 'Cały poziom roli';

  @override
  String get specificPersonOption => 'Konkretną osobę';

  @override
  String get roleTierLabel => 'Poziom roli';

  @override
  String get personLabel => 'Osoba';

  @override
  String get pushLabel => 'Push';

  @override
  String get rulesInAppNotice =>
      'Reguły są obecnie pokazywane w aplikacji; dostarczanie push/e-mail nie jest jeszcze połączone z backendem i zostanie dodane w kolejnym sprincie.';

  @override
  String get saveRuleButton => 'Zapisz regułę';

  @override
  String get addRuleButton => 'Dodaj regułę';

  @override
  String get noNotificationRulesYet =>
      'Nie skonfigurowano jeszcze żadnych reguł powiadomień.';

  @override
  String get stepYourAccount => 'Twoje konto';

  @override
  String get stepCompanyDetails => 'Dane firmy';

  @override
  String get stepOrgStructure => 'Struktura organizacji';

  @override
  String get stepFirstVenue => 'Pierwszy lokal';

  @override
  String get stepStarterSetup => 'Twój zestaw startowy';

  @override
  String get stepSubscription => 'Subskrypcja';

  @override
  String get stepPayment => 'Płatność';

  @override
  String get termsOfServiceTitle => 'Regulamin';

  @override
  String get companySignupGenericError =>
      'Coś poszło nie tak podczas tworzenia firmy. Spróbuj ponownie - jeśli problem się powtarza, skontaktuj się z VenuRite.';

  @override
  String get directDebitStartError =>
      'Nie udało się automatycznie uruchomić konfiguracji polecenia zapłaty - możesz to zrobić w dowolnym momencie w Ustawieniach po zalogowaniu.';

  @override
  String get continueButton => 'Dalej';

  @override
  String get creatingEllipsis => 'Tworzenie...';

  @override
  String get startFreeTrialButton => 'Rozpocznij bezpłatny okres próbny';

  @override
  String get companyCreatedTitle => 'Firma utworzona';

  @override
  String get adminAccountIntro =>
      'Skonfigurujmy twoje konto. Będziesz administratorem tej firmy w VenuRite i będziesz mógł zaprosić swój zespół, gdy tylko się zalogujesz.';

  @override
  String get firstNameLabel => 'Imię';

  @override
  String get lastNameLabel => 'Nazwisko';

  @override
  String get passwordMinCharsHelper => 'Co najmniej 8 znaków';

  @override
  String get companyDetailsIntro => 'Opowiedz nam o swojej firmie.';

  @override
  String get tradingCompanyNameLabel => 'Nazwa handlowa / firmy';

  @override
  String get legalCompanyNameLabel => 'Pełna nazwa firmy (opcjonalnie)';

  @override
  String get legalCompanyNameHelper =>
      'Zostaw puste, aby użyć nazwy handlowej podanej powyżej';

  @override
  String get countryLabel => 'Kraj';

  @override
  String get registeredAddressLabel =>
      'Adres rejestrowy / siedziby (opcjonalnie)';

  @override
  String get vatNumberLabel => 'Numer VAT / NIP (jeśli dotyczy)';

  @override
  String get billingContactEmailLabel =>
      'E-mail kontaktowy do rozliczeń (opcjonalnie)';

  @override
  String get structureIntro =>
      'Oto jak VenuRite organizuje twoją firmę. Nie musisz teraz niczego konfigurować - to tylko po to, by kolejny krok miał sens.';

  @override
  String get structureYourCompanyLabel => 'Twoja firma';

  @override
  String get structureYourCompanySublabel =>
      'Jedno skonsolidowane konto i rachunek';

  @override
  String get structureRegionsLabel => 'Regiony (opcjonalnie)';

  @override
  String get structureRegionsSublabel =>
      'Grupuj lokale według kraju lub obszaru - pomiń, jeśli tego nie potrzebujesz';

  @override
  String get structureVenuesLabel => 'Lokale';

  @override
  String get structureVenuesSublabel =>
      'Jeden lokal dziś, setki później - dodawaj kolejne w dowolnym momencie';

  @override
  String get structureStaffLabel => 'Personel';

  @override
  String get structureStaffSublabel =>
      'Zespół każdego lokalu, zapraszany, gdy lokal już istnieje';

  @override
  String get structureOutro =>
      'Następnie skonfigurujemy twój pierwszy lokal - regiony i kolejne lokale możesz dodać później w aplikacji.';

  @override
  String get wizardFirstVenueHeroTitle => 'Dodajmy twój pierwszy lokal';

  @override
  String get addMoreVenuesLaterText => 'Kolejne lokale możesz dodać później.';

  @override
  String get venueNameLabel => 'Nazwa lokalu';

  @override
  String get addressOptionalLabel => 'Adres (opcjonalnie)';

  @override
  String get regionAreaOptionalLabel => 'Region / obszar (opcjonalnie)';

  @override
  String get regionAreaHelper =>
      'np. \"Warszawa\" - potrzebne tylko, jeśli masz (lub będziesz mieć) więcej niż jeden lokal';

  @override
  String get venueTypeOptionalLabel => 'Typ lokalu (opcjonalnie)';

  @override
  String get venueTypeHelper =>
      'Wybranie typu pokaże gotowy zestaw startowy - zadania i sprzęt, które już wiesz, że są potrzebne.';

  @override
  String get payoffSkippedText =>
      'Pominąłeś wybór typu lokalu, więc nie ma jeszcze zestawu startowego do pokazania - zadania i sprzęt możesz dodać samodzielnie po zalogowaniu.';

  @override
  String get payoffErrorText =>
      'Nie udało się wczytać zestawu startowego dla tego typu lokalu - zadania i sprzęt możesz dodać samodzielnie po zalogowaniu.';

  @override
  String get payoffHeroTitle => 'Oto twoja gotowa zgodność z przepisami';

  @override
  String get equipmentSectionLabel => 'Sprzęt';

  @override
  String get subscriptionBannerText =>
      'Jedno konto firmowe, jeden skonsolidowany rachunek - cena za lokal, nigdy za osobę.';

  @override
  String get subscriptionIntroText =>
      'Ile lokali masz dziś, wliczając siedzibę główną, jeśli ją posiadasz? Teraz skonfigurujesz tylko swój pierwszy lokal - resztę dodasz w dowolnym momencie w aplikacji.';

  @override
  String get perBranchPriceLabel => '39 GBP/lokal/miesiąc';

  @override
  String get headOfficeIncludedLabel =>
      '+ 1 lokal siedziby głównej (4+ lokale)';

  @override
  String get discountCodeHint =>
      'Masz kod rabatowy? Możesz go wpisać podczas konfigurowania polecenia zapłaty.';

  @override
  String get trialBannerText =>
      'Rozpoczynasz 14-dniowy bezpłatny okres próbny - dziś karta nie jest potrzebna.';

  @override
  String get paymentStepIntro =>
      'Poprosimy cię o skonfigurowanie płatności przed końcem okresu próbnego, w Ustawieniach w aplikacji. Teraz nic nie jest pobierane - powiedz nam tylko, jak wolisz płacić.';

  @override
  String get cardPaymentTitle => 'Płatność kartą (Stripe)';

  @override
  String get cardPaymentSubtitle =>
      'Karta debetowa/kredytowa, rozliczana miesięcznie lub rocznie';

  @override
  String get directDebitTitle => 'Polecenie zapłaty (GoCardless)';

  @override
  String get directDebitSubtitle =>
      'Płatność bank-bank, karta nie jest wymagana';

  @override
  String get decideLaterButton => 'Zdecyduję później';

  @override
  String get decideLaterSnackbar =>
      'Nie ma problemu - możesz to skonfigurować w dowolnym momencie w Ustawieniach.';

  @override
  String get agreeToTermsPrefix => 'Przeczytałem/am i akceptuję ';

  @override
  String get successActivatedBanner =>
      'Twoja firma i pierwszy lokal są skonfigurowane, a ty jesteś zalogowany/a.';

  @override
  String get successNotActivatedBanner =>
      'Twoja firma i pierwszy lokal są skonfigurowane. Zaloguj się swoim e-mailem i hasłem, które właśnie wybrałeś/aś.';

  @override
  String get directDebitSettingUp => 'Konfigurowanie polecenia zapłaty...';

  @override
  String get directDebitOpenedBrowser =>
      'Otworzyliśmy twoją przeglądarkę, aby dokończyć konfigurację polecenia zapłaty.';

  @override
  String get inviteYourTeamTitle => 'Zaproś swój zespół';

  @override
  String get inviteYourTeamSubtitle =>
      'Opcjonalnie - dodaj osoby obecnie na zmianie albo pomiń i zrób to później w Zarządzaniu personelem.';

  @override
  String get jobTitleLabel => 'Stanowisko';

  @override
  String get tierFieldLabel => 'Poziom';

  @override
  String get addTeamMemberButton => 'Dodaj członka zespołu';

  @override
  String get goToDashboardButton => 'Przejdź do panelu';

  @override
  String get goToSignInButton => 'Przejdź do logowania';

  @override
  String wizardStepOfLabel(String title, int step, int total) {
    return '$title - Krok $step z $total';
  }

  @override
  String billingContactEmailHelper(String email) {
    return 'Zostaw puste, aby użyć $email';
  }

  @override
  String payoffNoStarterSet(String venueType) {
    return 'Nie mamy jeszcze gotowego zestawu startowego dla \"$venueType\" - zadania i sprzęt możesz dodać samodzielnie po zalogowaniu.';
  }

  @override
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  ) {
    return '$totalTasks zadań w $sectionCount sekcjach i $equipmentCount typów sprzętu już skonfigurowanych dla \"$venueType\".';
  }

  @override
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  ) {
    return '$totalTasks zadań w $sectionCount sekcjach już skonfigurowanych dla \"$venueType\".';
  }

  @override
  String totalPerMonthLabel(String total, int units) {
    return '£$total/miesiąc łącznie ($units lokali rozliczanych)';
  }

  @override
  String staffPinLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get jobRoleChefCook => 'Kucharz/Szef kuchni';

  @override
  String get jobRoleKitchenPorter => 'Pomoc kuchenna';

  @override
  String get jobRoleFrontOfHouse => 'Sala';

  @override
  String get jobRoleBar => 'Bar';

  @override
  String get jobRoleManagement => 'Kierownictwo';

  @override
  String get jobRoleEveryone => 'Wszyscy';

  @override
  String get jobRoleMaintenance => 'Konserwacja';

  @override
  String get jobRoleHousekeeping => 'Utrzymanie czystości';

  @override
  String get jobRoleReception => 'Recepcja';

  @override
  String get jobRoleSecurity => 'Ochrona';

  @override
  String get segmentFoodSafety =>
      'Bezpieczeństwo żywności i kontrola temperatury';

  @override
  String get segmentAllergen => 'Zarządzanie alergenami';

  @override
  String get segmentPersonalHygienePpe => 'Higiena osobista i ŚOI';

  @override
  String get segmentRefrigerationColdStorage =>
      'Chłodnictwo i przechowywanie w chłodzie';

  @override
  String get segmentCookingLineEquipment => 'Urządzenia linii gotowania';

  @override
  String get segmentWashupDishwash => 'Zmywalnia / Mycie naczyń';

  @override
  String get segmentCleaningSanitation => 'Czyszczenie i sanitacja';

  @override
  String get segmentCleaningChemicals =>
      'Środki czystości i materiały eksploatacyjne';

  @override
  String get segmentDryAmbientStorage =>
      'Magazyn suchy i temperatury otoczenia';

  @override
  String get segmentDeliveriesGoodsIn => 'Dostawy i przyjęcie towaru';

  @override
  String get segmentUtilitiesSafety => 'Media i bezpieczeństwo';

  @override
  String get segmentWastePestControl => 'Odpady i kontrola szkodników';

  @override
  String get segmentPreventiveMaintenance =>
      'Konserwacja zapobiegawcza (sprzęt kuchenny)';

  @override
  String get segmentStockControl => 'Kontrola zapasów';

  @override
  String get segmentOpeningProcedures => 'Procedury otwarcia';

  @override
  String get segmentClosingProcedures => 'Procedury zamknięcia';

  @override
  String get segmentServiceReadiness => 'Gotowość do obsługi';

  @override
  String get segmentFrontOfHouse => 'Sala / Obsługa';

  @override
  String get segmentBarBeverage => 'Bar i napoje';

  @override
  String get segmentHotelSpecific => 'Specyficzne dla hotelu';

  @override
  String get segmentManagementComplianceOversight =>
      'Zarządzanie i nadzór nad zgodnością';

  @override
  String get segmentMaintenance => 'Konserwacja';

  @override
  String get segmentHousekeeping => 'Utrzymanie czystości';

  @override
  String get segmentReception => 'Recepcja';

  @override
  String get segmentSecurity => 'Ochrona';

  @override
  String get freqDaily => 'Codziennie';

  @override
  String get freqWeekly => 'Co tydzień';

  @override
  String get freqPerShift => 'Na zmianę';

  @override
  String get freqThreeXDaily => '3x dziennie';

  @override
  String get freqTwoXDaily => '2x dziennie';

  @override
  String get freqPerBatch => 'Na partię';

  @override
  String get freqPerDelivery => 'Na dostawę';

  @override
  String get freqPerUse => 'Przy użyciu';

  @override
  String get freqPerService => 'Na usługę';

  @override
  String get freqTwoXPerService => '2x na usługę';

  @override
  String get freqEventBased => 'Wg zdarzenia';

  @override
  String get freqAsNeeded => 'W razie potrzeby';

  @override
  String get freqMonthly => 'Co miesiąc';

  @override
  String get freqCustom => 'Niestandardowa';

  @override
  String get jobRoleFieldLabel => 'Rola zawodowa';

  @override
  String get pinFieldLabel => 'PIN';

  @override
  String get addStaffMemberTitle => 'Dodaj pracownika';

  @override
  String get addLabel => 'Dodaj';

  @override
  String get assignTasksTitle => 'Przypisz zadania';

  @override
  String get noActiveSiteFoundError => 'Nie znaleziono aktywnego lokalu.';

  @override
  String get byPersonLabel => 'Wg osoby';

  @override
  String get byTaskLabel => 'Wg zadania';

  @override
  String get noEquipmentOfTypeSetUp =>
      'Brak sprzętu tego typu skonfigurowanego jeszcze.';

  @override
  String get applyButton => 'Zastosuj';

  @override
  String get assignToTitle => 'Przypisz do';

  @override
  String get noStaffMatchTiers =>
      'Żaden personel nie pasuje do poziomu(ów), do których te zadania się stosują.';

  @override
  String get assignButton => 'Przypisz';

  @override
  String get showInstructionsTooltip => 'Pokaż instrukcje';

  @override
  String get selectTasksToAssignLabel => 'Wybierz zadania do przypisania';

  @override
  String get taskPresetsSectionTitle => 'Zestawy zadań';

  @override
  String get showAllPresetsButton => 'Pokaż wszystkie zestawy';

  @override
  String get showTasksInGroupTooltip => 'Pokaż zadania w tej grupie';

  @override
  String get applyToMultipleButton => 'Zastosuj do wielu';

  @override
  String get addCustomTaskButton => 'Dodaj zadanie niestandardowe';

  @override
  String get customTaskSectionTitle => 'Zadanie niestandardowe';

  @override
  String get titleFieldLabel => 'Tytuł';

  @override
  String get departmentSectionLabel => 'Dział / sekcja';

  @override
  String get methodLabel => 'Metoda';

  @override
  String get methodTick => 'Zaznaczenie';

  @override
  String get methodData => 'Dane';

  @override
  String get methodDataTick => 'Dane + zaznaczenie';

  @override
  String get methodTickPhoto => 'Zaznaczenie + zdjęcie';

  @override
  String get methodDataPhoto => 'Dane + zdjęcie';

  @override
  String get methodNote => 'Notatka';

  @override
  String get methodDataNote => 'Dane + notatka';

  @override
  String get methodNotePhoto => 'Notatka + zdjęcie';

  @override
  String get methodTickNote => 'Zaznaczenie + notatka';

  @override
  String get methodMulti => 'Wielokrotny';

  @override
  String get requiresPhotoLabel => 'Wymaga zdjęcia';

  @override
  String get requiresNotesLabel => 'Wymaga notatek';

  @override
  String get minLimitLabel => 'Limit minimalny';

  @override
  String get maxLimitLabel => 'Limit maksymalny';

  @override
  String get unitHintLabel => 'Jednostka (np. Celsjusz)';

  @override
  String get equipmentTypeOptionalLabel => 'Typ sprzętu (opcjonalnie)';

  @override
  String get noneLabel => 'Brak';

  @override
  String get priorityLabel => 'Priorytet';

  @override
  String get priorityCritical => 'Krytyczny';

  @override
  String get priorityHigh => 'Wysoki';

  @override
  String get priorityStandard => 'Standardowy';

  @override
  String get requiresCorrectiveActionLabel =>
      'Wymaga działania naprawczego przy niepowodzeniu';

  @override
  String get fixInstructionsLabel => 'Instrukcje naprawy';

  @override
  String get customFieldsJsonLabel => 'Pola niestandardowe (JSON, opcjonalnie)';

  @override
  String get extraFieldsSectionTitle => 'Dodatkowe pola (opcjonalnie)';

  @override
  String get removeTooltip => 'Usuń';

  @override
  String get fieldLabelHint => 'Etykieta pola (np. numer zamówienia)';

  @override
  String get extraFieldTypeText => 'Tekst';

  @override
  String get extraFieldTypeNumber => 'Liczba';

  @override
  String get extraFieldTypeDate => 'Data';

  @override
  String get addFieldTooltip => 'Dodaj pole';

  @override
  String get saveCustomTaskButton => 'Zapisz zadanie niestandardowe';

  @override
  String get adHocLabel => 'Doraźnie';

  @override
  String get timeAllocatedLabel => 'Zaplanowany czas';

  @override
  String get frequencyPrefixLabel => 'Częstotliwość: ';

  @override
  String get atATimeLabel => 'O określonej porze';

  @override
  String get fromStartOfShiftLabel => 'Od początku zmiany';

  @override
  String get fromClockInLabel => 'Od zameldowania';

  @override
  String get availableFromEllipsis => 'Dostępne od…';

  @override
  String get untilEllipsis => 'do…';

  @override
  String assignTasksForStaffTitle(String name) {
    return 'Przypisz zadania - $name';
  }

  @override
  String applyPresetToWhichOneTitle(String name) {
    return 'Zastosować \"$name\" do którego?';
  }

  @override
  String allPresetTasksAlreadyAssigned(String name) {
    return 'Wszystkie zadania \"$name\" są już przypisane';
  }

  @override
  String addedTasksFromPreset(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dodano $count zadań',
      few: 'Dodano $count zadania',
      one: 'Dodano $count zadanie',
    );
    return '$_temp0 z \"$name\"';
  }

  @override
  String applyPresetToTitle(String name) {
    return 'Zastosuj \"$name\" do';
  }

  @override
  String assignTasksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Przypisz $count zadań do personelu…',
      few: 'Przypisz $count zadania do personelu…',
      one: 'Przypisz $count zadanie do personelu…',
    );
    return '$_temp0';
  }

  @override
  String addedTasksAcrossStaffLabel(int count, int staffCount) {
    return 'Dodano $count przypisań dla $staffCount pracowników';
  }

  @override
  String presetSectionPrefix(String segment) {
    return 'Sekcja: $segment';
  }

  @override
  String taskCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zadań',
      few: '$count zadania',
      one: '$count zadanie',
    );
    return '$_temp0';
  }

  @override
  String showAllRolesLabel(String jobRole) {
    return 'Pokaż wszystkie role (domyślnie tylko: $jobRole)';
  }

  @override
  String extraFieldSummary(String label, String type) {
    return '$label ($type)';
  }

  @override
  String noEquipmentSetUpForTemplate(String title) {
    return '$title - brak jeszcze skonfigurowanego sprzętu';
  }

  @override
  String fromTimeLabel(String time) {
    return 'Od $time';
  }

  @override
  String untilTimeLabel(String time) {
    return 'do $time';
  }

  @override
  String createdAssignmentsLabel(int count, String skippedNote) {
    return 'Utworzono $count przypisań$skippedNote.';
  }

  @override
  String skippedNoteLabel(int count) {
    return ' (pominięto $count - już przypisane lub niezgodność roli)';
  }

  @override
  String get serviceProvidersTitle => 'Dostawcy usług';

  @override
  String get myProvidersTab => 'Moi dostawcy';

  @override
  String get findProviderTab => 'Znajdź dostawcę';

  @override
  String get noBackendProviderNotice1 =>
      'Przeglądanie dostawców udostępnionych przez inne lokale wymaga zalogowania na prawdziwe konto firmowe - nie zadziała to tylko z lokalnym logowaniem demo. Twoje własne kontakty w \"Moi dostawcy\" działają zawsze.';

  @override
  String get noBackendProviderNotice2 =>
      'Zaloguj się przez Dostęp kierownictwa na prawdziwe konto firmowe, aby z tego skorzystać.';

  @override
  String get providerDisclaimerText =>
      'VenuRite nie weryfikuje ani nie poleca żadnego wymienionego dostawcy. Opinie pochodzą od innych lokali, nie od VenuRite.';

  @override
  String get addProviderButton => 'Dodaj dostawcę';

  @override
  String get noProvidersYetText =>
      'Nie dodałeś jeszcze żadnych dostawców usług.';

  @override
  String get addServiceProviderDialogTitle => 'Dodaj dostawcę usług';

  @override
  String get categoryLabel => 'Kategoria';

  @override
  String get phoneOptionalLabel => 'Telefon (opcjonalnie)';

  @override
  String get emailOptionalLabel => 'E-mail (opcjonalnie)';

  @override
  String get notesOptionalPrivateLabel => 'Notatki (opcjonalnie, prywatne)';

  @override
  String get happyToReviewShareLabel => 'Chętnie ocenię i udostępnię';

  @override
  String get shareVisibilityExplanation =>
      'Inne lokale zobaczą twoje oceny i opinie, z zamazaną nazwą/kontaktem, dopóki ich nie odblokują.';

  @override
  String get rateThisProviderLabel => 'Oceń tego dostawcę';

  @override
  String get priceRatingLabel => 'Cena';

  @override
  String get punctualityRatingLabel => 'Punktualność';

  @override
  String get qualityRatingLabel => 'Jakość';

  @override
  String get availabilityRatingLabel => 'Dostępność';

  @override
  String get reviewOptionalLabel => 'Opinia (opcjonalnie)';

  @override
  String get reviewHintText =>
      'Opisz swoje doświadczenie - proszę nie podawać nazwy firmy ani danych kontaktowych.';

  @override
  String get sessionExpiredMessage =>
      'Twoja sesja wygasła - zaloguj się ponownie.';

  @override
  String get sharedWithOtherVenuesLabel => 'Udostępniono innym lokalom';

  @override
  String get privateLabel => 'Prywatne';

  @override
  String get rateReviewsButton => 'Oceń / Opinie';

  @override
  String get searchByCategoryOrNameHint => 'Szukaj według kategorii lub nazwy';

  @override
  String get noContactsUnlockedThisMonth =>
      'W tym miesiącu nie odblokowano jeszcze żadnych kontaktów.';

  @override
  String get noSharedProvidersYetText =>
      'Brak udostępnionych dostawców - bądź pierwszym, który udostępni jednego w \"Moi dostawcy.\"';

  @override
  String get noProvidersMatchSearchText =>
      'Żaden dostawca nie pasuje do wyszukiwania.';

  @override
  String get noRatingsYetText => 'Brak ocen';

  @override
  String get hiddenUntilUnlockedText => 'Ukryte do odblokowania';

  @override
  String get unnamedPlaceholder => '(bez nazwy)';

  @override
  String get readReviewsButton => 'Przeczytaj opinie';

  @override
  String get unlockContactDetailsButton => 'Odblokuj dane kontaktowe';

  @override
  String get reviewsTitle => 'Opinie';

  @override
  String get noReviewsYetText => 'Brak opinii.';

  @override
  String get addYourRatingLabel => 'Dodaj swoją ocenę';

  @override
  String get submittingEllipsis => 'Wysyłanie...';

  @override
  String get submitRatingButton => 'Wyślij ocenę';

  @override
  String reviewContainsInfoWarningShort(String found) {
    return 'Twoja opinia zawiera prawdopodobnie $found. Usuń dane kontaktowe lub nazwy firm przed wysłaniem.';
  }

  @override
  String reviewContainsInfoWarningLong(String found) {
    return 'Twoja opinia zawiera prawdopodobnie $found. Usuń dane kontaktowe lub nazwy firm przed wysłaniem - opinie są przydatne (i uczciwe), gdy opisują doświadczenie, a nie do kogo dzwonić bezpośrednio.';
  }

  @override
  String contactsUnlockedThisMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odblokowano $count kontaktów w tym miesiącu.',
      few: 'Odblokowano $count kontakty w tym miesiącu.',
      one: 'Odblokowano $count kontakt w tym miesiącu.',
    );
    return '$_temp0';
  }

  @override
  String priceValueLabel(String value) {
    return 'Cena $value';
  }

  @override
  String punctualityValueLabel(String value) {
    return 'Punktualność $value';
  }

  @override
  String qualityValueLabel(String value) {
    return 'Jakość $value';
  }

  @override
  String availabilityValueLabel(String value) {
    return 'Dostępność $value';
  }

  @override
  String ratingReviewCountSuffix(String parts, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opinii',
      few: '$count opinie',
      one: '$count opinia',
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
    return 'Cena $price - Punktualność $punctuality - Jakość $quality - Dostępność $availability';
  }

  @override
  String phonePrefixLabel(String value) {
    return 'Telefon: $value';
  }

  @override
  String emailPrefixLabel(String value) {
    return 'E-mail: $value';
  }

  @override
  String get supplierCategoryFreshProduce => 'Świeże produkty';

  @override
  String get supplierCategoryMeatPoultry => 'Mięso i drób';

  @override
  String get supplierCategoryDairyEggs => 'Nabiał i jajka';

  @override
  String get supplierCategoryFrozenGoods => 'Produkty mrożone';

  @override
  String get supplierCategoryDryAmbientGoods => 'Suche i temperatury otoczenia';

  @override
  String get supplierCategoryDrinksBeverages => 'Napoje';

  @override
  String get supplierCategoryChemicalsCleaningSupplies =>
      'Chemikalia i środki czystości';

  @override
  String get supplierCategoryEquipmentMaintenance => 'Sprzęt i konserwacja';

  @override
  String get supplierCategoryOther => 'Inne';

  @override
  String get supplierStatusApproved => 'Zatwierdzony';

  @override
  String get supplierStatusPending => 'Oczekujący';

  @override
  String get supplierStatusSuspended => 'Zawieszony';

  @override
  String get addEquipmentTitle => 'Dodaj sprzęt';

  @override
  String get venueSetupTitle => 'Konfiguracja lokalu';

  @override
  String get nextButton => 'Dalej';

  @override
  String get finishSetupButton => 'Zakończ konfigurację';

  @override
  String get renameAreaTitle => 'Zmień nazwę obszaru';

  @override
  String get renameEquipmentTitle => 'Zmień nazwę sprzętu';

  @override
  String get saveButton => 'Zapisz';

  @override
  String get retireEquipmentTitle => 'Wycofaj sprzęt';

  @override
  String get retireEquipmentConfirmText =>
      'Wycofanie tego sprzętu odepnie też wszystkie przypisane do niego zadania. Historia zgłoszeń zostanie zachowana. Kontynuować?';

  @override
  String get retireButton => 'Wycofaj';

  @override
  String get areasStepTitle => 'Obszary';

  @override
  String get areasStepIntro => 'Dodaj strefy operacyjne tego lokalu.';

  @override
  String get areaSuggestionKitchen => 'Kuchnia';

  @override
  String get areaSuggestionStorage => 'Magazyn';

  @override
  String get areaSuggestionReceiving => 'Przyjęcie towaru';

  @override
  String get areaSuggestionFrontOfHouse => 'Sala';

  @override
  String get areaNameLabel => 'Nazwa obszaru';

  @override
  String get addAreaTooltip => 'Dodaj obszar';

  @override
  String get renameTooltip => 'Zmień nazwę';

  @override
  String get equipmentStepTitle => 'Sprzęt';

  @override
  String get equipmentStepIntro =>
      'Dodaj nazwane egzemplarze sprzętu, np. \"Lodówka 1\", \"Lodówka 2\".';

  @override
  String get showAllEquipmentTypesButton => 'Pokaż wszystkie typy sprzętu';

  @override
  String get equipmentTypeLabel => 'Typ sprzętu';

  @override
  String get somethingElseOption => 'Coś innego...';

  @override
  String get newEquipmentTypeNameLabel => 'Nazwa nowego typu sprzętu';

  @override
  String get confirmNewEquipmentTypeTooltip => 'Potwierdź nowy typ sprzętu';

  @override
  String get noAreasForDeptText =>
      'Brak jeszcze obszarów skonfigurowanych dla twojego działu - sprzęt nadal można dodać bez niego.';

  @override
  String get noAreasAddOneText =>
      'Nie dodano jeszcze żadnych obszarów - wróć, aby dodać jeden.';

  @override
  String get equipmentNameLabel => 'Nazwa sprzętu';

  @override
  String get equipmentNameHint =>
      'np. Chłodnia mięsna, Lodówka na desery, Frytkownica barowa';

  @override
  String get modelOptionalLabel => 'Model (opcjonalnie)';

  @override
  String get serialNumberOptionalLabel => 'Numer seryjny (opcjonalnie)';

  @override
  String get retireTooltip => 'Wycofaj';

  @override
  String get reactivateTooltip => 'Przywróć';

  @override
  String get unknownTypeLabel => 'Nieznany typ';

  @override
  String get unknownAreaLabel => 'Nieznany obszar';

  @override
  String get staffStepTitle => 'Personel';

  @override
  String get staffStepIntro =>
      'Dodaj pracowników i przypisz ich poziom stanowiska.';

  @override
  String get addStaffMemberButton => 'Dodaj pracownika';

  @override
  String get suppliersStepTitle => 'Dostawcy';

  @override
  String get suppliersStepIntro =>
      'Dodaj dostawców, z którymi współpracuje ten lokal. Flagi zatwierdzenia pojawiają się w eksporcie EHO - zawieszeni dostawcy są pokazywani menedżerom, nie ukrywani po cichu.';

  @override
  String get supplierNameLabel => 'Nazwa dostawcy';

  @override
  String get contactOptionalLabel => 'Kontakt (opcjonalnie)';

  @override
  String get phoneOrEmailHint => 'Telefon lub e-mail';

  @override
  String get approvalStatusLabel => 'Status zatwierdzenia';

  @override
  String get addSupplierButton => 'Dodaj dostawcę';

  @override
  String venueSetupStepTitle(int step) {
    return 'Konfiguracja lokalu - Krok $step z 4';
  }

  @override
  String modelPrefixLabel(String value) {
    return 'Model: $value';
  }

  @override
  String serialPrefixLabel(String value) {
    return 'Nr seryjny: $value';
  }

  @override
  String retiredSuffixLabel(String name) {
    return '$name (wycofany)';
  }

  @override
  String get addEquipmentTooltip => 'Dodaj sprzęt';

  @override
  String get newPinLabel => 'Nowy PIN';

  @override
  String get editDetailsTitle => 'Edytuj dane';

  @override
  String get sectionLabel => 'Sekcja';

  @override
  String get noSectionOption => 'Brak sekcji';

  @override
  String get inactiveParenSuffix => ' (nieaktywna)';

  @override
  String get noSpecificTeamOption => 'Brak konkretnego zespołu';

  @override
  String get noSectionsSetupText =>
      'W tym lokalu nie ma jeszcze skonfigurowanych sekcji - dodaj jedną najpierw w Zarządzaniu działami.';

  @override
  String get reportsToFieldLabel => 'Podlega pod';

  @override
  String get notSetOption => 'Nie ustawiono';

  @override
  String get deactivateStaffMemberTitle => 'Dezaktywuj pracownika';

  @override
  String get staffManagementTitle => 'Zarządzanie personelem';

  @override
  String get addStaffTooltip => 'Dodaj personel';

  @override
  String get bulkImportTooltip => 'Import zbiorczy';

  @override
  String get deactivatedSuffixLabel => '(nieaktywny)';

  @override
  String get moreActionsTooltip => 'Więcej działań';

  @override
  String get changeTierMenuItem => 'Zmień poziom';

  @override
  String get changeSectionMenuItem => 'Zmień sekcję';

  @override
  String get assignSupervisionMenuItem => 'Przypisz nadzór';

  @override
  String get reportsToMenuItem => 'Podlega pod';

  @override
  String get resetPinMenuItem => 'Resetuj PIN';

  @override
  String get trainingRecordsMenuItem => 'Rejestry szkoleń';

  @override
  String unknownUserIdFallback(String id) {
    return 'użytkownik #$id';
  }

  @override
  String resetPinForUserTitle(String name) {
    return 'Resetuj PIN - $name';
  }

  @override
  String pinResetForUserMessage(String name) {
    return 'Zresetowano PIN dla $name';
  }

  @override
  String changeRoleTierTitle(String name) {
    return 'Zmień poziom stanowiska - $name';
  }

  @override
  String changeSectionTitle(String name) {
    return 'Zmień sekcję - $name';
  }

  @override
  String assignSupervisionTitle(String name) {
    return 'Przypisz nadzór - $name';
  }

  @override
  String supervisionScopeUpdatedMessage(String name) {
    return 'Zaktualizowano zakres nadzoru dla $name';
  }

  @override
  String reportsToTitle(String name) {
    return 'Podlega pod - $name';
  }

  @override
  String deactivateStaffConfirmText(String name) {
    return '$name nie będzie już mógł się zalogować. Jego aktywne przypisania zadań zostaną odpięte. Historia zgłoszeń nie zostanie naruszona. Można to później cofnąć.';
  }

  @override
  String reportsToSubtitle(String name) {
    return 'Podlega pod $name';
  }

  @override
  String deactivatedOnByLabel(String date, String name) {
    return '$date przez $name';
  }

  @override
  String get darkModeLabel => 'Tryb ciemny';

  @override
  String get brandIdentityIntro =>
      'Jedna tożsamość marki, wspólna dla całej firmy - dotyczy każdego lokalu, nie per lokal.';

  @override
  String get companyNameLabel => 'Nazwa firmy';

  @override
  String get companyLogoLabel => 'Logo firmy';

  @override
  String get chooseLogoButton => 'Wybierz logo';

  @override
  String get changeLogoButton => 'Zmień logo';

  @override
  String get brandColourLabel => 'Kolor marki';

  @override
  String get customHexColourLabel => 'Niestandardowy kolor hex';

  @override
  String get enterValidHexColourError => 'Wprowadź prawidłowy kolor hex';

  @override
  String get contactPhoneLabel => 'Telefon kontaktowy';

  @override
  String get contactEmailLabel => 'E-mail kontaktowy';

  @override
  String get savingEllipsisLabel => 'Zapisywanie...';

  @override
  String get saveBrandingButton => 'Zapisz markę';

  @override
  String get brandingSavedMessage => 'Zapisano markę';

  @override
  String get customSwatchTooltip => 'Niestandardowy';

  @override
  String get rosterAddonTitle =>
      'Grafik/zmiany personelu (+6-10 GBP/lokal/miesiąc)';

  @override
  String get rosterAddonSubtitle =>
      'Pozwól personelowi samodzielnie widzieć i zgłaszać się na otwarte zmiany - menedżer publikuje zmiany, personel je wybiera. 6 GBP/miesiąc za lokal poniżej 10 pracowników, 10 GBP/miesiąc dla 10 lub więcej.';

  @override
  String get enableRosterTitle => 'Włączyć grafik?';

  @override
  String get confirmButton => 'Potwierdź';

  @override
  String get clearDemoDataTitle => 'Wyczyścić dane demo?';

  @override
  String get clearDemoDataConfirmText =>
      'To trwale usunie każdego demo pracownika, oddział i dział oraz wyloguje cię. Tego nie można cofnąć.';

  @override
  String get clearEverythingButton => 'Wyczyść wszystko';

  @override
  String get clearDemoDataCardTitle => 'Wyczyść dane demo';

  @override
  String get clearDemoDataCardBody =>
      'Usuń każdego demo pracownika, oddział i dział, aby móc skonfigurować własne od zera.';

  @override
  String get clearDemoDataButton => 'Wyczyść dane demo';

  @override
  String get temperatureUnitLabel => 'Jednostka temperatury';

  @override
  String get celsiusLabel => 'Celsjusz (°C)';

  @override
  String get fahrenheitLabel => 'Fahrenheit (°F)';

  @override
  String get comingSoonLabel => 'Wkrótce';

  @override
  String get presetColorOceanTeal => 'Morski Turkus';

  @override
  String get presetColorNavy => 'Granat';

  @override
  String get presetColorIndigo => 'Indygo';

  @override
  String get presetColorSlate => 'Łupek';

  @override
  String get presetColorPlum => 'Śliwka';

  @override
  String get presetColorForest => 'Leśna zieleń';

  @override
  String get presetColorUmber => 'Umbra';

  @override
  String get presetColorCharcoal => 'Antracyt';

  @override
  String couldNotGetPriceError(String error) {
    return 'Nie udało się uzyskać ceny: $error';
  }

  @override
  String enableRosterConfirmText(String amount) {
    return 'Na podstawie obecnej liczby pracowników, doda to $amount do twojego miesięcznego polecenia zapłaty.';
  }

  @override
  String get departmentLabel => 'Dział';

  @override
  String get noDepartmentOption => 'Brak działu';

  @override
  String get removeAnywayButton => 'Usuń mimo to';

  @override
  String get branchTeamStructureTitle => 'Struktura zespołu oddziału';

  @override
  String get noStaffAtBranchText => 'Brak jeszcze personelu w tym oddziale.';

  @override
  String get changeManagerMenuItem => 'Zmień przełożonego';

  @override
  String get moveDepartmentMenuItem => 'Przenieś dział/zespół';

  @override
  String get editJobTitleMenuItem => 'Edytuj stanowisko';

  @override
  String get removeFromBranchMenuItem => 'Usuń z tego oddziału';

  @override
  String changeManagerTitle(String name) {
    return 'Zmień przełożonego - $name';
  }

  @override
  String moveDepartmentTitle(String name) {
    return 'Przenieś dział/zespół - $name';
  }

  @override
  String changeTierTitle2(String name) {
    return 'Zmień poziom - $name';
  }

  @override
  String editJobTitleTitle(String name) {
    return 'Edytuj stanowisko - $name';
  }

  @override
  String removeFromBranchTitle(String name) {
    return 'Usuń $name z tego oddziału';
  }

  @override
  String removeFromBranchConfirmText(String name) {
    return '$name nie będzie już mógł się zalogować. Można to później cofnąć.';
  }

  @override
  String reportsWillBeUnassignedText(int count, String name, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count osób obecnie podlega',
      few: '$count osoby obecnie podlegają',
      one: '$count osoba obecnie podlega',
    );
    return '$_temp0 pod $name: $names. Usunięcie $name pozostawi ich bez przypisania do czasu ponownego przypisania.';
  }

  @override
  String reassignToManagerLabel(String name) {
    return 'Przypisz ich zamiast tego do przełożonego $name';
  }

  @override
  String reportsCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count podwładnych',
      few: '$count podwładnych',
      one: '$count podwładny',
    );
    return '$_temp0';
  }

  @override
  String get regionalManagerAssignedTitle => 'Kierownik regionalny przypisany';

  @override
  String get noOrganisationOnSessionError => 'Brak organizacji w tej sesji.';

  @override
  String get newRegionNameTitle => 'Nazwa nowego regionu';

  @override
  String get renameRegionTitle => 'Zmień nazwę regionu';

  @override
  String get renameVenueTitle => 'Zmień nazwę lokalu';

  @override
  String get newVenueNameTitle => 'Nazwa nowego lokalu';

  @override
  String get doneButton => 'Gotowe';

  @override
  String get resetPasswordQuestionTitle => 'Zresetować hasło?';

  @override
  String get resetButton => 'Resetuj';

  @override
  String get passwordResetTitle => 'Hasło zresetowane';

  @override
  String get giveNewTempPasswordText =>
      'Podaj tej osobie jej nowe tymczasowe hasło.';

  @override
  String get organisationTitle => 'Organizacja';

  @override
  String get headOfficeLabel => 'Siedziba główna';

  @override
  String get addRegionMenuItem => 'Dodaj region';

  @override
  String get addVenueNoRegionMenuItem => 'Dodaj lokal (bez regionu)';

  @override
  String get venuesNoRegionLabel => 'Lokale (bez regionu)';

  @override
  String get resetPasswordTooltip => 'Resetuj hasło';

  @override
  String get addVenueMenuItem => 'Dodaj lokal';

  @override
  String get assignRegionalManagerMenuItem =>
      'Przypisz kierownika regionalnego';

  @override
  String get reassignRegionalManagerMenuItem => 'Zmień kierownika regionalnego';

  @override
  String get noRegionalManagerYetText => 'Brak jeszcze kierownika regionalnego';

  @override
  String get noVenuesInRegionText => 'Brak jeszcze lokali w tym regionie.';

  @override
  String get noVenueManagerYetText => 'Brak jeszcze kierownika lokalu';

  @override
  String assignRegionalManagerTitle(String region) {
    return 'Przypisz kierownika regionalnego - $region';
  }

  @override
  String accountLiveGiveSignInDetails(String name) {
    return 'Konto jest już aktywne. Przekaż $name dane logowania - używa Dostępu kierownictwa.';
  }

  @override
  String emailColonLabel(String email) {
    return 'E-mail: $email';
  }

  @override
  String temporaryPasswordColonLabel(String password) {
    return 'Hasło tymczasowe: $password';
  }

  @override
  String resetPasswordConfirmText(String name) {
    return 'To natychmiast unieważnia obecne hasło $name. Otrzymasz nowe hasło tymczasowe do przekazania.';
  }

  @override
  String venueManagerSuffixLabel(String name) {
    return '$name  ·  Kierownik lokalu';
  }

  @override
  String get noSignedInUserError => 'Nie znaleziono zalogowanego użytkownika.';

  @override
  String get customCategoryTitleLabel => 'Niestandardowy tytuł kategorii';

  @override
  String get approvalNoteLabel =>
      'Notatka zatwierdzenia / due diligence (opcjonalnie)';

  @override
  String get supplierManagementTitle => 'Zarządzanie dostawcami';

  @override
  String get noSuppliersAddedYetText => 'Nie dodano jeszcze żadnych dostawców.';

  @override
  String get inactiveStandaloneLabel => '(nieaktywny)';

  @override
  String get changeApprovalStatusMenuItem => 'Zmień status zatwierdzenia';

  @override
  String editDetailsForSupplierTitle(String name) {
    return 'Edytuj dane - $name';
  }

  @override
  String changeApprovalStatusTitle(String name) {
    return 'Zmień status zatwierdzenia - $name';
  }

  @override
  String get newVenueTypeTitle => 'Nowy typ lokalu';

  @override
  String get renameOrganisationTitle => 'Zmień nazwę organizacji';

  @override
  String get resetSetupCodeTitle => 'Zresetować kod konfiguracji?';

  @override
  String get resetSetupCodeConfirmText =>
      'To odłączy każdy tablet obecnie korzystający z tego lokalu, dopóki nie otrzyma nowego kodu. Kontynuować?';

  @override
  String get resetCodeButton => 'Resetuj kod';

  @override
  String get createNewVenueTitle => 'Utwórz nowy lokal';

  @override
  String get multiSiteSupportPartialText =>
      'Obsługa wielu lokali jest częściowa: sprzęt, personel i listy zadań nie są jeszcze filtrowane według lokalu, więc codzienne korzystanie z drugiego lokalu nie jest jeszcze w pełni obsługiwane. Utworzenie go jest bezpieczne, ale zobaczysz dane tego lokalu i oryginalnego lokalu pomieszane na wspólnych listach, dopóki to nie zostanie zbudowane.';

  @override
  String get createButton => 'Utwórz';

  @override
  String get venueDetailsTitle => 'Szczegóły lokalu';

  @override
  String get billingLabel => 'Rozliczenia';

  @override
  String get billingSubtitleText => 'Plan, status, polecenie zapłaty';

  @override
  String get activeLabel => 'Aktywny';

  @override
  String get setAsActiveButton => 'Ustaw jako aktywny';

  @override
  String get tabletSetupCodeTitle => 'Kod konfiguracji tabletu';

  @override
  String get tabletSetupCodeExplanation =>
      'Wprowadź to raz na nowym tablecie, aby mógł wyświetlić listę personelu tego lokalu.';

  @override
  String get generateCodeButton => 'Wygeneruj kod';

  @override
  String get venueTypeSectionTitle => 'Typ lokalu';

  @override
  String get renamePresetTitle => 'Zmień nazwę zestawu';

  @override
  String get noTaskTemplatesExistYetText =>
      'Nie ma jeszcze żadnych szablonów zadań.';

  @override
  String get addTaskToPresetTitle => 'Dodaj zadanie do zestawu';

  @override
  String get taskFieldLabel => 'Zadanie';

  @override
  String get defaultFrequencyLabel => 'Domyślna częstotliwość';

  @override
  String get noPresetsYetText => 'Brak jeszcze zestawów.';

  @override
  String get createPresetButton => 'Utwórz zestaw';

  @override
  String get presetVerificationBannerText =>
      'Limity zadań są zbadane i udokumentowane (oznaczone [LAW]/[FSA]/[BEST] w instrukcjach każdego zadania), ale nie zostały jeszcze zatwierdzone przez wykwalifikowanego specjalistę ds. bezpieczeństwa żywności. Nie traktuj ich jako prawnie wiążących, dopóki nie zostaną zweryfikowane.';

  @override
  String get equipmentPresetsSectionTitle => 'Zestawy sprzętowe';

  @override
  String get sectionPresetsSectionTitle => 'Zestawy sekcyjne';

  @override
  String get addTaskButton => 'Dodaj zadanie';

  @override
  String get newPresetSectionTitle => 'Nowy zestaw';

  @override
  String get sectionSegmentOptionalLabel => 'Sekcja / segment (opcjonalnie)';

  @override
  String get setEquipmentOrSectionHint =>
      'Ustaw typ sprzętu lub sekcję (przynajmniej jedno).';

  @override
  String equipmentTypeFallback(String id) {
    return 'Typ sprzętu #$id';
  }

  @override
  String taskFallback(String id) {
    return 'Zadanie #$id';
  }

  @override
  String get departmentCategoryKitchen => 'Kuchnia';

  @override
  String get departmentCategoryFrontOfHouse => 'Sala';

  @override
  String get departmentCategoryBar => 'Bar';

  @override
  String get departmentCategoryManagement => 'Kierownictwo';

  @override
  String get departmentCategoryMaintenance => 'Konserwacja';

  @override
  String get departmentCategoryHousekeeping => 'Utrzymanie czystości';

  @override
  String get departmentCategoryReception => 'Recepcja';

  @override
  String get departmentCategorySecurity => 'Ochrona';

  @override
  String get addDepartmentButton => 'Dodaj dział';

  @override
  String get departmentManagementTitle => 'Zarządzanie działami';

  @override
  String get noDepartmentsAddedYetText => 'Nie dodano jeszcze żadnych działów.';

  @override
  String get noTeamsYetText => 'Brak jeszcze zespołów';

  @override
  String get editMenuItem => 'Edytuj';

  @override
  String get addTeamButton => 'Dodaj zespół';

  @override
  String editDepartmentTitle(String name) {
    return 'Edytuj - $name';
  }

  @override
  String addTeamTitle(String name) {
    return 'Dodaj zespół - $name';
  }

  @override
  String renameTeamTitle(String name) {
    return 'Zmień nazwę - $name';
  }

  @override
  String teamCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zespołów',
      few: '$count zespoły',
      one: '$count zespół',
    );
    return '$_temp0';
  }

  @override
  String get documentCategoryPolicy => 'Polityka';

  @override
  String get documentCategoryCertificate => 'Certyfikat';

  @override
  String get documentCategoryProcedure => 'Procedura';

  @override
  String get documentCategoryEhoReport => 'Raport EHO';

  @override
  String get addDocumentTitle => 'Dodaj dokument';

  @override
  String get noExpiryDateText => 'Brak daty ważności';

  @override
  String get setExpiryButton => 'Ustaw termin ważności';

  @override
  String get couldNotOpenFileText => 'Nie można otworzyć tego pliku.';

  @override
  String get documentCentreTitle => 'Centrum dokumentów';

  @override
  String get validLabel => 'Ważny';

  @override
  String get expiringSoonLabel => 'Wkrótce wygasa';

  @override
  String get expiredLabel => 'Wygasł';

  @override
  String get allFilterLabel => 'Wszystkie';

  @override
  String get noDocumentsYetText => 'Brak jeszcze dokumentów.';

  @override
  String get openMenuItem => 'Otwórz';

  @override
  String expiresOnLabel(String date) {
    return 'Wygasa $date';
  }

  @override
  String get planFriends => 'Friends';

  @override
  String get planStandard => 'Standard';

  @override
  String get planPremier => 'Premier';

  @override
  String get noPlanSelectedText => 'Nie wybrano planu';

  @override
  String get codeNotRecognisedText => 'Ten kod nie został rozpoznany.';

  @override
  String get couldNotReachServerText => 'Nie udało się połączyć z serwerem.';

  @override
  String get discountAppliedText => 'Zastosowano kod rabatowy.';

  @override
  String get couldNotOpenBrowserText => 'Nie udało się otworzyć przeglądarki';

  @override
  String get noSubscriptionFoundText =>
      'Nie znaleziono subskrypcji dla tej organizacji.';

  @override
  String get discountAppliedBadge => 'Rabat zastosowany';

  @override
  String get directDebitSetUpText =>
      'Polecenie zapłaty jest skonfigurowane dla tej organizacji.';

  @override
  String get directDebitNotSetUpText =>
      'Nie skonfigurowałeś jeszcze polecenia zapłaty. Zostaniesz przekierowany do GoCardless - VenuRite nigdy nie widzi twoich danych bankowych bezpośrednio.';

  @override
  String get discountCodeOptionalLabel => 'Kod rabatowy (opcjonalnie)';

  @override
  String get discountCodeHintText => 'Masz kod \'Friends\'? Wprowadź go tutaj';

  @override
  String get setUpDirectDebitButton => 'Skonfiguruj polecenie zapłaty';

  @override
  String get freeAccessCodeTitle => 'Kod darmowego dostępu';

  @override
  String get freeAccessActiveText =>
      'Darmowy dostęp jest aktywny dla tej organizacji - polecenie zapłaty ani płatność kartą nie są wymagane.';

  @override
  String get freeAccessPromptText =>
      'Masz kod darmowego dostępu? Wprowadź go tutaj, aby korzystać z pełnej aplikacji bez konfigurowania płatności.';

  @override
  String get redeemCodeButton => 'Wykorzystaj kod';

  @override
  String get onTrialText => 'Okres próbny';

  @override
  String get paymentFailedGraceText =>
      'Ostatnia płatność nie powiodła się. Zaktualizuj polecenie zapłaty - dostęp jest kontynuowany w tym okresie karencji.';

  @override
  String get directDebitCancelledRestrictedText =>
      'Twoje polecenie zapłaty zostało anulowane. Dostęp jest ograniczony do trybu tylko do odczytu, dopóki rozliczenia nie zostaną skonfigurowane ponownie.';

  @override
  String get paymentOverdueRestrictedText =>
      'Płatność jest zaległa zbyt długo. Dostęp jest ograniczony do trybu tylko do odczytu, dopóki to nie zostanie rozwiązane.';

  @override
  String couldNotLoadBillingDetailsError(String error) {
    return 'Nie udało się załadować danych rozliczeniowych: $error';
  }

  @override
  String pricePerMonthBilledLabel(String price, int units) {
    return '$price GBP/miesiąc (rozliczane $units lokali)';
  }

  @override
  String onTrialUntilText(String date) {
    return 'Okres próbny do $date';
  }

  @override
  String get reportedIssuesTitle => 'Zgłoszone problemy';

  @override
  String get noDeliveriesLoggedText =>
      'Brak zarejestrowanych dostaw od tego dostawcy w tym okresie.';

  @override
  String get scorecardCategoriesExplanation =>
      'Każda kategoria poniżej liczona jest niezależnie - dostawa może pojawić się w więcej niż jednym wierszu (np. spóźniona I uszkodzona).';

  @override
  String get rejectedOutrightLabel => 'Odrzucone całkowicie';

  @override
  String get acceptedPartiallyLabel => 'Przyjęte częściowo';

  @override
  String get reportedIssuesExplanation =>
      'Problemy dotyczące dostaw zgłoszone przeciwko temu dostawcy - osobny rejestr niż karta wyników dostaw powyżej, niepołączony z nią.';

  @override
  String deliveryScorecardTitle(int count) {
    return 'Karta wyników dostaw ($count dostaw)';
  }

  @override
  String countPercentLabel(int count, int rate) {
    return '$count ($rate%)';
  }

  @override
  String get missingNameError => 'Brak imienia';

  @override
  String get missingJobTitleError => 'Brak stanowiska';

  @override
  String get pinMustBe4DigitsError =>
      'PIN musi mieć dokładnie 4 cyfry (lub być pusty)';

  @override
  String get bulkStaffImportTitle => 'Zbiorczy import personelu';

  @override
  String get csvColumnsInstructionsText =>
      'Kolumny CSV: imię i nazwisko, stanowisko, poziom stanowiska, rola zawodowa (opcjonalnie), PIN (opcjonalnie). Wiersz nagłówka jest w porządku - jest wykrywany automatycznie. Zostaw PIN pusty, aby został wygenerowany za ciebie.';

  @override
  String get chooseCsvFileButton => 'Wybierz plik CSV';

  @override
  String get chooseDifferentFileButton => 'Wybierz inny plik';

  @override
  String get noteDownPinsText =>
      ' Zapisz każdy PIN poniżej przed opuszczeniem tego ekranu.';

  @override
  String get importingEllipsisLabel => 'Importowanie...';

  @override
  String roleTierMustBeOneOfError(String list) {
    return 'Poziom stanowiska musi być jednym z: $list';
  }

  @override
  String notAllowedToCreateTierError(String tier) {
    return 'Nie możesz utworzyć konta $tier';
  }

  @override
  String jobRoleMustBeOneOfError(String list) {
    return 'Rola zawodowa musi być jedną z: $list';
  }

  @override
  String csvExampleText(String example) {
    return 'Przykład: $example';
  }

  @override
  String rowsFoundLabel(String fileName, int count) {
    return '$fileName - znaleziono $count wierszy';
  }

  @override
  String needFixingSuffix(int count) {
    return ', $count wymaga poprawy';
  }

  @override
  String createdCountLabel(int count) {
    return 'Utworzono $count';
  }

  @override
  String failedSuffixLabel(int count) {
    return ', $count nie powiodło się';
  }

  @override
  String importStaffCountButton(int count) {
    return 'Importuj $count pracowników';
  }

  @override
  String rowNumberFallback(int number) {
    return 'Wiersz $number';
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
      'Poziom 2 Higieny i Bezpieczeństwa Żywności';

  @override
  String get trainingAllergenAwareness => 'Świadomość alergenowa';

  @override
  String get trainingCoshh =>
      'COSHH (kontrola substancji niebezpiecznych dla zdrowia)';

  @override
  String get trainingFireSafety => 'Bezpieczeństwo przeciwpożarowe';

  @override
  String get trainingManualHandling => 'Ręczne podnoszenie i przenoszenie';

  @override
  String get trainingFirstAid => 'Pierwsza pomoc w pracy';

  @override
  String get trainingInduction => 'Wdrożenie ukończone';

  @override
  String get itemFieldLabel => 'Element';

  @override
  String get customItemTitleLabel => 'Niestandardowy tytuł elementu';

  @override
  String get expiryNoneLabel => 'Ważność: brak';

  @override
  String get clearExpiryTooltip => 'Usuń datę ważności';

  @override
  String get certificateReferenceLabel => 'Numer certyfikatu (opcjonalnie)';

  @override
  String get certificateReferenceHint => 'np. numer certyfikatu, dostawca';

  @override
  String get noTrainingRecordsYetText => 'Brak jeszcze rejestrów szkoleń.';

  @override
  String get addRecordButton => 'Dodaj rekord';

  @override
  String get currentLabel => 'Aktualny';

  @override
  String get supersededLabel => '(zastąpiony)';

  @override
  String get noExpiryLabel => 'Brak ważności';

  @override
  String addTrainingRecordTitle(String name) {
    return 'Dodaj rekord szkolenia - $name';
  }

  @override
  String completedOnLabel(String date) {
    return 'Ukończono: $date';
  }

  @override
  String expiryOnLabel(String date) {
    return 'Ważność: $date';
  }

  @override
  String trainingRecordsTitle(String name) {
    return 'Rejestry szkoleń - $name';
  }

  @override
  String fullHistoryLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pełna historia ($count wcześniejszych rekordów)',
      few: 'Pełna historia ($count wcześniejsze rekordy)',
      one: 'Pełna historia ($count wcześniejszy rekord)',
    );
    return '$_temp0';
  }

  @override
  String completedDateLabel(String date) {
    return 'Ukończono $date';
  }

  @override
  String certRefLabel(String ref) {
    return 'Nr ref.: $ref';
  }

  @override
  String get twoFactorNowOnText =>
      'Uwierzytelnianie dwuskładnikowe jest teraz włączone.';

  @override
  String get turnOffTwoFactorTitle =>
      'Wyłączyć uwierzytelnianie dwuskładnikowe?';

  @override
  String get turnOffTwoFactorConfirmText =>
      'To konto będzie logować się ponownie tylko za pomocą hasła.';

  @override
  String get turnOffButton => 'Wyłącz';

  @override
  String get twoFactorAuthTitle => 'Uwierzytelnianie dwuskładnikowe';

  @override
  String get twoFactorOnText =>
      'Uwierzytelnianie dwuskładnikowe jest WŁĄCZONE dla tego konta.';

  @override
  String get twoFactorOffText =>
      'Uwierzytelnianie dwuskładnikowe jest WYŁĄCZONE - dodaj je jako dodatkową warstwę ochrony tego konta kierowniczego.';

  @override
  String get enableTwoFactorButton => 'Włącz uwierzytelnianie dwuskładnikowe';

  @override
  String get scanAuthenticatorText =>
      'Zeskanuj to aplikacją uwierzytelniającą (Google Authenticator, Authy itp.), a następnie wprowadź wyświetlony 6-cyfrowy kod.';

  @override
  String get cantScanManualEntryText =>
      'Nie możesz zeskanować? Wprowadź ten kod ręcznie:';

  @override
  String get requiredFieldError => 'Wymagane';

  @override
  String get joinExistingCompanyTitle => 'Dołącz do istniejącej firmy';

  @override
  String get enterInviteCodeText =>
      'Wprowadź kod zaproszenia, który dał ci menedżer.';

  @override
  String get inviteCodeLabel => 'Kod zaproszenia';

  @override
  String get yourNameLabel => 'Twoje imię';

  @override
  String get yourEmailLabel => 'Twój e-mail';

  @override
  String get enterValidEmailError => 'Wprowadź prawidłowy e-mail';

  @override
  String get choosePasswordLabel => 'Wybierz hasło';

  @override
  String get joinButton => 'Dołącz';

  @override
  String get youreInSignInText =>
      'Gotowe. Zaloguj się swoim e-mailem i hasłem, które właśnie wybrałeś.';

  @override
  String get newBranchNameTitle => 'Nazwa nowego oddziału';

  @override
  String get renameBranchTitle => 'Zmień nazwę oddziału';

  @override
  String get branchManagerNameTitle => 'Imię kierownika oddziału';

  @override
  String get accountCreatedTitle => 'Konto utworzone';

  @override
  String get giveNameAndPinText =>
      'Podaj tej osobie jej imię (do wybrania na ekranie logowania) i ten PIN.';

  @override
  String get branchesTitle => 'Oddziały';

  @override
  String get noRegionSetText =>
      'Twoje konto nie ma ustawionego regionu - skontaktuj się z dyrektorem.';

  @override
  String get noBranchesInRegionText =>
      'Brak jeszcze oddziałów w twoim regionie.';

  @override
  String get addBranchManagerMenuItem => 'Dodaj kierownika oddziału';

  @override
  String nameColonLabel(String name) {
    return 'Imię: $name';
  }

  @override
  String pinColonLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get deleteSelectedEvidenceTitle => 'Usunąć wybrane dowody?';

  @override
  String get deleteButton => 'Usuń';

  @override
  String get photoEvidenceTitle => 'Dowody fotograficzne';

  @override
  String get onThisDeviceLabel => 'Na tym urządzeniu';

  @override
  String get deletingFreesSpaceText =>
      'Usuwanie zwalnia też miejsce na urządzeniu. Wyeksportowane pliki PDF EHO już zawierają swoje kopie i nie są naruszane.';

  @override
  String get noEvidencePhotosYetText => 'Brak jeszcze zdjęć dowodowych.';

  @override
  String deleteEvidenceConfirmText(int count, String bytes) {
    return 'To trwale usuwa $count zdjęć ($bytes) z tego urządzenia. Wyeksportowane pliki PDF nie są naruszane. Tego nie można cofnąć.';
  }

  @override
  String evidencePhotosCountLabel(int count, String bytes) {
    return '$count zdjęć dowodowych · łącznie $bytes';
  }

  @override
  String deleteSelectedButton(int count, String bytes) {
    return 'Usuń $count zaznaczonych ($bytes)';
  }

  @override
  String get addTeamMemberTitle => 'Dodaj członka zespołu';

  @override
  String get createsTapNamePinAccountText =>
      'Tworzy konto z wyborem imienia i PIN-em dla twojego lokalu.';

  @override
  String get createAccountButton => 'Utwórz konto';

  @override
  String get shiftLogTitle => 'Rejestr zmian';

  @override
  String get noClockInsYetText => 'Brak jeszcze zarejestrowanych wejść.';

  @override
  String get stillClockedInText => 'Nadal zalogowany';

  @override
  String clockInLabel(String time) {
    return 'Wejście: $time';
  }

  @override
  String clockOutLabel(String time) {
    return 'Wyjście: $time';
  }

  @override
  String durationHoursMinutesLabel(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get inviteCreatedTitle => 'Zaproszenie utworzone';

  @override
  String get orShareCodeText =>
      'Lub udostępnij ten kod - wpiszą go na ekranie \"Dołącz do istniejącej firmy\":';

  @override
  String shareInviteExpiresText(int days) {
    return 'Udostępnij to osobie dołączającej - działa raz i wygasa za $days dni.';
  }

  @override
  String get contactVenuRiteTitle => 'Skontaktuj się z VenuRite';

  @override
  String get contactVenuRiteIntroText =>
      'Niezależnie od tego, czy jesteś dużą grupą potrzebującą pomocy w konfiguracji, czy po prostu masz pytanie - chętnie pomożemy.';

  @override
  String get emailUsButton => 'Napisz do nas';

  @override
  String taskCountOverdueLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zaległych zadań',
      few: '$count zaległe zadania',
      one: '$count zaległe zadanie',
    );
    return '$_temp0';
  }

  @override
  String acrossStaffMembersLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wśród $count pracowników',
      few: 'Wśród $count pracowników',
      one: 'Wśród $count pracownika',
    );
    return '$_temp0';
  }

  @override
  String moreStaffMembersLabel(int count) {
    return '+$count więcej pracowników';
  }

  @override
  String failCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count niepowodzeń',
      few: '$count niepowodzenia',
      one: '$count niepowodzenie',
    );
    return '$_temp0';
  }

  @override
  String notCompletedCountLabel(int count) {
    return '$count nieukończonych';
  }

  @override
  String issuesRaisedCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zgłoszonych problemów',
      few: '$count zgłoszone problemy',
      one: '$count zgłoszony problem',
    );
    return '$_temp0';
  }

  @override
  String shiftSummaryTitle(String name) {
    return 'Podsumowanie zmiany - $name';
  }

  @override
  String get faqQ1 => 'Kto widzi to, co zapisuję?';

  @override
  String get faqA1 =>
      'Twój przełożony i każdy powyżej niego w twoim lokalu widzi zadania, które wykonujesz. Nazwana osoba nigdy nie jest pokazywana z oceną punktową ani na tabeli wyników - tylko zwykła lista tego, co i kiedy zrobiła.';

  @override
  String get faqQ2 => 'Co się dzieje, jeśli przegapię zadanie podczas zmiany?';

  @override
  String get faqA2 =>
      'Zostaje zapisane jako nieukończone, nie jako niepowodzenie - porzucone w trakcie zmiany zadanie jest oczekiwanym, dopuszczalnym zachowaniem, po prostu nigdy nieukrywanym. Twój przełożony widzi to jako osobny, odrębny status.';

  @override
  String get faqQ3 => 'Czy mogę wrócić i dokończyć zadanie, które pominąłem?';

  @override
  String get faqA3 =>
      'Tak, w dowolnym momencie przed końcem zmiany - pozostaje dostępne na twojej liście zadań, dopóki go nie ukończysz lub zmiana się nie skończy.';

  @override
  String get faqQ4 =>
      'Co jeśli nie zaliczę kontroli (np. lodówka jest za ciepła)?';

  @override
  String get faqA4 =>
      'Zapisz to jako NIEPOWODZENIE, zanotuj podjęte działanie naprawcze (lub że to zgłosiłeś) i dodaj zdjęcie, jeśli jest wymagane. Dokładnie do tego służy system - zapisane NIEPOWODZENIE z naprawą to historia sukcesu dla inspektora, a nie problem dla ciebie.';

  @override
  String get faqQ5 =>
      'Czy muszę oddzielnie rejestrować wejście i wyjście od logowania?';

  @override
  String get faqA5 =>
      'Nie - zalogowanie się PIN-em na początku zmiany jest twoim wejściem. Użyj \'Zakończ zmianę\', gdy kończysz, co pokaże ci też wszystko, co jeszcze musisz ukończyć.';

  @override
  String get faqQ6 => 'Zgłosiłem problem - co się z nim dzieje?';

  @override
  String get faqA6 =>
      'Trafia do twojego przełożonego (lub eskaluje dalej, jeśli nie zostanie obsłużony na czas). Możesz sprawdzić jego status w dowolnym momencie w \"Moje zgłoszone problemy.\"';

  @override
  String get troubleQ1 => 'Mój PIN nie działa';

  @override
  String get troubleA1 =>
      'Sprawdź dokładnie, czy najpierw stukasz w swoje imię, a potem wpisujesz PIN - błędny PIN przy właściwym imieniu daje jasny komunikat odrzucenia. Jeśli nadal nie działa, poproś przełożonego o sprawdzenie, czy twoje konto jest aktywne, i zresetowanie PIN-u w razie potrzeby.';

  @override
  String get troubleQ2 => 'Brakuje mi zadania, które powinienem mieć na liście';

  @override
  String get troubleA2 =>
      'Poproś przełożonego o sprawdzenie, czy jest ono przypisane do twojej roli/sekcji w Przypisywaniu zadań. Zadania pojawiają się tylko dla ról i działów, dla których zostały włączone.';

  @override
  String get troubleQ3 => 'Aplikacja nie pozwala mi zrobić zdjęcia';

  @override
  String get troubleA3 =>
      'Upewnij się, że aplikacja ma uprawnienia do aparatu (sprawdź ustawienia urządzenia). W systemie Windows, jeśli nie wykryto aparatu, zamiast tego zaproponowany zostanie wybór pliku.';

  @override
  String get troubleQ4 =>
      'Nie mogę przesłać kontroli / nic się nie dzieje po naciśnięciu Wyślij';

  @override
  String get troubleA4 =>
      'Może się to zdarzyć, jeśli konto twojej organizacji wymaga uwagi w kwestii rozliczeń - jeśli tak jest, zobaczysz jasny komunikat. W przeciwnym razie sprawdź, czy każde wymagane pole (w tym ewentualne zdjęcie) jest wypełnione.';

  @override
  String get troubleQ5 => 'Aplikacja wygląda, jakby się zawiesiła';

  @override
  String get troubleA5 =>
      'Spróbuj ją zamknąć i otworzyć ponownie. Twój postęp do ostatniego ukończonego zadania jest zawsze zapisywany na bieżąco, więc nic już przesłanego nie zostanie utracone.';

  @override
  String get troubleQ6 => 'Nie widzę tych samych zadań co wczoraj';

  @override
  String get troubleA6 =>
      'To normalne, jeśli twój harmonogram zawiera zadania doraźne lub zadania powiązane z oknem czasowym - pojawiają się tylko wtedy, gdy są należne. Zapytaj przełożonego, jeśli coś wygląda naprawdę nie tak.';

  @override
  String taskOverdueSinceLabel(String title, String date) {
    return '$title - zaległe od $date';
  }

  @override
  String get uploadCertificateDocumentButton => 'Prześlij zdjęcie certyfikatu';

  @override
  String get certificateDocumentUploadedLabel => 'Certyfikat przesłany';

  @override
  String get viewCertificateDocumentTooltip => 'Zobacz dokument certyfikatu';

  @override
  String get certificateUploadFailed =>
      'Nie udało się przesłać certyfikatu. Spróbuj ponownie.';

  @override
  String get certificationRequirementsTitle => 'Wymagane certyfikaty';

  @override
  String get certificationRequirementsFloorNotice =>
      'Niektóre certyfikaty są zawsze wymagane dla określonych ról i nie można ich tu usunąć (np. role związane z obsługą żywności zawsze wymagają certyfikatu Higiena Żywności Poziom 2 i Świadomość Alergenów). Poniżej możesz dodać dodatkowe wymagania.';

  @override
  String get noExtraCertificationRequirementsText =>
      'Nie dodano jeszcze dodatkowych wymagań.';

  @override
  String get addRequirementButton => 'Dodaj wymog';

  @override
  String get addCertificationRequirementTitle => 'Dodaj wymagany certyfikat';

  @override
  String get removeCertificationRequirementTitle => 'Usunąć ten wymóg?';

  @override
  String get removeCertificationRequirementBody =>
      'Pracownicy na tym stanowisku nie będą już potrzebować tego certyfikatu do zaplanowania zmiany. Nie wpływa to na certyfikaty zawsze wymagane.';

  @override
  String get removeButton => 'Usuń';

  @override
  String get cannotClaimShiftTitle => 'Nie możesz jeszcze zająć tej zmiany';

  @override
  String missingCertificationsMessage(String certs) {
    return 'Ta rola wymaga następujących certyfikatów, które są brakujące lub wygasłe: $certs. Zapytaj kierownika o ich odnowienie.';
  }

  @override
  String cannotAssignShiftTitle(String name) {
    return 'Nie można przydzielić tej zmiany osobie $name';
  }

  @override
  String get allergenCelery => 'Seler';

  @override
  String get allergenGluten => 'Zboża zawierające gluten';

  @override
  String get allergenCrustaceans => 'Skorupiaki';

  @override
  String get allergenEggs => 'Jaja';

  @override
  String get allergenFish => 'Ryby';

  @override
  String get allergenLupin => 'Łubin';

  @override
  String get allergenMilk => 'Mleko';

  @override
  String get allergenMolluscs => 'Mięczaki';

  @override
  String get allergenMustard => 'Gorczyca';

  @override
  String get allergenTreeNuts => 'Orzechy';

  @override
  String get allergenPeanuts => 'Orzeszki ziemne';

  @override
  String get allergenSesame => 'Nasiona sezamu';

  @override
  String get allergenSoya => 'Soja';

  @override
  String get allergenSulphites => 'Dwutlenek siarki i siarczyny';

  @override
  String get allergenStatusContains => 'Zawiera';

  @override
  String get allergenStatusMayContain => 'Może zawierać';

  @override
  String get menuManagementTitle => 'Menu i alergeny';

  @override
  String get addDishButton => 'Dodaj danie';

  @override
  String get addDishTitle => 'Dodaj danie';

  @override
  String get dishNameLabel => 'Nazwa dania';

  @override
  String get dishCategoryLabel => 'Kategoria (opcjonalnie)';

  @override
  String get noDishesYetText => 'Nie dodano jeszcze żadnych dań.';

  @override
  String get draftLabel => 'Szkic';

  @override
  String get addIngredientTitle => 'Dodaj składnik';

  @override
  String get ingredientNameLabel => 'Nazwa składnika';

  @override
  String get addButton => 'Dodaj';

  @override
  String get addIngredientButton => 'Dodaj składnik';

  @override
  String get ingredientsHeading => 'Składniki';

  @override
  String get suggestedAllergensHeading =>
      'Sugerowane alergeny (jeszcze nieopublikowane)';

  @override
  String get publishedAllergensHeading => 'Opublikowane alergeny';

  @override
  String get noAllergensIdentifiedText =>
      'Nie zidentyfikowano alergenów z obecnych składników.';

  @override
  String get reviewAllergensTitle => 'Przejrzyj alergeny przed publikacją';

  @override
  String get allergenStatusNone => 'Brak';

  @override
  String get approveButton => 'Zatwierdź i opublikuj';

  @override
  String get reviewAndApproveButton => 'Przejrzyj i zatwierdź';

  @override
  String get reviewAndReapproveButton => 'Przejrzyj i zatwierdź ponownie';

  @override
  String get allergenMatrixTitle => 'Tabela alergenów';

  @override
  String get allergenMatrixLegend => 'Legenda';

  @override
  String get noApprovedDishesYetText =>
      'Brak jeszcze zatwierdzonych dań. Poproś kierownika o sprawdzenie i zatwierdzenie dań w sekcji Menu i alergeny.';

  @override
  String get exportAsPdfButton => 'Eksportuj jako PDF';

  @override
  String get allergenMatrixSubtitle =>
      'Sprawdz, co znajduje sie w daniu, zanim trafi do klienta';

  @override
  String get assignmentRejectedMessage =>
      'To przypisanie zostalo odrzucone. Sprawdz role i certyfikaty pracownika i sprobuj ponownie.';

  @override
  String get sopTemplateCleaningSchedule => 'Harmonogram sprzatania';

  @override
  String get sopTemplateAllergenControl => 'Kontrola alergenow';

  @override
  String get sopTemplateDeliveryAndStorage => 'Dostawy i przechowywanie';

  @override
  String get sopTemplatePersonalHygiene => 'Higiena osobista';

  @override
  String get sopTemplatePestControl => 'Kontrola szkodnikow';

  @override
  String get generateSopTitle => 'Generuj dokument procedury';

  @override
  String get sopGenerationDisclaimer =>
      'To tworzy pierwsza wersje dokumentu procedury wygenerowana przez AI, opartego na ogolnych brytyjskich zasadach bezpieczenstwa zywnosci. To tylko punkt wyjscia - przeczytaj uwaznie i edytuj wszystko specyficzne dla Twojego lokalu przed zapisaniem jako aktywny dokument.';

  @override
  String get sopTemplateFieldLabel => 'Typ dokumentu';

  @override
  String get sopExtraContextLabel => 'Dodatkowe szczegoly (opcjonalnie)';

  @override
  String get sopExtraContextHint =>
      'np. konkretny sprzet, role personelu lub zasady lokalu do uwzglednienia';

  @override
  String get generatingText => 'Generowanie...';

  @override
  String get generateDraftButton => 'Generuj szkic';

  @override
  String get documentTitleLabel => 'Tytul dokumentu';

  @override
  String get reviewAndEditDraftLabel => 'Przejrzyj i edytuj szkic';

  @override
  String get saveAsDocumentButton => 'Zapisz w Centrum Dokumentow';

  @override
  String get generateWithAiButton => 'Generuj z AI';

  @override
  String get shiftPeriodsTitle => 'Pory zmian';

  @override
  String get shiftPeriodsDescription =>
      'Podziel dzien na 2 lub 3 pory (np. Rano/Popoludnie/Noc). Kalendarz grafiku i automatyczne przypisywanie korzystaja z nich do filtrowania i planowania wedlug pory dnia.';

  @override
  String shiftPeriodCountOption(int count) {
    return '$count pory';
  }

  @override
  String get shiftPeriodNameLabel => 'Nazwa pory';

  @override
  String get shiftPeriodStartsLabel => 'Początek';

  @override
  String get shiftPeriodEndsLabel => 'Koniec';

  @override
  String get shiftPeriodsSavedMessage => 'Pory zmian zapisane';

  @override
  String shiftPeriodsSaveFailedMessage(String error) {
    return 'Nie udalo sie zapisac: $error';
  }

  @override
  String get shiftPeriodDefaultDay => 'Dzien';

  @override
  String get shiftPeriodDefaultNight => 'Noc';

  @override
  String get shiftPeriodDefaultMorning => 'Rano';

  @override
  String get shiftPeriodDefaultAfternoon => 'Popoludnie';

  @override
  String get rotaWeekTitle => 'Kalendarz grafiku';

  @override
  String get rosterAddonNotEnabledText =>
      'Zarzadzanie zmianami i grafikiem nie jest jeszcze wlaczone dla tej lokalizacji.';

  @override
  String get rotaTodayButton => 'Dzis';

  @override
  String get rotaFilterPeriodLabel => 'Pora';

  @override
  String get rotaFilterAllLabel => 'Wszystkie';

  @override
  String get rotaFilterDepartmentLabel => 'Dzial';

  @override
  String get rotaFilterPersonLabel => 'Osoba';

  @override
  String get rotaUnassignedRowLabel => 'Nieprzypisane';

  @override
  String get setUpShiftPeriodsFirstText =>
      'Najpierw skonfiguruj pory zmian (ekran Pory zmian).';

  @override
  String get addStaffingRequirementTitle => 'Dodaj wymog obsady';

  @override
  String get anyDepartmentLabel => 'Dowolny dzial';

  @override
  String get unknownDepartmentLabel => 'Nieznany dzial';

  @override
  String get anyRoleLabel => 'Dowolna rola';

  @override
  String get staffNeededLabel => 'Potrzebny personel';

  @override
  String get standbyNeededLabel => 'Potrzebna rezerwa';

  @override
  String shiftsGeneratedMessage(int count) {
    return 'Utworzono $count zmian na ten tydzien.';
  }

  @override
  String shiftGenerationFailedMessage(String error) {
    return 'Nie udalo sie: $error';
  }

  @override
  String plusStandbyCountLabel(int count) {
    return ' + $count w rezerwie';
  }

  @override
  String get masterRotaSettingsTitle => 'Ustawienia glownego grafiku';

  @override
  String get masterRotaSettingsDescription =>
      'Okresl, ile osob (i w rezerwie) jest potrzebnych na dany dzien/pore/dzial lub role, a nastepnie wygeneruj realne zmiany na caly tydzien za jednym razem.';

  @override
  String get noRequirementsYetText =>
      'Nie skonfigurowano jeszcze zadnych wymogow.';

  @override
  String get generateThisWeekButton => 'Generuj na ten tydzien';

  @override
  String get generateNextWeekButton => 'Generuj na przyszly tydzien';

  @override
  String get rotaFilterRoleLabel => 'Rola';

  @override
  String get rotaStaffViewLabel => 'Widok personelu';

  @override
  String get rotaSlotsViewLabel => 'Widok stanowisk';

  @override
  String get rotaSlotDetailTitle => 'Kto jest na tej zmianie';

  @override
  String get rotaAssignedLabel => 'Przypisani';

  @override
  String get rotaStandbyLabel => 'Rezerwa';

  @override
  String get rotaNoneAssignedText => 'Jeszcze nikt';

  @override
  String rotaUnfilledCountText(int count) {
    return 'Potrzeba jeszcze $count';
  }

  @override
  String get daysOffRequestedMessage => 'Zlozono wniosek o dni wolne.';

  @override
  String get bookDaysOffToggleLabel => 'Zarezerwuj dni wolne';

  @override
  String get submitDaysOffButton => 'Zglos dni wolne';

  @override
  String get alreadyRequestedOffText => 'Juz zgloszono';

  @override
  String get noShiftsThisPeriodText => 'Brak zmian';

  @override
  String get youAreStandbyText => 'Jestes w rezerwie';

  @override
  String get youAreAssignedText => 'Jestes na tej zmianie';

  @override
  String get joinStandbyButton => 'Dolacz jako rezerwa';

  @override
  String get shiftFullText => 'Pelna obsada';

  @override
  String get rotaClaimCalendarTitle => 'Zajmij zmiany (kalendarz)';

  @override
  String get rotaMonthTitle => 'Widok miesiecznego grafiku';

  @override
  String rotaMonthShiftCountText(int count) {
    return '$count zmian';
  }
}
