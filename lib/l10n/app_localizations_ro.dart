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
  String get categoryHint => 'ex. Reparații refrigerare, Deratizare';

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

  @override
  String get jobRoleChefCook => 'Bucătar';

  @override
  String get jobRoleKitchenPorter => 'Ajutor de bucătărie';

  @override
  String get jobRoleFrontOfHouse => 'Sală (Front of House)';

  @override
  String get jobRoleBar => 'Bar';

  @override
  String get jobRoleManagement => 'Management';

  @override
  String get jobRoleEveryone => 'Toată lumea';

  @override
  String get jobRoleMaintenance => 'Întreținere';

  @override
  String get jobRoleHousekeeping => 'Menaj';

  @override
  String get jobRoleReception => 'Recepție';

  @override
  String get jobRoleSecurity => 'Securitate';

  @override
  String get segmentFoodSafety =>
      'Siguranța alimentară și controlul temperaturii';

  @override
  String get segmentAllergen => 'Managementul alergenilor';

  @override
  String get segmentPersonalHygienePpe => 'Igienă personală și EIP';

  @override
  String get segmentRefrigerationColdStorage =>
      'Refrigerare și depozitare la rece';

  @override
  String get segmentCookingLineEquipment => 'Echipamente de linie de gătit';

  @override
  String get segmentWashupDishwash => 'Spălătorie / Spălat vase';

  @override
  String get segmentCleaningSanitation => 'Curățenie și igienizare';

  @override
  String get segmentCleaningChemicals => 'Substanțe de curățare și consumabile';

  @override
  String get segmentDryAmbientStorage =>
      'Depozitare uscată și la temperatura ambiantă';

  @override
  String get segmentDeliveriesGoodsIn => 'Livrări și recepție marfă';

  @override
  String get segmentUtilitiesSafety => 'Utilități și siguranță';

  @override
  String get segmentWastePestControl => 'Deșeuri și control dăunători';

  @override
  String get segmentPreventiveMaintenance =>
      'Întreținere preventivă (echipamente de bucătărie)';

  @override
  String get segmentStockControl => 'Control stoc';

  @override
  String get segmentOpeningProcedures => 'Proceduri de deschidere';

  @override
  String get segmentClosingProcedures => 'Proceduri de închidere';

  @override
  String get segmentServiceReadiness => 'Pregătire pentru serviciu';

  @override
  String get segmentFrontOfHouse => 'Sală / Serviciu';

  @override
  String get segmentBarBeverage => 'Bar și băuturi';

  @override
  String get segmentHotelSpecific => 'Specific hotelului';

  @override
  String get segmentManagementComplianceOversight =>
      'Management și supraveghere a conformității';

  @override
  String get segmentMaintenance => 'Întreținere';

  @override
  String get segmentHousekeeping => 'Menaj';

  @override
  String get segmentReception => 'Recepție';

  @override
  String get segmentSecurity => 'Securitate';

  @override
  String get freqDaily => 'Zilnic';

  @override
  String get freqWeekly => 'Săptămânal';

  @override
  String get freqPerShift => 'Pe tură';

  @override
  String get freqThreeXDaily => 'De 3 ori pe zi';

  @override
  String get freqTwoXDaily => 'De 2 ori pe zi';

  @override
  String get freqPerBatch => 'Pe lot';

  @override
  String get freqPerDelivery => 'Pe livrare';

  @override
  String get freqPerUse => 'La utilizare';

  @override
  String get freqPerService => 'Pe serviciu';

  @override
  String get freqTwoXPerService => 'De 2 ori pe serviciu';

  @override
  String get freqEventBased => 'Bazat pe eveniment';

  @override
  String get freqAsNeeded => 'La nevoie';

  @override
  String get freqMonthly => 'Lunar';

  @override
  String get freqCustom => 'Personalizat';

  @override
  String get jobRoleFieldLabel => 'Rol de post';

  @override
  String get pinFieldLabel => 'PIN';

  @override
  String get addStaffMemberTitle => 'Adaugă angajat';

  @override
  String get addLabel => 'Adaugă';

  @override
  String get assignTasksTitle => 'Atribuire sarcini';

  @override
  String get noActiveSiteFoundError => 'Nu s-a găsit niciun local activ.';

  @override
  String get byPersonLabel => 'După persoană';

  @override
  String get byTaskLabel => 'După sarcină';

  @override
  String get noEquipmentOfTypeSetUp =>
      'Niciun echipament de acest tip configurat încă.';

  @override
  String get applyButton => 'Aplică';

  @override
  String get assignToTitle => 'Atribuie către';

  @override
  String get noStaffMatchTiers =>
      'Niciun angajat nu se potrivește nivelului(rilor) cărora li se aplică aceste sarcini.';

  @override
  String get assignButton => 'Atribuie';

  @override
  String get showInstructionsTooltip => 'Arată instrucțiunile';

  @override
  String get selectTasksToAssignLabel => 'Selectează sarcini de atribuit';

  @override
  String get taskPresetsSectionTitle => 'Seturi predefinite de sarcini';

  @override
  String get showAllPresetsButton => 'Arată toate seturile';

  @override
  String get showTasksInGroupTooltip => 'Arată sarcinile din acest grup';

  @override
  String get applyToMultipleButton => 'Aplică la mai mulți';

  @override
  String get addCustomTaskButton => 'Adaugă sarcină personalizată';

  @override
  String get customTaskSectionTitle => 'Sarcină personalizată';

  @override
  String get titleFieldLabel => 'Titlu';

  @override
  String get departmentSectionLabel => 'Departament / secțiune';

  @override
  String get methodLabel => 'Metodă';

  @override
  String get methodTick => 'Bifă';

  @override
  String get methodData => 'Date';

  @override
  String get methodDataTick => 'Date + bifă';

  @override
  String get methodTickPhoto => 'Bifă + fotografie';

  @override
  String get methodDataPhoto => 'Date + fotografie';

  @override
  String get methodNote => 'Notă';

  @override
  String get methodDataNote => 'Date + notă';

  @override
  String get methodNotePhoto => 'Notă + fotografie';

  @override
  String get methodTickNote => 'Bifă + notă';

  @override
  String get methodMulti => 'Multiplu';

  @override
  String get requiresPhotoLabel => 'Necesită fotografie';

  @override
  String get requiresNotesLabel => 'Necesită notițe';

  @override
  String get minLimitLabel => 'Limită minimă';

  @override
  String get maxLimitLabel => 'Limită maximă';

  @override
  String get unitHintLabel => 'Unitate (ex. Celsius)';

  @override
  String get equipmentTypeOptionalLabel => 'Tip de echipament (opțional)';

  @override
  String get noneLabel => 'Niciunul';

  @override
  String get priorityLabel => 'Prioritate';

  @override
  String get priorityCritical => 'Critică';

  @override
  String get priorityHigh => 'Ridicată';

  @override
  String get priorityStandard => 'Standard';

  @override
  String get requiresCorrectiveActionLabel =>
      'Necesită acțiune corectivă la eșec';

  @override
  String get fixInstructionsLabel => 'Instrucțiuni de remediere';

  @override
  String get customFieldsJsonLabel => 'Câmpuri personalizate (JSON, opțional)';

  @override
  String get extraFieldsSectionTitle => 'Câmpuri suplimentare (opțional)';

  @override
  String get removeTooltip => 'Elimină';

  @override
  String get fieldLabelHint => 'Etichetă câmp (ex. număr comandă)';

  @override
  String get extraFieldTypeText => 'Text';

  @override
  String get extraFieldTypeNumber => 'Număr';

  @override
  String get extraFieldTypeDate => 'Dată';

  @override
  String get addFieldTooltip => 'Adaugă câmp';

  @override
  String get saveCustomTaskButton => 'Salvează sarcina personalizată';

  @override
  String get adHocLabel => 'Ad hoc';

  @override
  String get timeAllocatedLabel => 'Timp alocat';

  @override
  String get frequencyPrefixLabel => 'Frecvență: ';

  @override
  String get atATimeLabel => 'La o oră fixă';

  @override
  String get fromStartOfShiftLabel => 'De la începutul turei';

  @override
  String get fromClockInLabel => 'De la pontaj';

  @override
  String get availableFromEllipsis => 'Disponibil de la…';

  @override
  String get untilEllipsis => 'până la…';

  @override
  String assignTasksForStaffTitle(String name) {
    return 'Atribuire sarcini - $name';
  }

  @override
  String applyPresetToWhichOneTitle(String name) {
    return 'Aplică \"$name\" la care?';
  }

  @override
  String allPresetTasksAlreadyAssigned(String name) {
    return 'Toate sarcinile $name erau deja atribuite';
  }

  @override
  String addedTasksFromPreset(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'S-au adăugat $count sarcini',
      one: 'S-a adăugat $count sarcină',
    );
    return '$_temp0 din $name';
  }

  @override
  String applyPresetToTitle(String name) {
    return 'Aplică \"$name\" la';
  }

  @override
  String assignTasksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Atribuie $count sarcini personalului…',
      one: 'Atribuie $count sarcină personalului…',
    );
    return '$_temp0';
  }

  @override
  String addedTasksAcrossStaffLabel(int count, int staffCount) {
    return 'S-au adăugat $count atribuiri pentru $staffCount angajați';
  }

  @override
  String presetSectionPrefix(String segment) {
    return 'Secțiune: $segment';
  }

  @override
  String taskCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sarcini',
      one: '$count sarcină',
    );
    return '$_temp0';
  }

  @override
  String showAllRolesLabel(String jobRole) {
    return 'Arată toate rolurile (implicit doar: $jobRole)';
  }

  @override
  String extraFieldSummary(String label, String type) {
    return '$label ($type)';
  }

  @override
  String noEquipmentSetUpForTemplate(String title) {
    return '$title - niciun echipament configurat încă pentru asta';
  }

  @override
  String fromTimeLabel(String time) {
    return 'De la $time';
  }

  @override
  String untilTimeLabel(String time) {
    return 'până la $time';
  }

  @override
  String createdAssignmentsLabel(int count, String skippedNote) {
    return '$count atribuiri create$skippedNote.';
  }

  @override
  String skippedNoteLabel(int count) {
    return ' ($count omise - deja atribuite sau nepotrivire de rol)';
  }

  @override
  String get serviceProvidersTitle => 'Furnizori de servicii';

  @override
  String get myProvidersTab => 'Furnizorii mei';

  @override
  String get findProviderTab => 'Găsește un furnizor';

  @override
  String get noBackendProviderNotice1 =>
      'Răsfoirea furnizorilor partajați de alte localuri necesită autentificare cu un cont real de companie - nu poate funcționa doar cu autentificarea demo locală. Contactele tale proprii din \"Furnizorii mei\" funcționează oricum.';

  @override
  String get noBackendProviderNotice2 =>
      'Autentifică-te prin Acces conducere cu un cont real de companie pentru a folosi asta.';

  @override
  String get providerDisclaimerText =>
      'VenuRite nu verifică și nu recomandă niciun furnizor listat. Recenziile provin de la alte localuri, nu de la VenuRite.';

  @override
  String get addProviderButton => 'Adaugă un furnizor';

  @override
  String get noProvidersYetText =>
      'Nu ai adăugat încă niciun furnizor de servicii.';

  @override
  String get addServiceProviderDialogTitle => 'Adaugă un furnizor de servicii';

  @override
  String get categoryLabel => 'Categorie';

  @override
  String get phoneOptionalLabel => 'Telefon (opțional)';

  @override
  String get emailOptionalLabel => 'Email (opțional)';

  @override
  String get notesOptionalPrivateLabel =>
      'Note (opțional, private pentru tine)';

  @override
  String get happyToReviewShareLabel =>
      'Sunt bucuros să recenzez și să partajez';

  @override
  String get shareVisibilityExplanation =>
      'Alte localuri îți vor vedea evaluările și recenziile, cu numele/contactul neclare până le deblochează.';

  @override
  String get rateThisProviderLabel => 'Evaluează acest furnizor';

  @override
  String get priceRatingLabel => 'Preț';

  @override
  String get punctualityRatingLabel => 'Punctualitate';

  @override
  String get qualityRatingLabel => 'Calitate';

  @override
  String get availabilityRatingLabel => 'Disponibilitate';

  @override
  String get reviewOptionalLabel => 'Recenzie (opțional)';

  @override
  String get reviewHintText =>
      'Descrie experiența ta - te rugăm să nu numești afacerea sau să incluzi detalii de contact.';

  @override
  String get sessionExpiredMessage =>
      'Sesiunea ta a expirat - te rugăm să te autentifici din nou.';

  @override
  String get sharedWithOtherVenuesLabel => 'Partajat cu alte localuri';

  @override
  String get privateLabel => 'Privat';

  @override
  String get rateReviewsButton => 'Evaluează / Recenzii';

  @override
  String get searchByCategoryOrNameHint => 'Caută după categorie sau nume';

  @override
  String get noContactsUnlockedThisMonth =>
      'Niciun contact deblocat încă luna aceasta.';

  @override
  String get noSharedProvidersYetText =>
      'Niciun furnizor partajat încă - fii primul care partajează unul din \"Furnizorii mei.\"';

  @override
  String get noProvidersMatchSearchText =>
      'Niciun furnizor nu se potrivește căutării tale.';

  @override
  String get noRatingsYetText => 'Nicio evaluare încă';

  @override
  String get hiddenUntilUnlockedText => 'Ascuns până la deblocare';

  @override
  String get unnamedPlaceholder => '(fără nume)';

  @override
  String get readReviewsButton => 'Citește recenziile';

  @override
  String get unlockContactDetailsButton => 'Deblochează detaliile de contact';

  @override
  String get reviewsTitle => 'Recenzii';

  @override
  String get noReviewsYetText => 'Nicio recenzie încă.';

  @override
  String get addYourRatingLabel => 'Adaugă evaluarea ta';

  @override
  String get submittingEllipsis => 'Se trimite...';

  @override
  String get submitRatingButton => 'Trimite evaluarea';

  @override
  String reviewContainsInfoWarningShort(String found) {
    return 'Recenzia ta pare să includă $found. Te rugăm să elimini detaliile de contact sau numele afacerii înainte de a trimite.';
  }

  @override
  String reviewContainsInfoWarningLong(String found) {
    return 'Recenzia ta pare să includă $found. Te rugăm să elimini detaliile de contact sau numele afacerii înainte de a trimite - recenziile rămân utile (și corecte) atunci când descriu experiența, nu pe cine să suni direct.';
  }

  @override
  String contactsUnlockedThisMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contacte deblocate luna aceasta.',
      one: '$count contact deblocat luna aceasta.',
    );
    return '$_temp0';
  }

  @override
  String priceValueLabel(String value) {
    return 'Preț $value';
  }

  @override
  String punctualityValueLabel(String value) {
    return 'Punctualitate $value';
  }

  @override
  String qualityValueLabel(String value) {
    return 'Calitate $value';
  }

  @override
  String availabilityValueLabel(String value) {
    return 'Disponibilitate $value';
  }

  @override
  String ratingReviewCountSuffix(String parts, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recenzii',
      one: '$count recenzie',
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
    return 'Preț $price - Punctualitate $punctuality - Calitate $quality - Disponibilitate $availability';
  }

  @override
  String phonePrefixLabel(String value) {
    return 'Telefon: $value';
  }

  @override
  String emailPrefixLabel(String value) {
    return 'Email: $value';
  }

  @override
  String get supplierCategoryFreshProduce => 'Produse proaspete';

  @override
  String get supplierCategoryMeatPoultry => 'Carne și pasăre';

  @override
  String get supplierCategoryDairyEggs => 'Lactate și ouă';

  @override
  String get supplierCategoryFrozenGoods => 'Produse congelate';

  @override
  String get supplierCategoryDryAmbientGoods =>
      'Produse uscate și la temperatura ambiantă';

  @override
  String get supplierCategoryDrinksBeverages => 'Băuturi';

  @override
  String get supplierCategoryChemicalsCleaningSupplies =>
      'Chimicale și produse de curățenie';

  @override
  String get supplierCategoryEquipmentMaintenance =>
      'Echipamente și întreținere';

  @override
  String get supplierCategoryOther => 'Altele';

  @override
  String get supplierStatusApproved => 'Aprobat';

  @override
  String get supplierStatusPending => 'În așteptare';

  @override
  String get supplierStatusSuspended => 'Suspendat';

  @override
  String get addEquipmentTitle => 'Adaugă echipament';

  @override
  String get venueSetupTitle => 'Configurare local';

  @override
  String get nextButton => 'Următorul';

  @override
  String get finishSetupButton => 'Finalizează configurarea';

  @override
  String get renameAreaTitle => 'Redenumește zona';

  @override
  String get renameEquipmentTitle => 'Redenumește echipamentul';

  @override
  String get saveButton => 'Salvează';

  @override
  String get retireEquipmentTitle => 'Retrage echipamentul';

  @override
  String get retireEquipmentConfirmText =>
      'Retragerea acestui echipament va anula și alocarea oricăror sarcini atribuite în prezent acestuia. Istoricul trimiterilor anterioare este păstrat. Continui?';

  @override
  String get retireButton => 'Retrage';

  @override
  String get areasStepTitle => 'Zone';

  @override
  String get areasStepIntro => 'Adaugă zonele operaționale ale acestui local.';

  @override
  String get areaSuggestionKitchen => 'Bucătărie';

  @override
  String get areaSuggestionStorage => 'Depozit';

  @override
  String get areaSuggestionReceiving => 'Recepție marfă';

  @override
  String get areaSuggestionFrontOfHouse => 'Sală';

  @override
  String get areaNameLabel => 'Nume zonă';

  @override
  String get addAreaTooltip => 'Adaugă zonă';

  @override
  String get renameTooltip => 'Redenumește';

  @override
  String get equipmentStepTitle => 'Echipamente';

  @override
  String get equipmentStepIntro =>
      'Adaugă instanțe de echipamente cu nume, ex. \"Frigider 1\", \"Frigider 2\".';

  @override
  String get showAllEquipmentTypesButton =>
      'Arată toate tipurile de echipamente';

  @override
  String get equipmentTypeLabel => 'Tip de echipament';

  @override
  String get somethingElseOption => 'Altceva...';

  @override
  String get newEquipmentTypeNameLabel => 'Nume tip nou de echipament';

  @override
  String get confirmNewEquipmentTypeTooltip =>
      'Confirmă noul tip de echipament';

  @override
  String get noAreasForDeptText =>
      'Nicio zonă configurată încă pentru departamentul tău - echipamentul poate fi totuși adăugat fără una.';

  @override
  String get noAreasAddOneText =>
      'Nicio zonă adăugată încă - întoarce-te pentru a adăuga una.';

  @override
  String get equipmentNameLabel => 'Nume echipament';

  @override
  String get equipmentNameHint =>
      'ex. Cameră frigorifică carne, Frigider deserturi, Friteuză bar';

  @override
  String get modelOptionalLabel => 'Model (opțional)';

  @override
  String get serialNumberOptionalLabel => 'Număr de serie (opțional)';

  @override
  String get retireTooltip => 'Retrage';

  @override
  String get reactivateTooltip => 'Reactivează';

  @override
  String get unknownTypeLabel => 'Tip necunoscut';

  @override
  String get unknownAreaLabel => 'Zonă necunoscută';

  @override
  String get staffStepTitle => 'Personal';

  @override
  String get staffStepIntro =>
      'Adaugă membri ai personalului și atribuie-le nivelul de rol.';

  @override
  String get addStaffMemberButton => 'Adaugă membru personal';

  @override
  String get suppliersStepTitle => 'Furnizori';

  @override
  String get suppliersStepIntro =>
      'Adaugă furnizorii cu care lucrează acest local. Marcajele de aprobare apar în exportul EHO - furnizorii suspendați sunt afișați managerilor, nu ascunși în tăcere.';

  @override
  String get supplierNameLabel => 'Nume furnizor';

  @override
  String get contactOptionalLabel => 'Contact (opțional)';

  @override
  String get phoneOrEmailHint => 'Telefon sau email';

  @override
  String get approvalStatusLabel => 'Stare aprobare';

  @override
  String get addSupplierButton => 'Adaugă furnizor';

  @override
  String venueSetupStepTitle(int step) {
    return 'Configurare local - Pasul $step din 4';
  }

  @override
  String modelPrefixLabel(String value) {
    return 'Model: $value';
  }

  @override
  String serialPrefixLabel(String value) {
    return 'Nr. serie: $value';
  }

  @override
  String retiredSuffixLabel(String name) {
    return '$name (retras)';
  }

  @override
  String get addEquipmentTooltip => 'Adaugă echipament';

  @override
  String get newPinLabel => 'PIN nou';

  @override
  String get editDetailsTitle => 'Editează detaliile';

  @override
  String get sectionLabel => 'Secțiune';

  @override
  String get noSectionOption => 'Fără secțiune';

  @override
  String get inactiveParenSuffix => ' (inactivă)';

  @override
  String get noSpecificTeamOption => 'Fără o echipă anume';

  @override
  String get noSectionsSetupText =>
      'Nicio secțiune configurată încă la acest local - adaugă una mai întâi în Managementul departamentelor.';

  @override
  String get reportsToFieldLabel => 'Raportează către';

  @override
  String get notSetOption => 'Nesetat';

  @override
  String get deactivateStaffMemberTitle => 'Dezactivează angajatul';

  @override
  String get staffManagementTitle => 'Managementul personalului';

  @override
  String get addStaffTooltip => 'Adaugă personal';

  @override
  String get bulkImportTooltip => 'Import în masă';

  @override
  String get deactivatedSuffixLabel => '(dezactivat)';

  @override
  String get moreActionsTooltip => 'Mai multe acțiuni';

  @override
  String get changeTierMenuItem => 'Schimbă nivelul';

  @override
  String get changeSectionMenuItem => 'Schimbă secțiunea';

  @override
  String get assignSupervisionMenuItem => 'Atribuie supervizare';

  @override
  String get reportsToMenuItem => 'Raportează către';

  @override
  String get resetPinMenuItem => 'Resetează PIN-ul';

  @override
  String get trainingRecordsMenuItem => 'Înregistrări de instruire';

  @override
  String unknownUserIdFallback(String id) {
    return 'utilizator #$id';
  }

  @override
  String resetPinForUserTitle(String name) {
    return 'Resetează PIN - $name';
  }

  @override
  String pinResetForUserMessage(String name) {
    return 'PIN resetat pentru $name';
  }

  @override
  String changeRoleTierTitle(String name) {
    return 'Schimbă nivelul rolului - $name';
  }

  @override
  String changeSectionTitle(String name) {
    return 'Schimbă secțiunea - $name';
  }

  @override
  String assignSupervisionTitle(String name) {
    return 'Atribuie supervizare - $name';
  }

  @override
  String supervisionScopeUpdatedMessage(String name) {
    return 'Domeniul de supervizare actualizat pentru $name';
  }

  @override
  String reportsToTitle(String name) {
    return 'Raportează către - $name';
  }

  @override
  String deactivateStaffConfirmText(String name) {
    return '$name nu se va mai putea autentifica. Sarcinile active atribuite vor fi dezatribuite. Istoricul trimiterilor nu este afectat. Aceasta poate fi anulată ulterior.';
  }

  @override
  String reportsToSubtitle(String name) {
    return 'Raportează către $name';
  }

  @override
  String deactivatedOnByLabel(String date, String name) {
    return 'pe $date de $name';
  }

  @override
  String get darkModeLabel => 'Mod întunecat';

  @override
  String get brandIdentityIntro =>
      'O singură identitate de brand, comună la nivel de companie - se aplică fiecărui local, nu per local.';

  @override
  String get companyNameLabel => 'Numele companiei';

  @override
  String get companyLogoLabel => 'Logo companie';

  @override
  String get chooseLogoButton => 'Alege logo';

  @override
  String get changeLogoButton => 'Schimbă logo';

  @override
  String get brandColourLabel => 'Culoare brand';

  @override
  String get customHexColourLabel => 'Culoare hex personalizată';

  @override
  String get enterValidHexColourError => 'Introdu o culoare hex validă';

  @override
  String get contactPhoneLabel => 'Telefon de contact';

  @override
  String get contactEmailLabel => 'Email de contact';

  @override
  String get savingEllipsisLabel => 'Se salvează...';

  @override
  String get saveBrandingButton => 'Salvează brandul';

  @override
  String get brandingSavedMessage => 'Brand salvat';

  @override
  String get customSwatchTooltip => 'Personalizat';

  @override
  String get rosterAddonTitle => 'Tură/Program personal (+6-10 GBP/local/lună)';

  @override
  String get rosterAddonSubtitle =>
      'Lasă personalul să vadă și să preia singur turele deschise - un manager postează ture, personalul le preia. 6 GBP/lună per local sub 10 angajați, 10 GBP/lună pentru 10 sau mai mulți.';

  @override
  String get enableRosterTitle => 'Activezi Programul?';

  @override
  String get confirmButton => 'Confirmă';

  @override
  String get clearDemoDataTitle => 'Ștergi datele demo?';

  @override
  String get clearDemoDataConfirmText =>
      'Aceasta șterge definitiv fiecare angajat demo, filială și departament și te deloghează. Nu poate fi anulat.';

  @override
  String get clearEverythingButton => 'Șterge tot';

  @override
  String get clearDemoDataCardTitle => 'Șterge datele demo';

  @override
  String get clearDemoDataCardBody =>
      'Elimină fiecare angajat demo, filială și departament ca să-ți poți configura propriile date de la zero.';

  @override
  String get clearDemoDataButton => 'Șterge datele demo';

  @override
  String get temperatureUnitLabel => 'Unitate de temperatură';

  @override
  String get celsiusLabel => 'Celsius (°C)';

  @override
  String get fahrenheitLabel => 'Fahrenheit (°F)';

  @override
  String get comingSoonLabel => 'În curând';

  @override
  String get presetColorOceanTeal => 'Turcoaz Ocean';

  @override
  String get presetColorNavy => 'Bleumarin';

  @override
  String get presetColorIndigo => 'Indigo';

  @override
  String get presetColorSlate => 'Ardezie';

  @override
  String get presetColorPlum => 'Prună';

  @override
  String get presetColorForest => 'Verde pădure';

  @override
  String get presetColorUmber => 'Umbra';

  @override
  String get presetColorCharcoal => 'Cărbune';

  @override
  String couldNotGetPriceError(String error) {
    return 'Nu s-a putut obține un preț: $error';
  }

  @override
  String enableRosterConfirmText(String amount) {
    return 'Pe baza numărului actual de angajați, aceasta va adăuga $amount la Direct Debit-ul tău lunar.';
  }

  @override
  String get departmentLabel => 'Departament';

  @override
  String get noDepartmentOption => 'Niciun departament';

  @override
  String get removeAnywayButton => 'Elimină oricum';

  @override
  String get branchTeamStructureTitle => 'Structura echipei filialei';

  @override
  String get noStaffAtBranchText => 'Niciun angajat la această filială încă.';

  @override
  String get changeManagerMenuItem => 'Schimbă managerul';

  @override
  String get moveDepartmentMenuItem => 'Mută departamentul/echipa';

  @override
  String get editJobTitleMenuItem => 'Editează funcția';

  @override
  String get removeFromBranchMenuItem => 'Elimină din această filială';

  @override
  String changeManagerTitle(String name) {
    return 'Schimbă managerul - $name';
  }

  @override
  String moveDepartmentTitle(String name) {
    return 'Mută departamentul/echipa - $name';
  }

  @override
  String changeTierTitle2(String name) {
    return 'Schimbă nivelul - $name';
  }

  @override
  String editJobTitleTitle(String name) {
    return 'Editează funcția - $name';
  }

  @override
  String removeFromBranchTitle(String name) {
    return 'Elimină $name din această filială';
  }

  @override
  String removeFromBranchConfirmText(String name) {
    return '$name nu se va mai putea autentifica. Aceasta poate fi anulată ulterior.';
  }

  @override
  String reportsWillBeUnassignedText(int count, String name, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count persoane raportează',
      one: '$count persoană raportează',
    );
    return '$_temp0 în prezent către $name: $names. Eliminarea $name îi va lăsa neatribuiți până la reatribuire.';
  }

  @override
  String reassignToManagerLabel(String name) {
    return 'Reatribuie-i în schimb managerului lui $name';
  }

  @override
  String reportsCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subordonați',
      one: '$count subordonat',
    );
    return '$_temp0';
  }

  @override
  String get regionalManagerAssignedTitle => 'Manager regional atribuit';

  @override
  String get noOrganisationOnSessionError =>
      'Nicio companie în această sesiune.';

  @override
  String get newRegionNameTitle => 'Nume regiune nouă';

  @override
  String get renameRegionTitle => 'Redenumește regiunea';

  @override
  String get renameVenueTitle => 'Redenumește localul';

  @override
  String get newVenueNameTitle => 'Nume local nou';

  @override
  String get doneButton => 'Gata';

  @override
  String get resetPasswordQuestionTitle => 'Resetezi parola?';

  @override
  String get resetButton => 'Resetează';

  @override
  String get passwordResetTitle => 'Parolă resetată';

  @override
  String get giveNewTempPasswordText =>
      'Dă-i acestei persoane noua parolă temporară.';

  @override
  String get organisationTitle => 'Companie';

  @override
  String get headOfficeLabel => 'Sediu Central';

  @override
  String get addRegionMenuItem => 'Adaugă regiune';

  @override
  String get addVenueNoRegionMenuItem => 'Adaugă local (fără regiune)';

  @override
  String get venuesNoRegionLabel => 'Localuri (fără regiune)';

  @override
  String get resetPasswordTooltip => 'Resetează parola';

  @override
  String get addVenueMenuItem => 'Adaugă local';

  @override
  String get assignRegionalManagerMenuItem => 'Atribuie manager regional';

  @override
  String get reassignRegionalManagerMenuItem => 'Reatribuie manager regional';

  @override
  String get noRegionalManagerYetText => 'Niciun manager regional încă';

  @override
  String get noVenuesInRegionText => 'Niciun local în această regiune încă.';

  @override
  String get noVenueManagerYetText => 'Niciun manager de local încă';

  @override
  String assignRegionalManagerTitle(String region) {
    return 'Atribuie manager regional - $region';
  }

  @override
  String accountLiveGiveSignInDetails(String name) {
    return 'Contul este acum activ. Dă-i lui $name detaliile de autentificare - folosește Acces conducere.';
  }

  @override
  String emailColonLabel(String email) {
    return 'Email: $email';
  }

  @override
  String temporaryPasswordColonLabel(String password) {
    return 'Parolă temporară: $password';
  }

  @override
  String resetPasswordConfirmText(String name) {
    return 'Aceasta invalidează imediat parola curentă a lui $name. Vei primi o nouă parolă temporară de transmis.';
  }

  @override
  String venueManagerSuffixLabel(String name) {
    return '$name  ·  Manager local';
  }

  @override
  String get noSignedInUserError => 'Niciun utilizator autentificat găsit.';

  @override
  String get customCategoryTitleLabel => 'Titlu categorie personalizat';

  @override
  String get approvalNoteLabel => 'Notă de aprobare / diligență (opțional)';

  @override
  String get supplierManagementTitle => 'Managementul furnizorilor';

  @override
  String get noSuppliersAddedYetText => 'Niciun furnizor adăugat încă.';

  @override
  String get inactiveStandaloneLabel => '(inactiv)';

  @override
  String get changeApprovalStatusMenuItem => 'Schimbă starea de aprobare';

  @override
  String editDetailsForSupplierTitle(String name) {
    return 'Editează detaliile - $name';
  }

  @override
  String changeApprovalStatusTitle(String name) {
    return 'Schimbă starea de aprobare - $name';
  }

  @override
  String get newVenueTypeTitle => 'Tip de local nou';

  @override
  String get renameOrganisationTitle => 'Redenumește compania';

  @override
  String get resetSetupCodeTitle => 'Resetezi codul de configurare?';

  @override
  String get resetSetupCodeConfirmText =>
      'Aceasta va deconecta fiecare tabletă care folosește în prezent acest local, până când primesc noul cod. Continui?';

  @override
  String get resetCodeButton => 'Resetează codul';

  @override
  String get createNewVenueTitle => 'Creează local nou';

  @override
  String get multiSiteSupportPartialText =>
      'Suportul pentru mai multe locații este parțial: echipamentele, personalul și listele de sarcini nu sunt încă filtrate pe local, deci utilizarea zilnică a unui al doilea local nu este încă complet susținută. Crearea unuia este sigură, dar vei vedea datele acestui local și ale localului original amestecate în liste comune până când asta va fi construit.';

  @override
  String get createButton => 'Creează';

  @override
  String get venueDetailsTitle => 'Detalii local';

  @override
  String get billingLabel => 'Facturare';

  @override
  String get billingSubtitleText => 'Plan, stare, Direct Debit';

  @override
  String get activeLabel => 'Activ';

  @override
  String get setAsActiveButton => 'Setează ca activ';

  @override
  String get tabletSetupCodeTitle => 'Cod de configurare tabletă';

  @override
  String get tabletSetupCodeExplanation =>
      'Introdu acest cod o dată pe o tabletă nouă ca să poată afișa lista de personal a acestui local.';

  @override
  String get generateCodeButton => 'Generează codul';

  @override
  String get venueTypeSectionTitle => 'Tip de local';

  @override
  String get renamePresetTitle => 'Redenumește setul';

  @override
  String get noTaskTemplatesExistYetText =>
      'Niciun șablon de sarcină nu există încă.';

  @override
  String get addTaskToPresetTitle => 'Adaugă sarcină la set';

  @override
  String get taskFieldLabel => 'Sarcină';

  @override
  String get defaultFrequencyLabel => 'Frecvență implicită';

  @override
  String get noPresetsYetText => 'Niciun set încă.';

  @override
  String get createPresetButton => 'Creează set';

  @override
  String get presetVerificationBannerText =>
      'Limitele sarcinilor sunt cercetate și documentate (marcate [LAW]/[FSA]/[BEST] în instrucțiunile fiecărei sarcini), dar nu au fost încă aprobate de un profesionist calificat în siguranța alimentară. Nu le trata ca fiind autoritare din punct de vedere legal până la verificare.';

  @override
  String get equipmentPresetsSectionTitle => 'Seturi de echipamente';

  @override
  String get sectionPresetsSectionTitle => 'Seturi de secțiuni';

  @override
  String get addTaskButton => 'Adaugă sarcină';

  @override
  String get newPresetSectionTitle => 'Set nou';

  @override
  String get sectionSegmentOptionalLabel => 'Secțiune / segment (opțional)';

  @override
  String get setEquipmentOrSectionHint =>
      'Setează un tip de echipament sau o secțiune (cel puțin una).';

  @override
  String equipmentTypeFallback(String id) {
    return 'Tip de echipament #$id';
  }

  @override
  String taskFallback(String id) {
    return 'Sarcină #$id';
  }

  @override
  String get departmentCategoryKitchen => 'Bucătărie';

  @override
  String get departmentCategoryFrontOfHouse => 'Sală';

  @override
  String get departmentCategoryBar => 'Bar';

  @override
  String get departmentCategoryManagement => 'Management';

  @override
  String get departmentCategoryMaintenance => 'Întreținere';

  @override
  String get departmentCategoryHousekeeping => 'Menaj';

  @override
  String get departmentCategoryReception => 'Recepție';

  @override
  String get departmentCategorySecurity => 'Securitate';

  @override
  String get addDepartmentButton => 'Adaugă departament';

  @override
  String get departmentManagementTitle => 'Managementul departamentelor';

  @override
  String get noDepartmentsAddedYetText => 'Niciun departament adăugat încă.';

  @override
  String get noTeamsYetText => 'Nicio echipă încă';

  @override
  String get editMenuItem => 'Editează';

  @override
  String get addTeamButton => 'Adaugă echipă';

  @override
  String editDepartmentTitle(String name) {
    return 'Editează - $name';
  }

  @override
  String addTeamTitle(String name) {
    return 'Adaugă echipă - $name';
  }

  @override
  String renameTeamTitle(String name) {
    return 'Redenumește - $name';
  }

  @override
  String teamCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count echipe',
      one: '$count echipă',
    );
    return '$_temp0';
  }

  @override
  String get documentCategoryPolicy => 'Politică';

  @override
  String get documentCategoryCertificate => 'Certificat';

  @override
  String get documentCategoryProcedure => 'Procedură';

  @override
  String get documentCategoryEhoReport => 'Raport EHO';

  @override
  String get addDocumentTitle => 'Adaugă document';

  @override
  String get noExpiryDateText => 'Fără dată de expirare';

  @override
  String get setExpiryButton => 'Setează expirarea';

  @override
  String get couldNotOpenFileText => 'Nu s-a putut deschide acest fișier.';

  @override
  String get documentCentreTitle => 'Centrul de documente';

  @override
  String get validLabel => 'Valid';

  @override
  String get expiringSoonLabel => 'Expiră curând';

  @override
  String get expiredLabel => 'Expirat';

  @override
  String get allFilterLabel => 'Toate';

  @override
  String get noDocumentsYetText => 'Niciun document încă.';

  @override
  String get openMenuItem => 'Deschide';

  @override
  String expiresOnLabel(String date) {
    return 'Expiră $date';
  }

  @override
  String get planFriends => 'Friends';

  @override
  String get planStandard => 'Standard';

  @override
  String get planPremier => 'Premier';

  @override
  String get noPlanSelectedText => 'Niciun plan selectat';

  @override
  String get codeNotRecognisedText => 'Acel cod nu a fost recunoscut.';

  @override
  String get couldNotReachServerText => 'Nu s-a putut contacta serverul.';

  @override
  String get discountAppliedText => 'Cod de reducere aplicat.';

  @override
  String get couldNotOpenBrowserText => 'Nu s-a putut deschide browserul';

  @override
  String get noSubscriptionFoundText =>
      'Niciun abonament găsit pentru această companie.';

  @override
  String get discountAppliedBadge => 'Reducere aplicată';

  @override
  String get directDebitSetUpText =>
      'Direct Debit este configurat pentru această companie.';

  @override
  String get directDebitNotSetUpText =>
      'Încă nu ai configurat Direct Debit. Vei fi dus la GoCardless - VenuRite nu vede niciodată detaliile tale bancare direct.';

  @override
  String get discountCodeOptionalLabel => 'Cod de reducere (opțional)';

  @override
  String get discountCodeHintText => 'Ai un cod \'Friends\'? Introdu-l aici';

  @override
  String get setUpDirectDebitButton => 'Configurează Direct Debit';

  @override
  String get freeAccessCodeTitle => 'Cod de acces gratuit';

  @override
  String get freeAccessActiveText =>
      'Accesul gratuit este activ pentru această companie - nu este necesar Direct Debit sau plată cu cardul.';

  @override
  String get freeAccessPromptText =>
      'Ai un cod de acces gratuit? Introdu-l aici pentru a folosi aplicația completă fără a configura plata.';

  @override
  String get redeemCodeButton => 'Revendică codul';

  @override
  String get onTrialText => 'În perioadă de probă';

  @override
  String get paymentFailedGraceText =>
      'O plată recentă a eșuat. Actualizează-ți Direct Debit-ul - accesul continuă în această perioadă de grație.';

  @override
  String get directDebitCancelledRestrictedText =>
      'Direct Debit-ul tău a fost anulat. Accesul este restricționat doar la citire până când facturarea este configurată din nou.';

  @override
  String get paymentOverdueRestrictedText =>
      'Plata este restantă de prea mult timp. Accesul este restricționat doar la citire până când aceasta este rezolvată.';

  @override
  String couldNotLoadBillingDetailsError(String error) {
    return 'Nu s-au putut încărca detaliile de facturare: $error';
  }

  @override
  String pricePerMonthBilledLabel(String price, int units) {
    return '$price GBP/lună ($units locații facturate)';
  }

  @override
  String onTrialUntilText(String date) {
    return 'În perioadă de probă până la $date';
  }

  @override
  String get reportedIssuesTitle => 'Probleme raportate';

  @override
  String get noDeliveriesLoggedText =>
      'Nicio livrare înregistrată pentru acest furnizor în această perioadă.';

  @override
  String get scorecardCategoriesExplanation =>
      'Fiecare categorie de mai jos se numără independent - o livrare poate apărea în mai multe rânduri (ex. întârziată ȘI deteriorată).';

  @override
  String get rejectedOutrightLabel => 'Respinsă complet';

  @override
  String get acceptedPartiallyLabel => 'Acceptată parțial';

  @override
  String get reportedIssuesExplanation =>
      'Probleme de aprovizionare raportate împotriva acestui furnizor - un jurnal separat de cardul de scor al livrărilor de mai sus, nefuzionat cu acesta.';

  @override
  String deliveryScorecardTitle(int count) {
    return 'Card de scor livrări ($count livrări)';
  }

  @override
  String countPercentLabel(int count, int rate) {
    return '$count ($rate%)';
  }

  @override
  String get missingNameError => 'Lipsește numele';

  @override
  String get missingJobTitleError => 'Lipsește funcția';

  @override
  String get pinMustBe4DigitsError =>
      'PIN-ul trebuie să aibă exact 4 cifre (sau lăsat gol)';

  @override
  String get bulkStaffImportTitle => 'Import în masă a personalului';

  @override
  String get csvColumnsInstructionsText =>
      'Coloane CSV: nume, funcție, nivel rol, rol de post (opțional), PIN (opțional). Un rând de antet e în regulă - e detectat automat. Lasă PIN-ul gol pentru a fi generat automat.';

  @override
  String get chooseCsvFileButton => 'Alege fișierul CSV';

  @override
  String get chooseDifferentFileButton => 'Alege alt fișier';

  @override
  String get noteDownPinsText =>
      ' Notează fiecare PIN mai jos înainte de a părăsi acest ecran.';

  @override
  String get importingEllipsisLabel => 'Se importă...';

  @override
  String roleTierMustBeOneOfError(String list) {
    return 'Nivelul rolului trebuie să fie unul dintre: $list';
  }

  @override
  String notAllowedToCreateTierError(String tier) {
    return 'Nu ai voie să creezi un cont $tier';
  }

  @override
  String jobRoleMustBeOneOfError(String list) {
    return 'Rolul de post trebuie să fie unul dintre: $list';
  }

  @override
  String csvExampleText(String example) {
    return 'Exemplu: $example';
  }

  @override
  String rowsFoundLabel(String fileName, int count) {
    return '$fileName - $count rânduri găsite';
  }

  @override
  String needFixingSuffix(int count) {
    return ', $count necesită corectare';
  }

  @override
  String createdCountLabel(int count) {
    return '$count create';
  }

  @override
  String failedSuffixLabel(int count) {
    return ', $count eșuate';
  }

  @override
  String importStaffCountButton(int count) {
    return 'Importă $count angajați';
  }

  @override
  String rowNumberFallback(int number) {
    return 'Rândul $number';
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
      'Nivel 2 Igienă și Siguranță Alimentară';

  @override
  String get trainingAllergenAwareness => 'Conștientizarea alergenilor';

  @override
  String get trainingCoshh =>
      'COSHH (Controlul substanțelor periculoase pentru sănătate)';

  @override
  String get trainingFireSafety => 'Siguranța la incendiu';

  @override
  String get trainingManualHandling => 'Manipulare manuală';

  @override
  String get trainingFirstAid => 'Prim ajutor la locul de muncă';

  @override
  String get trainingInduction => 'Inducție finalizată';

  @override
  String get itemFieldLabel => 'Element';

  @override
  String get customItemTitleLabel => 'Titlu element personalizat';

  @override
  String get expiryNoneLabel => 'Expirare: fără';

  @override
  String get clearExpiryTooltip => 'Șterge expirarea';

  @override
  String get certificateReferenceLabel => 'Referință certificat (opțional)';

  @override
  String get certificateReferenceHint => 'ex. număr certificat, furnizor';

  @override
  String get noTrainingRecordsYetText => 'Niciun dosar de instruire încă.';

  @override
  String get addRecordButton => 'Adaugă înregistrare';

  @override
  String get currentLabel => 'Curent';

  @override
  String get supersededLabel => '(înlocuit)';

  @override
  String get noExpiryLabel => 'Fără expirare';

  @override
  String addTrainingRecordTitle(String name) {
    return 'Adaugă înregistrare instruire - $name';
  }

  @override
  String completedOnLabel(String date) {
    return 'Finalizat: $date';
  }

  @override
  String expiryOnLabel(String date) {
    return 'Expirare: $date';
  }

  @override
  String trainingRecordsTitle(String name) {
    return 'Înregistrări de instruire - $name';
  }

  @override
  String fullHistoryLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Istoric complet ($count înregistrări anterioare)',
      one: 'Istoric complet ($count înregistrare anterioară)',
    );
    return '$_temp0';
  }

  @override
  String completedDateLabel(String date) {
    return 'Finalizat $date';
  }

  @override
  String certRefLabel(String ref) {
    return 'Ref: $ref';
  }

  @override
  String get twoFactorNowOnText =>
      'Autentificarea în doi pași este acum activă.';

  @override
  String get turnOffTwoFactorTitle => 'Dezactivezi autentificarea în doi pași?';

  @override
  String get turnOffTwoFactorConfirmText =>
      'Acest cont se va autentifica din nou doar cu o parolă.';

  @override
  String get turnOffButton => 'Dezactivează';

  @override
  String get twoFactorAuthTitle => 'Autentificare în doi pași';

  @override
  String get twoFactorOnText =>
      'Autentificarea în doi pași este ACTIVATĂ pentru acest cont.';

  @override
  String get twoFactorOffText =>
      'Autentificarea în doi pași este DEZACTIVATĂ - adaug-o pentru un nivel suplimentar de protecție pe acest cont de conducere.';

  @override
  String get enableTwoFactorButton => 'Activează autentificarea în doi pași';

  @override
  String get scanAuthenticatorText =>
      'Scanează asta cu aplicația ta de autentificare (Google Authenticator, Authy etc.), apoi introdu codul din 6 cifre pe care îl afișează.';

  @override
  String get cantScanManualEntryText =>
      'Nu poți scana? Introdu acest cod manual:';

  @override
  String get requiredFieldError => 'Obligatoriu';

  @override
  String get joinExistingCompanyTitle => 'Alătură-te unei companii existente';

  @override
  String get enterInviteCodeText =>
      'Introdu codul de invitație primit de la managerul tău.';

  @override
  String get inviteCodeLabel => 'Cod de invitație';

  @override
  String get yourNameLabel => 'Numele tău';

  @override
  String get yourEmailLabel => 'Emailul tău';

  @override
  String get enterValidEmailError => 'Introdu un email valid';

  @override
  String get choosePasswordLabel => 'Alege o parolă';

  @override
  String get joinButton => 'Alătură-te';

  @override
  String get youreInSignInText =>
      'Ai intrat. Autentifică-te cu emailul tău și parola pe care tocmai ai ales-o.';

  @override
  String get newBranchNameTitle => 'Nume filială nouă';

  @override
  String get renameBranchTitle => 'Redenumește filiala';

  @override
  String get branchManagerNameTitle => 'Numele managerului filialei';

  @override
  String get accountCreatedTitle => 'Cont creat';

  @override
  String get giveNameAndPinText =>
      'Dă-i acestei persoane numele (pentru a-l atinge pe ecranul de autentificare) și acest PIN.';

  @override
  String get branchesTitle => 'Filiale';

  @override
  String get noRegionSetText =>
      'Contul tău nu are o regiune setată - contactează-ți directorul.';

  @override
  String get noBranchesInRegionText => 'Nicio filială în regiunea ta încă.';

  @override
  String get addBranchManagerMenuItem => 'Adaugă manager de filială';

  @override
  String nameColonLabel(String name) {
    return 'Nume: $name';
  }

  @override
  String pinColonLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get deleteSelectedEvidenceTitle => 'Ștergi dovezile selectate?';

  @override
  String get deleteButton => 'Șterge';

  @override
  String get photoEvidenceTitle => 'Dovezi foto';

  @override
  String get onThisDeviceLabel => 'Pe acest dispozitiv';

  @override
  String get deletingFreesSpaceText =>
      'Ștergerea eliberează și spațiu pe dispozitiv. PDF-urile EHO exportate conțin deja propriile copii și nu sunt afectate.';

  @override
  String get noEvidencePhotosYetText => 'Nicio fotografie dovadă încă.';

  @override
  String deleteEvidenceConfirmText(int count, String bytes) {
    return 'Aceasta șterge definitiv $count fotografii ($bytes) de pe acest dispozitiv. PDF-urile deja exportate nu sunt afectate. Aceasta nu poate fi anulată.';
  }

  @override
  String evidencePhotosCountLabel(int count, String bytes) {
    return '$count fotografii dovadă · $bytes total';
  }

  @override
  String deleteSelectedButton(int count, String bytes) {
    return 'Șterge $count selectate ($bytes)';
  }

  @override
  String get addTeamMemberTitle => 'Adaugă membru al echipei';

  @override
  String get createsTapNamePinAccountText =>
      'Creează un cont cu nume-atins + PIN pentru propriul tău local.';

  @override
  String get createAccountButton => 'Creează cont';

  @override
  String get shiftLogTitle => 'Jurnal ture';

  @override
  String get noClockInsYetText => 'Nicio pontare înregistrată încă.';

  @override
  String get stillClockedInText => 'Încă pontat';

  @override
  String clockInLabel(String time) {
    return 'Intrare: $time';
  }

  @override
  String clockOutLabel(String time) {
    return 'Ieșire: $time';
  }

  @override
  String durationHoursMinutesLabel(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get inviteCreatedTitle => 'Invitație creată';

  @override
  String get orShareCodeText =>
      'Sau distribuie acest cod - îl introduc pe ecranul \"Alătură-te unei companii existente\":';

  @override
  String shareInviteExpiresText(int days) {
    return 'Distribuie asta persoanei care se alătură - funcționează o dată și expiră în $days zile.';
  }

  @override
  String get contactVenuRiteTitle => 'Contactează VenuRite';

  @override
  String get contactVenuRiteIntroText =>
      'Fie că ești un grup mare care are nevoie de ajutor la configurare, fie că ai doar o întrebare - suntem bucuroși să ajutăm.';

  @override
  String get emailUsButton => 'Trimite-ne un email';

  @override
  String taskCountOverdueLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sarcini restante',
      one: '$count sarcină restantă',
    );
    return '$_temp0';
  }

  @override
  String acrossStaffMembersLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'La $count angajați',
      one: 'La $count angajat',
    );
    return '$_temp0';
  }

  @override
  String moreStaffMembersLabel(int count) {
    return '+$count angajați în plus';
  }

  @override
  String failCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eșecuri',
      one: '$count eșec',
    );
    return '$_temp0';
  }

  @override
  String notCompletedCountLabel(int count) {
    return '$count neefectuate';
  }

  @override
  String issuesRaisedCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count probleme raportate',
      one: '$count problemă raportată',
    );
    return '$_temp0';
  }

  @override
  String shiftSummaryTitle(String name) {
    return 'Rezumatul turei - $name';
  }

  @override
  String get faqQ1 => 'Cine poate vedea ce înregistrez?';

  @override
  String get faqA1 =>
      'Managerul tău și oricine este deasupra lui în localul tău pot vedea sarcinile pe care le finalizezi. Unei persoane numite nu i se arată niciodată un scor evaluat sau un clasament - doar o listă simplă a ceea ce a făcut și când.';

  @override
  String get faqQ2 => 'Ce se întâmplă dacă ratez o sarcină în timpul turei?';

  @override
  String get faqA2 =>
      'Este înregistrată ca neefectuată, nu ca eșec - o sarcină abandonată la mijlocul turei este un comportament așteptat, permis, doar niciodată ascuns. Managerul tău o vede ca statut distinct, separat.';

  @override
  String get faqQ3 => 'Mă pot întoarce să termin o sarcină pe care am sărit-o?';

  @override
  String get faqA3 =>
      'Da, oricând înainte de sfârșitul turei - rămâne disponibilă în lista ta de sarcini până o finalizezi sau se termină tura.';

  @override
  String get faqQ4 =>
      'Ce se întâmplă dacă pic o verificare (ex. un frigider e prea cald)?';

  @override
  String get faqA4 =>
      'Înregistreaz-o ca EȘEC, notează acțiunea corectivă pe care ai luat-o (sau că ai raportat-o) și adaugă o fotografie dacă ți se cere. Exact pentru asta există sistemul - un EȘEC înregistrat cu o remediere este o poveste de succes pentru un inspector, nu o problemă pentru tine.';

  @override
  String get faqQ5 => 'Trebuie să pontez separat de autentificare?';

  @override
  String get faqA5 =>
      'Nu - autentificarea cu PIN-ul tău la începutul turei este pontarea ta de intrare. Folosește \'Încheie tura\' când termini, ceea ce îți arată și orice mai trebuie să finalizezi.';

  @override
  String get faqQ6 => 'Am raportat o problemă - ce se întâmplă cu ea?';

  @override
  String get faqA6 =>
      'Ajunge la managerul tău (sau escaladează mai departe dacă nu este gestionată la timp). Îi poți verifica starea oricând din \"Problemele mele raportate.\"';

  @override
  String get troubleQ1 => 'PIN-ul meu nu funcționează';

  @override
  String get troubleA1 =>
      'Verifică din nou dacă atingi mai întâi propriul nume, apoi introduci PIN-ul - un PIN greșit pe numele corect dă un mesaj clar de respingere. Dacă tot nu funcționează, cere unui manager să verifice dacă contul tău este activ și să-ți reseteze PIN-ul dacă e nevoie.';

  @override
  String get troubleQ2 =>
      'O sarcină pe care ar trebui să o am lipsește din lista mea';

  @override
  String get troubleA2 =>
      'Cere managerului tău să verifice dacă e atribuită rolului/secțiunii tale în Atribuire Sarcini. Sarcinile apar doar pentru rolurile și departamentele pentru care au fost activate.';

  @override
  String get troubleQ3 => 'Aplicația nu mă lasă să fac o fotografie';

  @override
  String get troubleA3 =>
      'Asigură-te că aplicația are permisiunea camerei (verifică setările dispozitivului). Pe Windows, dacă nu este detectată nicio cameră, ți se va oferi în schimb un selector de fișiere.';

  @override
  String get troubleQ4 =>
      'Nu pot trimite o verificare / nu se întâmplă nimic când apăs Trimite';

  @override
  String get troubleA4 =>
      'Acest lucru se poate întâmpla dacă contul companiei tale necesită atenție la facturare - vei vedea un mesaj clar dacă e cazul. Altfel, verifică dacă fiecare câmp obligatoriu (inclusiv orice fotografie) este completat.';

  @override
  String get troubleQ5 => 'Aplicația pare blocată / înghețată';

  @override
  String get troubleA5 =>
      'Încearcă să o închizi și să o redeschizi. Progresul tău până la ultima sarcină finalizată este mereu salvat pe măsură ce avansezi, așa că nimic deja trimis nu se pierde.';

  @override
  String get troubleQ6 => 'Nu văd aceleași sarcini ca ieri';

  @override
  String get troubleA6 =>
      'Este normal dacă programul tău include sarcini ad hoc sau sarcini legate de o fereastră de timp - apar doar când sunt scadente. Întreabă-ți managerul dacă ceva pare cu adevărat în neregulă.';

  @override
  String taskOverdueSinceLabel(String title, String date) {
    return '$title - restantă din $date';
  }

  @override
  String get uploadCertificateDocumentButton =>
      'Încarcă fotografia certificatului';

  @override
  String get certificateDocumentUploadedLabel => 'Certificat încărcat';

  @override
  String get viewCertificateDocumentTooltip =>
      'Vizualizează documentul certificatului';

  @override
  String get certificateUploadFailed =>
      'Certificatul nu a putut fi încărcat. Vă rugăm să încercați din nou.';

  @override
  String get certificationRequirementsTitle => 'Cerințe de certificare';

  @override
  String get certificationRequirementsFloorNotice =>
      'Unele certificări sunt întotdeauna necesare pentru anumite roluri și nu pot fi eliminate aici (de ex. rolurile de manipulare a alimentelor necesită întotdeauna Igiena Alimentară Nivel 2 și Conștientizarea Alergenilor). Puteți adăuga cerințe suplimentare mai jos.';

  @override
  String get noExtraCertificationRequirementsText =>
      'Nu au fost adăugate cerințe suplimentare încă.';

  @override
  String get addRequirementButton => 'Adaugă cerință';

  @override
  String get addCertificationRequirementTitle =>
      'Adaugă cerință de certificare';

  @override
  String get removeCertificationRequirementTitle =>
      'Eliminați această cerință?';

  @override
  String get removeCertificationRequirementBody =>
      'Personalul din acest rol nu va mai avea nevoie de această certificare pentru a fi programat. Acest lucru nu afectează certificările întotdeauna necesare.';

  @override
  String get removeButton => 'Elimină';

  @override
  String get cannotClaimShiftTitle => 'Nu poți prelua încă acest tur';

  @override
  String missingCertificationsMessage(String certs) {
    return 'Acest rol necesită următoarele, care lipsesc sau au expirat: $certs. Întreabă-ți managerul despre reînnoirea acestora.';
  }

  @override
  String cannotAssignShiftTitle(String name) {
    return 'Nu se poate atribui acest tur lui $name';
  }

  @override
  String get allergenCelery => 'Țelină';

  @override
  String get allergenGluten => 'Cereale care conțin gluten';

  @override
  String get allergenCrustaceans => 'Crustacee';

  @override
  String get allergenEggs => 'Ouă';

  @override
  String get allergenFish => 'Pește';

  @override
  String get allergenLupin => 'Lupin';

  @override
  String get allergenMilk => 'Lapte';

  @override
  String get allergenMolluscs => 'Moluște';

  @override
  String get allergenMustard => 'Muștar';

  @override
  String get allergenTreeNuts => 'Fructe cu coajă lemnoasă';

  @override
  String get allergenPeanuts => 'Arahide';

  @override
  String get allergenSesame => 'Semințe de susan';

  @override
  String get allergenSoya => 'Soia';

  @override
  String get allergenSulphites => 'Dioxid de sulf și sulfiți';

  @override
  String get allergenStatusContains => 'Conține';

  @override
  String get allergenStatusMayContain => 'Poate conține';

  @override
  String get menuManagementTitle => 'Meniu și alergeni';

  @override
  String get addDishButton => 'Adaugă fel de mâncare';

  @override
  String get addDishTitle => 'Adaugă un fel de mâncare';

  @override
  String get dishNameLabel => 'Numele felului de mâncare';

  @override
  String get dishCategoryLabel => 'Categorie (opțional)';

  @override
  String get noDishesYetText => 'Nu au fost adăugate feluri de mâncare încă.';

  @override
  String get draftLabel => 'Ciornă';

  @override
  String get addIngredientTitle => 'Adaugă ingredient';

  @override
  String get ingredientNameLabel => 'Numele ingredientului';

  @override
  String get addButton => 'Adaugă';

  @override
  String get addIngredientButton => 'Adaugă ingredient';

  @override
  String get ingredientsHeading => 'Ingrediente';

  @override
  String get suggestedAllergensHeading =>
      'Alergeni sugerați (încă nepublicați)';

  @override
  String get publishedAllergensHeading => 'Alergeni publicați';

  @override
  String get noAllergensIdentifiedText =>
      'Niciun alergen identificat din ingredientele actuale.';

  @override
  String get reviewAllergensTitle => 'Verifică alergenii înainte de publicare';

  @override
  String get allergenStatusNone => 'Niciunul';

  @override
  String get approveButton => 'Aprobă și publică';

  @override
  String get reviewAndApproveButton => 'Verifică și aprobă';

  @override
  String get reviewAndReapproveButton => 'Verifică și reaprobă';

  @override
  String get allergenMatrixTitle => 'Matrice de alergeni';

  @override
  String get allergenMatrixLegend => 'Legendă';

  @override
  String get noApprovedDishesYetText =>
      'Niciun fel de mâncare aprobat încă. Cere unui manager să revizuiască și să aprobe felurile de mâncare în Meniu și alergeni.';

  @override
  String get exportAsPdfButton => 'Exportă ca PDF';

  @override
  String get allergenMatrixSubtitle =>
      'Verifica ce contine un fel de mancare inainte sa ajunga la client';
}
