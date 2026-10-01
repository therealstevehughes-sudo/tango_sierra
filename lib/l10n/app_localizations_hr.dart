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

  @override
  String get noAdHocTaskTypesSetUp =>
      'Na ovoj lokaciji još nisu postavljene vrste ad hoc zadataka - zamoli voditelja da prvo dodijeli predložak provjere dostave ili temperature.';

  @override
  String get whatKindOfThing => 'Kakvu vrstu stvari radiš?';

  @override
  String get notesOptionalLabel => 'Bilješke (neobavezno)';

  @override
  String get noteOptionalLabel => 'Bilješka (neobavezno)';

  @override
  String get temperatureCelsiusLabel => 'Temperatura (°C)';

  @override
  String get submitLabel => 'Pošalji';

  @override
  String get logReadingButton => 'Zabilježi očitanje';

  @override
  String get loggedThanksMessage =>
      'Zabilježeno. Hvala što si to zabilježio/la.';

  @override
  String get logAnotherAdHocTask => 'Zabilježi još jedan ad hoc zadatak';

  @override
  String get deliveryCheckLabel => 'Provjera dostave';

  @override
  String get temperatureCheckLabel => 'Provjera temperature';

  @override
  String get sessionSummaryTitle => 'Sažetak smjene';

  @override
  String tasksCompletedCount(int count) {
    return 'Dovršeni zadaci: $count';
  }

  @override
  String get passedLabel => 'Prošlo';

  @override
  String get failedLabel => 'Palo';

  @override
  String get triggersFailedTasks => 'Okidači / Zadaci koji nisu prošli';

  @override
  String get yourReliability => 'Tvoja pouzdanost';

  @override
  String get reliabilityExplanation =>
      'Zadnjih 30 dana - provjere dovršene i zabilježene na vrijeme. Zabilježeni neuspjeh broji se jednako kao zabilježeni uspjeh: ovo mjeri samo jesi li i kada provjerio/la.';

  @override
  String completedPercentChip(int percent) {
    return '$percent% dovršeno';
  }

  @override
  String onTimePercentChip(int percent) {
    return '$percent% na vrijeme';
  }

  @override
  String get sendSummaryToManager =>
      'Pošalji ovaj sažetak voditelju (neobavezno)';

  @override
  String get noManagersSetUp => 'Još nema postavljenih voditelja.';

  @override
  String get managerLabel => 'Voditelj';

  @override
  String get sentLabel => 'Poslano';

  @override
  String get sendLabel => 'Pošalji';

  @override
  String get leaveNoteForNextShift =>
      'Ostavi bilješku za sljedeću smjenu (neobavezno)';

  @override
  String get handoverNoteLabel => 'Bilješka predaje';

  @override
  String get doneLabel => 'Gotovo';

  @override
  String get supplierOptionalLabel => 'Dobavljač (neobavezno)';

  @override
  String supplierWarningRecorded(String status) {
    return 'Ovaj dobavljač je označen kao $status - provjera će ipak biti zabilježena.';
  }

  @override
  String get reportProblemWithDelivery => 'Prijavi problem s ovom dostavom';

  @override
  String get temperatureOnArrivalLabel =>
      'Temperatura pri dolasku (°C, neobavezno)';

  @override
  String get problemsTickAnyApply => 'Problemi (označi sve koji se odnose)';

  @override
  String get shortDeliveryLabel => 'Nepotpuna dostava';

  @override
  String get damagedStockLabel => 'Oštećena roba';

  @override
  String get lateDeliveryLabel => 'Kasna dostava';

  @override
  String get qualityProblemLabel => 'Problem s kvalitetom';

  @override
  String get outcomeLabel => 'Ishod';

  @override
  String get acceptedLabel => 'Prihvaćeno';

  @override
  String get rejectedLabel => 'Odbijeno';

  @override
  String get partiallyAcceptedLabel => 'Djelomično prihvaćeno';

  @override
  String get noCameraFound => 'Na ovom uređaju nije pronađena kamera.';

  @override
  String couldNotStartCamera(String error) {
    return 'Kameru nije bilo moguće pokrenuti: $error';
  }

  @override
  String couldNotSwitchCamera(String error) {
    return 'Kameru nije bilo moguće promijeniti: $error';
  }

  @override
  String couldNotCapturePhoto(String error) {
    return 'Fotografiju nije bilo moguće snimiti: $error';
  }

  @override
  String get switchCameraTooltip => 'Promijeni kameru';

  @override
  String get allTasksTitle => 'Svi zadaci';

  @override
  String get otherSegmentLabel => 'Ostalo';

  @override
  String get reorderTasksTitle => 'Promijeni redoslijed zadataka';

  @override
  String get ungroupedLabel => 'Negrupirano';

  @override
  String get taskOrderSaved => 'Redoslijed zadataka spremljen.';

  @override
  String couldNotSaveTaskOrder(String error) {
    return 'Redoslijed zadataka nije bilo moguće spremiti: $error';
  }

  @override
  String get noVenueSelectedReorder =>
      'Još nije odabrana lokacija. Postavi aktivnu lokaciju u Detaljima lokacije prije promjene redoslijeda zadataka.';

  @override
  String get noActiveTasksToReorder =>
      'Još nema aktivnih zadataka za promjenu redoslijeda. Prvo dodijeli zadatke, a zatim se vrati ovdje kako bi odabrao/la njihov redoslijed.';

  @override
  String get savingEllipsis => 'Spremanje…';

  @override
  String get saveOrderLabel => 'Spremi redoslijed';

  @override
  String get moveUpTooltip => 'Pomakni gore';

  @override
  String get moveDownTooltip => 'Pomakni dolje';

  @override
  String get accountRestrictedTitle => 'Račun ograničen';

  @override
  String get accountRestrictedBody =>
      'Izravno terećenje ove organizacije zahtijeva pažnju prije nego što se nove provjere mogu spremiti. Tvoj rad nije izgubljen - obavijesti voditelja ili direktora da riješi naplatu, a zatim pokušaj ponovno.';

  @override
  String get okLabel => 'U redu';

  @override
  String get troubleshootingTitle => 'Rješavanje problema';

  @override
  String get faqTitle => 'Česta pitanja';

  @override
  String get helpTitle => 'Pomoć';

  @override
  String get couldntReachAssistant => 'Nije bilo moguće kontaktirati asistenta';

  @override
  String get aiOfflineBody =>
      'AI asistent trenutno nije dostupan - može biti tvoja veza ili je usluga privremeno nedostupna. U međuvremenu, Česta pitanja i Rješavanje problema u nastavku pokrivaju najčešća pitanja, ili izravno kontaktiraj VenuRite.';

  @override
  String get askQuestionSubtitle => 'Dobij jasan odgovor, jednostavnim jezikom';

  @override
  String get faqSubtitle => 'Česta pitanja, s odgovorima';

  @override
  String get troubleshootingSubtitle => 'Nešto ne radi? Počni ovdje';

  @override
  String get contactVenuriteTitle => 'Kontaktiraj VenuRite';

  @override
  String get contactVenuriteSubtitle => 'Stupi izravno u kontakt';

  @override
  String get topTierViewTitle => 'Prikaz najviše razine';

  @override
  String get everythingsDone => 'Sve je gotovo. Dobar posao.';

  @override
  String tasksNotCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zadataka nije dovršeno:',
      one: '1 zadatak nije dovršen:',
    );
    return '$_temp0';
  }

  @override
  String get backToShiftLabel => 'Natrag na smjenu';

  @override
  String get finishShiftLabel => 'Završi smjenu';

  @override
  String get ehoAuditExportTitle => 'EHO / izvoz revizije';

  @override
  String get ehoExportDescription =>
      'Generira PDF s evidencijom usklađenosti ove lokacije za odabrani vremenski raspon.';

  @override
  String dateRangeValue(String start, String end) {
    return '$start - $end';
  }

  @override
  String get selectDateRangeLabel => 'Odaberi vremenski raspon';

  @override
  String get tapToChooseDates =>
      'Dodirni za odabir početnog i završnog datuma.';

  @override
  String get includeFullDetailedLog => 'Uključi potpuni detaljni zapisnik';

  @override
  String get fullLogSubtitle =>
      'Zadano isključeno - sažetak i iznimke iznad su ono što inspektor stvarno pregledava; ovo dodaje svaku pojedinačnu provjeru.';

  @override
  String get generateLabel => 'Generiraj';

  @override
  String get exportFailedTitle => 'Izvoz nije uspio';

  @override
  String exportFailedBody(String error) {
    return 'Izvoz nije uspio: $error';
  }

  @override
  String get exportCreatedTitle => 'Izvoz stvoren';

  @override
  String savedToLabel(String path) {
    return 'Spremljeno u:\n$path';
  }

  @override
  String get dashboardTitle => 'Nadzorna ploča';

  @override
  String get noVenueFound => 'Nije pronađena lokacija.';

  @override
  String get allPermittedVenuesLast30Days =>
      'Sve dopuštene lokacije · posljednjih 30 dana';

  @override
  String get last30Days => 'Posljednjih 30 dana';

  @override
  String failCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PALO (30 dana)',
      one: '1 PALO (30 dana)',
    );
    return '$_temp0';
  }

  @override
  String overdueCountLabel(int count) {
    return '$count zakašnjelo';
  }

  @override
  String get venuesSectionTitle => 'Poslovnice';

  @override
  String get teamSectionTitle => 'Tim';

  @override
  String get noStaffAtVenue => 'Još nema osoblja na ovoj lokaciji.';

  @override
  String get notEnoughDataYet => 'Nedovoljno podataka';

  @override
  String get venueFallbackLabel => 'Lokacija';

  @override
  String get trendsTitle => 'Trendovi';

  @override
  String get trendNeedsHistory =>
      'Podaci o trendu: potrebno je najmanje 4 tjedna povijesti za prikaz trenda.';

  @override
  String perVenueWeeklyCompletion(int weeks) {
    return 'Tjedno dovršavanje po lokaciji · posljednjih $weeks tjedana';
  }

  @override
  String get allVenuesCombined => 'Sve lokacije zajedno';

  @override
  String get noVenuesYet => 'Još nema lokacija.';

  @override
  String get otherVenuesLabel => 'Ostale lokacije';

  @override
  String lowLoggingFlagLabel(int completed, int total) {
    return 'Zabilježeno $completed od $total provjera';
  }

  @override
  String regionFallbackLabel(int id) {
    return 'Regija #$id';
  }

  @override
  String get dashboardOverviewTitle => 'Pregled nadzorne ploče';

  @override
  String get gradedBarsOnTooltip =>
      'Ocijenjene trake po zaposleniku: uključeno';

  @override
  String get gradedBarsOffTooltip =>
      'Ocijenjene trake po zaposleniku: isključeno';

  @override
  String get noBranchesToShow => 'Još nema podružnica za prikaz.';

  @override
  String get supervisorNoScopeMessage =>
      'Još nisi dodijeljen/a odjelu ili timu - zamoli voditelja da to postavi u Upravljanju osobljem prije nego što ova nadzorna ploča ima što prikazati.';

  @override
  String get individualViewNotice =>
      'Pojedinačni prikaz - za nadzor rizika, ne ljestvica.';

  @override
  String get branchLabel => 'Podružnica';

  @override
  String get allBranchesLabel => 'Sve podružnice';

  @override
  String get yourSectionLabel => 'Tvoj odjel';

  @override
  String get noneAssignedLabel => 'Ništa nije dodijeljeno';

  @override
  String get areaLabel => 'Područje';

  @override
  String get allAreasLabel => 'Sva područja';

  @override
  String get employeeLabel => 'Zaposlenik';

  @override
  String get allEmployeesLabel => 'Svi zaposlenici';

  @override
  String get monthLabel => 'Mjesec';

  @override
  String get weekLabel => 'Tjedan';

  @override
  String get dayLabel => 'Dan';

  @override
  String get noTaskActivityPeriod =>
      'Nema aktivnosti zadataka u ovom razdoblju.';

  @override
  String get taskOverviewTitle => 'Pregled zadataka';

  @override
  String get incidentsTitle => 'Incidenti';

  @override
  String get noIncidentsPeriod =>
      'U ovom razdoblju nisu prijavljeni incidenti.';

  @override
  String urgentCountLabel(int count) {
    return '$count hitno';
  }

  @override
  String get tapForDetailsHint =>
      'Dodirni obojeni odjeljak ili stavku legende za detalje';

  @override
  String get employeeFallbackLabel => 'Zaposlenik';

  @override
  String get plainLookupNotice =>
      'Obična pretraga, ne ocjena - boja dovršenosti i oznake problema ovdje se nikada ne ocjenjuju po osobi.';

  @override
  String tasksCompletedCountParens(int count) {
    return 'Dovršeni zadaci ($count)';
  }

  @override
  String issuesRaisedCountParens(int count) {
    return 'Prijavljeni problemi ($count)';
  }

  @override
  String get doneOnTimeNoIssues => 'Obavljeno na vrijeme (bez problema)';

  @override
  String get doneOnTimeIssuesLogged =>
      'Obavljeno na vrijeme (problemi prijavljeni)';

  @override
  String get doneEarlyLateNoIssues => 'Obavljeno ranije/kasnije (bez problema)';

  @override
  String get doneEarlyLateIssuesLogged =>
      'Obavljeno ranije/kasnije (problemi prijavljeni)';

  @override
  String get notDoneLabel => 'Nije obavljeno';

  @override
  String get resolvedLabel => 'Riješeno';

  @override
  String get unresolvedLabel => 'Neriješeno';

  @override
  String get escalatedLabel => 'Eskalirano';

  @override
  String get urgentLabel => 'Hitno';

  @override
  String get signInFailed => 'Prijava nije uspjela';

  @override
  String get twoFactorRequiredNoFactor =>
      'Potrebna je dvofaktorska provjera, ali nije pronađen nijedan faktor.';

  @override
  String get couldNotVerifyCode => 'Taj kod nije bilo moguće provjeriti';

  @override
  String get codeDidntWork => 'Taj kod nije funkcionirao.';

  @override
  String get accountNotLinkedToStaff =>
      'Ovaj račun još nije povezan s profilom osoblja - kontaktiraj administratora.';

  @override
  String get resetPasswordTitle => 'Resetiraj lozinku';

  @override
  String get enterEmailForResetCode =>
      'Unesi svoj e-mail i poslat ćemo ti kod za resetiranje lozinke.';

  @override
  String get emailLabel => 'E-pošta';

  @override
  String get sendCodeButton => 'POŠALJI KOD';

  @override
  String get backToSignIn => 'Natrag na prijavu';

  @override
  String sentCodeToEmail(String email) {
    return 'Poslali smo kod na $email. Unesi ga u nastavku zajedno s novom lozinkom.';
  }

  @override
  String get sixDigitCodeLabel => '6-znamenkasti kod';

  @override
  String get newPasswordLabel => 'Nova lozinka';

  @override
  String get resetPasswordButton => 'RESETIRAJ LOZINKU';

  @override
  String get twoFactorVerificationTitle => 'Dvofaktorska provjera';

  @override
  String get enterAuthenticatorCode =>
      'Unesi kod iz svoje aplikacije za autentifikaciju.';

  @override
  String get verifyButton => 'PROVJERI';

  @override
  String get regionalDirectorSignIn =>
      'Prijava za regionalnog voditelja i direktora.';

  @override
  String get passwordLabel => 'Lozinka';

  @override
  String get signInButton => 'PRIJAVA';

  @override
  String get forgotPasswordLink => 'Zaboravio/la si lozinku?';

  @override
  String get noBackendConfiguredPin =>
      'Za ovu instalaciju nije konfiguriran backend - prijavi se PIN-om, kao i svi ostali.';

  @override
  String get noDirectorRegionalAccounts =>
      'Na ovom uređaju nema računa direktora/regionalnog voditelja.';

  @override
  String get directorLabel => 'Direktor';

  @override
  String get regionalManagerLabel => 'Regionalni voditelj';

  @override
  String get whoAreYouTitle => 'Tko si ti?';

  @override
  String get searchLabel => 'Pretraži';

  @override
  String get noMatchesLabel => 'Nema podudaranja';

  @override
  String get leadershipSectionTitle => 'Rukovodstvo';

  @override
  String get kitchenStaffSectionTitle => 'Kuhinjsko osoblje';

  @override
  String get chooseASectionTitle => 'Odaberi odjel';

  @override
  String get unassignedLabel => 'Nedodijeljeno';

  @override
  String personCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count osoba',
      one: '$count osoba',
    );
    return '$_temp0';
  }

  @override
  String get goodMorning => 'Dobro jutro';

  @override
  String get goodAfternoon => 'Dobar dan';

  @override
  String get goodEvening => 'Dobra večer';

  @override
  String get welcomeToVenurite => 'Dobrodošli u VenuRite';

  @override
  String get helpAssistantTooltip => 'Pomoć i asistent';

  @override
  String get couldntLoadScreen => 'Ovaj zaslon nije bilo moguće učitati.';

  @override
  String get retryLabel => 'Pokušaj ponovno';

  @override
  String get microphonePermissionDenied =>
      'Dopuštenje za mikrofon je odbijeno.';

  @override
  String get couldntRecordTryAgain =>
      'Snimanje nije uspjelo - pokušaj ponovno.';

  @override
  String get couldntTranscribe => 'To nije bilo moguće transkribirati.';

  @override
  String get couldntReachTranscriptionService =>
      'Nije bilo moguće kontaktirati uslugu transkripcije.';

  @override
  String get dictateANote => 'Izdiktiraj bilješku';

  @override
  String get stoppingSoonTapToStop =>
      'Uskoro se zaustavlja - dodirni za trenutno zaustavljanje';

  @override
  String get stopLabel => 'Zaustavi';

  @override
  String get somethingWentWrong => 'Nešto je pošlo po zlu';

  @override
  String alertsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count upozorenja',
      one: '1 upozorenje',
    );
    return '$_temp0';
  }

  @override
  String unacknowledgedCountLabel(int count) {
    return '$count nepotvrđeno';
  }

  @override
  String get allAcknowledgedLabel => 'Sve potvrđeno';

  @override
  String overdueUnacknowledgedMinutes(int minutes) {
    return 'ZAKAŠNJELO - nepotvrđeno $minutes min';
  }

  @override
  String get escalatedToTopTier => 'Eskalirano na najvišu razinu';

  @override
  String get acknowledgeLabel => 'Potvrdi';

  @override
  String get nothingInCategory => 'Ništa u ovoj kategoriji.';

  @override
  String categoryWithCountLabel(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get leadershipOverview => 'Pregled rukovodstva';

  @override
  String get photoEvidence => 'Fotografski dokazi';

  @override
  String get staffManagement => 'Upravljanje osobljem';

  @override
  String get addTeamMember => 'Dodaj člana tima';

  @override
  String get shiftLog => 'Zapisnik smjena';

  @override
  String get branchTeamStructure => 'Struktura tima podružnice';

  @override
  String get departmentManagement => 'Upravljanje odjelima';

  @override
  String get rosterBoard => 'Raspored smjena';

  @override
  String get claimShifts => 'Preuzmi smjene';

  @override
  String get requestADayOff => 'Zatraži slobodan dan';

  @override
  String get shiftFairnessReview => 'Pregled pravednosti rasporeda';

  @override
  String get venueDetails => 'Detalji lokacije';

  @override
  String get assignTasks => 'Dodijeli zadatke';

  @override
  String get taskPresets => 'Predlošci zadataka';

  @override
  String get supplierManagement => 'Upravljanje dobavljačima';

  @override
  String get serviceProviders => 'Pružatelji usluga';

  @override
  String get notificationRules => 'Pravila obavijesti';

  @override
  String get documentCentre => 'Centar dokumenata';

  @override
  String get setupWizard => 'Čarobnjak za postavljanje';

  @override
  String get organisationLabel => 'Organizacija';

  @override
  String get branchesLabel => 'Podružnice';

  @override
  String get homeLabel => 'Početna';

  @override
  String get oversightLabel => 'Nadzor';

  @override
  String get problemsAndIssues => 'Problemi i incidenti';

  @override
  String get twoFactorAuthentication => 'Dvofaktorska autentifikacija';

  @override
  String get backUpNow => 'Napravi sigurnosnu kopiju sada';

  @override
  String get dailySection => 'Dnevno';

  @override
  String get insightsSection => 'Uvidi';

  @override
  String get peopleSection => 'Osoblje';

  @override
  String get rosterSection => 'Raspored';

  @override
  String get venueSetupSection => 'Postavljanje lokacije';

  @override
  String get companySection => 'Tvrtka';

  @override
  String get accountSection => 'Račun';

  @override
  String get settingsLabel => 'Postavke';

  @override
  String percentCompletedTodayChip(int percent) {
    return '$percent% dovršeno danas';
  }

  @override
  String activeStaffCountLabel(int count) {
    return '$count aktivnog osoblja';
  }

  @override
  String failCountTodayBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PALO danas',
      one: '1 PALO danas',
    );
    return '$_temp0';
  }

  @override
  String get managerViewTitle => 'Prikaz voditelja';

  @override
  String showingScopeLabel(String scope) {
    return 'Prikazano: $scope';
  }

  @override
  String get supervisorNoScopeMessageLog =>
      'Još nisi dodijeljen/a odjelu ili timu - zamoli voditelja da to postavi u Upravljanju osobljem prije nego što ovaj zapisnik ima što prikazati.';

  @override
  String entriesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unosa',
      one: '1 unos',
    );
    return '$_temp0';
  }

  @override
  String failCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PALO',
      one: '1 PALO',
    );
    return '$_temp0';
  }

  @override
  String get noFailsLabel => 'Bez padova';

  @override
  String get noCompletedTasksLoggedYet =>
      'Još nema zabilježenih dovršenih zadataka';

  @override
  String sessionSummariesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sažetaka smjena',
      one: '1 sažetak smjene',
    );
    return '$_temp0';
  }

  @override
  String passFailCountLabel(int passCount, int failCount) {
    return '$passCount prošlo / $failCount palo';
  }

  @override
  String get workerFixedIt => 'Zaposlenik je to popravio';

  @override
  String get noCorrectiveActionRecorded => 'Nije zabilježena korektivna radnja';

  @override
  String get taskAlertFallback => 'Upozorenje o zadatku';

  @override
  String get loggedByLabel => 'Zabilježio/la';

  @override
  String get resultLabel => 'Rezultat';

  @override
  String get correctiveActionLabel => 'Korektivna radnja';

  @override
  String get noteLabel => 'Bilješka';

  @override
  String get closeLabel => 'Zatvori';

  @override
  String get notCompletedSuffix => '- NIJE DOVRŠENO (smjena završena)';

  @override
  String get todayAllFails => 'Danas + svi padovi';

  @override
  String byAxisLabel(String axis) {
    return 'Prema $axis';
  }

  @override
  String get nameAxisLabel => 'Ime';

  @override
  String get dateAxisLabel => 'Datum';

  @override
  String get taskAxisLabel => 'Zadatak';

  @override
  String get filterLabel => 'Filtar';

  @override
  String get filterByLabel => 'Filtriraj prema:';

  @override
  String get clearFiltersLabel => 'Očisti filtre';

  @override
  String get staffLabel => 'Osoblje';

  @override
  String get issueTypeComplaint => 'Pritužba';

  @override
  String get issueTypeAccident => 'Nesreća';

  @override
  String get issueTypeIncident => 'Incident';

  @override
  String get issueTypeSupplyProblem => 'Problem s opskrbom';

  @override
  String get issueTypeVenueProblem => 'Problem s lokacijom';

  @override
  String get issueTypeOther => 'Ostalo';

  @override
  String get incorrectDeliveryLabel => 'Pogrešna dostava';

  @override
  String get driverProblemLabel => 'Problem s vozačem';

  @override
  String get otherLabel => 'Ostalo';

  @override
  String get whatKindOfThingHappened => 'Kakva se stvar dogodila?';

  @override
  String get whichOneLabel => 'Koja?';

  @override
  String get supplierLabel => 'Dobavljač';

  @override
  String get whatWasWrongWithDelivery => 'Što nije bilo u redu s dostavom?';

  @override
  String get receivedByLabel => 'Primio/la';

  @override
  String get whichSectionOptional => 'O kojem se odjelu radi? (neobavezno)';

  @override
  String get noSectionLabel => 'Bez odjela';

  @override
  String get teamOptionalLabel => 'Tim (neobavezno)';

  @override
  String get noSpecificTeamLabel => 'Nema određenog tima';

  @override
  String get whatHappenedLabel => 'Što se dogodilo?';

  @override
  String get markAsUrgentLabel => 'Označi kao hitno';

  @override
  String get markUrgentSubtitle =>
      'Zahtijeva trenutnu pažnju, bez obzira koliko dugo ostaje neriješeno';

  @override
  String get logItButton => 'Zabilježi';

  @override
  String get escalateToTitle => 'Eskaliraj do';

  @override
  String get sendToLabel => 'Pošalji';

  @override
  String get escalateButton => 'Eskaliraj';

  @override
  String get savedLabel => 'Spremljeno.';

  @override
  String remindedMessage(String name) {
    return '$name je podsjećen/a.';
  }

  @override
  String get couldNotSendReminder => 'Podsjetnik nije bilo moguće poslati.';

  @override
  String get viewSupplierScorecard => 'Pogledaj karticu dobavljača';

  @override
  String raisedAtLabel(String date) {
    return 'Prijavljeno $date';
  }

  @override
  String escalatedToColonLabel(String name) {
    return 'Eskalirano do: $name';
  }

  @override
  String get historyLabel => 'Povijest';

  @override
  String get addAnUpdateLabel => 'Dodaj ažuriranje';

  @override
  String get addProcessNoteButton => 'Dodaj bilješku procesa';

  @override
  String get resolveButton => 'Riješi';

  @override
  String get reopenThisIssueTitle => 'Ponovno otvori ovaj problem';

  @override
  String get whyReopenLabel => 'Zašto bi ovo trebalo ponovno otvoriti?';

  @override
  String get reopenButton => 'Ponovno otvori';

  @override
  String sentToLabel(String name) {
    return 'Poslano $name';
  }

  @override
  String get remindButton => 'Podsjeti';

  @override
  String get phaseRaisedLabel => 'Prijavljeno';

  @override
  String get phaseUpdateLabel => 'Ažuriranje';

  @override
  String get phaseOutcomeLabel => 'Ishod';

  @override
  String get allLabel => 'Sve';

  @override
  String get dateRangeLabel => 'Raspon datuma';

  @override
  String get allDatesLabel => 'Svi datumi';

  @override
  String get typeLabel => 'Vrsta';

  @override
  String get anyTypeLabel => 'Bilo koja vrsta';

  @override
  String get anyoneLabel => 'Bilo tko';

  @override
  String staffFallback(String id) {
    return 'Osoblje #$id';
  }

  @override
  String get nothingHereGoodSign => 'Ovdje nema ničega - to je dobar znak.';

  @override
  String escalatedToNameLabel(String name) {
    return 'Eskalirano do $name';
  }

  @override
  String get havenReportedYet => 'Još nisi ništa prijavio/la.';

  @override
  String get failsAndProblemsRegisterTitle => 'Registar padova i problema';

  @override
  String get taskProblemsTab => 'Problemi sa zadacima';

  @override
  String get issuesAndIncidentsTab => 'Problemi i incidenti';

  @override
  String get failFilterLabel => 'Palo';

  @override
  String get reportedFilterLabel => 'Prijavljeno';

  @override
  String get notCompletedFilterLabel => 'Nije dovršeno';

  @override
  String get abandonedLabel => 'Napušteno';

  @override
  String get noActionTakenLabel => 'Nije poduzeta radnja';

  @override
  String get markResolvedButton => 'Označi kao riješeno';

  @override
  String get openLabel => 'Otvoreno';

  @override
  String get enableRosterQuestion => 'Omogućiti raspored?';

  @override
  String rosterQuoteBody(String amount) {
    return 'Na temelju tvog trenutnog broja osoblja, ovo će dodati $amount tvom mjesečnom izravnom terećenju, počevši od sljedeće uplate.';
  }

  @override
  String get confirmAndEnable => 'Potvrdi i omogući';

  @override
  String couldNotReachVenurite(String error) {
    return 'Nije bilo moguće kontaktirati VenuRite: $error';
  }

  @override
  String get letStaffClaimShifts =>
      'Dopusti osoblju da preuzme vlastite smjene';

  @override
  String get rosterPitchBody =>
      'Objavi otvorene smjene i dopusti osoblju da ih samo preuzme - više nema kruženja telefonom ili WhatsApp grupe kada netko ne može doći. Osoblje također može zatražiti slobodne dane, a ti odobravaš ili odbijaš s istog mjesta.';

  @override
  String get pricingLabel => 'Cijene';

  @override
  String get priceUnder10Staff =>
      '6 GBP/mjesečno po podružnici s manje od 10 zaposlenika';

  @override
  String get price10PlusStaff =>
      '10 GBP/mjesečno po podružnici s 10 ili više zaposlenika';

  @override
  String get addedToDirectDebitNote =>
      'Dodano tvom postojećem izravnom terećenju - nije potreban novi način plaćanja. Vidjet ćeš točan iznos prije potvrde.';

  @override
  String get enableRosterButton => 'Omogući raspored';

  @override
  String get availableShiftsTitle => 'Dostupne smjene';

  @override
  String get shiftClaimingNotEnabled =>
      'Preuzimanje smjena još nije omogućeno za ovu lokaciju. Zamoli voditelja da to omogući u Postavkama.';

  @override
  String couldNotLoadShifts(String error) {
    return 'Smjene nije bilo moguće učitati: $error';
  }

  @override
  String get noShiftsPostedYet => 'Još nema objavljenih smjena.';

  @override
  String get someoneElseClaimedShift =>
      'Netko drugi je upravo preuzeo tu smjenu - žao nam je!';

  @override
  String get shiftClaimedMessage => 'Smjena preuzeta.';

  @override
  String get cancelThisShiftTitle => 'Otkazati ovu smjenu?';

  @override
  String get cancelShiftLateWarning =>
      '\n\nPreostalo je manje od 24 sata do početka smjene - otkazivanje sada može utjecati na tvoju evidenciju pouzdanosti.';

  @override
  String willNoLongerBeClaimed(String warning) {
    return 'Više nećeš biti prijavljen/a za ovu smjenu.$warning';
  }

  @override
  String get keepShiftButton => 'Zadrži smjenu';

  @override
  String get cancelShiftButton => 'Otkaži smjenu';

  @override
  String get yourShiftRecordReliable => 'Tvoja evidencija smjena: Pouzdan/na';

  @override
  String get yourShiftRecordNeedsImprovement =>
      'Tvoja evidencija smjena: Potrebno poboljšanje';

  @override
  String get yourShiftRecordBuilding =>
      'Tvoja evidencija smjena: Gradi se evidencija';

  @override
  String get claimLabel => 'Preuzmi';

  @override
  String get claimedLabel => 'Preuzeto';

  @override
  String requestDateOffTitle(String date) {
    return 'Zatraži slobodan dan $date';
  }

  @override
  String get reasonOptionalLabel => 'Razlog (neobavezno)';

  @override
  String get submitRequestButton => 'Pošalji zahtjev';

  @override
  String get offDayRequestsNotEnabled =>
      'Zahtjevi za slobodan dan još nisu omogućeni za ovu lokaciju. Zamoli voditelja da omogući Raspored u Postavkama.';

  @override
  String get noOffDayRequestsYet => 'Još nemaš zahtjeve za slobodan dan.';

  @override
  String get yourRequestsLabel => 'Tvoji zahtjevi';

  @override
  String get approvedLabel => 'Odobreno';

  @override
  String get deniedLabel => 'Odbijeno';

  @override
  String get pendingLabel => 'Na čekanju';

  @override
  String get postAShiftTitle => 'Objavi smjenu';

  @override
  String get categoryHint => 'npr. Popravak hlađenja, Suzbijanje štetočina';

  @override
  String get pickStartTime => 'Odaberi vrijeme početka';

  @override
  String get pickEndTime => 'Odaberi vrijeme završetka';

  @override
  String get postLabel => 'Objavi';

  @override
  String get assignShiftToTitle => 'Dodijeli ovu smjenu';

  @override
  String get unknownLabel => 'Nepoznato';

  @override
  String get shiftsTabLabel => 'Smjene';

  @override
  String get offDayRequestsTabLabel => 'Zahtjevi za slobodan dan';

  @override
  String get rosterAddonNotEnabledManager =>
      'Dodatak Raspored nije omogućen za ovu lokaciju. Omogući ga u Postavke > Tvrtka da počneš objavljivati smjene.';

  @override
  String get noShiftsTapPlus =>
      'Još nema objavljenih smjena. Dodirni + za dodavanje.';

  @override
  String get openStatusLabel => 'Otvoreno';

  @override
  String get assignedStatusPrefix => 'Dodijeljeno';

  @override
  String get claimedStatusPrefix => 'Preuzeto';

  @override
  String get assignDirectlyLabel => 'Dodijeli izravno';

  @override
  String get removeClaimLabel => 'Ukloni preuzimanje';

  @override
  String couldNotLoadOffDayRequests(String error) {
    return 'Zahtjeve za slobodan dan nije bilo moguće učitati: $error';
  }

  @override
  String get noOffDayRequests => 'Nema zahtjeva za slobodan dan.';

  @override
  String get approveLabel => 'Odobri';

  @override
  String get denyLabel => 'Odbij';

  @override
  String get rosterAddonNotEnabledPlain =>
      'Dodatak Raspored nije omogućen za ovu lokaciju.';

  @override
  String get noActiveStaffVenue =>
      'Još nema aktivnog osoblja na ovoj lokaciji.';

  @override
  String get last90DaysAlphabetical =>
      'Posljednjih 90 dana, prema kategoriji smjene. Abecedno - nije ljestvica.';

  @override
  String shiftsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count smjena',
      one: '1 smjena',
    );
    return '$_temp0';
  }

  @override
  String get noShiftsInPeriod => 'Nema smjena u ovom razdoblju.';

  @override
  String categoryCountLabel(String category, int count) {
    return '$category: $count';
  }

  @override
  String get backupExplanation =>
      'Ovo stvara potpunu kopiju lokalne baze podataka u tvojoj mapi Dokumenti. Premještanje na USB pogon ili mapu sinkroniziranu s oblakom naknadno je zaseban ručni korak.';

  @override
  String get backupNameOptional => 'Naziv sigurnosne kopije (neobavezno)';

  @override
  String get backupNameHint => 'npr. Sigurnosna kopija prije inspekcije';

  @override
  String get backupCreatedTitle => 'Sigurnosna kopija stvorena';

  @override
  String get tierTeamMember => 'Član tima';

  @override
  String get tierSupervisor => 'Voditelj smjene';

  @override
  String get tierManager => 'Voditelj';

  @override
  String get tierRegionalManager => 'Regionalni voditelj';

  @override
  String get tierDirector => 'Direktor';

  @override
  String get anyTaskFail => 'Bilo koji pad zadatka';

  @override
  String taskFailLabel(String title) {
    return 'Palo: $title';
  }

  @override
  String get taskFailTemplateStale =>
      'Zadatak nije prošao (predložak više nije aktualan)';

  @override
  String get unknownUserLabel => 'Nepoznati korisnik';

  @override
  String tierSuffixLabel(String tier) {
    return 'razina $tier';
  }

  @override
  String get unsetLabel => 'Nije postavljeno';

  @override
  String get pushChannelLabel => 'push';

  @override
  String get emailChannelLabel => 'e-pošta';

  @override
  String get inAppOnlyLabel => 'samo unutar aplikacije';

  @override
  String inAppPlusChannelsLabel(String channels) {
    return 'unutar aplikacije + $channels';
  }

  @override
  String get tierColumnTeam => 'Tim';

  @override
  String get tierColumnSupv => 'Vod.sm';

  @override
  String get tierColumnMgr => 'Vod';

  @override
  String get tierColumnRegnl => 'Regija';

  @override
  String get tierColumnDir => 'Dir';

  @override
  String get quickSetupSectionTitle =>
      'Brzo postavljanje: obavijesti o padu po zadatku';

  @override
  String get tickTierNotified =>
      'Označi koja razina prima obavijest kad određeni zadatak ne prođe.';

  @override
  String get noTaskTemplatesSetUp =>
      'Još nema postavljenih predložaka zadataka.';

  @override
  String notifyPrefixLabel(String target, String channels) {
    return 'Obavijesti: $target ($channels)';
  }

  @override
  String setByTierLabel(String tier) {
    return 'Postavio/la razina $tier';
  }

  @override
  String get inactiveSuffixLabel => ' - neaktivno';

  @override
  String get deactivateButton => 'Deaktiviraj';

  @override
  String get reactivateButton => 'Ponovno aktiviraj';

  @override
  String get newRuleTitle => 'Novo pravilo';

  @override
  String get triggerLabel => 'Okidač';

  @override
  String get notifyLabel => 'Obavijesti';

  @override
  String get wholeRoleTierOption => 'Cijela razina uloge';

  @override
  String get specificPersonOption => 'Određena osoba';

  @override
  String get roleTierLabel => 'Razina uloge';

  @override
  String get personLabel => 'Osoba';

  @override
  String get pushLabel => 'Push';

  @override
  String get rulesInAppNotice =>
      'Pravila se sada prikazuju samo unutar aplikacije; push/e-pošta dostava još nije povezana s pozadinskim sustavom i bit će dodana u kasnijem sprintu.';

  @override
  String get saveRuleButton => 'Spremi pravilo';

  @override
  String get addRuleButton => 'Dodaj pravilo';

  @override
  String get noNotificationRulesYet =>
      'Još nema postavljenih pravila obavijesti.';

  @override
  String get stepYourAccount => 'Tvoj račun';

  @override
  String get stepCompanyDetails => 'Podaci o tvrtki';

  @override
  String get stepOrgStructure => 'Struktura organizacije';

  @override
  String get stepFirstVenue => 'Prva poslovnica';

  @override
  String get stepStarterSetup => 'Tvoj početni paket';

  @override
  String get stepSubscription => 'Pretplata';

  @override
  String get stepPayment => 'Plaćanje';

  @override
  String get termsOfServiceTitle => 'Uvjeti korištenja';

  @override
  String get companySignupGenericError =>
      'Nešto je pošlo po zlu pri stvaranju tvrtke. Pokušaj ponovno - ako se to i dalje događa, kontaktiraj VenuRite.';

  @override
  String get directDebitStartError =>
      'Nismo mogli automatski pokrenuti postavljanje izravnog terećenja - to možeš učiniti u bilo kojem trenutku u Postavkama nakon prijave.';

  @override
  String get continueButton => 'Nastavi';

  @override
  String get creatingEllipsis => 'Stvaranje...';

  @override
  String get startFreeTrialButton => 'Pokreni besplatno probno razdoblje';

  @override
  String get companyCreatedTitle => 'Tvrtka stvorena';

  @override
  String get adminAccountIntro =>
      'Postavimo tvoj račun. Bit ćeš administrator ove tvrtke na VenuRiteu i moći ćeš pozvati svoj tim čim uđeš.';

  @override
  String get firstNameLabel => 'Ime';

  @override
  String get lastNameLabel => 'Prezime';

  @override
  String get passwordMinCharsHelper => 'Najmanje 8 znakova';

  @override
  String get companyDetailsIntro => 'Reci nam nešto o svojoj tvrtki.';

  @override
  String get tradingCompanyNameLabel => 'Trgovački / naziv tvrtke';

  @override
  String get legalCompanyNameLabel => 'Puni naziv tvrtke (neobavezno)';

  @override
  String get legalCompanyNameHelper =>
      'Ostavi prazno za korištenje trgovačkog naziva iznad';

  @override
  String get countryLabel => 'Država';

  @override
  String get registeredAddressLabel =>
      'Registrirana / poslovna adresa (neobavezno)';

  @override
  String get vatNumberLabel => 'PDV / porezni broj (ako je primjenjivo)';

  @override
  String get billingContactEmailLabel => 'E-mail za naplatu (neobavezno)';

  @override
  String get structureIntro =>
      'Evo kako VenuRite organizira tvoju tvrtku. Ne moraš sada ništa postavljati - ovo je samo da bi sljedeći korak imao smisla.';

  @override
  String get structureYourCompanyLabel => 'Tvoja tvrtka';

  @override
  String get structureYourCompanySublabel =>
      'Jedan objedinjeni račun i jedan račun za plaćanje';

  @override
  String get structureRegionsLabel => 'Regije (neobavezno)';

  @override
  String get structureRegionsSublabel =>
      'Grupiraj poslovnice po državi ili području - preskoči ako ti ne treba';

  @override
  String get structureVenuesLabel => 'Poslovnice';

  @override
  String get structureVenuesSublabel =>
      'Jedna poslovnica danas, stotine kasnije - dodaj još kad god želiš';

  @override
  String get structureStaffLabel => 'Osoblje';

  @override
  String get structureStaffSublabel =>
      'Tim svake poslovnice, pozvan čim poslovnica postoji';

  @override
  String get structureOutro =>
      'Sljedeće ćemo postaviti tvoju prvu poslovnicu - regije i dodatne poslovnice možeš dodati kasnije unutar aplikacije.';

  @override
  String get wizardFirstVenueHeroTitle => 'Dodajmo tvoju prvu poslovnicu';

  @override
  String get addMoreVenuesLaterText =>
      'Dodatne poslovnice možeš dodati kasnije.';

  @override
  String get venueNameLabel => 'Naziv poslovnice';

  @override
  String get addressOptionalLabel => 'Adresa (neobavezno)';

  @override
  String get regionAreaOptionalLabel => 'Regija / područje (neobavezno)';

  @override
  String get regionAreaHelper =>
      'npr. \"Zagreb\" - potrebno samo ako imaš (ili ćeš imati) više od jedne poslovnice';

  @override
  String get venueTypeOptionalLabel => 'Vrsta poslovnice (neobavezno)';

  @override
  String get venueTypeHelper =>
      'Odabir prikazuje gotov početni paket - za zadatke i opremu za koje već znaš da su ti potrebni.';

  @override
  String get payoffSkippedText =>
      'Preskočio/la si odabir vrste poslovnice, pa još nema početnog paketa za prikaz - zadatke i opremu možeš dodati sam/sama nakon što uđeš.';

  @override
  String get payoffErrorText =>
      'Nije uspjelo učitavanje početnog paketa za ovu vrstu poslovnice - zadatke i opremu možeš dodati sam/sama nakon što uđeš.';

  @override
  String get payoffHeroTitle => 'Evo tvoje usklađenosti, spremne za korištenje';

  @override
  String get equipmentSectionLabel => 'Oprema';

  @override
  String get subscriptionBannerText =>
      'Jedan račun tvrtke, jedan objedinjeni račun za plaćanje - cijena po poslovnici, nikad po osobi.';

  @override
  String get subscriptionIntroText =>
      'Koliko poslovnica danas imaš, uključujući sjedište ako ga imaš? Sada ćeš postaviti samo svoju prvu poslovnicu - ostatak dodaješ kad god želiš unutar aplikacije.';

  @override
  String get perBranchPriceLabel => '39 GBP/poslovnici/mjesečno';

  @override
  String get headOfficeIncludedLabel =>
      '+ 1 poslovnica sjedišta (4+ poslovnice)';

  @override
  String get discountCodeHint =>
      'Imaš kod za popust? Možeš ga unijeti prilikom postavljanja izravnog terećenja.';

  @override
  String get trialBannerText =>
      'Započinješ 14-dnevno besplatno probno razdoblje - danas kartica nije potrebna.';

  @override
  String get paymentStepIntro =>
      'Zatražit ćemo od tebe da postaviš plaćanje prije isteka probnog razdoblja, u Postavkama unutar aplikacije. Sada se ništa ne naplaćuje - samo nam reci kako želiš plaćati.';

  @override
  String get cardPaymentTitle => 'Plaćanje karticom (Stripe)';

  @override
  String get cardPaymentSubtitle =>
      'Debitna/kreditna kartica, naplata mjesečno ili godišnje';

  @override
  String get directDebitTitle => 'Izravno terećenje (GoCardless)';

  @override
  String get directDebitSubtitle =>
      'Plaćanje banka-banci, kartica nije potrebna';

  @override
  String get decideLaterButton => 'Odlučit ću kasnije';

  @override
  String get decideLaterSnackbar =>
      'Nema problema - ovo možeš postaviti bilo kada u Postavkama.';

  @override
  String get agreeToTermsPrefix => 'Pročitao/la sam i slažem se s ';

  @override
  String get successActivatedBanner =>
      'Tvoja tvrtka i prva poslovnica su postavljene, a ti si prijavljen/a.';

  @override
  String get successNotActivatedBanner =>
      'Tvoja tvrtka i prva poslovnica su postavljene. Prijavi se svojom e-poštom i lozinkom koju si upravo odabrao/la.';

  @override
  String get directDebitSettingUp => 'Postavljanje izravnog terećenja...';

  @override
  String get directDebitOpenedBrowser =>
      'Otvorili smo tvoj preglednik za dovršetak postavljanja izravnog terećenja.';

  @override
  String get inviteYourTeamTitle => 'Pozovi svoj tim';

  @override
  String get inviteYourTeamSubtitle =>
      'Neobavezno - dodaj sve koji su trenutno na smjeni, ili preskoči i učini to kasnije u Upravljanju osobljem.';

  @override
  String get jobTitleLabel => 'Radno mjesto';

  @override
  String get tierFieldLabel => 'Razina';

  @override
  String get addTeamMemberButton => 'Dodaj člana tima';

  @override
  String get goToDashboardButton => 'Idi na nadzornu ploču';

  @override
  String get goToSignInButton => 'Idi na prijavu';

  @override
  String wizardStepOfLabel(String title, int step, int total) {
    return '$title - Korak $step od $total';
  }

  @override
  String billingContactEmailHelper(String email) {
    return 'Ostavi prazno za korištenje $email';
  }

  @override
  String payoffNoStarterSet(String venueType) {
    return 'Još nemamo unaprijed pripremljen početni paket za $venueType - zadatke i opremu možeš dodati sam/sama nakon što uđeš.';
  }

  @override
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  ) {
    return '$totalTasks zadataka u $sectionCount odjeljaka i $equipmentCount vrsta opreme već postavljeno za \"$venueType\".';
  }

  @override
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  ) {
    return '$totalTasks zadataka u $sectionCount odjeljaka već postavljeno za \"$venueType\".';
  }

  @override
  String totalPerMonthLabel(String total, int units) {
    return '£$total/mjesečno ukupno (naplaćeno $units poslovnica)';
  }

  @override
  String staffPinLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get jobRoleChefCook => 'Kuhar';

  @override
  String get jobRoleKitchenPorter => 'Kuhinjski pomoćnik';

  @override
  String get jobRoleFrontOfHouse => 'Sala (usluživanje)';

  @override
  String get jobRoleBar => 'Šank';

  @override
  String get jobRoleManagement => 'Uprava';

  @override
  String get jobRoleEveryone => 'Svi';

  @override
  String get jobRoleMaintenance => 'Održavanje';

  @override
  String get jobRoleHousekeeping => 'Čišćenje';

  @override
  String get jobRoleReception => 'Recepcija';

  @override
  String get jobRoleSecurity => 'Zaštitarska služba';

  @override
  String get segmentFoodSafety => 'Sigurnost hrane i kontrola temperature';

  @override
  String get segmentAllergen => 'Upravljanje alergenima';

  @override
  String get segmentPersonalHygienePpe => 'Osobna higijena i OZO';

  @override
  String get segmentRefrigerationColdStorage =>
      'Hlađenje i skladištenje na hladnom';

  @override
  String get segmentCookingLineEquipment => 'Oprema kuhinjske linije';

  @override
  String get segmentWashupDishwash => 'Pranje posuđa';

  @override
  String get segmentCleaningSanitation => 'Čišćenje i sanitacija';

  @override
  String get segmentCleaningChemicals =>
      'Sredstva za čišćenje i potrošni materijal';

  @override
  String get segmentDryAmbientStorage =>
      'Suho i skladištenje na sobnoj temperaturi';

  @override
  String get segmentDeliveriesGoodsIn => 'Dostave i prijem robe';

  @override
  String get segmentUtilitiesSafety => 'Instalacije i sigurnost';

  @override
  String get segmentWastePestControl => 'Otpad i kontrola štetočina';

  @override
  String get segmentPreventiveMaintenance =>
      'Preventivno održavanje (kuhinjska oprema)';

  @override
  String get segmentStockControl => 'Kontrola zaliha';

  @override
  String get segmentOpeningProcedures => 'Postupci otvaranja';

  @override
  String get segmentClosingProcedures => 'Postupci zatvaranja';

  @override
  String get segmentServiceReadiness => 'Spremnost za uslugu';

  @override
  String get segmentFrontOfHouse => 'Sala / Usluživanje';

  @override
  String get segmentBarBeverage => 'Šank i pića';

  @override
  String get segmentHotelSpecific => 'Specifično za hotel';

  @override
  String get segmentManagementComplianceOversight =>
      'Upravljanje i nadzor usklađenosti';

  @override
  String get segmentMaintenance => 'Održavanje';

  @override
  String get segmentHousekeeping => 'Čišćenje';

  @override
  String get segmentReception => 'Recepcija';

  @override
  String get segmentSecurity => 'Zaštitarska služba';

  @override
  String get freqDaily => 'Dnevno';

  @override
  String get freqWeekly => 'Tjedno';

  @override
  String get freqPerShift => 'Po smjeni';

  @override
  String get freqThreeXDaily => '3x dnevno';

  @override
  String get freqTwoXDaily => '2x dnevno';

  @override
  String get freqPerBatch => 'Po seriji';

  @override
  String get freqPerDelivery => 'Po dostavi';

  @override
  String get freqPerUse => 'Po upotrebi';

  @override
  String get freqPerService => 'Po usluzi';

  @override
  String get freqTwoXPerService => '2x po usluzi';

  @override
  String get freqEventBased => 'Prema događaju';

  @override
  String get freqAsNeeded => 'Prema potrebi';

  @override
  String get freqMonthly => 'Mjesečno';

  @override
  String get freqCustom => 'Prilagođeno';

  @override
  String get jobRoleFieldLabel => 'Radna uloga';

  @override
  String get pinFieldLabel => 'PIN';

  @override
  String get addStaffMemberTitle => 'Dodaj zaposlenika';

  @override
  String get addLabel => 'Dodaj';

  @override
  String get assignTasksTitle => 'Dodijeli zadatke';

  @override
  String get noActiveSiteFoundError => 'Nije pronađena aktivna poslovnica.';

  @override
  String get byPersonLabel => 'Po osobi';

  @override
  String get byTaskLabel => 'Po zadatku';

  @override
  String get noEquipmentOfTypeSetUp => 'Još nema postavljene opreme ove vrste.';

  @override
  String get applyButton => 'Primijeni';

  @override
  String get assignToTitle => 'Dodijeli';

  @override
  String get noStaffMatchTiers =>
      'Nijedan zaposlenik ne odgovara razini(ama) na koje se ovi zadaci odnose.';

  @override
  String get assignButton => 'Dodijeli';

  @override
  String get showInstructionsTooltip => 'Prikaži upute';

  @override
  String get selectTasksToAssignLabel => 'Odaberi zadatke za dodjelu';

  @override
  String get taskPresetsSectionTitle => 'Skupovi zadataka';

  @override
  String get showAllPresetsButton => 'Prikaži sve skupove';

  @override
  String get showTasksInGroupTooltip => 'Prikaži zadatke u ovoj skupini';

  @override
  String get applyToMultipleButton => 'Primijeni na više njih';

  @override
  String get addCustomTaskButton => 'Dodaj prilagođeni zadatak';

  @override
  String get customTaskSectionTitle => 'Prilagođeni zadatak';

  @override
  String get titleFieldLabel => 'Naslov';

  @override
  String get departmentSectionLabel => 'Odjel / sekcija';

  @override
  String get methodLabel => 'Metoda';

  @override
  String get methodTick => 'Kvačica';

  @override
  String get methodData => 'Podaci';

  @override
  String get methodDataTick => 'Podaci + kvačica';

  @override
  String get methodTickPhoto => 'Kvačica + fotografija';

  @override
  String get methodDataPhoto => 'Podaci + fotografija';

  @override
  String get methodNote => 'Bilješka';

  @override
  String get methodDataNote => 'Podaci + bilješka';

  @override
  String get methodNotePhoto => 'Bilješka + fotografija';

  @override
  String get methodTickNote => 'Kvačica + bilješka';

  @override
  String get methodMulti => 'Višestruko';

  @override
  String get requiresPhotoLabel => 'Zahtijeva fotografiju';

  @override
  String get requiresNotesLabel => 'Zahtijeva bilješke';

  @override
  String get minLimitLabel => 'Minimalna granica';

  @override
  String get maxLimitLabel => 'Maksimalna granica';

  @override
  String get unitHintLabel => 'Jedinica (npr. Celzij)';

  @override
  String get equipmentTypeOptionalLabel => 'Vrsta opreme (neobavezno)';

  @override
  String get noneLabel => 'Nijedna';

  @override
  String get priorityLabel => 'Prioritet';

  @override
  String get priorityCritical => 'Kritično';

  @override
  String get priorityHigh => 'Visoko';

  @override
  String get priorityStandard => 'Standardno';

  @override
  String get requiresCorrectiveActionLabel =>
      'Zahtijeva korektivnu radnju u slučaju neuspjeha';

  @override
  String get fixInstructionsLabel => 'Upute za ispravak';

  @override
  String get customFieldsJsonLabel => 'Prilagođena polja (JSON, neobavezno)';

  @override
  String get extraFieldsSectionTitle => 'Dodatna polja (neobavezno)';

  @override
  String get removeTooltip => 'Ukloni';

  @override
  String get fieldLabelHint => 'Naziv polja (npr. broj narudžbe)';

  @override
  String get extraFieldTypeText => 'Tekst';

  @override
  String get extraFieldTypeNumber => 'Broj';

  @override
  String get extraFieldTypeDate => 'Datum';

  @override
  String get addFieldTooltip => 'Dodaj polje';

  @override
  String get saveCustomTaskButton => 'Spremi prilagođeni zadatak';

  @override
  String get adHocLabel => 'Prema potrebi';

  @override
  String get timeAllocatedLabel => 'Dodijeljeno vrijeme';

  @override
  String get frequencyPrefixLabel => 'Učestalost: ';

  @override
  String get atATimeLabel => 'U određeno vrijeme';

  @override
  String get fromStartOfShiftLabel => 'Od početka smjene';

  @override
  String get fromClockInLabel => 'Od prijave na posao';

  @override
  String get availableFromEllipsis => 'Dostupno od…';

  @override
  String get untilEllipsis => 'do…';

  @override
  String assignTasksForStaffTitle(String name) {
    return 'Dodijeli zadatke - $name';
  }

  @override
  String applyPresetToWhichOneTitle(String name) {
    return 'Primijeni \"$name\" na koji?';
  }

  @override
  String allPresetTasksAlreadyAssigned(String name) {
    return 'Svi zadaci \"$name\" već su dodijeljeni';
  }

  @override
  String addedTasksFromPreset(int count, String name) {
    return 'Dodano $count zadataka iz \"$name\"';
  }

  @override
  String applyPresetToTitle(String name) {
    return 'Primijeni \"$name\" na';
  }

  @override
  String assignTasksCountLabel(int count) {
    return 'Dodijeli $count zadataka osoblju…';
  }

  @override
  String addedTasksAcrossStaffLabel(int count, int staffCount) {
    return 'Dodano $count dodjela za $staffCount zaposlenika';
  }

  @override
  String presetSectionPrefix(String segment) {
    return 'Odjeljak: $segment';
  }

  @override
  String taskCountLabel(int count) {
    return '$count zadataka';
  }

  @override
  String showAllRolesLabel(String jobRole) {
    return 'Prikaži sve uloge (zadano: samo $jobRole)';
  }

  @override
  String extraFieldSummary(String label, String type) {
    return '$label ($type)';
  }

  @override
  String noEquipmentSetUpForTemplate(String title) {
    return '$title - za ovo još nije postavljena oprema';
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
    return 'Stvoreno $count dodjela$skippedNote.';
  }

  @override
  String skippedNoteLabel(int count) {
    return ' (preskočeno $count - već dodijeljeno ili neusklađena uloga)';
  }

  @override
  String get serviceProvidersTitle => 'Pružatelji usluga';

  @override
  String get myProvidersTab => 'Moji pružatelji';

  @override
  String get findProviderTab => 'Pronađi pružatelja';

  @override
  String get noBackendProviderNotice1 =>
      'Pregledavanje pružatelja koje su podijelile druge poslovnice zahtijeva prijavljen pravi poslovni račun - to ne može raditi samo s lokalnom demo prijavom. Tvoji vlastiti kontakti pod \"Moji pružatelji\" rade u oba slučaja.';

  @override
  String get noBackendProviderNotice2 =>
      'Prijavi se putem Pristupa uprave s pravim poslovnim računom da bi ovo koristio/koristila.';

  @override
  String get providerDisclaimerText =>
      'VenuRite ne provjerava niti podržava nijednog navedenog pružatelja. Recenzije dolaze od drugih poslovnica, ne od VenuRitea.';

  @override
  String get addProviderButton => 'Dodaj pružatelja';

  @override
  String get noProvidersYetText =>
      'Još nisi dodao/dodala nijednog pružatelja usluga.';

  @override
  String get addServiceProviderDialogTitle => 'Dodaj pružatelja usluga';

  @override
  String get categoryLabel => 'Kategorija';

  @override
  String get phoneOptionalLabel => 'Telefon (neobavezno)';

  @override
  String get emailOptionalLabel => 'E-pošta (neobavezno)';

  @override
  String get notesOptionalPrivateLabel =>
      'Bilješke (neobavezno, privatno za tebe)';

  @override
  String get happyToReviewShareLabel => 'Rado ću ocijeniti i podijeliti';

  @override
  String get shareVisibilityExplanation =>
      'Druge poslovnice vidjet će tvoje ocjene i recenzije, s imenom/kontaktom zamagljenim dok ih ne otključaju.';

  @override
  String get rateThisProviderLabel => 'Ocijeni ovog pružatelja';

  @override
  String get priceRatingLabel => 'Cijena';

  @override
  String get punctualityRatingLabel => 'Točnost';

  @override
  String get qualityRatingLabel => 'Kvaliteta';

  @override
  String get availabilityRatingLabel => 'Dostupnost';

  @override
  String get reviewOptionalLabel => 'Recenzija (neobavezno)';

  @override
  String get reviewHintText =>
      'Opiši svoje iskustvo - molimo nemoj navoditi naziv tvrtke ili kontakt podatke.';

  @override
  String get sessionExpiredMessage =>
      'Tvoja sesija je istekla - prijavi se ponovno.';

  @override
  String get sharedWithOtherVenuesLabel => 'Podijeljeno s drugim poslovnicama';

  @override
  String get privateLabel => 'Privatno';

  @override
  String get rateReviewsButton => 'Ocijeni / Recenzije';

  @override
  String get searchByCategoryOrNameHint => 'Pretraži po kategoriji ili nazivu';

  @override
  String get noContactsUnlockedThisMonth =>
      'Ovaj mjesec još nema otključanih kontakata.';

  @override
  String get noSharedProvidersYetText =>
      'Još nema podijeljenih pružatelja - budi prvi koji će podijeliti jednog iz \"Moji pružatelji.\"';

  @override
  String get noProvidersMatchSearchText =>
      'Nijedan pružatelj ne odgovara tvojoj pretrazi.';

  @override
  String get noRatingsYetText => 'Još nema ocjena';

  @override
  String get hiddenUntilUnlockedText => 'Skriveno do otključavanja';

  @override
  String get unnamedPlaceholder => '(bez naziva)';

  @override
  String get readReviewsButton => 'Pročitaj recenzije';

  @override
  String get unlockContactDetailsButton => 'Otključaj kontakt podatke';

  @override
  String get reviewsTitle => 'Recenzije';

  @override
  String get noReviewsYetText => 'Još nema recenzija.';

  @override
  String get addYourRatingLabel => 'Dodaj svoju ocjenu';

  @override
  String get submittingEllipsis => 'Slanje...';

  @override
  String get submitRatingButton => 'Pošalji ocjenu';

  @override
  String reviewContainsInfoWarningShort(String found) {
    return 'Čini se da tvoja recenzija sadrži $found. Ukloni kontakt podatke ili nazive tvrtki prije slanja.';
  }

  @override
  String reviewContainsInfoWarningLong(String found) {
    return 'Čini se da tvoja recenzija sadrži $found. Ukloni kontakt podatke ili nazive tvrtki prije slanja - recenzije ostaju korisne (i poštene) kad opisuju iskustvo, a ne koga izravno nazvati.';
  }

  @override
  String contactsUnlockedThisMonth(int count) {
    return 'Ovaj mjesec otključano $count kontakata.';
  }

  @override
  String priceValueLabel(String value) {
    return 'Cijena $value';
  }

  @override
  String punctualityValueLabel(String value) {
    return 'Točnost $value';
  }

  @override
  String qualityValueLabel(String value) {
    return 'Kvaliteta $value';
  }

  @override
  String availabilityValueLabel(String value) {
    return 'Dostupnost $value';
  }

  @override
  String ratingReviewCountSuffix(String parts, int count) {
    return '$parts ($count recenzija)';
  }

  @override
  String reviewRatingsLine(
    int price,
    int punctuality,
    int quality,
    int availability,
  ) {
    return 'Cijena $price - Točnost $punctuality - Kvaliteta $quality - Dostupnost $availability';
  }

  @override
  String phonePrefixLabel(String value) {
    return 'Telefon: $value';
  }

  @override
  String emailPrefixLabel(String value) {
    return 'E-pošta: $value';
  }

  @override
  String get supplierCategoryFreshProduce => 'Svježi proizvodi';

  @override
  String get supplierCategoryMeatPoultry => 'Meso i perad';

  @override
  String get supplierCategoryDairyEggs => 'Mliječni proizvodi i jaja';

  @override
  String get supplierCategoryFrozenGoods => 'Smrznuta roba';

  @override
  String get supplierCategoryDryAmbientGoods =>
      'Suha roba i roba na sobnoj temperaturi';

  @override
  String get supplierCategoryDrinksBeverages => 'Pića';

  @override
  String get supplierCategoryChemicalsCleaningSupplies =>
      'Kemikalije i sredstva za čišćenje';

  @override
  String get supplierCategoryEquipmentMaintenance => 'Oprema i održavanje';

  @override
  String get supplierCategoryOther => 'Ostalo';

  @override
  String get supplierStatusApproved => 'Odobreno';

  @override
  String get supplierStatusPending => 'Na čekanju';

  @override
  String get supplierStatusSuspended => 'Suspendirano';

  @override
  String get addEquipmentTitle => 'Dodaj opremu';

  @override
  String get venueSetupTitle => 'Postavljanje poslovnice';

  @override
  String get nextButton => 'Dalje';

  @override
  String get finishSetupButton => 'Završi postavljanje';

  @override
  String get renameAreaTitle => 'Preimenuj područje';

  @override
  String get renameEquipmentTitle => 'Preimenuj opremu';

  @override
  String get saveButton => 'Spremi';

  @override
  String get retireEquipmentTitle => 'Povuci opremu iz upotrebe';

  @override
  String get retireEquipmentConfirmText =>
      'Povlačenje ove opreme također će poništiti dodjelu svih zadataka trenutno dodijeljenih njoj. Prošla povijest podnošenja se čuva. Nastaviti?';

  @override
  String get retireButton => 'Povuci iz upotrebe';

  @override
  String get areasStepTitle => 'Područja';

  @override
  String get areasStepIntro => 'Dodaj operativna područja ove poslovnice.';

  @override
  String get areaSuggestionKitchen => 'Kuhinja';

  @override
  String get areaSuggestionStorage => 'Skladište';

  @override
  String get areaSuggestionReceiving => 'Prijem robe';

  @override
  String get areaSuggestionFrontOfHouse => 'Sala';

  @override
  String get areaNameLabel => 'Naziv područja';

  @override
  String get addAreaTooltip => 'Dodaj područje';

  @override
  String get renameTooltip => 'Preimenuj';

  @override
  String get equipmentStepTitle => 'Oprema';

  @override
  String get equipmentStepIntro =>
      'Dodaj imenovane primjerke opreme, npr. \"Hladnjak 1\", \"Hladnjak 2\".';

  @override
  String get showAllEquipmentTypesButton => 'Prikaži sve vrste opreme';

  @override
  String get equipmentTypeLabel => 'Vrsta opreme';

  @override
  String get somethingElseOption => 'Nešto drugo...';

  @override
  String get newEquipmentTypeNameLabel => 'Naziv nove vrste opreme';

  @override
  String get confirmNewEquipmentTypeTooltip => 'Potvrdi novu vrstu opreme';

  @override
  String get noAreasForDeptText =>
      'Za tvoj odjel još nema postavljenih područja - oprema se ipak može dodati bez njega.';

  @override
  String get noAreasAddOneText =>
      'Još nije dodano nijedno područje - vrati se da bi dodao/dodala jedno.';

  @override
  String get equipmentNameLabel => 'Naziv opreme';

  @override
  String get equipmentNameHint =>
      'npr. Rashladna komora za meso, Hladnjak za deserte, Friteza za šank';

  @override
  String get modelOptionalLabel => 'Model (neobavezno)';

  @override
  String get serialNumberOptionalLabel => 'Serijski broj (neobavezno)';

  @override
  String get retireTooltip => 'Povuci iz upotrebe';

  @override
  String get reactivateTooltip => 'Ponovno aktiviraj';

  @override
  String get unknownTypeLabel => 'Nepoznata vrsta';

  @override
  String get unknownAreaLabel => 'Nepoznato područje';

  @override
  String get staffStepTitle => 'Osoblje';

  @override
  String get staffStepIntro =>
      'Dodaj članove osoblja i dodijeli im razinu uloge.';

  @override
  String get addStaffMemberButton => 'Dodaj člana osoblja';

  @override
  String get suppliersStepTitle => 'Dobavljači';

  @override
  String get suppliersStepIntro =>
      'Dodaj dobavljače s kojima ova poslovnica surađuje. Oznake odobrenja pojavljuju se u EHO izvozu - suspendirani dobavljači prikazuju se voditeljima, ne skrivaju se tiho.';

  @override
  String get supplierNameLabel => 'Naziv dobavljača';

  @override
  String get contactOptionalLabel => 'Kontakt (neobavezno)';

  @override
  String get phoneOrEmailHint => 'Telefon ili e-pošta';

  @override
  String get approvalStatusLabel => 'Status odobrenja';

  @override
  String get addSupplierButton => 'Dodaj dobavljača';

  @override
  String venueSetupStepTitle(int step) {
    return 'Postavljanje poslovnice - Korak $step od 4';
  }

  @override
  String modelPrefixLabel(String value) {
    return 'Model: $value';
  }

  @override
  String serialPrefixLabel(String value) {
    return 'Serijski br.: $value';
  }

  @override
  String retiredSuffixLabel(String name) {
    return '$name (povučeno)';
  }

  @override
  String get addEquipmentTooltip => 'Dodaj opremu';

  @override
  String get newPinLabel => 'Novi PIN';

  @override
  String get editDetailsTitle => 'Uredi podatke';

  @override
  String get sectionLabel => 'Odjel';

  @override
  String get noSectionOption => 'Bez odjela';

  @override
  String get inactiveParenSuffix => ' (neaktivan)';

  @override
  String get noSpecificTeamOption => 'Bez određenog tima';

  @override
  String get noSectionsSetupText =>
      'Za ovu poslovnicu još nema postavljenih odjela - prvo dodaj jedan u Upravljanju odjelima.';

  @override
  String get reportsToFieldLabel => 'Izvještava se';

  @override
  String get notSetOption => 'Nije postavljeno';

  @override
  String get deactivateStaffMemberTitle => 'Deaktiviraj zaposlenika';

  @override
  String get staffManagementTitle => 'Upravljanje osobljem';

  @override
  String get addStaffTooltip => 'Dodaj osoblje';

  @override
  String get bulkImportTooltip => 'Skupni uvoz';

  @override
  String get deactivatedSuffixLabel => '(deaktiviran)';

  @override
  String get moreActionsTooltip => 'Više radnji';

  @override
  String get changeTierMenuItem => 'Promijeni razinu';

  @override
  String get changeSectionMenuItem => 'Promijeni odjel';

  @override
  String get assignSupervisionMenuItem => 'Dodijeli nadzor';

  @override
  String get reportsToMenuItem => 'Izvještava se';

  @override
  String get resetPinMenuItem => 'Resetiraj PIN';

  @override
  String get trainingRecordsMenuItem => 'Evidencija osposobljavanja';

  @override
  String unknownUserIdFallback(String id) {
    return 'korisnik #$id';
  }

  @override
  String resetPinForUserTitle(String name) {
    return 'Resetiraj PIN - $name';
  }

  @override
  String pinResetForUserMessage(String name) {
    return 'PIN resetiran za $name';
  }

  @override
  String changeRoleTierTitle(String name) {
    return 'Promijeni razinu uloge - $name';
  }

  @override
  String changeSectionTitle(String name) {
    return 'Promijeni odjel - $name';
  }

  @override
  String assignSupervisionTitle(String name) {
    return 'Dodijeli nadzor - $name';
  }

  @override
  String supervisionScopeUpdatedMessage(String name) {
    return 'Opseg nadzora ažuriran za $name';
  }

  @override
  String reportsToTitle(String name) {
    return 'Izvještava se - $name';
  }

  @override
  String deactivateStaffConfirmText(String name) {
    return '$name se više neće moći prijaviti. Njihove aktivne dodjele zadataka bit će poništene. Njihova povijest podnošenja nije pogođena. Ovo se kasnije može poništiti.';
  }

  @override
  String reportsToSubtitle(String name) {
    return 'Izvještava se $name';
  }

  @override
  String deactivatedOnByLabel(String date, String name) {
    return '$date od strane $name';
  }

  @override
  String get darkModeLabel => 'Tamni način';

  @override
  String get brandIdentityIntro =>
      'Jedan identitet marke, zajednički za cijelu tvrtku - primjenjuje se na svaku poslovnicu, ne po poslovnici.';

  @override
  String get companyNameLabel => 'Naziv tvrtke';

  @override
  String get companyLogoLabel => 'Logo tvrtke';

  @override
  String get chooseLogoButton => 'Odaberi logo';

  @override
  String get changeLogoButton => 'Promijeni logo';

  @override
  String get brandColourLabel => 'Boja marke';

  @override
  String get customHexColourLabel => 'Prilagođena hex boja';

  @override
  String get enterValidHexColourError => 'Unesi valjanu hex boju';

  @override
  String get contactPhoneLabel => 'Kontakt telefon';

  @override
  String get contactEmailLabel => 'Kontakt e-pošta';

  @override
  String get savingEllipsisLabel => 'Spremanje...';

  @override
  String get saveBrandingButton => 'Spremi identitet marke';

  @override
  String get brandingSavedMessage => 'Identitet marke spremljen';

  @override
  String get customSwatchTooltip => 'Prilagođeno';

  @override
  String get rosterAddonTitle =>
      'Smjene osoblja / raspored (+6-10 GBP/poslovnici/mjesečno)';

  @override
  String get rosterAddonSubtitle =>
      'Dopusti osoblju da samo vidi i preuzme otvorene smjene - voditelj objavljuje smjene, osoblje ih preuzima. 6 GBP/mjesečno po poslovnici s manje od 10 zaposlenika, 10 GBP/mjesečno za 10 ili više.';

  @override
  String get enableRosterTitle => 'Omogućiti raspored?';

  @override
  String get confirmButton => 'Potvrdi';

  @override
  String get clearDemoDataTitle => 'Očistiti demo podatke?';

  @override
  String get clearDemoDataConfirmText =>
      'Ovo trajno briše svakog demo zaposlenika, poslovnicu i odjel, te te odjavljuje. Ovo se ne može poništiti.';

  @override
  String get clearEverythingButton => 'Očisti sve';

  @override
  String get clearDemoDataCardTitle => 'Očisti demo podatke';

  @override
  String get clearDemoDataCardBody =>
      'Ukloni svakog demo zaposlenika, poslovnicu i odjel kako bi mogao/mogla postaviti svoje od nule.';

  @override
  String get clearDemoDataButton => 'Očisti demo podatke';

  @override
  String get temperatureUnitLabel => 'Jedinica temperature';

  @override
  String get celsiusLabel => 'Celzij (°C)';

  @override
  String get fahrenheitLabel => 'Fahrenheit (°F)';

  @override
  String get comingSoonLabel => 'Uskoro';

  @override
  String get presetColorOceanTeal => 'Oceanska tirkizna';

  @override
  String get presetColorNavy => 'Mornarsko plava';

  @override
  String get presetColorIndigo => 'Indigo';

  @override
  String get presetColorSlate => 'Škriljevac';

  @override
  String get presetColorPlum => 'Šljiva';

  @override
  String get presetColorForest => 'Šumsko zelena';

  @override
  String get presetColorUmber => 'Umbra';

  @override
  String get presetColorCharcoal => 'Antracit';

  @override
  String couldNotGetPriceError(String error) {
    return 'Nije moguće dobiti cijenu: $error';
  }

  @override
  String enableRosterConfirmText(String amount) {
    return 'Na temelju tvog trenutnog broja zaposlenika, ovo će dodati $amount tvom mjesečnom izravnom terećenju.';
  }

  @override
  String get departmentLabel => 'Odjel';

  @override
  String get noDepartmentOption => 'Bez odjela';

  @override
  String get removeAnywayButton => 'Ukloni ipak';

  @override
  String get branchTeamStructureTitle => 'Struktura tima poslovnice';

  @override
  String get noStaffAtBranchText => 'Još nema osoblja u ovoj poslovnici.';

  @override
  String get changeManagerMenuItem => 'Promijeni voditelja';

  @override
  String get moveDepartmentMenuItem => 'Premjesti odjel/tim';

  @override
  String get editJobTitleMenuItem => 'Uredi radno mjesto';

  @override
  String get removeFromBranchMenuItem => 'Ukloni iz ove poslovnice';

  @override
  String changeManagerTitle(String name) {
    return 'Promijeni voditelja - $name';
  }

  @override
  String moveDepartmentTitle(String name) {
    return 'Premjesti odjel/tim - $name';
  }

  @override
  String changeTierTitle2(String name) {
    return 'Promijeni razinu - $name';
  }

  @override
  String editJobTitleTitle(String name) {
    return 'Uredi radno mjesto - $name';
  }

  @override
  String removeFromBranchTitle(String name) {
    return 'Ukloni $name iz ove poslovnice';
  }

  @override
  String removeFromBranchConfirmText(String name) {
    return '$name se više neće moći prijaviti. Ovo se kasnije može poništiti.';
  }

  @override
  String reportsWillBeUnassignedText(int count, String name, String names) {
    return 'Trenutno se $count osoba izvještava $name: $names. Uklanjanje $name ostavit će ih nedodijeljenima dok se ponovno ne dodijele.';
  }

  @override
  String reassignToManagerLabel(String name) {
    return 'Umjesto toga, ponovno ih dodijeli $name vlastitom voditelju';
  }

  @override
  String reportsCountBadge(int count) {
    return '$count podređenih';
  }

  @override
  String get regionalManagerAssignedTitle => 'Regionalni voditelj dodijeljen';

  @override
  String get noOrganisationOnSessionError => 'Nema tvrtke u ovoj sesiji.';

  @override
  String get newRegionNameTitle => 'Naziv nove regije';

  @override
  String get renameRegionTitle => 'Preimenuj regiju';

  @override
  String get renameVenueTitle => 'Preimenuj poslovnicu';

  @override
  String get newVenueNameTitle => 'Naziv nove poslovnice';

  @override
  String get doneButton => 'Gotovo';

  @override
  String get resetPasswordQuestionTitle => 'Resetirati lozinku?';

  @override
  String get resetButton => 'Resetiraj';

  @override
  String get passwordResetTitle => 'Lozinka resetirana';

  @override
  String get giveNewTempPasswordText =>
      'Daj ovoj osobi njezinu novu privremenu lozinku.';

  @override
  String get organisationTitle => 'Tvrtka';

  @override
  String get headOfficeLabel => 'Sjedište';

  @override
  String get addRegionMenuItem => 'Dodaj regiju';

  @override
  String get addVenueNoRegionMenuItem => 'Dodaj poslovnicu (bez regije)';

  @override
  String get venuesNoRegionLabel => 'Poslovnice (bez regije)';

  @override
  String get resetPasswordTooltip => 'Resetiraj lozinku';

  @override
  String get addVenueMenuItem => 'Dodaj poslovnicu';

  @override
  String get assignRegionalManagerMenuItem => 'Dodijeli regionalnog voditelja';

  @override
  String get reassignRegionalManagerMenuItem =>
      'Ponovno dodijeli regionalnog voditelja';

  @override
  String get noRegionalManagerYetText => 'Još nema regionalnog voditelja';

  @override
  String get noVenuesInRegionText => 'Još nema poslovnica u ovoj regiji.';

  @override
  String get noVenueManagerYetText => 'Još nema voditelja poslovnice';

  @override
  String assignRegionalManagerTitle(String region) {
    return 'Dodijeli regionalnog voditelja - $region';
  }

  @override
  String accountLiveGiveSignInDetails(String name) {
    return 'Račun je sada aktivan. Daj $name podatke za prijavu - koriste Pristup uprave.';
  }

  @override
  String emailColonLabel(String email) {
    return 'E-pošta: $email';
  }

  @override
  String temporaryPasswordColonLabel(String password) {
    return 'Privremena lozinka: $password';
  }

  @override
  String resetPasswordConfirmText(String name) {
    return 'Ovo odmah poništava trenutnu lozinku korisnika $name. Dobit ćeš novu privremenu lozinku za proslijediti.';
  }

  @override
  String venueManagerSuffixLabel(String name) {
    return '$name  ·  Voditelj poslovnice';
  }

  @override
  String get noSignedInUserError => 'Nije pronađen prijavljeni korisnik.';

  @override
  String get customCategoryTitleLabel => 'Prilagođeni naziv kategorije';

  @override
  String get approvalNoteLabel =>
      'Bilješka o odobrenju / dubinskoj analizi (neobavezno)';

  @override
  String get supplierManagementTitle => 'Upravljanje dobavljačima';

  @override
  String get noSuppliersAddedYetText => 'Još nema dodanih dobavljača.';

  @override
  String get inactiveStandaloneLabel => '(neaktivan)';

  @override
  String get changeApprovalStatusMenuItem => 'Promijeni status odobrenja';

  @override
  String editDetailsForSupplierTitle(String name) {
    return 'Uredi podatke - $name';
  }

  @override
  String changeApprovalStatusTitle(String name) {
    return 'Promijeni status odobrenja - $name';
  }

  @override
  String get newVenueTypeTitle => 'Nova vrsta poslovnice';

  @override
  String get renameOrganisationTitle => 'Preimenuj tvrtku';

  @override
  String get resetSetupCodeTitle => 'Resetirati kod postavljanja?';

  @override
  String get resetSetupCodeConfirmText =>
      'Ovo će odspojiti svaki tablet koji trenutno koristi ovu poslovnicu dok mu se ne da novi kod. Nastaviti?';

  @override
  String get resetCodeButton => 'Resetiraj kod';

  @override
  String get createNewVenueTitle => 'Stvori novu poslovnicu';

  @override
  String get multiSiteSupportPartialText =>
      'Podrška za više poslovnica je djelomična: oprema, osoblje i popisi zadataka još nisu filtrirani po poslovnici, pa svakodnevno korištenje druge poslovnice još nije u potpunosti podržano. Stvaranje jedne je sigurno, ali ćeš vidjeti podatke ove poslovnice i izvorne poslovnice pomiješane na zajedničkim popisima dok se to ne izgradi.';

  @override
  String get createButton => 'Stvori';

  @override
  String get venueDetailsTitle => 'Detalji poslovnice';

  @override
  String get billingLabel => 'Naplata';

  @override
  String get billingSubtitleText => 'Plan, status, izravno terećenje';

  @override
  String get activeLabel => 'Aktivno';

  @override
  String get setAsActiveButton => 'Postavi kao aktivno';

  @override
  String get tabletSetupCodeTitle => 'Kod postavljanja tableta';

  @override
  String get tabletSetupCodeExplanation =>
      'Unesi ovo jednom na novom tabletu kako bi mogao prikazati popis osoblja ove poslovnice.';

  @override
  String get generateCodeButton => 'Generiraj kod';

  @override
  String get venueTypeSectionTitle => 'Vrsta poslovnice';

  @override
  String get renamePresetTitle => 'Preimenuj predložak';

  @override
  String get noTaskTemplatesExistYetText =>
      'Još ne postoje predlošci zadataka.';

  @override
  String get addTaskToPresetTitle => 'Dodaj zadatak u predložak';

  @override
  String get taskFieldLabel => 'Zadatak';

  @override
  String get defaultFrequencyLabel => 'Zadana učestalost';

  @override
  String get noPresetsYetText => 'Još nema predložaka.';

  @override
  String get createPresetButton => 'Stvori predložak';

  @override
  String get presetVerificationBannerText =>
      'Ograničenja zadataka su istražena i dokumentirana (označena s [LAW]/[FSA]/[BEST] u uputama svakog zadatka), ali ih još nije odobrio kvalificirani stručnjak za sigurnost hrane. Ne tretiraj ih kao pravno mjerodavne dok se ne provjere.';

  @override
  String get equipmentPresetsSectionTitle => 'Predlošci opreme';

  @override
  String get sectionPresetsSectionTitle => 'Predlošci odjela';

  @override
  String get addTaskButton => 'Dodaj zadatak';

  @override
  String get newPresetSectionTitle => 'Novi predložak';

  @override
  String get sectionSegmentOptionalLabel => 'Odjel / segment (neobavezno)';

  @override
  String get setEquipmentOrSectionHint =>
      'Postavi vrstu opreme ili odjel (barem jedno).';

  @override
  String equipmentTypeFallback(String id) {
    return 'Vrsta opreme #$id';
  }

  @override
  String taskFallback(String id) {
    return 'Zadatak #$id';
  }

  @override
  String get departmentCategoryKitchen => 'Kuhinja';

  @override
  String get departmentCategoryFrontOfHouse => 'Sala';

  @override
  String get departmentCategoryBar => 'Šank';

  @override
  String get departmentCategoryManagement => 'Uprava';

  @override
  String get departmentCategoryMaintenance => 'Održavanje';

  @override
  String get departmentCategoryHousekeeping => 'Čišćenje';

  @override
  String get departmentCategoryReception => 'Recepcija';

  @override
  String get departmentCategorySecurity => 'Zaštitarska služba';

  @override
  String get addDepartmentButton => 'Dodaj odjel';

  @override
  String get departmentManagementTitle => 'Upravljanje odjelima';

  @override
  String get noDepartmentsAddedYetText => 'Još nema dodanih odjela.';

  @override
  String get noTeamsYetText => 'Još nema timova';

  @override
  String get editMenuItem => 'Uredi';

  @override
  String get addTeamButton => 'Dodaj tim';

  @override
  String editDepartmentTitle(String name) {
    return 'Uredi - $name';
  }

  @override
  String addTeamTitle(String name) {
    return 'Dodaj tim - $name';
  }

  @override
  String renameTeamTitle(String name) {
    return 'Preimenuj - $name';
  }

  @override
  String teamCountLabel(int count) {
    return '$count timova';
  }

  @override
  String get documentCategoryPolicy => 'Politika';

  @override
  String get documentCategoryCertificate => 'Certifikat';

  @override
  String get documentCategoryProcedure => 'Postupak';

  @override
  String get documentCategoryEhoReport => 'EHO izvještaj';

  @override
  String get addDocumentTitle => 'Dodaj dokument';

  @override
  String get noExpiryDateText => 'Bez datuma isteka';

  @override
  String get setExpiryButton => 'Postavi istek';

  @override
  String get couldNotOpenFileText => 'Nije moguće otvoriti ovu datoteku.';

  @override
  String get documentCentreTitle => 'Centar za dokumente';

  @override
  String get validLabel => 'Vrijedi';

  @override
  String get expiringSoonLabel => 'Uskoro istječe';

  @override
  String get expiredLabel => 'Istekao';

  @override
  String get allFilterLabel => 'Sve';

  @override
  String get noDocumentsYetText => 'Još nema dokumenata.';

  @override
  String get openMenuItem => 'Otvori';

  @override
  String expiresOnLabel(String date) {
    return 'Istječe $date';
  }

  @override
  String get planFriends => 'Friends';

  @override
  String get planStandard => 'Standard';

  @override
  String get planPremier => 'Premier';

  @override
  String get noPlanSelectedText => 'Nije odabran plan';

  @override
  String get codeNotRecognisedText => 'Taj kod nije prepoznat.';

  @override
  String get couldNotReachServerText => 'Nije moguće doći do poslužitelja.';

  @override
  String get discountAppliedText => 'Kod za popust primijenjen.';

  @override
  String get couldNotOpenBrowserText => 'Nije moguće otvoriti preglednik';

  @override
  String get noSubscriptionFoundText =>
      'Nije pronađena pretplata za ovu tvrtku.';

  @override
  String get discountAppliedBadge => 'Popust primijenjen';

  @override
  String get directDebitSetUpText =>
      'Izravno terećenje postavljeno je za ovu tvrtku.';

  @override
  String get directDebitNotSetUpText =>
      'Još nisi postavio/postavila izravno terećenje. Bit ćeš odveden/odvedena na GoCardless - VenuRite nikada izravno ne vidi tvoje bankovne podatke.';

  @override
  String get discountCodeOptionalLabel => 'Kod za popust (neobavezno)';

  @override
  String get discountCodeHintText => 'Imaš \'Friends\' kod? Unesi ga ovdje';

  @override
  String get setUpDirectDebitButton => 'Postavi izravno terećenje';

  @override
  String get freeAccessCodeTitle => 'Kod za besplatan pristup';

  @override
  String get freeAccessActiveText =>
      'Besplatan pristup je aktivan za ovu tvrtku - izravno terećenje ili plaćanje karticom nije potrebno.';

  @override
  String get freeAccessPromptText =>
      'Imaš kod za besplatan pristup? Unesi ga ovdje da koristiš cijelu aplikaciju bez postavljanja plaćanja.';

  @override
  String get redeemCodeButton => 'Iskoristi kod';

  @override
  String get onTrialText => 'Na probnom razdoblju';

  @override
  String get paymentFailedGraceText =>
      'Nedavno plaćanje nije uspjelo. Ažuriraj svoje izravno terećenje - pristup se nastavlja tijekom ovog razdoblja odgode.';

  @override
  String get directDebitCancelledRestrictedText =>
      'Tvoje izravno terećenje je otkazano. Pristup je ograničen na samo čitanje dok se naplata ponovno ne postavi.';

  @override
  String get paymentOverdueRestrictedText =>
      'Plaćanje kasni predugo. Pristup je ograničen na samo čitanje dok se to ne riješi.';

  @override
  String couldNotLoadBillingDetailsError(String error) {
    return 'Nije moguće učitati podatke o naplati: $error';
  }

  @override
  String pricePerMonthBilledLabel(String price, int units) {
    return '$price GBP/mjesečno (naplaćeno $units poslovnica)';
  }

  @override
  String onTrialUntilText(String date) {
    return 'Na probnom razdoblju do $date';
  }

  @override
  String get reportedIssuesTitle => 'Prijavljeni problemi';

  @override
  String get noDeliveriesLoggedText =>
      'U ovom razdoblju nema evidentiranih dostava za ovog dobavljača.';

  @override
  String get scorecardCategoriesExplanation =>
      'Svaka kategorija u nastavku broji se neovisno - dostava se može pojaviti u više od jednog retka (npr. kasna I oštećena).';

  @override
  String get rejectedOutrightLabel => 'U potpunosti odbijeno';

  @override
  String get acceptedPartiallyLabel => 'Djelomično prihvaćeno';

  @override
  String get reportedIssuesExplanation =>
      'Problemi s opskrbom prijavljeni protiv ovog dobavljača - zaseban zapis od gornje kartice ocjena dostave, nije spojen s njom.';

  @override
  String deliveryScorecardTitle(int count) {
    return 'Kartica ocjena dostave ($count dostava)';
  }

  @override
  String countPercentLabel(int count, int rate) {
    return '$count ($rate%)';
  }

  @override
  String get missingNameError => 'Nedostaje ime';

  @override
  String get missingJobTitleError => 'Nedostaje radno mjesto';

  @override
  String get pinMustBe4DigitsError =>
      'PIN mora imati točno 4 znamenke (ili ostati prazan)';

  @override
  String get bulkStaffImportTitle => 'Skupni uvoz osoblja';

  @override
  String get csvColumnsInstructionsText =>
      'CSV stupci: ime, radno mjesto, razina uloge, radna uloga (neobavezno), PIN (neobavezno). Redak zaglavlja je u redu - automatski se otkriva. Ostavi PIN prazan da bude generiran umjesto tebe.';

  @override
  String get chooseCsvFileButton => 'Odaberi CSV datoteku';

  @override
  String get chooseDifferentFileButton => 'Odaberi drugu datoteku';

  @override
  String get noteDownPinsText =>
      ' Zabilježi svaki PIN u nastavku prije napuštanja ovog zaslona.';

  @override
  String get importingEllipsisLabel => 'Uvoženje...';

  @override
  String roleTierMustBeOneOfError(String list) {
    return 'Razina uloge mora biti jedna od: $list';
  }

  @override
  String notAllowedToCreateTierError(String tier) {
    return 'Nije ti dopušteno stvoriti $tier račun';
  }

  @override
  String jobRoleMustBeOneOfError(String list) {
    return 'Radna uloga mora biti jedna od: $list';
  }

  @override
  String csvExampleText(String example) {
    return 'Primjer: $example';
  }

  @override
  String rowsFoundLabel(String fileName, int count) {
    return '$fileName - pronađeno $count redaka';
  }

  @override
  String needFixingSuffix(int count) {
    return ', $count treba ispraviti';
  }

  @override
  String createdCountLabel(int count) {
    return 'Stvoreno $count';
  }

  @override
  String failedSuffixLabel(int count) {
    return ', $count neuspješno';
  }

  @override
  String importStaffCountButton(int count) {
    return 'Uvezi $count zaposlenika';
  }

  @override
  String rowNumberFallback(int number) {
    return 'Redak $number';
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
      'Razina 2 higijene i sigurnosti hrane';

  @override
  String get trainingAllergenAwareness => 'Svijest o alergenima';

  @override
  String get trainingCoshh => 'COSHH (kontrola tvari opasnih za zdravlje)';

  @override
  String get trainingFireSafety => 'Sigurnost od požara';

  @override
  String get trainingManualHandling => 'Ručno rukovanje';

  @override
  String get trainingFirstAid => 'Prva pomoć na radu';

  @override
  String get trainingInduction => 'Uvođenje dovršeno';

  @override
  String get itemFieldLabel => 'Stavka';

  @override
  String get customItemTitleLabel => 'Prilagođeni naziv stavke';

  @override
  String get expiryNoneLabel => 'Istek: nema';

  @override
  String get clearExpiryTooltip => 'Ukloni istek';

  @override
  String get certificateReferenceLabel => 'Referenca certifikata (neobavezno)';

  @override
  String get certificateReferenceHint => 'npr. broj certifikata, pružatelj';

  @override
  String get noTrainingRecordsYetText => 'Još nema evidencije osposobljavanja.';

  @override
  String get addRecordButton => 'Dodaj zapis';

  @override
  String get currentLabel => 'Trenutačno';

  @override
  String get supersededLabel => '(zamijenjeno)';

  @override
  String get noExpiryLabel => 'Bez isteka';

  @override
  String addTrainingRecordTitle(String name) {
    return 'Dodaj zapis o osposobljavanju - $name';
  }

  @override
  String completedOnLabel(String date) {
    return 'Dovršeno: $date';
  }

  @override
  String expiryOnLabel(String date) {
    return 'Istek: $date';
  }

  @override
  String trainingRecordsTitle(String name) {
    return 'Evidencija osposobljavanja - $name';
  }

  @override
  String fullHistoryLabel(int count) {
    return 'Puna povijest ($count ranijih zapisa)';
  }

  @override
  String completedDateLabel(String date) {
    return 'Dovršeno $date';
  }

  @override
  String certRefLabel(String ref) {
    return 'Ref.: $ref';
  }

  @override
  String get twoFactorNowOnText =>
      'Dvofaktorska autentifikacija sada je uključena.';

  @override
  String get turnOffTwoFactorTitle =>
      'Isključiti dvofaktorsku autentifikaciju?';

  @override
  String get turnOffTwoFactorConfirmText =>
      'Ovaj račun će se ponovno prijavljivati samo lozinkom.';

  @override
  String get turnOffButton => 'Isključi';

  @override
  String get twoFactorAuthTitle => 'Dvofaktorska autentifikacija';

  @override
  String get twoFactorOnText =>
      'Dvofaktorska autentifikacija je UKLJUČENA za ovaj račun.';

  @override
  String get twoFactorOffText =>
      'Dvofaktorska autentifikacija je ISKLJUČENA - dodaj je za dodatni sloj zaštite ovog rukovodećeg računa.';

  @override
  String get enableTwoFactorButton => 'Omogući dvofaktorsku autentifikaciju';

  @override
  String get scanAuthenticatorText =>
      'Skeniraj ovo svojom aplikacijom za autentifikaciju (Google Authenticator, Authy itd.), a zatim unesi prikazani 6-znamenkasti kod.';

  @override
  String get cantScanManualEntryText =>
      'Ne možeš skenirati? Unesi ovaj kod ručno:';

  @override
  String get requiredFieldError => 'Obavezno';

  @override
  String get joinExistingCompanyTitle => 'Pridruži se postojećoj tvrtki';

  @override
  String get enterInviteCodeText =>
      'Unesi pozivni kod koji ti je dao voditelj.';

  @override
  String get inviteCodeLabel => 'Pozivni kod';

  @override
  String get yourNameLabel => 'Tvoje ime';

  @override
  String get yourEmailLabel => 'Tvoja e-pošta';

  @override
  String get enterValidEmailError => 'Unesi valjanu e-poštu';

  @override
  String get choosePasswordLabel => 'Odaberi lozinku';

  @override
  String get joinButton => 'Pridruži se';

  @override
  String get youreInSignInText =>
      'Unutra si. Prijavi se svojom e-poštom i lozinkom koju si upravo odabrao/la.';

  @override
  String get newBranchNameTitle => 'Naziv nove poslovnice';

  @override
  String get renameBranchTitle => 'Preimenuj poslovnicu';

  @override
  String get branchManagerNameTitle => 'Ime voditelja poslovnice';

  @override
  String get accountCreatedTitle => 'Račun stvoren';

  @override
  String get giveNameAndPinText =>
      'Daj ovoj osobi njezino ime (za dodir na ekranu za prijavu) i ovaj PIN.';

  @override
  String get branchesTitle => 'Poslovnice';

  @override
  String get noRegionSetText =>
      'Tvoj račun nema postavljenu regiju - kontaktiraj svog direktora.';

  @override
  String get noBranchesInRegionText => 'Još nema poslovnica u tvojoj regiji.';

  @override
  String get addBranchManagerMenuItem => 'Dodaj voditelja poslovnice';

  @override
  String nameColonLabel(String name) {
    return 'Ime: $name';
  }

  @override
  String pinColonLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get deleteSelectedEvidenceTitle => 'Izbrisati odabrane dokaze?';

  @override
  String get deleteButton => 'Izbriši';

  @override
  String get photoEvidenceTitle => 'Fotografski dokazi';

  @override
  String get onThisDeviceLabel => 'Na ovom uređaju';

  @override
  String get deletingFreesSpaceText =>
      'Brisanje također oslobađa prostor na uređaju. Izvezeni EHO PDF-ovi već sadrže vlastite kopije i nisu pogođeni.';

  @override
  String get noEvidencePhotosYetText => 'Još nema fotografija dokaza.';

  @override
  String deleteEvidenceConfirmText(int count, String bytes) {
    return 'Ovo trajno briše $count fotografija ($bytes) s ovog uređaja. Već izvezeni PDF-ovi nisu pogođeni. Ovo se ne može poništiti.';
  }

  @override
  String evidencePhotosCountLabel(int count, String bytes) {
    return '$count fotografija dokaza · ukupno $bytes';
  }

  @override
  String deleteSelectedButton(int count, String bytes) {
    return 'Izbriši $count odabranih ($bytes)';
  }

  @override
  String get addTeamMemberTitle => 'Dodaj člana tima';

  @override
  String get createsTapNamePinAccountText =>
      'Stvara račun s odabirom imena + PIN-om za tvoju vlastitu poslovnicu.';

  @override
  String get createAccountButton => 'Stvori račun';

  @override
  String get shiftLogTitle => 'Evidencija smjena';

  @override
  String get noClockInsYetText => 'Još nema evidentiranih prijava.';

  @override
  String get stillClockedInText => 'Još prijavljen';

  @override
  String clockInLabel(String time) {
    return 'Ulaz: $time';
  }

  @override
  String clockOutLabel(String time) {
    return 'Izlaz: $time';
  }

  @override
  String durationHoursMinutesLabel(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get inviteCreatedTitle => 'Poziv stvoren';

  @override
  String get orShareCodeText =>
      'Ili podijeli ovaj kod - unijet će ga na ekranu \"Pridruži se postojećoj tvrtki\":';

  @override
  String shareInviteExpiresText(int days) {
    return 'Podijeli ovo s osobom koja se pridružuje - radi jednom i istječe za $days dana.';
  }

  @override
  String get contactVenuRiteTitle => 'Kontaktiraj VenuRite';

  @override
  String get contactVenuRiteIntroText =>
      'Bilo da si velika grupa kojoj treba pomoć pri postavljanju ili samo imaš pitanje - rado ćemo pomoći.';

  @override
  String get emailUsButton => 'Pošalji nam e-poštu';

  @override
  String taskCountOverdueLabel(int count) {
    return '$count zakašnjelih zadataka';
  }

  @override
  String acrossStaffMembersLabel(int count) {
    return 'Kod $count zaposlenika';
  }

  @override
  String moreStaffMembersLabel(int count) {
    return '+$count više zaposlenika';
  }

  @override
  String failCountLabel(int count) {
    return '$count neuspjeha';
  }

  @override
  String notCompletedCountLabel(int count) {
    return '$count nedovršeno';
  }

  @override
  String issuesRaisedCountLabel(int count) {
    return '$count prijavljenih problema';
  }

  @override
  String shiftSummaryTitle(String name) {
    return 'Sažetak smjene - $name';
  }

  @override
  String get faqQ1 => 'Tko može vidjeti što bilježim?';

  @override
  String get faqA1 =>
      'Tvoj voditelj i svi iznad njega u tvojoj poslovnici mogu vidjeti zadatke koje dovršavaš. Imenovanoj osobi nikada se ne prikazuje ocijenjeni rezultat ili ljestvica - samo jednostavan popis onoga što je i kada napravila.';

  @override
  String get faqQ2 => 'Što se događa ako propustim zadatak tijekom smjene?';

  @override
  String get faqA2 =>
      'Bilježi se kao nedovršeno, ne kao neuspjeh - napušten zadatak usred smjene je očekivano, dopušteno ponašanje, samo se nikad ne skriva. Tvoj voditelj to vidi kao vlastiti, poseban status.';

  @override
  String get faqQ3 =>
      'Mogu li se vratiti i dovršiti zadatak koji sam preskočio/la?';

  @override
  String get faqA3 =>
      'Da, bilo kada prije kraja smjene - ostaje dostupan na tvom popisu zadataka dok ga ne dovršiš ili smjena ne završi.';

  @override
  String get faqQ4 => 'Što ako ne prođem provjeru (npr. hladnjak je pretopao)?';

  @override
  String get faqA4 =>
      'Zabilježi to kao NEUSPJEH, zabilježi korektivnu radnju koju si poduzeo/la (ili da si to prijavio/la), i dodaj fotografiju ako se traži. Upravo za to služi sustav - zabilježen NEUSPJEH s popravkom je uspješna priča za inspektora, a ne problem za tebe.';

  @override
  String get faqQ5 =>
      'Moram li se odjavljivati/prijavljivati odvojeno od prijave u smjenu?';

  @override
  String get faqA5 =>
      'Ne - prijava PIN-om na početku smjene je tvoja prijava na posao. Koristi \'Završi smjenu\' kad završiš, što ti također pokazuje sve što još trebaš dovršiti.';

  @override
  String get faqQ6 => 'Prijavio/la sam problem - što se s njim događa?';

  @override
  String get faqA6 =>
      'Ide tvom voditelju (ili se dalje eskalira ako se ne riješi na vrijeme). Status možeš provjeriti bilo kada u \"Moji prijavljeni problemi.\"';

  @override
  String get troubleQ1 => 'Moj PIN ne radi';

  @override
  String get troubleA1 =>
      'Provjeri dodiruješ li prvo svoje ime, a zatim unosiš PIN - pogrešan PIN na pravom imenu daje jasnu poruku odbijanja. Ako i dalje ne radi, zamoli voditelja da provjeri je li tvoj račun aktivan i resetira tvoj PIN ako je potrebno.';

  @override
  String get troubleQ2 =>
      'Zadatak koji bih trebao/la imati nedostaje s mog popisa';

  @override
  String get troubleA2 =>
      'Zamoli voditelja da provjeri je li dodijeljen tvojoj ulozi/odjelu u Dodjeli zadataka. Zadaci se pojavljuju samo za uloge i odjele za koje su uključeni.';

  @override
  String get troubleQ3 => 'Aplikacija mi ne dopušta fotografirati';

  @override
  String get troubleA3 =>
      'Provjeri ima li aplikacija dopuštenje za kameru (provjeri postavke uređaja). Na Windowsima, ako kamera nije otkrivena, umjesto toga ćeš dobiti birač datoteka.';

  @override
  String get troubleQ4 =>
      'Ne mogu poslati provjeru / ništa se ne događa kad pritisnem Pošalji';

  @override
  String get troubleA4 =>
      'To se može dogoditi ako račun tvoje organizacije zahtijeva pažnju vezanu uz naplatu - vidjet ćeš jasnu poruku ako je tako. Inače, provjeri je li svako obavezno polje (uključujući fotografiju) ispunjeno.';

  @override
  String get troubleQ5 => 'Aplikacija izgleda kao da je zapela / zamrznuta';

  @override
  String get troubleA5 =>
      'Pokušaj je zatvoriti i ponovno otvoriti. Tvoj napredak do posljednjeg dovršenog zadatka uvijek se sprema usput, tako da se ništa već poslano ne gubi.';

  @override
  String get troubleQ6 => 'Ne vidim iste zadatke kao jučer';

  @override
  String get troubleA6 =>
      'To je očekivano ako tvoj raspored uključuje zadatke prema potrebi ili zadatke vezane uz vremenski okvir - pojavljuju se samo kad dospiju. Pitaj voditelja ako nešto izgleda stvarno pogrešno.';

  @override
  String taskOverdueSinceLabel(String title, String date) {
    return '$title - zakašnjelo od $date';
  }

  @override
  String get uploadCertificateDocumentButton =>
      'Prenesi fotografiju certifikata';

  @override
  String get certificateDocumentUploadedLabel => 'Certifikat prenesen';

  @override
  String get viewCertificateDocumentTooltip => 'Prikaži dokument certifikata';

  @override
  String get certificateUploadFailed =>
      'Slanje certifikata nije uspjelo. Pokušajte ponovno.';

  @override
  String get certificationRequirementsTitle => 'Zahtjevi za certifikate';

  @override
  String get certificationRequirementsFloorNotice =>
      'Neki certifikati uvijek su obavezni za određene uloge i ne mogu se ovdje ukloniti (npr. uloge rukovanja hranom uvijek zahtijevaju Higijenu hrane razine 2 i Svijest o alergenima). Ispod možete dodati dodatne zahtjeve.';

  @override
  String get noExtraCertificationRequirementsText =>
      'Još nisu dodani dodatni zahtjevi.';

  @override
  String get addRequirementButton => 'Dodaj zahtjev';

  @override
  String get addCertificationRequirementTitle => 'Dodaj zahtjev za certifikat';

  @override
  String get removeCertificationRequirementTitle => 'Ukloniti ovaj zahtjev?';

  @override
  String get removeCertificationRequirementBody =>
      'Osoblje u ovoj ulozi više neće trebati ovaj certifikat za raspoređivanje. To ne utječe na certifikate koji su uvijek obavezni.';

  @override
  String get removeButton => 'Ukloni';

  @override
  String get cannotClaimShiftTitle => 'Ovu smjenu još ne možete preuzeti';

  @override
  String missingCertificationsMessage(String certs) {
    return 'Ova uloga zahtijeva sljedeće, što nedostaje ili je isteklo: $certs. Pitajte svog voditelja o obnavljanju.';
  }

  @override
  String cannotAssignShiftTitle(String name) {
    return 'Ovu smjenu nije moguće dodijeliti osobi $name';
  }

  @override
  String get allergenCelery => 'Celer';

  @override
  String get allergenGluten => 'Žitarice koje sadrže gluten';

  @override
  String get allergenCrustaceans => 'Rakovi';

  @override
  String get allergenEggs => 'Jaja';

  @override
  String get allergenFish => 'Riba';

  @override
  String get allergenLupin => 'Lupina';

  @override
  String get allergenMilk => 'Mlijeko';

  @override
  String get allergenMolluscs => 'Mekušci';

  @override
  String get allergenMustard => 'Gorušica';

  @override
  String get allergenTreeNuts => 'Orašasti plodovi';

  @override
  String get allergenPeanuts => 'Kikiriki';

  @override
  String get allergenSesame => 'Sjemenke sezama';

  @override
  String get allergenSoya => 'Soja';

  @override
  String get allergenSulphites => 'Sumporov dioksid i sulfiti';

  @override
  String get allergenStatusContains => 'Sadrži';

  @override
  String get allergenStatusMayContain => 'Može sadržavati';

  @override
  String get menuManagementTitle => 'Jelovnik i alergeni';

  @override
  String get addDishButton => 'Dodaj jelo';

  @override
  String get addDishTitle => 'Dodaj jelo';

  @override
  String get dishNameLabel => 'Naziv jela';

  @override
  String get dishCategoryLabel => 'Kategorija (neobavezno)';

  @override
  String get noDishesYetText => 'Još nema dodanih jela.';

  @override
  String get draftLabel => 'Nacrt';

  @override
  String get addIngredientTitle => 'Dodaj sastojak';

  @override
  String get ingredientNameLabel => 'Naziv sastojka';

  @override
  String get addButton => 'Dodaj';

  @override
  String get addIngredientButton => 'Dodaj sastojak';

  @override
  String get ingredientsHeading => 'Sastojci';

  @override
  String get suggestedAllergensHeading =>
      'Predloženi alergeni (još nisu objavljeni)';

  @override
  String get publishedAllergensHeading => 'Objavljeni alergeni';

  @override
  String get noAllergensIdentifiedText =>
      'Iz trenutnih sastojaka nisu identificirani alergeni.';

  @override
  String get reviewAllergensTitle => 'Pregledajte alergene prije objave';

  @override
  String get allergenStatusNone => 'Nijedan';

  @override
  String get approveButton => 'Odobri i objavi';

  @override
  String get reviewAndApproveButton => 'Pregledaj i odobri';

  @override
  String get reviewAndReapproveButton => 'Pregledaj i ponovno odobri';

  @override
  String get allergenMatrixTitle => 'Matrica alergena';

  @override
  String get allergenMatrixLegend => 'Legenda';

  @override
  String get noApprovedDishesYetText =>
      'Još nema odobrenih jela. Zamolite voditelja da pregleda i odobri jela u Jelovnik i alergeni.';

  @override
  String get exportAsPdfButton => 'Izvezi kao PDF';

  @override
  String get allergenMatrixSubtitle =>
      'Provjerite sto se nalazi u jelu prije nego sto stigne do gosta';

  @override
  String get assignmentRejectedMessage =>
      'Ovo dodjeljivanje je odbijeno. Provjerite ulogu i certifikate zaposlenika i pokusajte ponovno.';

  @override
  String get sopTemplateCleaningSchedule => 'Raspored ciscenja';

  @override
  String get sopTemplateAllergenControl => 'Kontrola alergena';

  @override
  String get sopTemplateDeliveryAndStorage => 'Dostava i skladistenje';

  @override
  String get sopTemplatePersonalHygiene => 'Osobna higijena';

  @override
  String get sopTemplatePestControl => 'Suzbijanje stetnika';

  @override
  String get generateSopTitle => 'Generiraj SOP dokument';

  @override
  String get sopGenerationDisclaimer =>
      'Ovo stvara prvu verziju dokumenta postupka koju je izradila AI, koristeci opce britanske prakse sigurnosti hrane. Ovo je samo polazna tocka - pazljivo procitajte i uredite sve specificno za vasu poslovnicu prije spremanja kao aktivnog dokumenta.';

  @override
  String get sopTemplateFieldLabel => 'Vrsta dokumenta';

  @override
  String get sopExtraContextLabel => 'Dodatni detalji (neobavezno)';

  @override
  String get sopExtraContextHint =>
      'npr. specificna oprema, uloge osoblja ili vlastita pravila za ukljucivanje';

  @override
  String get generatingText => 'Generiranje...';

  @override
  String get generateDraftButton => 'Generiraj nacrt';

  @override
  String get documentTitleLabel => 'Naziv dokumenta';

  @override
  String get reviewAndEditDraftLabel => 'Pregledajte i uredite nacrt';

  @override
  String get saveAsDocumentButton => 'Spremi u Centar dokumenata';

  @override
  String get generateWithAiButton => 'Generiraj s AI';

  @override
  String get shiftPeriodsTitle => 'Razdoblja smjena';

  @override
  String get shiftPeriodsDescription =>
      'Podijelite dan na 2 ili 3 razdoblja (npr. Jutro/Poslijepodne/Noc). Kalendar rasporeda i automatsko dodjeljivanje koriste ih za filtriranje i planiranje prema dobu dana.';

  @override
  String shiftPeriodCountOption(int count) {
    return '$count razdoblja';
  }

  @override
  String get shiftPeriodNameLabel => 'Naziv razdoblja';

  @override
  String get shiftPeriodStartsLabel => 'Pocinje';

  @override
  String get shiftPeriodEndsLabel => 'Zavrsava';

  @override
  String get shiftPeriodsSavedMessage => 'Razdoblja smjena spremljena';

  @override
  String shiftPeriodsSaveFailedMessage(String error) {
    return 'Spremanje nije uspjelo: $error';
  }

  @override
  String get shiftPeriodDefaultDay => 'Dan';

  @override
  String get shiftPeriodDefaultNight => 'Noc';

  @override
  String get shiftPeriodDefaultMorning => 'Jutro';

  @override
  String get shiftPeriodDefaultAfternoon => 'Poslijepodne';

  @override
  String get rotaWeekTitle => 'Kalendar rasporeda';

  @override
  String get rosterAddonNotEnabledText =>
      'Upravljanje smjenama i rasporedom jos nije omoguceno za ovu lokaciju.';

  @override
  String get rotaTodayButton => 'Danas';

  @override
  String get rotaFilterPeriodLabel => 'Razdoblje';

  @override
  String get rotaFilterAllLabel => 'Sve';

  @override
  String get rotaFilterDepartmentLabel => 'Odjel';

  @override
  String get rotaFilterPersonLabel => 'Osoba';

  @override
  String get rotaUnassignedRowLabel => 'Nedodijeljeno';

  @override
  String get setUpShiftPeriodsFirstText =>
      'Prvo postavite razdoblja smjena (zaslon Razdoblja smjena).';

  @override
  String get addStaffingRequirementTitle => 'Dodaj zahtjev za osoblje';

  @override
  String get anyDepartmentLabel => 'Bilo koji odjel';

  @override
  String get unknownDepartmentLabel => 'Nepoznat odjel';

  @override
  String get anyRoleLabel => 'Bilo koja uloga';

  @override
  String get staffNeededLabel => 'Potrebno osoblje';

  @override
  String get standbyNeededLabel => 'Potrebna pricuva';

  @override
  String shiftsGeneratedMessage(int count) {
    return 'Stvoreno je $count smjena za taj tjedan.';
  }

  @override
  String shiftGenerationFailedMessage(String error) {
    return 'Neuspjelo: $error';
  }

  @override
  String plusStandbyCountLabel(int count) {
    return ' + $count pricuva';
  }

  @override
  String get masterRotaSettingsTitle => 'Postavke glavnog rasporeda';

  @override
  String get masterRotaSettingsDescription =>
      'Odredite koliko je osoblja (i pricuve) potrebno po danu/razdoblju/odjelu ili ulozi, a zatim generirajte stvarne smjene za tjedan odjednom.';

  @override
  String get noRequirementsYetText => 'Jos nisu postavljeni zahtjevi.';

  @override
  String get generateThisWeekButton => 'Generiraj za ovaj tjedan';

  @override
  String get generateNextWeekButton => 'Generiraj za sljedeci tjedan';

  @override
  String get rotaFilterRoleLabel => 'Uloga';

  @override
  String get rotaStaffViewLabel => 'Prikaz osoblja';

  @override
  String get rotaSlotsViewLabel => 'Prikaz mjesta';

  @override
  String get rotaSlotDetailTitle => 'Tko je na ovoj smjeni';

  @override
  String get rotaAssignedLabel => 'Dodijeljeno';

  @override
  String get rotaStandbyLabel => 'Pricuva';

  @override
  String get rotaNoneAssignedText => 'Jos nitko';

  @override
  String rotaUnfilledCountText(int count) {
    return 'Jos je potrebno $count';
  }

  @override
  String get daysOffRequestedMessage => 'Zatrazeni su slobodni dani.';

  @override
  String get bookDaysOffToggleLabel => 'Umjesto toga zatrazi slobodne dane';

  @override
  String get submitDaysOffButton => 'Posalji zahtjev za slobodne dane';

  @override
  String get alreadyRequestedOffText => 'Vec zatrazeno';

  @override
  String get noShiftsThisPeriodText => 'Nema smjena';

  @override
  String get youAreStandbyText => 'Vi ste pricuva';

  @override
  String get youAreAssignedText => 'Vi ste na ovoj smjeni';

  @override
  String get joinStandbyButton => 'Pridruzi se kao pricuva';

  @override
  String get shiftFullText => 'Popunjeno';

  @override
  String get rotaClaimCalendarTitle => 'Preuzmi smjene (kalendar)';

  @override
  String get rotaMonthTitle => 'Mjesecni prikaz rasporeda';

  @override
  String rotaMonthShiftCountText(int count) {
    return '$count smjena';
  }
}
