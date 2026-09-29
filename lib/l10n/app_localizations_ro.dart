// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'VenuRite';

  @override
  String get settingsTitle => 'Setări';

  @override
  String get personalSection => 'Personal';

  @override
  String get languageSettingTitle => 'Limbă';

  @override
  String get languageSettingSubtitle =>
      'Alege limba în care vrei să folosești VenuRite.';

  @override
  String get languageUpdated => 'Limba a fost actualizată.';

  @override
  String get chooseLanguageTitle => 'Alege limba';

  @override
  String get languageDeviceScope =>
      'Folosită pe acest dispozitiv înainte ca personalul să se autentifice.';

  @override
  String languageUserScope(String name) {
    return 'Salvată pentru $name.';
  }

  @override
  String get cancel => 'Anulează';

  @override
  String get done => 'Gata';

  @override
  String get login => 'AUTENTIFICARE';

  @override
  String get back => 'Înapoi';

  @override
  String get enterPin => 'Introdu PIN-ul';

  @override
  String get leadershipAccess => 'Acces pentru conducere';

  @override
  String get notOnThisList => 'Nu ești pe listă? Autentifică-te altfel';

  @override
  String errorLoadingStaff(String error) {
    return 'Eroare la încărcarea personalului: $error';
  }

  @override
  String get incorrectPin => 'PIN incorect';

  @override
  String tooManyWrongAttempts(int minutes) {
    return 'Prea multe încercări greșite. Încearcă din nou în $minutes min.';
  }

  @override
  String get accountNotFound => 'Contul nu a fost găsit';

  @override
  String get getStarted => 'Începe';

  @override
  String get kitchenComplianceDoneRight =>
      'Conformitate în bucătărie, clară și de încredere';

  @override
  String get valuePointEhoReady =>
      'Mereu pregătit pentru inspecția sanitară - evidențe în timp real, fără grabă de ultim moment';

  @override
  String get valuePointHonestRecords =>
      'Construit ca rezultatele să nu poată fi manipulate - fiecare verificare are o evidență credibilă';

  @override
  String get valuePointAuditExport =>
      'Export de audit cu o atingere - oferă imediat inspectorului o evidență reală';

  @override
  String get howGetStarted => 'Cum vrei să începi?';

  @override
  String get setUpMyBusiness => 'Configurează localul meu';

  @override
  String get teamAlreadyUses => 'Echipa mea folosește deja VenuRite';

  @override
  String get alreadyHaveAccount => 'Ai deja cont? Autentifică-te';

  @override
  String get needHelpContact => 'Ai nevoie de ajutor? Contactează VenuRite';

  @override
  String get signInAnotherWay => 'Autentifică-te altfel';

  @override
  String get deviceNotSetUp => 'Această tabletă nu este încă configurată';

  @override
  String get askManagerSetupCode =>
      'Cere unui manager codul de configurare pentru această locație.';

  @override
  String get setupCode => 'Cod de configurare';

  @override
  String get connectTablet => 'Conectează această tabletă';

  @override
  String get couldNotReachServer => 'Nu s-a putut contacta serverul';

  @override
  String get stillStuckSetupCode =>
      'Încă nu poți continua? Un manager îl poate găsi în Setări -> Detalii locație.';

  @override
  String get askQuestionTitle => 'Pune o întrebare';

  @override
  String get askQuestionLabel => 'Ce vrei să afli?';

  @override
  String get askQuestionHint =>
      'de ex. ce temperatură trebuie să aibă un frigider?';

  @override
  String get ask => 'Întreabă';

  @override
  String get aiQuestionLimitReached =>
      'Limita lunară pentru întrebări AI a fost atinsă';

  @override
  String get home => 'Acasă';

  @override
  String get logOut => 'Deconectare';

  @override
  String get endShift => 'Încheie tura';

  @override
  String get workerHubPrompt => 'Ce vrei să faci?';

  @override
  String get myScheduledTasks => 'Sarcinile mele programate';

  @override
  String get doAdHocTask => 'Fă o sarcină ad-hoc';

  @override
  String get logSomethingHappened => 'Înregistrează ce tocmai s-a întâmplat';

  @override
  String get claimShift => 'Preia o tură';

  @override
  String get requestDayOff => 'Cere o zi liberă';

  @override
  String get thingsIReported => 'Lucruri raportate de mine';

  @override
  String shiftWelcome(String firstName) {
    return 'Bun venit, $firstName';
  }

  @override
  String get shiftPlanIntro => 'Iată ce ai de făcut în tura ta:';

  @override
  String get startOfShift => 'Începutul turei';

  @override
  String get duringYourShift => 'În timpul turei';

  @override
  String get endOfShift => 'Sfârșitul turei';

  @override
  String get shiftHandoverTitle => 'Predarea turei';

  @override
  String get shiftHandoverNeedsAttention =>
      'Aceasta necesită în continuare atenția turei următoare';

  @override
  String get gotIt => 'Am înțeles';

  @override
  String get openIssues => 'Probleme deschise';

  @override
  String get flaggedEquipment => 'Echipamente semnalate';

  @override
  String get notYetDoneToday => 'Neefectuate încă astăzi';

  @override
  String get takePhoto => 'Fă o poză';

  @override
  String get uploadFromFiles => 'Încarcă din fișiere';

  @override
  String get seeAllTasksTooltip => 'Vezi toate sarcinile';

  @override
  String get leaveBeforeFinishingTitle => 'Ieși înainte de a termina?';

  @override
  String get leaveBeforeFinishingBody =>
      'Unele verificări nu sunt complete. Aceasta va fi înregistrată. Te poți întoarce și termina oricând în timpul acestei ture.';

  @override
  String get enterValue => 'Introdu o valoare';

  @override
  String enterValueWithUnit(String unit) {
    return 'Introdu o valoare ($unit)';
  }

  @override
  String safeRangeLabel(String min, String max) {
    return 'Interval sigur: $min - $max';
  }

  @override
  String get errorNumericRequired => 'Este necesară o valoare numerică validă';

  @override
  String get errorSelectOption => 'Te rugăm să selectezi o opțiune';

  @override
  String get errorNotesRequired => 'Este necesară o notă';

  @override
  String get errorPhotoRequired => 'Este necesară o fotografie';

  @override
  String get errorCorrectiveActionRequired =>
      'Alege cum a fost gestionată acțiunea corectivă';

  @override
  String get myTasksTitle => 'Sarcinile mele';

  @override
  String get taskTitleFallback => 'Sarcină';

  @override
  String get noTasksAssigned => 'Nicio sarcină atribuită încă.';

  @override
  String get overdueLabel => 'Restant';

  @override
  String overdueSinceLabel(String date) {
    return 'Restant din $date';
  }

  @override
  String get withinRangePass => 'În limite - TRECUT';

  @override
  String get outsideRangeFail => 'În afara limitelor - NEREUȘIT';

  @override
  String get selectOptionLabel => 'Selectează o opțiune';

  @override
  String get notesLabel => 'Note';

  @override
  String get spotCheckPhotoNotice =>
      'Verificare prin sondaj de azi - este nevoie de o fotografie de data aceasta pentru a confirma că a fost făcută efectiv.';

  @override
  String get photoAdded => 'Fotografie adăugată';

  @override
  String get addPhoto => 'Adaugă fotografie';

  @override
  String get passLabel => 'TRECUT';

  @override
  String get failLabel => 'NEREUȘIT';

  @override
  String get readingOutsideSafeRange =>
      'Citirea este în afara intervalului sigur';

  @override
  String get hereIsWhatToDo => 'Iată ce trebuie făcut:';

  @override
  String get correctiveActionRequired => 'Este necesară o acțiune corectivă';

  @override
  String get iFixedIt => 'Am reparat';

  @override
  String get reportedToManager => 'Raportat managerului';

  @override
  String get correctiveActionNoteLabel => 'Ce ai făcut? (opțional)';

  @override
  String get managerWillBeNotified => 'Managerul tău va fi notificat.';

  @override
  String get submitButton => 'TRIMITE';

  @override
  String availableFrom(String time) {
    return 'Disponibil de la $time';
  }

  @override
  String get backToList => 'Înapoi la listă';

  @override
  String get skipComesBackLater => 'Omite - revine mai târziu';

  @override
  String get noAdHocTaskTypesSetUp =>
      'Niciun tip de sarcină ad-hoc nu este configurat la acest site încă - roagă un manager să atribuie mai întâi un șablon de verificare a livrării sau a temperaturii.';

  @override
  String get whatKindOfThing => 'Ce fel de lucru faci?';

  @override
  String get notesOptionalLabel => 'Note (opțional)';

  @override
  String get noteOptionalLabel => 'Notă (opțional)';

  @override
  String get temperatureCelsiusLabel => 'Temperatură (°C)';

  @override
  String get submitLabel => 'Trimite';

  @override
  String get logReadingButton => 'Înregistrează citirea';

  @override
  String get loggedThanksMessage => 'Înregistrat. Mulțumim că ai notat asta.';

  @override
  String get logAnotherAdHocTask => 'Înregistrează altă sarcină ad-hoc';

  @override
  String get deliveryCheckLabel => 'Verificare livrare';

  @override
  String get temperatureCheckLabel => 'Verificare temperatură';

  @override
  String get sessionSummaryTitle => 'Rezumatul turei';

  @override
  String tasksCompletedCount(int count) {
    return 'Sarcini finalizate: $count';
  }

  @override
  String get passedLabel => 'Trecut';

  @override
  String get failedLabel => 'Nereușit';

  @override
  String get triggersFailedTasks => 'Declanșatoare / Sarcini nereușite';

  @override
  String get yourReliability => 'Fiabilitatea ta';

  @override
  String get reliabilityExplanation =>
      'Ultimele 30 de zile - verificări efectuate și înregistrate la timp. Un eșec înregistrat contează la fel ca un succes înregistrat: aceasta măsoară doar dacă și când ai verificat.';

  @override
  String completedPercentChip(int percent) {
    return '$percent% finalizat';
  }

  @override
  String onTimePercentChip(int percent) {
    return '$percent% la timp';
  }

  @override
  String get sendSummaryToManager =>
      'Trimite acest rezumat unui manager (opțional)';

  @override
  String get noManagersSetUp => 'Niciun manager configurat încă.';

  @override
  String get managerLabel => 'Manager';

  @override
  String get sentLabel => 'Trimis';

  @override
  String get sendLabel => 'Trimite';

  @override
  String get leaveNoteForNextShift =>
      'Lasă o notă pentru tura următoare (opțional)';

  @override
  String get handoverNoteLabel => 'Notă de predare';

  @override
  String get doneLabel => 'Gata';

  @override
  String get supplierOptionalLabel => 'Furnizor (opțional)';

  @override
  String supplierWarningRecorded(String status) {
    return 'Acest furnizor este marcat ca $status - verificarea va fi totuși înregistrată.';
  }

  @override
  String get reportProblemWithDelivery =>
      'Raportează o problemă cu această livrare';

  @override
  String get temperatureOnArrivalLabel =>
      'Temperatura la sosire (°C, opțional)';

  @override
  String get problemsTickAnyApply => 'Probleme (bifează tot ce se aplică)';

  @override
  String get shortDeliveryLabel => 'Livrare incompletă';

  @override
  String get damagedStockLabel => 'Marfă deteriorată';

  @override
  String get lateDeliveryLabel => 'Livrare întârziată';

  @override
  String get qualityProblemLabel => 'Problemă de calitate';

  @override
  String get outcomeLabel => 'Rezultat';

  @override
  String get acceptedLabel => 'Acceptat';

  @override
  String get rejectedLabel => 'Respins';

  @override
  String get partiallyAcceptedLabel => 'Acceptat parțial';

  @override
  String get noCameraFound => 'Nu s-a găsit nicio cameră pe acest dispozitiv.';

  @override
  String couldNotStartCamera(String error) {
    return 'Camera nu a putut fi pornită: $error';
  }

  @override
  String couldNotSwitchCamera(String error) {
    return 'Camera nu a putut fi schimbată: $error';
  }

  @override
  String couldNotCapturePhoto(String error) {
    return 'Nu s-a putut face o fotografie: $error';
  }

  @override
  String get switchCameraTooltip => 'Schimbă camera';

  @override
  String get allTasksTitle => 'Toate sarcinile';

  @override
  String get otherSegmentLabel => 'Altele';

  @override
  String get reorderTasksTitle => 'Reordonează sarcinile';

  @override
  String get ungroupedLabel => 'Negrupat';

  @override
  String get taskOrderSaved => 'Ordinea sarcinilor a fost salvată.';

  @override
  String couldNotSaveTaskOrder(String error) {
    return 'Ordinea sarcinilor nu a putut fi salvată: $error';
  }

  @override
  String get noVenueSelectedReorder =>
      'Niciun local selectat încă. Setează un local activ din Detalii local înainte de a reordona sarcinile.';

  @override
  String get noActiveTasksToReorder =>
      'Nu există sarcini active de reordonat încă. Atribuie mai întâi sarcini, apoi revino aici pentru a le alege ordinea.';

  @override
  String get savingEllipsis => 'Se salvează…';

  @override
  String get saveOrderLabel => 'Salvează ordinea';

  @override
  String get moveUpTooltip => 'Mută în sus';

  @override
  String get moveDownTooltip => 'Mută în jos';

  @override
  String get accountRestrictedTitle => 'Cont restricționat';

  @override
  String get accountRestrictedBody =>
      'Debitul direct al acestei organizații necesită atenție înainte ca noi verificări să poată fi salvate. Munca ta nu este pierdută - te rugăm să anunți un manager sau un director să rezolve facturarea, apoi încearcă din nou.';

  @override
  String get okLabel => 'OK';

  @override
  String get troubleshootingTitle => 'Depanare';

  @override
  String get faqTitle => 'Întrebări frecvente';

  @override
  String get helpTitle => 'Ajutor';

  @override
  String get couldntReachAssistant => 'Nu s-a putut contacta asistentul';

  @override
  String get aiOfflineBody =>
      'Asistentul AI nu poate fi contactat acum - poate fi conexiunea ta sau serviciul este temporar indisponibil. Între timp, secțiunile Întrebări frecvente și Depanare de mai jos acoperă cele mai comune întrebări, sau contactează direct VenuRite.';

  @override
  String get askQuestionSubtitle =>
      'Primește un răspuns clar, pe înțelesul tuturor';

  @override
  String get faqSubtitle => 'Întrebări comune, cu răspuns';

  @override
  String get troubleshootingSubtitle => 'Ceva nu funcționează? Începe de aici';

  @override
  String get contactVenuriteTitle => 'Contactează VenuRite';

  @override
  String get contactVenuriteSubtitle => 'Ia legătura direct';

  @override
  String get topTierViewTitle => 'Vizualizare nivel superior';

  @override
  String get everythingsDone => 'Totul e gata. Bună treabă.';

  @override
  String tasksNotCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sarcini neterminate:',
      one: '1 sarcină neterminată:',
    );
    return '$_temp0';
  }

  @override
  String get backToShiftLabel => 'Înapoi la tură';

  @override
  String get finishShiftLabel => 'Încheie tura';

  @override
  String get ehoAuditExportTitle => 'Export EHO / Audit';

  @override
  String get ehoExportDescription =>
      'Generează un PDF cu înregistrările de conformitate ale acestui local pentru intervalul de date ales.';

  @override
  String dateRangeValue(String start, String end) {
    return '$start - $end';
  }

  @override
  String get selectDateRangeLabel => 'Selectează intervalul de date';

  @override
  String get tapToChooseDates =>
      'Atinge pentru a alege o dată de început și de sfârșit.';

  @override
  String get includeFullDetailedLog => 'Include jurnalul detaliat complet';

  @override
  String get fullLogSubtitle =>
      'Dezactivat implicit - rezumatul și excepțiile de mai sus sunt ceea ce verifică efectiv un inspector; aceasta adaugă fiecare verificare individuală.';

  @override
  String get generateLabel => 'Generează';

  @override
  String get exportFailedTitle => 'Exportul a eșuat';

  @override
  String exportFailedBody(String error) {
    return 'Exportul a eșuat: $error';
  }

  @override
  String get exportCreatedTitle => 'Export creat';

  @override
  String savedToLabel(String path) {
    return 'Salvat în:\n$path';
  }

  @override
  String get dashboardTitle => 'Tablou de bord';

  @override
  String get noVenueFound => 'Niciun local găsit.';

  @override
  String get allPermittedVenuesLast30Days =>
      'Toate localurile permise · ultimele 30 de zile';

  @override
  String get last30Days => 'Ultimele 30 de zile';

  @override
  String failCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NEREUȘITE (30 zile)',
      one: '1 NEREUȘIT (30 zile)',
    );
    return '$_temp0';
  }

  @override
  String overdueCountLabel(int count) {
    return '$count restante';
  }

  @override
  String get venuesSectionTitle => 'Localuri';

  @override
  String get teamSectionTitle => 'Echipă';

  @override
  String get noStaffAtVenue => 'Niciun personal la acest local încă.';

  @override
  String get notEnoughDataYet => 'Date insuficiente';

  @override
  String get venueFallbackLabel => 'Local';

  @override
  String get trendsTitle => 'Tendințe';

  @override
  String get trendNeedsHistory =>
      'Date de tendință: sunt necesare cel puțin 4 săptămâni de istoric pentru a afișa o tendință.';

  @override
  String perVenueWeeklyCompletion(int weeks) {
    return 'Finalizare săptămânală pe local · ultimele $weeks săptămâni';
  }

  @override
  String get allVenuesCombined => 'Toate localurile combinate';

  @override
  String get noVenuesYet => 'Niciun local încă.';

  @override
  String get otherVenuesLabel => 'Alte localuri';

  @override
  String lowLoggingFlagLabel(int completed, int total) {
    return '$completed din $total verificări înregistrate';
  }

  @override
  String regionFallbackLabel(int id) {
    return 'Regiunea #$id';
  }

  @override
  String get dashboardOverviewTitle => 'Prezentare generală tablou de bord';

  @override
  String get gradedBarsOnTooltip => 'Bare notate per angajat: activat';

  @override
  String get gradedBarsOffTooltip => 'Bare notate per angajat: dezactivat';

  @override
  String get noBranchesToShow => 'Niciun sediu de afișat încă.';

  @override
  String get supervisorNoScopeMessage =>
      'Nu ai fost încă atribuit unei secțiuni sau echipe - roagă un manager să configureze acest lucru în Gestionarea personalului înainte ca acest tablou de bord să aibă ceva de arătat.';

  @override
  String get individualViewNotice =>
      'Vizualizare individuală - pentru supraveghere de risc, nu un clasament.';

  @override
  String get branchLabel => 'Sediu';

  @override
  String get allBranchesLabel => 'Toate sediile';

  @override
  String get yourSectionLabel => 'Secțiunea ta';

  @override
  String get noneAssignedLabel => 'Niciuna atribuită';

  @override
  String get areaLabel => 'Zonă';

  @override
  String get allAreasLabel => 'Toate zonele';

  @override
  String get employeeLabel => 'Angajat';

  @override
  String get allEmployeesLabel => 'Toți angajații';

  @override
  String get monthLabel => 'Lună';

  @override
  String get weekLabel => 'Săptămână';

  @override
  String get dayLabel => 'Zi';

  @override
  String get noTaskActivityPeriod =>
      'Nicio activitate de sarcini în această perioadă.';

  @override
  String get taskOverviewTitle => 'Prezentare sarcini';

  @override
  String get incidentsTitle => 'Incidente';

  @override
  String get noIncidentsPeriod =>
      'Niciun incident raportat în această perioadă.';

  @override
  String urgentCountLabel(int count) {
    return '$count urgente';
  }

  @override
  String get tapForDetailsHint =>
      'Atinge o secțiune colorată sau o legendă pentru detalii';

  @override
  String get employeeFallbackLabel => 'Angajat';

  @override
  String get plainLookupNotice =>
      'O simplă căutare, nu un scor - culoarea de finalizare și etichetele problemelor nu sunt niciodată notate per persoană aici.';

  @override
  String tasksCompletedCountParens(int count) {
    return 'Sarcini finalizate ($count)';
  }

  @override
  String issuesRaisedCountParens(int count) {
    return 'Probleme raportate ($count)';
  }

  @override
  String get doneOnTimeNoIssues => 'Făcut la timp (fără probleme)';

  @override
  String get doneOnTimeIssuesLogged => 'Făcut la timp (probleme raportate)';

  @override
  String get doneEarlyLateNoIssues =>
      'Făcut mai devreme/târziu (fără probleme)';

  @override
  String get doneEarlyLateIssuesLogged =>
      'Făcut mai devreme/târziu (probleme raportate)';

  @override
  String get notDoneLabel => 'Nefăcut';

  @override
  String get resolvedLabel => 'Rezolvate';

  @override
  String get unresolvedLabel => 'Nerezolvate';

  @override
  String get escalatedLabel => 'Escaladate';

  @override
  String get urgentLabel => 'Urgent';

  @override
  String get signInFailed => 'Autentificarea a eșuat';

  @override
  String get twoFactorRequiredNoFactor =>
      'Este necesară verificarea în doi pași, dar nu a fost găsită nicio metodă.';

  @override
  String get couldNotVerifyCode => 'Codul nu a putut fi verificat';

  @override
  String get codeDidntWork => 'Acel cod nu a funcționat.';

  @override
  String get accountNotLinkedToStaff =>
      'Acest cont nu este încă asociat unui profil de angajat - contactează un administrator.';

  @override
  String get resetPasswordTitle => 'Resetează parola';

  @override
  String get enterEmailForResetCode =>
      'Introdu adresa de e-mail și îți vom trimite un cod pentru a-ți reseta parola.';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get sendCodeButton => 'TRIMITE COD';

  @override
  String get backToSignIn => 'Înapoi la autentificare';

  @override
  String sentCodeToEmail(String email) {
    return 'Am trimis un cod la $email. Introdu-l mai jos împreună cu noua parolă.';
  }

  @override
  String get sixDigitCodeLabel => 'Cod din 6 cifre';

  @override
  String get newPasswordLabel => 'Parolă nouă';

  @override
  String get resetPasswordButton => 'RESETEAZĂ PAROLA';

  @override
  String get twoFactorVerificationTitle => 'Verificare în doi pași';

  @override
  String get enterAuthenticatorCode =>
      'Introdu codul din aplicația de autentificare.';

  @override
  String get verifyButton => 'VERIFICĂ';

  @override
  String get regionalDirectorSignIn => 'Autentificare Regional și Director.';

  @override
  String get passwordLabel => 'Parolă';

  @override
  String get signInButton => 'AUTENTIFICARE';

  @override
  String get forgotPasswordLink => 'Ai uitat parola?';

  @override
  String get noBackendConfiguredPin =>
      'Nu este configurat niciun backend pentru această instalare - autentifică-te cu un PIN, la fel ca toți ceilalți.';

  @override
  String get noDirectorRegionalAccounts =>
      'Niciun cont de Director/Regional pe acest dispozitiv.';

  @override
  String get directorLabel => 'Director';

  @override
  String get regionalManagerLabel => 'Manager regional';

  @override
  String get whoAreYouTitle => 'Cine ești?';

  @override
  String get searchLabel => 'Caută';

  @override
  String get noMatchesLabel => 'Nicio potrivire';

  @override
  String get leadershipSectionTitle => 'Conducere';

  @override
  String get kitchenStaffSectionTitle => 'Personal de bucătărie';

  @override
  String get chooseASectionTitle => 'Alege o secțiune';

  @override
  String get unassignedLabel => 'Neatribuit';

  @override
  String personCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count persoane',
      one: '$count persoană',
    );
    return '$_temp0';
  }

  @override
  String get goodMorning => 'Bună dimineața';

  @override
  String get goodAfternoon => 'Bună ziua';

  @override
  String get goodEvening => 'Bună seara';

  @override
  String get welcomeToVenurite => 'Bine ai venit la VenuRite';

  @override
  String get helpAssistantTooltip => 'Ajutor și asistent';

  @override
  String get couldntLoadScreen => 'Acest ecran nu a putut fi încărcat.';

  @override
  String get retryLabel => 'Reîncearcă';

  @override
  String get microphonePermissionDenied =>
      'Permisiunea pentru microfon a fost refuzată.';

  @override
  String get couldntRecordTryAgain =>
      'Nu s-a putut înregistra - încearcă din nou.';

  @override
  String get couldntTranscribe => 'Nu s-a putut transcrie.';

  @override
  String get couldntReachTranscriptionService =>
      'Nu s-a putut contacta serviciul de transcriere.';

  @override
  String get dictateANote => 'Dictează o notă';

  @override
  String get stoppingSoonTapToStop =>
      'Se oprește curând - atinge pentru a opri acum';

  @override
  String get stopLabel => 'Oprește';

  @override
  String get somethingWentWrong => 'Ceva nu a mers bine';

  @override
  String alertsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alerte',
      one: '1 alertă',
    );
    return '$_temp0';
  }

  @override
  String unacknowledgedCountLabel(int count) {
    return '$count necitite';
  }

  @override
  String get allAcknowledgedLabel => 'Toate confirmate';

  @override
  String overdueUnacknowledgedMinutes(int minutes) {
    return 'ÎNTÂRZIAT - neconfirmat de $minutes min';
  }

  @override
  String get escalatedToTopTier => 'Escaladat la nivelul superior';

  @override
  String get acknowledgeLabel => 'Confirmă';

  @override
  String get nothingInCategory => 'Nimic în această categorie.';

  @override
  String categoryWithCountLabel(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get leadershipOverview => 'Prezentare generală conducere';

  @override
  String get photoEvidence => 'Dovezi foto';

  @override
  String get staffManagement => 'Gestionarea personalului';

  @override
  String get addTeamMember => 'Adaugă membru al echipei';

  @override
  String get shiftLog => 'Jurnal de tură';

  @override
  String get branchTeamStructure => 'Structura echipei sucursalei';

  @override
  String get departmentManagement => 'Gestionarea departamentelor';

  @override
  String get rosterBoard => 'Panou de tură';

  @override
  String get claimShifts => 'Revendică ture';

  @override
  String get requestADayOff => 'Solicită o zi liberă';

  @override
  String get shiftFairnessReview => 'Analiză echitate ture';

  @override
  String get venueDetails => 'Detalii local';

  @override
  String get assignTasks => 'Atribuie sarcini';

  @override
  String get taskPresets => 'Presetări sarcini';

  @override
  String get supplierManagement => 'Gestionarea furnizorilor';

  @override
  String get serviceProviders => 'Furnizori de servicii';

  @override
  String get notificationRules => 'Reguli de notificare';

  @override
  String get documentCentre => 'Centru de documente';

  @override
  String get setupWizard => 'Expert de configurare';

  @override
  String get organisationLabel => 'Organizație';

  @override
  String get branchesLabel => 'Sucursale';

  @override
  String get homeLabel => 'Acasă';

  @override
  String get oversightLabel => 'Supraveghere';

  @override
  String get problemsAndIssues => 'Probleme și sesizări';

  @override
  String get twoFactorAuthentication => 'Autentificare în doi pași';

  @override
  String get backUpNow => 'Salvează acum';

  @override
  String get dailySection => 'Zilnic';

  @override
  String get insightsSection => 'Analize';

  @override
  String get peopleSection => 'Personal';

  @override
  String get rosterSection => 'Tură';

  @override
  String get venueSetupSection => 'Configurare local';

  @override
  String get companySection => 'Companie';

  @override
  String get accountSection => 'Cont';

  @override
  String get settingsLabel => 'Setări';

  @override
  String percentCompletedTodayChip(int percent) {
    return '$percent% finalizat azi';
  }

  @override
  String activeStaffCountLabel(int count) {
    return '$count personal activ';
  }

  @override
  String failCountTodayBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NEREUȘITE azi',
      one: '1 NEREUȘIT azi',
    );
    return '$_temp0';
  }

  @override
  String get managerViewTitle => 'Vizualizare manager';

  @override
  String showingScopeLabel(String scope) {
    return 'Se afișează: $scope';
  }

  @override
  String get supervisorNoScopeMessageLog =>
      'Nu ai fost încă atribuit unei secțiuni sau echipe - roagă un manager să configureze acest lucru în Gestionarea personalului înainte ca acest jurnal să aibă ceva de arătat.';

  @override
  String entriesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count înregistrări',
      one: '1 înregistrare',
    );
    return '$_temp0';
  }

  @override
  String failCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NEREUȘITE',
      one: '1 NEREUȘIT',
    );
    return '$_temp0';
  }

  @override
  String get noFailsLabel => 'Fără eșecuri';

  @override
  String get noCompletedTasksLoggedYet =>
      'Nicio sarcină finalizată înregistrată încă';

  @override
  String sessionSummariesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rezumate de tură',
      one: '1 rezumat de tură',
    );
    return '$_temp0';
  }

  @override
  String passFailCountLabel(int passCount, int failCount) {
    return '$passCount trecut / $failCount nereușit';
  }

  @override
  String get workerFixedIt => 'Angajatul a reparat';

  @override
  String get noCorrectiveActionRecorded =>
      'Nicio acțiune corectivă înregistrată';

  @override
  String get taskAlertFallback => 'Alertă sarcină';

  @override
  String get loggedByLabel => 'Înregistrat de';

  @override
  String get resultLabel => 'Rezultat';

  @override
  String get correctiveActionLabel => 'Acțiune corectivă';

  @override
  String get noteLabel => 'Notă';

  @override
  String get closeLabel => 'Închide';

  @override
  String get notCompletedSuffix => '- NETERMINAT (tura încheiată)';

  @override
  String get todayAllFails => 'Azi + toate eșecurile';

  @override
  String byAxisLabel(String axis) {
    return 'După $axis';
  }

  @override
  String get nameAxisLabel => 'Nume';

  @override
  String get dateAxisLabel => 'Dată';

  @override
  String get taskAxisLabel => 'Sarcină';

  @override
  String get filterLabel => 'Filtru';

  @override
  String get filterByLabel => 'Filtrează după:';

  @override
  String get clearFiltersLabel => 'Șterge filtrele';

  @override
  String get staffLabel => 'Personal';

  @override
  String get issueTypeComplaint => 'Reclamație';

  @override
  String get issueTypeAccident => 'Accident';

  @override
  String get issueTypeIncident => 'Incident';

  @override
  String get issueTypeSupplyProblem => 'Problemă de aprovizionare';

  @override
  String get issueTypeVenueProblem => 'Problemă a localului';

  @override
  String get issueTypeOther => 'Altele';

  @override
  String get incorrectDeliveryLabel => 'Livrare incorectă';

  @override
  String get driverProblemLabel => 'Problemă cu șoferul';

  @override
  String get otherLabel => 'Altele';

  @override
  String get whatKindOfThingHappened => 'Ce fel de lucru s-a întâmplat?';

  @override
  String get whichOneLabel => 'Care anume?';

  @override
  String get supplierLabel => 'Furnizor';

  @override
  String get whatWasWrongWithDelivery => 'Ce a fost în neregulă cu livrarea?';

  @override
  String get receivedByLabel => 'Primit de';

  @override
  String get whichSectionOptional =>
      'Despre ce secțiune este vorba? (opțional)';

  @override
  String get noSectionLabel => 'Nicio secțiune';

  @override
  String get teamOptionalLabel => 'Echipă (opțional)';

  @override
  String get noSpecificTeamLabel => 'Nicio echipă specifică';

  @override
  String get whatHappenedLabel => 'Ce s-a întâmplat?';

  @override
  String get markAsUrgentLabel => 'Marchează ca urgent';

  @override
  String get markUrgentSubtitle =>
      'Necesită atenție imediată, indiferent de cât timp rămâne nerezolvat';

  @override
  String get logItButton => 'Înregistrează';

  @override
  String get escalateToTitle => 'Escaladează către';

  @override
  String get sendToLabel => 'Trimite către';

  @override
  String get escalateButton => 'Escaladează';

  @override
  String get savedLabel => 'Salvat.';

  @override
  String remindedMessage(String name) {
    return '$name a fost notificat(ă).';
  }

  @override
  String get couldNotSendReminder => 'Memento-ul nu a putut fi trimis.';

  @override
  String get viewSupplierScorecard => 'Vezi fișa furnizorului';

  @override
  String raisedAtLabel(String date) {
    return 'Raportat $date';
  }

  @override
  String escalatedToColonLabel(String name) {
    return 'Escaladat către: $name';
  }

  @override
  String get historyLabel => 'Istoric';

  @override
  String get addAnUpdateLabel => 'Adaugă o actualizare';

  @override
  String get addProcessNoteButton => 'Adaugă notă de proces';

  @override
  String get resolveButton => 'Rezolvă';

  @override
  String get reopenThisIssueTitle => 'Redeschide această sesizare';

  @override
  String get whyReopenLabel => 'De ce ar trebui redeschisă?';

  @override
  String get reopenButton => 'Redeschide';

  @override
  String sentToLabel(String name) {
    return 'Trimis către $name';
  }

  @override
  String get remindButton => 'Reamintește';

  @override
  String get phaseRaisedLabel => 'Raportat';

  @override
  String get phaseUpdateLabel => 'Actualizare';

  @override
  String get phaseOutcomeLabel => 'Rezultat';

  @override
  String get allLabel => 'Toate';

  @override
  String get dateRangeLabel => 'Interval de date';

  @override
  String get allDatesLabel => 'Toate datele';

  @override
  String get typeLabel => 'Tip';

  @override
  String get anyTypeLabel => 'Orice tip';

  @override
  String get anyoneLabel => 'Oricine';

  @override
  String staffFallback(String id) {
    return 'Angajat #$id';
  }

  @override
  String get nothingHereGoodSign => 'Nimic aici - este un semn bun.';

  @override
  String escalatedToNameLabel(String name) {
    return 'Escaladat către $name';
  }

  @override
  String get havenReportedYet => 'Nu ai raportat încă nimic.';

  @override
  String get failsAndProblemsRegisterTitle =>
      'Registrul de eșecuri și probleme';

  @override
  String get taskProblemsTab => 'Probleme de sarcini';

  @override
  String get issuesAndIncidentsTab => 'Sesizări și incidente';

  @override
  String get failFilterLabel => 'Nereușit';

  @override
  String get reportedFilterLabel => 'Raportat';

  @override
  String get notCompletedFilterLabel => 'Neterminat';

  @override
  String get abandonedLabel => 'Abandonat';

  @override
  String get noActionTakenLabel => 'Nicio acțiune întreprinsă';

  @override
  String get markResolvedButton => 'Marchează ca rezolvat';

  @override
  String get openLabel => 'Deschis';

  @override
  String get enableRosterQuestion => 'Activezi Tura?';

  @override
  String rosterQuoteBody(String amount) {
    return 'Pe baza numărului actual de angajați, aceasta va adăuga $amount la debitul tău direct lunar, începând cu următoarea plată.';
  }

  @override
  String get confirmAndEnable => 'Confirmă și activează';

  @override
  String couldNotReachVenurite(String error) {
    return 'Nu s-a putut contacta VenuRite: $error';
  }

  @override
  String get letStaffClaimShifts =>
      'Lasă personalul să-și revendice propriile ture';

  @override
  String get rosterPitchBody =>
      'Publică ture libere și lasă personalul să le preia singur - fără telefoane în lanț sau grup de WhatsApp când cineva nu poate veni. Personalul poate cere și zile libere, iar tu aprobi sau respingi din același loc.';

  @override
  String get pricingLabel => 'Preț';

  @override
  String get priceUnder10Staff =>
      '6 GBP/lună per local cu mai puțin de 10 angajați';

  @override
  String get price10PlusStaff =>
      '10 GBP/lună per local cu 10 sau mai mulți angajați';

  @override
  String get addedToDirectDebitNote =>
      'Adăugat la debitul tău direct existent - nu este nevoie de o nouă metodă de plată. Vei vedea suma exactă înainte de confirmare.';

  @override
  String get enableRosterButton => 'Activează Tura';

  @override
  String get availableShiftsTitle => 'Ture disponibile';

  @override
  String get shiftClaimingNotEnabled =>
      'Revendicarea turelor nu este încă activată pentru acest local. Roagă un manager să o activeze din Setări.';

  @override
  String couldNotLoadShifts(String error) {
    return 'Turele nu au putut fi încărcate: $error';
  }

  @override
  String get noShiftsPostedYet => 'Nicio tură publicată încă.';

  @override
  String get someoneElseClaimedShift =>
      'Altcineva tocmai a revendicat acea tură - ne pare rău!';

  @override
  String get shiftClaimedMessage => 'Tură revendicată.';

  @override
  String get cancelThisShiftTitle => 'Anulezi această tură?';

  @override
  String get cancelShiftLateWarning =>
      '\n\nMai sunt mai puțin de 24 de ore până la începerea turei - anularea acum îți poate afecta istoricul de fiabilitate.';

  @override
  String willNoLongerBeClaimed(String warning) {
    return 'Nu vei mai fi înregistrat(ă) pentru această tură.$warning';
  }

  @override
  String get keepShiftButton => 'Păstrează tura';

  @override
  String get cancelShiftButton => 'Anulează tura';

  @override
  String get yourShiftRecordReliable => 'Istoricul turelor tale: Fiabil';

  @override
  String get yourShiftRecordNeedsImprovement =>
      'Istoricul turelor tale: Necesită îmbunătățire';

  @override
  String get yourShiftRecordBuilding =>
      'Istoricul turelor tale: În curs de construire';

  @override
  String get claimLabel => 'Revendică';

  @override
  String get claimedLabel => 'Revendicat';

  @override
  String requestDateOffTitle(String date) {
    return 'Solicită liber $date';
  }

  @override
  String get reasonOptionalLabel => 'Motiv (opțional)';

  @override
  String get submitRequestButton => 'Trimite cererea';

  @override
  String get offDayRequestsNotEnabled =>
      'Cererile de zi liberă nu sunt încă activate pentru acest local. Roagă un manager să activeze Tura din Setări.';

  @override
  String get noOffDayRequestsYet => 'Nu ai nicio cerere de zi liberă încă.';

  @override
  String get yourRequestsLabel => 'Cererile tale';

  @override
  String get approvedLabel => 'Aprobat';

  @override
  String get deniedLabel => 'Refuzat';

  @override
  String get pendingLabel => 'În așteptare';

  @override
  String get postAShiftTitle => 'Publică o tură';

  @override
  String get categoryHint => 'Categorie (ex. deschidere, închidere)';

  @override
  String get pickStartTime => 'Alege ora de început';

  @override
  String get pickEndTime => 'Alege ora de sfârșit';

  @override
  String get postLabel => 'Publică';

  @override
  String get assignShiftToTitle => 'Atribuie această tură lui';

  @override
  String get unknownLabel => 'Necunoscut';

  @override
  String get shiftsTabLabel => 'Ture';

  @override
  String get offDayRequestsTabLabel => 'Cereri de zi liberă';

  @override
  String get rosterAddonNotEnabledManager =>
      'Add-on-ul Tură nu este activat pentru acest local. Activează-l din Setări > Companie pentru a începe să publici ture.';

  @override
  String get noShiftsTapPlus =>
      'Nicio tură publicată încă. Atinge + pentru a adăuga una.';

  @override
  String get openStatusLabel => 'Liberă';

  @override
  String get assignedStatusPrefix => 'Atribuită';

  @override
  String get claimedStatusPrefix => 'Revendicată';

  @override
  String get assignDirectlyLabel => 'Atribuie direct';

  @override
  String get removeClaimLabel => 'Elimină revendicarea';

  @override
  String couldNotLoadOffDayRequests(String error) {
    return 'Cererile de zi liberă nu au putut fi încărcate: $error';
  }

  @override
  String get noOffDayRequests => 'Nicio cerere de zi liberă.';

  @override
  String get approveLabel => 'Aprobă';

  @override
  String get denyLabel => 'Refuză';

  @override
  String get rosterAddonNotEnabledPlain =>
      'Add-on-ul Tură nu este activat pentru acest local.';

  @override
  String get noActiveStaffVenue => 'Niciun personal activ la acest local încă.';

  @override
  String get last90DaysAlphabetical =>
      'Ultimele 90 de zile, pe categorie de tură. Alfabetic - nu un clasament.';

  @override
  String shiftsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ture',
      one: '1 tură',
    );
    return '$_temp0';
  }

  @override
  String get noShiftsInPeriod => 'Nicio tură în această perioadă.';

  @override
  String categoryCountLabel(String category, int count) {
    return '$category: $count';
  }

  @override
  String get backupExplanation =>
      'Aceasta creează o copie completă a bazei de date locale în folderul Documente. Mutarea acesteia pe o unitate USB sau un folder sincronizat cloud ulterior este un pas manual separat.';

  @override
  String get backupNameOptional => 'Nume backup (opțional)';

  @override
  String get backupNameHint => 'ex. Backup înainte de inspecție';

  @override
  String get backupCreatedTitle => 'Backup creat';

  @override
  String get tierTeamMember => 'Membru al echipei';

  @override
  String get tierSupervisor => 'Supervizor';

  @override
  String get tierManager => 'Manager';

  @override
  String get tierRegionalManager => 'Manager regional';

  @override
  String get tierDirector => 'Director';

  @override
  String get anyTaskFail => 'Orice sarcină nereușită';

  @override
  String taskFailLabel(String title) {
    return 'Eșec: $title';
  }

  @override
  String get taskFailTemplateStale =>
      'Eșec sarcină (șablon nu mai este curent)';

  @override
  String get unknownUserLabel => 'Utilizator necunoscut';

  @override
  String tierSuffixLabel(String tier) {
    return 'nivel $tier';
  }

  @override
  String get unsetLabel => 'Nesetat';

  @override
  String get pushChannelLabel => 'push';

  @override
  String get emailChannelLabel => 'e-mail';

  @override
  String get inAppOnlyLabel => 'doar în aplicație';

  @override
  String inAppPlusChannelsLabel(String channels) {
    return 'în aplicație + $channels';
  }

  @override
  String get tierColumnTeam => 'Echipă';

  @override
  String get tierColumnSupv => 'Sprv';

  @override
  String get tierColumnMgr => 'Mgr';

  @override
  String get tierColumnRegnl => 'Regnl';

  @override
  String get tierColumnDir => 'Dir';

  @override
  String get quickSetupSectionTitle =>
      'Configurare rapidă: notificări pentru eșecul sarcinilor';

  @override
  String get tickTierNotified =>
      'Bifează ce nivel este notificat când o anumită sarcină eșuează.';

  @override
  String get noTaskTemplatesSetUp =>
      'Niciun șablon de sarcină configurat încă.';

  @override
  String notifyPrefixLabel(String target, String channels) {
    return 'Notifică: $target ($channels)';
  }

  @override
  String setByTierLabel(String tier) {
    return 'Setat de nivelul $tier';
  }

  @override
  String get inactiveSuffixLabel => ' - inactiv';

  @override
  String get deactivateButton => 'Dezactivează';

  @override
  String get reactivateButton => 'Reactivează';

  @override
  String get newRuleTitle => 'Regulă nouă';

  @override
  String get triggerLabel => 'Declanșator';

  @override
  String get notifyLabel => 'Notifică';

  @override
  String get wholeRoleTierOption => 'Un întreg nivel de rol';

  @override
  String get specificPersonOption => 'O anumită persoană';

  @override
  String get roleTierLabel => 'Nivel de rol';

  @override
  String get personLabel => 'Persoană';

  @override
  String get pushLabel => 'Push';

  @override
  String get rulesInAppNotice =>
      'Regulile sunt afișate acum doar în aplicație; livrarea push/e-mail nu este încă conectată la un backend și va fi adăugată într-un sprint viitor.';

  @override
  String get saveRuleButton => 'Salvează regula';

  @override
  String get addRuleButton => 'Adaugă regulă';

  @override
  String get noNotificationRulesYet =>
      'Nicio regulă de notificare configurată încă.';

  @override
  String get stepYourAccount => 'Contul tău';

  @override
  String get stepCompanyDetails => 'Detaliile companiei';

  @override
  String get stepOrgStructure => 'Structura organizației';

  @override
  String get stepFirstVenue => 'Primul local';

  @override
  String get stepStarterSetup => 'Setul tău de pornire';

  @override
  String get stepSubscription => 'Abonament';

  @override
  String get stepPayment => 'Plată';

  @override
  String get termsOfServiceTitle => 'Termeni și condiții';

  @override
  String get companySignupGenericError =>
      'Ceva n-a mers bine la crearea companiei tale. Te rugăm încearcă din nou - dacă tot se întâmplă, contactează VenuRite.';

  @override
  String get directDebitStartError =>
      'N-am putut porni automat configurarea Direct Debit - poți face asta oricând din Setări după ce te-ai autentificat.';

  @override
  String get continueButton => 'Continuă';

  @override
  String get creatingEllipsis => 'Se creează...';

  @override
  String get startFreeTrialButton => 'Începe perioada de probă gratuită';

  @override
  String get companyCreatedTitle => 'Companie creată';

  @override
  String get adminAccountIntro =>
      'Hai să-ți configurăm contul. Vei fi administratorul acestei companii pe VenuRite și îți poți invita echipa odată ce ai intrat.';

  @override
  String get firstNameLabel => 'Prenume';

  @override
  String get lastNameLabel => 'Nume';

  @override
  String get passwordMinCharsHelper => 'Cel puțin 8 caractere';

  @override
  String get companyDetailsIntro => 'Spune-ne despre compania ta.';

  @override
  String get tradingCompanyNameLabel => 'Nume comercial / al companiei';

  @override
  String get legalCompanyNameLabel => 'Denumire legală a companiei (opțional)';

  @override
  String get legalCompanyNameHelper =>
      'Lasă gol pentru a folosi numele comercial de mai sus';

  @override
  String get countryLabel => 'Țară';

  @override
  String get registeredAddressLabel =>
      'Adresă înregistrată / de afaceri (opțional)';

  @override
  String get vatNumberLabel => 'Cod TVA / fiscal (dacă e cazul)';

  @override
  String get billingContactEmailLabel =>
      'Email de contact pentru facturare (opțional)';

  @override
  String get structureIntro =>
      'Iată cum organizează VenuRite compania ta. Nu trebuie să configurezi nimic acum - e doar ca să aibă sens pasul următor.';

  @override
  String get structureYourCompanyLabel => 'Compania ta';

  @override
  String get structureYourCompanySublabel =>
      'Un singur cont și o singură factură consolidată';

  @override
  String get structureRegionsLabel => 'Regiuni (opțional)';

  @override
  String get structureRegionsSublabel =>
      'Grupează locațiile după țară sau zonă - sari peste dacă nu ai nevoie';

  @override
  String get structureVenuesLabel => 'Locații';

  @override
  String get structureVenuesSublabel =>
      'O locație azi, sute mai târziu - adaugă mai multe oricând';

  @override
  String get structureStaffLabel => 'Personal';

  @override
  String get structureStaffSublabel =>
      'Echipa fiecărei locații, invitată odată ce există';

  @override
  String get structureOutro =>
      'Vom configura primul tău local în continuare - poți adăuga regiuni și mai multe locații mai târziu din aplicație.';

  @override
  String get wizardFirstVenueHeroTitle => 'Hai să adăugăm primul tău local';

  @override
  String get addMoreVenuesLaterText =>
      'Poți adăuga mai multe locații mai târziu.';

  @override
  String get venueNameLabel => 'Numele localului';

  @override
  String get addressOptionalLabel => 'Adresă (opțional)';

  @override
  String get regionAreaOptionalLabel => 'Regiune / zonă (opțional)';

  @override
  String get regionAreaHelper =>
      'de ex. \"București\" - necesar doar dacă ai (sau vei avea) mai mult de o locație';

  @override
  String get venueTypeOptionalLabel => 'Tip de local (opțional)';

  @override
  String get venueTypeHelper =>
      'Alegerea uneia îți arată un set de pornire gata făcut - pentru sarcini și echipamente de care știi deja că ai nevoie.';

  @override
  String get payoffSkippedText =>
      'Ai sărit peste alegerea unui tip de local, deci nu există încă un set de pornire de arătat - poți adăuga sarcini și echipamente singur odată ce ai intrat.';

  @override
  String get payoffErrorText =>
      'Nu am putut încărca setul de pornire pentru acest tip de local - poți adăuga sarcini și echipamente singur odată ce ai intrat.';

  @override
  String get payoffHeroTitle => 'Iată conformitatea ta, gata de utilizare';

  @override
  String get equipmentSectionLabel => 'Echipamente';

  @override
  String get subscriptionBannerText =>
      'Un cont de companie, o factură consolidată - taxat per local, niciodată per persoană.';

  @override
  String get subscriptionIntroText =>
      'Câte locații ai astăzi, inclusiv sediul central dacă ai unul? Vei configura acum doar primul tău local - restul le adaugi oricând din aplicație.';

  @override
  String get perBranchPriceLabel => '39 GBP/local/lună';

  @override
  String get headOfficeIncludedLabel =>
      '+ 1 local de sediu central (4+ locații)';

  @override
  String get discountCodeHint =>
      'Ai un cod de reducere? Îl poți introduce când configurezi Direct Debit.';

  @override
  String get trialBannerText =>
      'Începi o perioadă de probă gratuită de 14 zile - nu ai nevoie de card azi.';

  @override
  String get paymentStepIntro =>
      'Îți vom cere să configurezi plata înainte de sfârșitul perioadei de probă, din Setări în aplicație. Nu se taxează nimic acum - spune-ne doar cum preferi să plătești.';

  @override
  String get cardPaymentTitle => 'Plată cu cardul (Stripe)';

  @override
  String get cardPaymentSubtitle =>
      'Card de debit/credit, facturat lunar sau anual';

  @override
  String get directDebitTitle => 'Direct Debit (GoCardless)';

  @override
  String get directDebitSubtitle => 'Plată bancă-la-bancă, fără card necesar';

  @override
  String get decideLaterButton => 'Decid mai târziu';

  @override
  String get decideLaterSnackbar =>
      'Nicio problemă - poți configura asta oricând din Setări.';

  @override
  String get agreeToTermsPrefix => 'Am citit și sunt de acord cu ';

  @override
  String get successActivatedBanner =>
      'Compania și primul tău local sunt configurate, și ești autentificat.';

  @override
  String get successNotActivatedBanner =>
      'Compania și primul tău local sunt configurate. Autentifică-te cu emailul tău și parola pe care tocmai ai ales-o.';

  @override
  String get directDebitSettingUp => 'Se configurează Direct Debit...';

  @override
  String get directDebitOpenedBrowser =>
      'Ți-am deschis browserul pentru a finaliza configurarea Direct Debit.';

  @override
  String get inviteYourTeamTitle => 'Invită-ți echipa';

  @override
  String get inviteYourTeamSubtitle =>
      'Opțional - adaugă pe oricine e în tură acum, sau sari peste și fă asta mai târziu din Managementul personalului.';

  @override
  String get jobTitleLabel => 'Funcție';

  @override
  String get tierFieldLabel => 'Nivel';

  @override
  String get addTeamMemberButton => 'Adaugă membru al echipei';

  @override
  String get goToDashboardButton => 'Mergi la panou';

  @override
  String get goToSignInButton => 'Mergi la autentificare';

  @override
  String wizardStepOfLabel(String title, int step, int total) {
    return '$title - Pasul $step din $total';
  }

  @override
  String billingContactEmailHelper(String email) {
    return 'Lasă gol pentru a folosi $email';
  }

  @override
  String payoffNoStarterSet(String venueType) {
    return 'Nu avem încă un set de pornire predefinit pentru $venueType - poți adăuga sarcini și echipamente singur odată ce ai intrat.';
  }

  @override
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  ) {
    return '$totalTasks sarcini în $sectionCount secțiuni și $equipmentCount tipuri de echipamente deja configurate pentru un $venueType.';
  }

  @override
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  ) {
    return '$totalTasks sarcini în $sectionCount secțiuni deja configurate pentru un $venueType.';
  }

  @override
  String totalPerMonthLabel(String total, int units) {
    return '£$total/lună total ($units locații facturate)';
  }

  @override
  String staffPinLabel(String pin) {
    return 'PIN: $pin';
  }
}
