// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'VenuRite';

  @override
  String get settingsTitle => 'Postavke';

  @override
  String get personalSection => 'Osobno';

  @override
  String get languageSettingTitle => 'Jezik';

  @override
  String get languageSettingSubtitle =>
      'Odaberite jezik na kojem će vam se prikazivati VenuRite.';

  @override
  String get languageUpdated => 'Jezik je ažuriran.';

  @override
  String get chooseLanguageTitle => 'Odaberite jezik';

  @override
  String get languageDeviceScope =>
      'Koristi se na ovom uređaju prije nego što se osoblje prijavi.';

  @override
  String languageUserScope(String name) {
    return 'Spremljeno za $name.';
  }

  @override
  String get cancel => 'Odustani';

  @override
  String get done => 'Gotovo';

  @override
  String get login => 'PRIJAVA';

  @override
  String get back => 'Natrag';

  @override
  String get enterPin => 'Unesite PIN';

  @override
  String get leadershipAccess => 'Pristup za voditelje';

  @override
  String get notOnThisList => 'Niste na popisu? Prijavite se na drugi način';

  @override
  String errorLoadingStaff(String error) {
    return 'Pogreška pri učitavanju osoblja: $error';
  }

  @override
  String get incorrectPin => 'Neispravan PIN';

  @override
  String tooManyWrongAttempts(int minutes) {
    return 'Previše pogrešnih pokušaja. Pokušajte ponovno za $minutes min.';
  }

  @override
  String get accountNotFound => 'Račun nije pronađen';

  @override
  String get getStarted => 'Započni';

  @override
  String get kitchenComplianceDoneRight =>
      'Kuhinjska usklađenost, jasno i pouzdano';

  @override
  String get valuePointEhoReady =>
      'Uvijek spremni za sanitarnu inspekciju - usklađenost u stvarnom vremenu, bez panike u zadnji čas';

  @override
  String get valuePointHonestRecords =>
      'Osmišljeno tako da se rezultati ne mogu namještati - svaka provjera je vjerodostojna';

  @override
  String get valuePointAuditExport =>
      'Izvoz za reviziju jednim dodirom - inspektoru odmah predajte stvaran zapis';

  @override
  String get howGetStarted => 'Kako želite započeti?';

  @override
  String get setUpMyBusiness => 'Postavi moj objekt';

  @override
  String get teamAlreadyUses => 'Moj tim već koristi VenuRite';

  @override
  String get alreadyHaveAccount => 'Već imate račun? Prijavite se';

  @override
  String get needHelpContact => 'Trebate pomoć? Kontaktirajte VenuRite';

  @override
  String get signInAnotherWay => 'Prijavite se na drugi način';

  @override
  String get deviceNotSetUp => 'Ovaj tablet još nije postavljen';

  @override
  String get askManagerSetupCode =>
      'Zatražite od voditelja kod za postavljanje ovog objekta.';

  @override
  String get setupCode => 'Kod za postavljanje';

  @override
  String get connectTablet => 'Poveži ovaj tablet';

  @override
  String get couldNotReachServer => 'Nije moguće kontaktirati server';

  @override
  String get stillStuckSetupCode =>
      'Još uvijek ne ide? Voditelj ga može pronaći u Postavke -> Detalji objekta.';

  @override
  String get askQuestionTitle => 'Postavite pitanje';

  @override
  String get askQuestionLabel => 'Što želite znati?';

  @override
  String get askQuestionHint => 'npr. koja temperatura treba biti u hladnjaku?';

  @override
  String get ask => 'Pitaj';

  @override
  String get aiQuestionLimitReached =>
      'Dosegnuto je mjesečno ograničenje za AI pitanja';

  @override
  String get home => 'Početna';

  @override
  String get logOut => 'Odjava';

  @override
  String get endShift => 'Završi smjenu';

  @override
  String get workerHubPrompt => 'Što želite napraviti?';

  @override
  String get myScheduledTasks => 'Moji zakazani zadaci';

  @override
  String get doAdHocTask => 'Napravi ad-hoc zadatak';

  @override
  String get logSomethingHappened => 'Zabilježi što se upravo dogodilo';

  @override
  String get claimShift => 'Preuzmi smjenu';

  @override
  String get requestDayOff => 'Zatraži slobodan dan';

  @override
  String get thingsIReported => 'Stvari koje sam prijavio/la';

  @override
  String shiftWelcome(String firstName) {
    return 'Dobrodošli, $firstName';
  }

  @override
  String get shiftPlanIntro => 'Ovo vas čeka u smjeni:';

  @override
  String get startOfShift => 'Početak smjene';

  @override
  String get duringYourShift => 'Tijekom smjene';

  @override
  String get endOfShift => 'Kraj smjene';

  @override
  String get shiftHandoverTitle => 'Predaja smjene';

  @override
  String get shiftHandoverNeedsAttention =>
      'Ovo i dalje treba pažnju sljedeće smjene';

  @override
  String get gotIt => 'Razumijem';

  @override
  String get openIssues => 'Otvoreni problemi';

  @override
  String get flaggedEquipment => 'Označena oprema';

  @override
  String get notYetDoneToday => 'Još nije obavljeno danas';

  @override
  String get takePhoto => 'Fotografiraj';

  @override
  String get uploadFromFiles => 'Prenesi iz datoteka';

  @override
  String get seeAllTasksTooltip => 'Pogledaj sve zadatke';

  @override
  String get leaveBeforeFinishingTitle => 'Izaći prije dovršetka?';

  @override
  String get leaveBeforeFinishingBody =>
      'Neke provjere nisu dovršene. Ovo će biti zabilježeno. Možeš se vratiti i dovršiti u bilo kojem trenutku tijekom ove smjene.';

  @override
  String get enterValue => 'Unesi vrijednost';

  @override
  String enterValueWithUnit(String unit) {
    return 'Unesi vrijednost ($unit)';
  }

  @override
  String safeRangeLabel(String min, String max) {
    return 'Siguran raspon: $min - $max';
  }

  @override
  String get errorNumericRequired => 'Potrebna je valjana brojčana vrijednost';

  @override
  String get errorSelectOption => 'Odaberi opciju';

  @override
  String get errorNotesRequired => 'Potrebne su bilješke';

  @override
  String get errorPhotoRequired => 'Potrebna je fotografija';

  @override
  String get errorCorrectiveActionRequired =>
      'Odaberi kako je riješena korektivna radnja';

  @override
  String get myTasksTitle => 'Moji zadaci';

  @override
  String get taskTitleFallback => 'Zadatak';

  @override
  String get noTasksAssigned => 'Još nema dodijeljenih zadataka.';

  @override
  String get overdueLabel => 'Zakašnjelo';

  @override
  String overdueSinceLabel(String date) {
    return 'Zakašnjelo od $date';
  }

  @override
  String get withinRangePass => 'Unutar raspona - PROŠLO';

  @override
  String get outsideRangeFail => 'Izvan raspona - PALO';

  @override
  String get selectOptionLabel => 'Odaberi opciju';

  @override
  String get notesLabel => 'Bilješke';

  @override
  String get spotCheckPhotoNotice =>
      'Današnja nasumična provjera - ovaj put je potrebna fotografija kako bi se potvrdilo da je to stvarno obavljeno.';

  @override
  String get photoAdded => 'Fotografija dodana';

  @override
  String get addPhoto => 'Dodaj fotografiju';

  @override
  String get passLabel => 'PROŠLO';

  @override
  String get failLabel => 'PALO';

  @override
  String get readingOutsideSafeRange => 'Očitanje je izvan sigurnog raspona';

  @override
  String get hereIsWhatToDo => 'Evo što treba učiniti:';

  @override
  String get correctiveActionRequired => 'Potrebna je korektivna radnja';

  @override
  String get iFixedIt => 'Popravio/la sam';

  @override
  String get reportedToManager => 'Prijavljeno voditelju';

  @override
  String get correctiveActionNoteLabel => 'Što si učinio/la? (neobavezno)';

  @override
  String get managerWillBeNotified => 'Tvoj voditelj bit će obaviješten.';

  @override
  String get submitButton => 'POŠALJI';

  @override
  String availableFrom(String time) {
    return 'Dostupno od $time';
  }

  @override
  String get backToList => 'Natrag na popis';

  @override
  String get skipComesBackLater => 'Preskoči - vraća se kasnije';
}
