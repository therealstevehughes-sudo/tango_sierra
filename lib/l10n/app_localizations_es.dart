// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'VenuRite';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get personalSection => 'Personal';

  @override
  String get languageSettingTitle => 'Idioma';

  @override
  String get languageSettingSubtitle =>
      'Elige el idioma en el que quieres usar VenuRite.';

  @override
  String get languageUpdated => 'Idioma actualizado.';

  @override
  String get chooseLanguageTitle => 'Elegir idioma';

  @override
  String get languageDeviceScope =>
      'Se usa en este dispositivo antes de que el personal inicie sesión.';

  @override
  String languageUserScope(String name) {
    return 'Guardado para $name.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get done => 'Listo';

  @override
  String get login => 'INICIAR SESIÓN';

  @override
  String get back => 'Atrás';

  @override
  String get enterPin => 'Introduce el PIN';

  @override
  String get leadershipAccess => 'Acceso para responsables';

  @override
  String get notOnThisList =>
      '¿No apareces en esta lista? Inicia sesión de otra forma';

  @override
  String errorLoadingStaff(String error) {
    return 'Error al cargar el personal: $error';
  }

  @override
  String get incorrectPin => 'PIN incorrecto';

  @override
  String tooManyWrongAttempts(int minutes) {
    return 'Demasiados intentos incorrectos. Inténtalo de nuevo en $minutes min.';
  }

  @override
  String get accountNotFound => 'Cuenta no encontrada';

  @override
  String get getStarted => 'Empezar';

  @override
  String get kitchenComplianceDoneRight =>
      'Cumplimiento en cocina, claro y fiable';

  @override
  String get valuePointEhoReady =>
      'Siempre listo para una inspección sanitaria: registros en tiempo real, sin prisas de última hora';

  @override
  String get valuePointHonestRecords =>
      'Diseñado para que los resultados no se puedan manipular: cada comprobación queda respaldada';

  @override
  String get valuePointAuditExport =>
      'Exportación de auditoría con un toque: entrega al inspector un registro real al instante';

  @override
  String get howGetStarted => '¿Cómo quieres empezar?';

  @override
  String get setUpMyBusiness => 'Configurar mi local';

  @override
  String get teamAlreadyUses => 'Mi equipo ya usa VenuRite';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? Inicia sesión';

  @override
  String get needHelpContact => '¿Necesitas ayuda? Contacta con VenuRite';

  @override
  String get signInAnotherWay => 'Inicia sesión de otra forma';

  @override
  String get deviceNotSetUp => 'Esta tablet aún no está configurada';

  @override
  String get askManagerSetupCode =>
      'Pide a un responsable el código de configuración de este local.';

  @override
  String get setupCode => 'Código de configuración';

  @override
  String get connectTablet => 'Conectar esta tablet';

  @override
  String get couldNotReachServer => 'No se pudo contactar con el servidor';

  @override
  String get stillStuckSetupCode =>
      '¿Sigues sin poder avanzar? Un responsable puede encontrarlo en Ajustes -> Detalles del local.';

  @override
  String get askQuestionTitle => 'Hacer una pregunta';

  @override
  String get askQuestionLabel => '¿Qué quieres saber?';

  @override
  String get askQuestionHint =>
      'p. ej. ¿a qué temperatura debe estar un frigorífico?';

  @override
  String get ask => 'Preguntar';

  @override
  String get aiQuestionLimitReached =>
      'Se ha alcanzado el límite mensual de preguntas de IA';

  @override
  String get home => 'Inicio';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get endShift => 'Terminar turno';

  @override
  String get workerHubPrompt => '¿Qué quieres hacer?';

  @override
  String get myScheduledTasks => 'Mis tareas programadas';

  @override
  String get doAdHocTask => 'Hacer una tarea ad hoc';

  @override
  String get logSomethingHappened => 'Registrar algo que acaba de pasar';

  @override
  String get claimShift => 'Tomar un turno';

  @override
  String get requestDayOff => 'Solicitar un día libre';

  @override
  String get thingsIReported => 'Cosas que he comunicado';

  @override
  String shiftWelcome(String firstName) {
    return 'Bienvenido/a, $firstName';
  }

  @override
  String get shiftPlanIntro => 'Esto es lo previsto para tu turno:';

  @override
  String get startOfShift => 'Inicio del turno';

  @override
  String get duringYourShift => 'Durante tu turno';

  @override
  String get endOfShift => 'Fin del turno';

  @override
  String get shiftHandoverTitle => 'Traspaso de turno';

  @override
  String get shiftHandoverNeedsAttention =>
      'Esto todavía necesita la atención del siguiente turno';

  @override
  String get gotIt => 'Entendido';

  @override
  String get openIssues => 'Problemas abiertos';

  @override
  String get flaggedEquipment => 'Equipo señalado';

  @override
  String get notYetDoneToday => 'Aún no realizado hoy';

  @override
  String get takePhoto => 'Hacer foto';

  @override
  String get uploadFromFiles => 'Subir desde archivos';

  @override
  String get seeAllTasksTooltip => 'Ver todas las tareas';

  @override
  String get leaveBeforeFinishingTitle => '¿Salir antes de terminar?';

  @override
  String get leaveBeforeFinishingBody =>
      'Algunas comprobaciones no están completas. Esto quedará registrado. Puedes volver y terminar en cualquier momento de este turno.';

  @override
  String get enterValue => 'Introduce un valor';

  @override
  String enterValueWithUnit(String unit) {
    return 'Introduce un valor ($unit)';
  }

  @override
  String safeRangeLabel(String min, String max) {
    return 'Rango seguro: $min - $max';
  }

  @override
  String get errorNumericRequired => 'Se requiere un valor numérico válido';

  @override
  String get errorSelectOption => 'Selecciona una opción';

  @override
  String get errorNotesRequired => 'Se requieren notas';

  @override
  String get errorPhotoRequired => 'Se requiere una foto';

  @override
  String get errorCorrectiveActionRequired =>
      'Elige cómo se gestionó la acción correctiva';

  @override
  String get myTasksTitle => 'Mis tareas';

  @override
  String get taskTitleFallback => 'Tarea';

  @override
  String get noTasksAssigned => 'Aún no hay tareas asignadas.';

  @override
  String get overdueLabel => 'Atrasada';

  @override
  String overdueSinceLabel(String date) {
    return 'Atrasada desde $date';
  }

  @override
  String get withinRangePass => 'Dentro del rango - APTO';

  @override
  String get outsideRangeFail => 'Fuera del rango - NO APTO';

  @override
  String get selectOptionLabel => 'Selecciona una opción';

  @override
  String get notesLabel => 'Notas';

  @override
  String get spotCheckPhotoNotice =>
      'Comprobación puntual de hoy: esta vez se necesita una foto para confirmar que realmente se hizo.';

  @override
  String get photoAdded => 'Foto añadida';

  @override
  String get addPhoto => 'Añadir foto';

  @override
  String get passLabel => 'APTO';

  @override
  String get failLabel => 'NO APTO';

  @override
  String get readingOutsideSafeRange =>
      'La lectura está fuera del rango seguro';

  @override
  String get hereIsWhatToDo => 'Esto es lo que hay que hacer:';

  @override
  String get correctiveActionRequired => 'Se requiere una acción correctiva';

  @override
  String get iFixedIt => 'Lo he arreglado';

  @override
  String get reportedToManager => 'Notificado al responsable';

  @override
  String get correctiveActionNoteLabel => '¿Qué hiciste? (opcional)';

  @override
  String get managerWillBeNotified => 'Se notificará a tu responsable.';

  @override
  String get submitButton => 'ENVIAR';

  @override
  String availableFrom(String time) {
    return 'Disponible desde las $time';
  }

  @override
  String get backToList => 'Volver a la lista';

  @override
  String get skipComesBackLater => 'Omitir - vuelve más tarde';

  @override
  String get noAdHocTaskTypesSetUp =>
      'Todavía no hay tipos de tareas puntuales configurados en este local - pide a un responsable que asigne primero una plantilla de control de entrega o de temperatura.';

  @override
  String get whatKindOfThing => '¿Qué tipo de cosa estás haciendo?';

  @override
  String get notesOptionalLabel => 'Notas (opcional)';

  @override
  String get noteOptionalLabel => 'Nota (opcional)';

  @override
  String get temperatureCelsiusLabel => 'Temperatura (°C)';

  @override
  String get submitLabel => 'Enviar';

  @override
  String get logReadingButton => 'Registrar lectura';

  @override
  String get loggedThanksMessage => 'Registrado. Gracias por anotarlo.';

  @override
  String get logAnotherAdHocTask => 'Registrar otra tarea puntual';

  @override
  String get deliveryCheckLabel => 'Control de entrega';

  @override
  String get temperatureCheckLabel => 'Control de temperatura';

  @override
  String get sessionSummaryTitle => 'Resumen del turno';

  @override
  String tasksCompletedCount(int count) {
    return 'Tareas completadas: $count';
  }

  @override
  String get passedLabel => 'Aptas';

  @override
  String get failedLabel => 'No aptas';

  @override
  String get triggersFailedTasks => 'Alertas / Tareas no aptas';

  @override
  String get yourReliability => 'Tu fiabilidad';

  @override
  String get reliabilityExplanation =>
      'Últimos 30 días: comprobaciones realizadas y registradas a tiempo. Un fallo registrado cuenta igual que un resultado apto registrado: esto solo mide si y cuándo comprobaste.';

  @override
  String completedPercentChip(int percent) {
    return '$percent% completado';
  }

  @override
  String onTimePercentChip(int percent) {
    return '$percent% a tiempo';
  }

  @override
  String get sendSummaryToManager =>
      'Enviar este resumen a un responsable (opcional)';

  @override
  String get noManagersSetUp => 'Aún no hay responsables configurados.';

  @override
  String get managerLabel => 'Responsable';

  @override
  String get sentLabel => 'Enviado';

  @override
  String get sendLabel => 'Enviar';

  @override
  String get leaveNoteForNextShift =>
      'Deja una nota para el siguiente turno (opcional)';

  @override
  String get handoverNoteLabel => 'Nota de traspaso';

  @override
  String get doneLabel => 'Hecho';

  @override
  String get supplierOptionalLabel => 'Proveedor (opcional)';

  @override
  String supplierWarningRecorded(String status) {
    return 'Este proveedor está marcado como $status - la comprobación se registrará igualmente.';
  }

  @override
  String get reportProblemWithDelivery =>
      'Informar de un problema con esta entrega';

  @override
  String get temperatureOnArrivalLabel =>
      'Temperatura a la llegada (°C, opcional)';

  @override
  String get problemsTickAnyApply => 'Problemas (marca los que correspondan)';

  @override
  String get shortDeliveryLabel => 'Entrega incompleta';

  @override
  String get damagedStockLabel => 'Mercancía dañada';

  @override
  String get lateDeliveryLabel => 'Entrega tardía';

  @override
  String get qualityProblemLabel => 'Problema de calidad';

  @override
  String get outcomeLabel => 'Resultado';

  @override
  String get acceptedLabel => 'Aceptada';

  @override
  String get rejectedLabel => 'Rechazada';

  @override
  String get partiallyAcceptedLabel => 'Aceptada parcialmente';

  @override
  String get noCameraFound =>
      'No se encontró ninguna cámara en este dispositivo.';

  @override
  String couldNotStartCamera(String error) {
    return 'No se pudo iniciar la cámara: $error';
  }

  @override
  String couldNotSwitchCamera(String error) {
    return 'No se pudo cambiar de cámara: $error';
  }

  @override
  String couldNotCapturePhoto(String error) {
    return 'No se pudo capturar la foto: $error';
  }

  @override
  String get switchCameraTooltip => 'Cambiar cámara';

  @override
  String get allTasksTitle => 'Todas las tareas';

  @override
  String get otherSegmentLabel => 'Otros';

  @override
  String get reorderTasksTitle => 'Reordenar tareas';

  @override
  String get ungroupedLabel => 'Sin agrupar';

  @override
  String get taskOrderSaved => 'Orden de tareas guardado.';

  @override
  String couldNotSaveTaskOrder(String error) {
    return 'No se pudo guardar el orden de las tareas: $error';
  }

  @override
  String get noVenueSelectedReorder =>
      'Todavía no hay ningún local seleccionado. Establece un local activo desde Detalles del local antes de reordenar las tareas.';

  @override
  String get noActiveTasksToReorder =>
      'Todavía no hay tareas activas para reordenar. Asigna tareas primero y luego vuelve aquí para elegir su orden.';

  @override
  String get savingEllipsis => 'Guardando…';

  @override
  String get saveOrderLabel => 'Guardar orden';

  @override
  String get moveUpTooltip => 'Subir';

  @override
  String get moveDownTooltip => 'Bajar';

  @override
  String get accountRestrictedTitle => 'Cuenta restringida';

  @override
  String get accountRestrictedBody =>
      'El adeudo directo de esta organización necesita atención antes de que se puedan guardar nuevas comprobaciones. Tu trabajo no se ha perdido: dile a un responsable o director que resuelva el tema de facturación y vuelve a intentarlo.';

  @override
  String get okLabel => 'Aceptar';

  @override
  String get troubleshootingTitle => 'Solución de problemas';

  @override
  String get faqTitle => 'Preguntas frecuentes';

  @override
  String get helpTitle => 'Ayuda';

  @override
  String get couldntReachAssistant => 'No se pudo contactar con el asistente';

  @override
  String get aiOfflineBody =>
      'El asistente de IA no está disponible ahora mismo - puede ser tu conexión o que el servicio esté caído temporalmente. Mientras tanto, las Preguntas frecuentes y Solución de problemas de abajo cubren las dudas más comunes, o contacta directamente con VenuRite.';

  @override
  String get askQuestionSubtitle =>
      'Obtén una respuesta clara, en lenguaje sencillo';

  @override
  String get faqSubtitle => 'Preguntas frecuentes, respondidas';

  @override
  String get troubleshootingSubtitle => '¿Algo no funciona? Empieza aquí';

  @override
  String get contactVenuriteTitle => 'Contactar con VenuRite';

  @override
  String get contactVenuriteSubtitle => 'Ponte en contacto directamente';

  @override
  String get topTierViewTitle => 'Vista de nivel superior';

  @override
  String get everythingsDone => 'Todo hecho. Buen trabajo.';

  @override
  String tasksNotCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas sin completar:',
      one: '1 tarea sin completar:',
    );
    return '$_temp0';
  }

  @override
  String get backToShiftLabel => 'Volver al turno';

  @override
  String get finishShiftLabel => 'Terminar turno';

  @override
  String get ehoAuditExportTitle => 'Exportación EHO / Auditoría';

  @override
  String get ehoExportDescription =>
      'Genera un PDF con los registros de cumplimiento de este local para el intervalo de fechas elegido.';

  @override
  String dateRangeValue(String start, String end) {
    return '$start - $end';
  }

  @override
  String get selectDateRangeLabel => 'Seleccionar intervalo de fechas';

  @override
  String get tapToChooseDates =>
      'Toca para elegir una fecha de inicio y de fin.';

  @override
  String get includeFullDetailedLog => 'Incluir registro detallado completo';

  @override
  String get fullLogSubtitle =>
      'Desactivado por defecto: el resumen y las excepciones de arriba son lo que realmente revisa un inspector; esto añade cada comprobación individual.';

  @override
  String get generateLabel => 'Generar';

  @override
  String get exportFailedTitle => 'Error en la exportación';

  @override
  String exportFailedBody(String error) {
    return 'Error en la exportación: $error';
  }

  @override
  String get exportCreatedTitle => 'Exportación creada';

  @override
  String savedToLabel(String path) {
    return 'Guardado en:\n$path';
  }
}
