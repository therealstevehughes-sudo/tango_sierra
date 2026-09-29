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
}
