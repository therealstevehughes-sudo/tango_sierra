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

  @override
  String get dashboardTitle => 'Panel';

  @override
  String get noVenueFound => 'No se encontró ningún local.';

  @override
  String get allPermittedVenuesLast30Days =>
      'Todos los locales permitidos · últimos 30 días';

  @override
  String get last30Days => 'Últimos 30 días';

  @override
  String failCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NO APTOS (30 días)',
      one: '1 NO APTO (30 días)',
    );
    return '$_temp0';
  }

  @override
  String overdueCountLabel(int count) {
    return '$count atrasadas';
  }

  @override
  String get venuesSectionTitle => 'Locales';

  @override
  String get teamSectionTitle => 'Equipo';

  @override
  String get noStaffAtVenue => 'Aún no hay personal en este local.';

  @override
  String get notEnoughDataYet => 'Datos insuficientes';

  @override
  String get venueFallbackLabel => 'Local';

  @override
  String get trendsTitle => 'Tendencias';

  @override
  String get trendNeedsHistory =>
      'Datos de tendencia: se necesitan al menos 4 semanas de historial para mostrar una tendencia.';

  @override
  String perVenueWeeklyCompletion(int weeks) {
    return 'Finalización semanal por local · últimas $weeks semanas';
  }

  @override
  String get allVenuesCombined => 'Todos los locales combinados';

  @override
  String get noVenuesYet => 'Aún no hay locales.';

  @override
  String get otherVenuesLabel => 'Otros locales';

  @override
  String lowLoggingFlagLabel(int completed, int total) {
    return '$completed de $total comprobaciones registradas';
  }

  @override
  String regionFallbackLabel(int id) {
    return 'Región n.º $id';
  }

  @override
  String get dashboardOverviewTitle => 'Resumen del panel';

  @override
  String get gradedBarsOnTooltip => 'Barras calificadas por empleado: activado';

  @override
  String get gradedBarsOffTooltip =>
      'Barras calificadas por empleado: desactivado';

  @override
  String get noBranchesToShow => 'Aún no hay locales que mostrar.';

  @override
  String get supervisorNoScopeMessage =>
      'Todavía no se te ha asignado a una sección o equipo - pide a un responsable que lo configure en Gestión de personal antes de que este panel tenga algo que mostrar.';

  @override
  String get individualViewNotice =>
      'Vista individual - para supervisión de riesgos, no una clasificación.';

  @override
  String get branchLabel => 'Local';

  @override
  String get allBranchesLabel => 'Todos los locales';

  @override
  String get yourSectionLabel => 'Tu sección';

  @override
  String get noneAssignedLabel => 'Ninguna asignada';

  @override
  String get areaLabel => 'Zona';

  @override
  String get allAreasLabel => 'Todas las zonas';

  @override
  String get employeeLabel => 'Empleado';

  @override
  String get allEmployeesLabel => 'Todos los empleados';

  @override
  String get monthLabel => 'Mes';

  @override
  String get weekLabel => 'Semana';

  @override
  String get dayLabel => 'Día';

  @override
  String get noTaskActivityPeriod => 'Sin actividad de tareas en este periodo.';

  @override
  String get taskOverviewTitle => 'Resumen de tareas';

  @override
  String get incidentsTitle => 'Incidencias';

  @override
  String get noIncidentsPeriod =>
      'No se han notificado incidencias en este periodo.';

  @override
  String urgentCountLabel(int count) {
    return '$count urgentes';
  }

  @override
  String get tapForDetailsHint =>
      'Toca una sección de color o una leyenda para ver detalles';

  @override
  String get employeeFallbackLabel => 'Empleado';

  @override
  String get plainLookupNotice =>
      'Una simple consulta, no una puntuación - el color de finalización y las etiquetas de incidencias nunca se califican por persona aquí.';

  @override
  String tasksCompletedCountParens(int count) {
    return 'Tareas completadas ($count)';
  }

  @override
  String issuesRaisedCountParens(int count) {
    return 'Incidencias notificadas ($count)';
  }

  @override
  String get doneOnTimeNoIssues => 'Hecho a tiempo (sin incidencias)';

  @override
  String get doneOnTimeIssuesLogged =>
      'Hecho a tiempo (incidencias registradas)';

  @override
  String get doneEarlyLateNoIssues => 'Hecho antes/después (sin incidencias)';

  @override
  String get doneEarlyLateIssuesLogged =>
      'Hecho antes/después (incidencias registradas)';

  @override
  String get notDoneLabel => 'No hecho';

  @override
  String get resolvedLabel => 'Resueltas';

  @override
  String get unresolvedLabel => 'Sin resolver';

  @override
  String get escalatedLabel => 'Escaladas';

  @override
  String get urgentLabel => 'Urgente';

  @override
  String get signInFailed => 'Error al iniciar sesión';

  @override
  String get twoFactorRequiredNoFactor =>
      'Se requiere verificación en dos pasos, pero no se encontró ningún factor.';

  @override
  String get couldNotVerifyCode => 'No se pudo verificar ese código';

  @override
  String get codeDidntWork => 'Ese código no funcionó.';

  @override
  String get accountNotLinkedToStaff =>
      'Esta cuenta aún no está vinculada a un perfil de personal - contacta con un administrador.';

  @override
  String get resetPasswordTitle => 'Restablecer contraseña';

  @override
  String get enterEmailForResetCode =>
      'Introduce tu correo y te enviaremos un código para restablecer tu contraseña.';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get sendCodeButton => 'ENVIAR CÓDIGO';

  @override
  String get backToSignIn => 'Volver a iniciar sesión';

  @override
  String sentCodeToEmail(String email) {
    return 'Enviamos un código a $email. Introdúcelo a continuación junto con tu nueva contraseña.';
  }

  @override
  String get sixDigitCodeLabel => 'Código de 6 dígitos';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get resetPasswordButton => 'RESTABLECER CONTRASEÑA';

  @override
  String get twoFactorVerificationTitle => 'Verificación en dos pasos';

  @override
  String get enterAuthenticatorCode =>
      'Introduce el código de tu aplicación de autenticación.';

  @override
  String get verifyButton => 'VERIFICAR';

  @override
  String get regionalDirectorSignIn => 'Inicio de sesión Regional y Director.';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get signInButton => 'INICIAR SESIÓN';

  @override
  String get forgotPasswordLink => '¿Olvidaste tu contraseña?';

  @override
  String get noBackendConfiguredPin =>
      'No hay ningún backend configurado para esta instalación - inicia sesión con un PIN, igual que todos los demás.';

  @override
  String get noDirectorRegionalAccounts =>
      'No hay cuentas de Director/Regional en este dispositivo.';

  @override
  String get directorLabel => 'Director';

  @override
  String get regionalManagerLabel => 'Gerente regional';

  @override
  String get whoAreYouTitle => '¿Quién eres?';

  @override
  String get searchLabel => 'Buscar';

  @override
  String get noMatchesLabel => 'Sin resultados';

  @override
  String get leadershipSectionTitle => 'Dirección';

  @override
  String get kitchenStaffSectionTitle => 'Personal de cocina';

  @override
  String get chooseASectionTitle => 'Elige una sección';

  @override
  String get unassignedLabel => 'Sin asignar';

  @override
  String personCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personas',
      one: '$count persona',
    );
    return '$_temp0';
  }

  @override
  String get goodMorning => 'Buenos días';

  @override
  String get goodAfternoon => 'Buenas tardes';

  @override
  String get goodEvening => 'Buenas noches';

  @override
  String get welcomeToVenurite => 'Bienvenido a VenuRite';

  @override
  String get helpAssistantTooltip => 'Ayuda y asistente';

  @override
  String get couldntLoadScreen => 'No se pudo cargar esta pantalla.';

  @override
  String get retryLabel => 'Reintentar';

  @override
  String get microphonePermissionDenied =>
      'Se denegó el permiso del micrófono.';

  @override
  String get couldntRecordTryAgain => 'No se pudo grabar - inténtalo de nuevo.';

  @override
  String get couldntTranscribe => 'No se pudo transcribir eso.';

  @override
  String get couldntReachTranscriptionService =>
      'No se pudo contactar con el servicio de transcripción.';

  @override
  String get dictateANote => 'Dictar una nota';

  @override
  String get stoppingSoonTapToStop =>
      'Se detendrá pronto - toca para detener ahora';

  @override
  String get stopLabel => 'Detener';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String alertsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertas',
      one: '1 alerta',
    );
    return '$_temp0';
  }

  @override
  String unacknowledgedCountLabel(int count) {
    return '$count sin confirmar';
  }

  @override
  String get allAcknowledgedLabel => 'Todo confirmado';

  @override
  String overdueUnacknowledgedMinutes(int minutes) {
    return 'ATRASADO - sin confirmar desde hace $minutes min';
  }

  @override
  String get escalatedToTopTier => 'Escalado al nivel superior';

  @override
  String get acknowledgeLabel => 'Confirmar';

  @override
  String get nothingInCategory => 'Nada en esta categoría.';

  @override
  String categoryWithCountLabel(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get leadershipOverview => 'Resumen de dirección';

  @override
  String get photoEvidence => 'Evidencia fotográfica';

  @override
  String get staffManagement => 'Gestión de personal';

  @override
  String get addTeamMember => 'Añadir miembro del equipo';

  @override
  String get shiftLog => 'Registro de turnos';

  @override
  String get branchTeamStructure => 'Estructura del equipo del local';

  @override
  String get departmentManagement => 'Gestión de departamentos';

  @override
  String get rosterBoard => 'Panel de turnos';

  @override
  String get claimShifts => 'Reclamar turnos';

  @override
  String get requestADayOff => 'Solicitar un día libre';

  @override
  String get shiftFairnessReview => 'Revisión de equidad de turnos';

  @override
  String get venueDetails => 'Detalles del local';

  @override
  String get assignTasks => 'Asignar tareas';

  @override
  String get taskPresets => 'Plantillas de tareas';

  @override
  String get supplierManagement => 'Gestión de proveedores';

  @override
  String get serviceProviders => 'Proveedores de servicios';

  @override
  String get notificationRules => 'Reglas de notificación';

  @override
  String get documentCentre => 'Centro de documentos';

  @override
  String get setupWizard => 'Asistente de configuración';

  @override
  String get organisationLabel => 'Organización';

  @override
  String get branchesLabel => 'Locales';

  @override
  String get homeLabel => 'Inicio';

  @override
  String get oversightLabel => 'Supervisión';

  @override
  String get problemsAndIssues => 'Problemas e incidencias';

  @override
  String get twoFactorAuthentication => 'Autenticación en dos pasos';

  @override
  String get backUpNow => 'Hacer copia de seguridad ahora';

  @override
  String get dailySection => 'Diario';

  @override
  String get insightsSection => 'Análisis';

  @override
  String get peopleSection => 'Personal';

  @override
  String get rosterSection => 'Turnos';

  @override
  String get venueSetupSection => 'Configuración del local';

  @override
  String get companySection => 'Empresa';

  @override
  String get accountSection => 'Cuenta';

  @override
  String get settingsLabel => 'Ajustes';

  @override
  String percentCompletedTodayChip(int percent) {
    return '$percent% completado hoy';
  }

  @override
  String activeStaffCountLabel(int count) {
    return '$count personal activo';
  }

  @override
  String failCountTodayBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NO APTOS hoy',
      one: '1 NO APTO hoy',
    );
    return '$_temp0';
  }

  @override
  String get managerViewTitle => 'Vista de responsable';

  @override
  String showingScopeLabel(String scope) {
    return 'Mostrando: $scope';
  }

  @override
  String get supervisorNoScopeMessageLog =>
      'Todavía no se te ha asignado a una sección o equipo - pide a un responsable que lo configure en Gestión de personal antes de que este registro tenga algo que mostrar.';

  @override
  String entriesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entradas',
      one: '1 entrada',
    );
    return '$_temp0';
  }

  @override
  String failCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count NO APTOS',
      one: '1 NO APTO',
    );
    return '$_temp0';
  }

  @override
  String get noFailsLabel => 'Sin fallos';

  @override
  String get noCompletedTasksLoggedYet =>
      'Aún no hay tareas completadas registradas';

  @override
  String sessionSummariesCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resúmenes de turno',
      one: '1 resumen de turno',
    );
    return '$_temp0';
  }

  @override
  String passFailCountLabel(int passCount, int failCount) {
    return '$passCount aptos / $failCount no aptos';
  }

  @override
  String get workerFixedIt => 'El trabajador lo arregló';

  @override
  String get noCorrectiveActionRecorded =>
      'No se registró ninguna acción correctiva';

  @override
  String get taskAlertFallback => 'Alerta de tarea';

  @override
  String get loggedByLabel => 'Registrado por';

  @override
  String get resultLabel => 'Resultado';

  @override
  String get correctiveActionLabel => 'Acción correctiva';

  @override
  String get noteLabel => 'Nota';

  @override
  String get closeLabel => 'Cerrar';

  @override
  String get notCompletedSuffix => '- NO COMPLETADO (turno finalizado)';

  @override
  String get todayAllFails => 'Hoy + todos los fallos';

  @override
  String byAxisLabel(String axis) {
    return 'Por $axis';
  }

  @override
  String get nameAxisLabel => 'Nombre';

  @override
  String get dateAxisLabel => 'Fecha';

  @override
  String get taskAxisLabel => 'Tarea';

  @override
  String get filterLabel => 'Filtro';

  @override
  String get filterByLabel => 'Filtrar por:';

  @override
  String get clearFiltersLabel => 'Borrar filtros';

  @override
  String get staffLabel => 'Personal';
}
