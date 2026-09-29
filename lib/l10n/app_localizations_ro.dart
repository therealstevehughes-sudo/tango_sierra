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
}
