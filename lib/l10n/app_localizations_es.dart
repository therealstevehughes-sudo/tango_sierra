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
  String get emailLabel => 'Correo';

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

  @override
  String get issueTypeComplaint => 'Queja';

  @override
  String get issueTypeAccident => 'Accidente';

  @override
  String get issueTypeIncident => 'Incidente';

  @override
  String get issueTypeSupplyProblem => 'Problema de suministro';

  @override
  String get issueTypeVenueProblem => 'Problema del local';

  @override
  String get issueTypeOther => 'Otro';

  @override
  String get incorrectDeliveryLabel => 'Entrega incorrecta';

  @override
  String get driverProblemLabel => 'Problema con el conductor';

  @override
  String get otherLabel => 'Otro';

  @override
  String get whatKindOfThingHappened => '¿Qué tipo de cosa ha pasado?';

  @override
  String get whichOneLabel => '¿Cuál?';

  @override
  String get supplierLabel => 'Proveedor';

  @override
  String get whatWasWrongWithDelivery => '¿Qué salió mal con la entrega?';

  @override
  String get receivedByLabel => 'Recibido por';

  @override
  String get whichSectionOptional => '¿Sobre qué sección es esto? (opcional)';

  @override
  String get noSectionLabel => 'Sin sección';

  @override
  String get teamOptionalLabel => 'Equipo (opcional)';

  @override
  String get noSpecificTeamLabel => 'Ningún equipo específico';

  @override
  String get whatHappenedLabel => '¿Qué pasó?';

  @override
  String get markAsUrgentLabel => 'Marcar como urgente';

  @override
  String get markUrgentSubtitle =>
      'Necesita atención inmediata, independientemente de cuánto tiempo lleve sin resolver';

  @override
  String get logItButton => 'Registrar';

  @override
  String get escalateToTitle => 'Escalar a';

  @override
  String get sendToLabel => 'Enviar a';

  @override
  String get escalateButton => 'Escalar';

  @override
  String get savedLabel => 'Guardado.';

  @override
  String remindedMessage(String name) {
    return 'Se recordó a $name.';
  }

  @override
  String get couldNotSendReminder => 'No se pudo enviar el recordatorio.';

  @override
  String get viewSupplierScorecard => 'Ver ficha del proveedor';

  @override
  String raisedAtLabel(String date) {
    return 'Notificado $date';
  }

  @override
  String escalatedToColonLabel(String name) {
    return 'Escalado a: $name';
  }

  @override
  String get historyLabel => 'Historial';

  @override
  String get addAnUpdateLabel => 'Añadir una actualización';

  @override
  String get addProcessNoteButton => 'Añadir nota de proceso';

  @override
  String get resolveButton => 'Resolver';

  @override
  String get reopenThisIssueTitle => 'Reabrir esta incidencia';

  @override
  String get whyReopenLabel => '¿Por qué debería reabrirse?';

  @override
  String get reopenButton => 'Reabrir';

  @override
  String sentToLabel(String name) {
    return 'Enviado a $name';
  }

  @override
  String get remindButton => 'Recordar';

  @override
  String get phaseRaisedLabel => 'Notificado';

  @override
  String get phaseUpdateLabel => 'Actualización';

  @override
  String get phaseOutcomeLabel => 'Resultado';

  @override
  String get allLabel => 'Todas';

  @override
  String get dateRangeLabel => 'Rango de fechas';

  @override
  String get allDatesLabel => 'Todas las fechas';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get anyTypeLabel => 'Cualquier tipo';

  @override
  String get anyoneLabel => 'Cualquiera';

  @override
  String staffFallback(String id) {
    return 'Empleado #$id';
  }

  @override
  String get nothingHereGoodSign => 'No hay nada aquí - buena señal.';

  @override
  String escalatedToNameLabel(String name) {
    return 'Escalado a $name';
  }

  @override
  String get havenReportedYet => 'Aún no has notificado nada.';

  @override
  String get failsAndProblemsRegisterTitle => 'Registro de fallos y problemas';

  @override
  String get taskProblemsTab => 'Problemas de tareas';

  @override
  String get issuesAndIncidentsTab => 'Incidencias y sucesos';

  @override
  String get failFilterLabel => 'No apto';

  @override
  String get reportedFilterLabel => 'Notificado';

  @override
  String get notCompletedFilterLabel => 'No completado';

  @override
  String get abandonedLabel => 'Abandonado';

  @override
  String get noActionTakenLabel => 'Sin acción tomada';

  @override
  String get markResolvedButton => 'Marcar como resuelto';

  @override
  String get openLabel => 'Abierto';

  @override
  String get enableRosterQuestion => '¿Activar Turnos?';

  @override
  String rosterQuoteBody(String amount) {
    return 'Según tu número actual de empleados, esto añadirá $amount a tu domiciliación bancaria mensual, a partir del próximo pago.';
  }

  @override
  String get confirmAndEnable => 'Confirmar y activar';

  @override
  String couldNotReachVenurite(String error) {
    return 'No se pudo contactar con VenuRite: $error';
  }

  @override
  String get letStaffClaimShifts =>
      'Deja que el personal reclame sus propios turnos';

  @override
  String get rosterPitchBody =>
      'Publica turnos abiertos y deja que el personal los reclame por sí mismo - se acabaron las rondas de llamadas o el grupo de WhatsApp cuando alguien no puede venir. El personal también puede solicitar días libres, y tú apruebas o rechazas desde el mismo lugar.';

  @override
  String get pricingLabel => 'Precios';

  @override
  String get priceUnder10Staff =>
      '6 GBP/mes por local con menos de 10 empleados';

  @override
  String get price10PlusStaff => '10 GBP/mes por local con 10 o más empleados';

  @override
  String get addedToDirectDebitNote =>
      'Se añade a tu domiciliación bancaria actual - no se necesita un nuevo método de pago. Verás el importe exacto antes de confirmar.';

  @override
  String get enableRosterButton => 'Activar Turnos';

  @override
  String get availableShiftsTitle => 'Turnos disponibles';

  @override
  String get shiftClaimingNotEnabled =>
      'La reclamación de turnos aún no está activada para este local. Pide a tu responsable que la active en Ajustes.';

  @override
  String couldNotLoadShifts(String error) {
    return 'No se pudieron cargar los turnos: $error';
  }

  @override
  String get noShiftsPostedYet => 'Aún no se han publicado turnos.';

  @override
  String get someoneElseClaimedShift =>
      'Otra persona acaba de reclamar ese turno - ¡lo sentimos!';

  @override
  String get shiftClaimedMessage => 'Turno reclamado.';

  @override
  String get cancelThisShiftTitle => '¿Cancelar este turno?';

  @override
  String get cancelShiftLateWarning =>
      '\n\nFaltan menos de 24 horas para que empiece el turno - cancelarlo ahora puede afectar a tu historial de fiabilidad.';

  @override
  String willNoLongerBeClaimed(String warning) {
    return 'Ya no estarás asignado a este turno.$warning';
  }

  @override
  String get keepShiftButton => 'Mantener turno';

  @override
  String get cancelShiftButton => 'Cancelar turno';

  @override
  String get yourShiftRecordReliable => 'Tu historial de turnos: Fiable';

  @override
  String get yourShiftRecordNeedsImprovement =>
      'Tu historial de turnos: Necesita mejorar';

  @override
  String get yourShiftRecordBuilding =>
      'Tu historial de turnos: Creando historial';

  @override
  String get claimLabel => 'Reclamar';

  @override
  String get claimedLabel => 'Reclamado';

  @override
  String requestDateOffTitle(String date) {
    return 'Solicitar $date libre';
  }

  @override
  String get reasonOptionalLabel => 'Motivo (opcional)';

  @override
  String get submitRequestButton => 'Enviar solicitud';

  @override
  String get offDayRequestsNotEnabled =>
      'Las solicitudes de días libres aún no están activadas para este local. Pide a tu responsable que active Turnos en Ajustes.';

  @override
  String get noOffDayRequestsYet => 'Aún no tienes solicitudes de días libres.';

  @override
  String get yourRequestsLabel => 'Tus solicitudes';

  @override
  String get approvedLabel => 'Aprobada';

  @override
  String get deniedLabel => 'Denegada';

  @override
  String get pendingLabel => 'Pendiente';

  @override
  String get postAShiftTitle => 'Publicar un turno';

  @override
  String get categoryHint =>
      'p. ej. Reparación de refrigeración, Control de plagas';

  @override
  String get pickStartTime => 'Elegir hora de inicio';

  @override
  String get pickEndTime => 'Elegir hora de fin';

  @override
  String get postLabel => 'Publicar';

  @override
  String get assignShiftToTitle => 'Asignar este turno a';

  @override
  String get unknownLabel => 'Desconocido';

  @override
  String get shiftsTabLabel => 'Turnos';

  @override
  String get offDayRequestsTabLabel => 'Solicitudes de días libres';

  @override
  String get rosterAddonNotEnabledManager =>
      'El complemento Turnos no está activado para este local. Actívalo en Ajustes > Empresa para empezar a publicar turnos.';

  @override
  String get noShiftsTapPlus =>
      'Aún no se han publicado turnos. Toca + para añadir uno.';

  @override
  String get openStatusLabel => 'Abierto';

  @override
  String get assignedStatusPrefix => 'Asignado';

  @override
  String get claimedStatusPrefix => 'Reclamado';

  @override
  String get assignDirectlyLabel => 'Asignar directamente';

  @override
  String get removeClaimLabel => 'Eliminar reclamación';

  @override
  String couldNotLoadOffDayRequests(String error) {
    return 'No se pudieron cargar las solicitudes de días libres: $error';
  }

  @override
  String get noOffDayRequests => 'No hay solicitudes de días libres.';

  @override
  String get approveLabel => 'Aprobar';

  @override
  String get denyLabel => 'Denegar';

  @override
  String get rosterAddonNotEnabledPlain =>
      'El complemento Turnos no está activado para este local.';

  @override
  String get noActiveStaffVenue => 'Aún no hay personal activo en este local.';

  @override
  String get last90DaysAlphabetical =>
      'Últimos 90 días, por categoría de turno. Alfabético - no es una clasificación.';

  @override
  String shiftsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnos',
      one: '1 turno',
    );
    return '$_temp0';
  }

  @override
  String get noShiftsInPeriod => 'Sin turnos en este periodo.';

  @override
  String categoryCountLabel(String category, int count) {
    return '$category: $count';
  }

  @override
  String get backupExplanation =>
      'Esto crea una copia completa de la base de datos local en tu carpeta Documentos. Moverla a una unidad USB o carpeta sincronizada en la nube es un paso manual aparte.';

  @override
  String get backupNameOptional => 'Nombre de la copia de seguridad (opcional)';

  @override
  String get backupNameHint => 'p. ej. Copia antes de la inspección';

  @override
  String get backupCreatedTitle => 'Copia de seguridad creada';

  @override
  String get tierTeamMember => 'Miembro del equipo';

  @override
  String get tierSupervisor => 'Supervisor';

  @override
  String get tierManager => 'Responsable';

  @override
  String get tierRegionalManager => 'Responsable regional';

  @override
  String get tierDirector => 'Director';

  @override
  String get anyTaskFail => 'Cualquier tarea no apta';

  @override
  String taskFailLabel(String title) {
    return 'No apta: $title';
  }

  @override
  String get taskFailTemplateStale => 'Tarea no apta (plantilla ya no vigente)';

  @override
  String get unknownUserLabel => 'Usuario desconocido';

  @override
  String tierSuffixLabel(String tier) {
    return 'nivel $tier';
  }

  @override
  String get unsetLabel => 'Sin definir';

  @override
  String get pushChannelLabel => 'push';

  @override
  String get emailChannelLabel => 'correo';

  @override
  String get inAppOnlyLabel => 'solo en la app';

  @override
  String inAppPlusChannelsLabel(String channels) {
    return 'en la app + $channels';
  }

  @override
  String get tierColumnTeam => 'Equipo';

  @override
  String get tierColumnSupv => 'Superv';

  @override
  String get tierColumnMgr => 'Resp';

  @override
  String get tierColumnRegnl => 'Region';

  @override
  String get tierColumnDir => 'Dir';

  @override
  String get quickSetupSectionTitle =>
      'Configuración rápida: notificaciones de tareas no aptas';

  @override
  String get tickTierNotified =>
      'Marca qué nivel recibe notificación cuando una tarea concreta no sea apta.';

  @override
  String get noTaskTemplatesSetUp =>
      'Aún no hay plantillas de tareas configuradas.';

  @override
  String notifyPrefixLabel(String target, String channels) {
    return 'Notificar: $target ($channels)';
  }

  @override
  String setByTierLabel(String tier) {
    return 'Establecido por el nivel $tier';
  }

  @override
  String get inactiveSuffixLabel => ' - inactiva';

  @override
  String get deactivateButton => 'Desactivar';

  @override
  String get reactivateButton => 'Reactivar';

  @override
  String get newRuleTitle => 'Nueva regla';

  @override
  String get triggerLabel => 'Disparador';

  @override
  String get notifyLabel => 'Notificar';

  @override
  String get wholeRoleTierOption => 'Todo un nivel de rol';

  @override
  String get specificPersonOption => 'Una persona concreta';

  @override
  String get roleTierLabel => 'Nivel de rol';

  @override
  String get personLabel => 'Persona';

  @override
  String get pushLabel => 'Push';

  @override
  String get rulesInAppNotice =>
      'Las reglas ahora se muestran solo en la app; el envío por push/correo aún no está conectado a un backend y se añadirá en un sprint posterior.';

  @override
  String get saveRuleButton => 'Guardar regla';

  @override
  String get addRuleButton => 'Añadir regla';

  @override
  String get noNotificationRulesYet =>
      'Aún no hay reglas de notificación configuradas.';

  @override
  String get stepYourAccount => 'Tu cuenta';

  @override
  String get stepCompanyDetails => 'Datos de la empresa';

  @override
  String get stepOrgStructure => 'Estructura organizativa';

  @override
  String get stepFirstVenue => 'Primer local';

  @override
  String get stepStarterSetup => 'Tu configuración inicial';

  @override
  String get stepSubscription => 'Suscripción';

  @override
  String get stepPayment => 'Pago';

  @override
  String get termsOfServiceTitle => 'Términos de servicio';

  @override
  String get companySignupGenericError =>
      'Algo salió mal al crear tu empresa. Inténtalo de nuevo - si sigue ocurriendo, contacta con VenuRite.';

  @override
  String get directDebitStartError =>
      'No pudimos iniciar la configuración de Domiciliación Bancaria automáticamente - puedes hacerlo en cualquier momento desde Ajustes una vez que hayas iniciado sesión.';

  @override
  String get continueButton => 'Continuar';

  @override
  String get creatingEllipsis => 'Creando...';

  @override
  String get startFreeTrialButton => 'Iniciar prueba gratuita';

  @override
  String get companyCreatedTitle => 'Empresa creada';

  @override
  String get adminAccountIntro =>
      'Configuremos tu cuenta. Serás el administrador de esta empresa en VenuRite y podrás invitar a tu equipo en cuanto entres.';

  @override
  String get firstNameLabel => 'Nombre';

  @override
  String get lastNameLabel => 'Apellidos';

  @override
  String get passwordMinCharsHelper => 'Al menos 8 caracteres';

  @override
  String get companyDetailsIntro => 'Cuéntanos sobre tu empresa.';

  @override
  String get tradingCompanyNameLabel => 'Nombre comercial / de la empresa';

  @override
  String get legalCompanyNameLabel => 'Nombre legal de la empresa (opcional)';

  @override
  String get legalCompanyNameHelper =>
      'Déjalo en blanco para usar el nombre comercial de arriba';

  @override
  String get countryLabel => 'País';

  @override
  String get registeredAddressLabel =>
      'Dirección registrada / comercial (opcional)';

  @override
  String get vatNumberLabel => 'Número de IVA / fiscal (si aplica)';

  @override
  String get billingContactEmailLabel =>
      'Correo de contacto de facturación (opcional)';

  @override
  String get structureIntro =>
      'Así es como VenuRite organiza tu empresa. No necesitas configurar nada ahora - esto es solo para que el siguiente paso tenga sentido.';

  @override
  String get structureYourCompanyLabel => 'Tu empresa';

  @override
  String get structureYourCompanySublabel =>
      'Una cuenta y una factura consolidadas';

  @override
  String get structureRegionsLabel => 'Regiones (opcional)';

  @override
  String get structureRegionsSublabel =>
      'Agrupa locales por país o zona - omítelo si no lo necesitas';

  @override
  String get structureVenuesLabel => 'Locales';

  @override
  String get structureVenuesSublabel =>
      'Un local hoy, cientos más adelante - añade más en cualquier momento';

  @override
  String get structureStaffLabel => 'Personal';

  @override
  String get structureStaffSublabel =>
      'El equipo de cada local, invitado una vez que existe';

  @override
  String get structureOutro =>
      'A continuación configuraremos tu primer local - puedes añadir regiones y más locales más adelante desde dentro de la app.';

  @override
  String get wizardFirstVenueHeroTitle => 'Añadamos tu primer local';

  @override
  String get addMoreVenuesLaterText =>
      'Puedes añadir más locales más adelante.';

  @override
  String get venueNameLabel => 'Nombre del local';

  @override
  String get addressOptionalLabel => 'Dirección (opcional)';

  @override
  String get regionAreaOptionalLabel => 'Región / zona (opcional)';

  @override
  String get regionAreaHelper =>
      'p. ej. \"Madrid\" - solo necesario si tienes (o vas a tener) más de un local';

  @override
  String get venueTypeOptionalLabel => 'Tipo de local (opcional)';

  @override
  String get venueTypeHelper =>
      'Elegir uno te muestra un conjunto inicial ya preparado - para tareas y equipamiento que ya sabes que necesitas.';

  @override
  String get payoffSkippedText =>
      'Te saltaste la elección de un tipo de local, así que todavía no hay un conjunto inicial que mostrar - puedes añadir tareas y equipamiento tú mismo una vez que entres.';

  @override
  String get payoffErrorText =>
      'No se pudo cargar el conjunto inicial para este tipo de local - puedes añadir tareas y equipamiento tú mismo una vez que entres.';

  @override
  String get payoffHeroTitle =>
      'Aquí tienes tu cumplimiento normativo, listo para usar';

  @override
  String get equipmentSectionLabel => 'Equipamiento';

  @override
  String get subscriptionBannerText =>
      'Una cuenta de empresa, una factura consolidada - con precio por local, nunca por persona.';

  @override
  String get subscriptionIntroText =>
      '¿Cuántos locales tienes hoy, incluida la oficina central si tienes una? Ahora solo configurarás tu primer local - el resto los añades cuando quieras desde la app.';

  @override
  String get perBranchPriceLabel => '39£/local/mes';

  @override
  String get headOfficeIncludedLabel =>
      '+ 1 local de oficina central (4+ locales)';

  @override
  String get discountCodeHint =>
      '¿Tienes un código de descuento? Puedes introducirlo al configurar la Domiciliación Bancaria.';

  @override
  String get trialBannerText =>
      'Estás empezando una prueba gratuita de 14 días - no se necesita tarjeta hoy.';

  @override
  String get paymentStepIntro =>
      'Te pediremos que configures el pago antes de que termine tu prueba, desde Ajustes dentro de la app. No se cobra nada ahora - solo dinos cómo prefieres pagar.';

  @override
  String get cardPaymentTitle => 'Pago con tarjeta (Stripe)';

  @override
  String get cardPaymentSubtitle =>
      'Tarjeta de débito/crédito, facturado mensual o anualmente';

  @override
  String get directDebitTitle => 'Domiciliación Bancaria (GoCardless)';

  @override
  String get directDebitSubtitle =>
      'Pago de banco a banco, sin necesidad de tarjeta';

  @override
  String get decideLaterButton => 'Decidiré más tarde';

  @override
  String get decideLaterSnackbar =>
      'No hay problema - puedes configurar esto cuando quieras desde Ajustes.';

  @override
  String get agreeToTermsPrefix => 'He leído y acepto los ';

  @override
  String get successActivatedBanner =>
      'Tu empresa y tu primer local están configurados, y has iniciado sesión.';

  @override
  String get successNotActivatedBanner =>
      'Tu empresa y tu primer local están configurados. Inicia sesión con tu correo y la contraseña que acabas de elegir.';

  @override
  String get directDebitSettingUp => 'Configurando Domiciliación Bancaria...';

  @override
  String get directDebitOpenedBrowser =>
      'Hemos abierto tu navegador para terminar de configurar la Domiciliación Bancaria.';

  @override
  String get inviteYourTeamTitle => 'Invita a tu equipo';

  @override
  String get inviteYourTeamSubtitle =>
      'Opcional - añade a quien esté en turno ahora, o sáltatelo y hazlo más tarde desde Gestión de Personal.';

  @override
  String get jobTitleLabel => 'Puesto';

  @override
  String get tierFieldLabel => 'Nivel';

  @override
  String get addTeamMemberButton => 'Añadir miembro del equipo';

  @override
  String get goToDashboardButton => 'Ir al panel';

  @override
  String get goToSignInButton => 'Ir a iniciar sesión';

  @override
  String wizardStepOfLabel(String title, int step, int total) {
    return '$title - Paso $step de $total';
  }

  @override
  String billingContactEmailHelper(String email) {
    return 'Déjalo en blanco para usar $email';
  }

  @override
  String payoffNoStarterSet(String venueType) {
    return 'Todavía no tenemos un conjunto inicial predefinido para $venueType - puedes añadir tareas y equipamiento tú mismo una vez que entres.';
  }

  @override
  String payoffSummaryWithEquipment(
    int totalTasks,
    int sectionCount,
    int equipmentCount,
    String venueType,
  ) {
    return '$totalTasks tareas en $sectionCount secciones y $equipmentCount tipos de equipamiento ya configurados para un $venueType.';
  }

  @override
  String payoffSummaryNoEquipment(
    int totalTasks,
    int sectionCount,
    String venueType,
  ) {
    return '$totalTasks tareas en $sectionCount secciones ya configuradas para un $venueType.';
  }

  @override
  String totalPerMonthLabel(String total, int units) {
    return '£$total/mes en total ($units locales facturados)';
  }

  @override
  String staffPinLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get jobRoleChefCook => 'Chef/Cocinero';

  @override
  String get jobRoleKitchenPorter => 'Ayudante de cocina';

  @override
  String get jobRoleFrontOfHouse => 'Sala';

  @override
  String get jobRoleBar => 'Bar';

  @override
  String get jobRoleManagement => 'Dirección';

  @override
  String get jobRoleEveryone => 'Todos';

  @override
  String get jobRoleMaintenance => 'Mantenimiento';

  @override
  String get jobRoleHousekeeping => 'Limpieza';

  @override
  String get jobRoleReception => 'Recepción';

  @override
  String get jobRoleSecurity => 'Seguridad';

  @override
  String get segmentFoodSafety =>
      'Seguridad alimentaria y control de temperatura';

  @override
  String get segmentAllergen => 'Gestión de alérgenos';

  @override
  String get segmentPersonalHygienePpe => 'Higiene personal y EPI';

  @override
  String get segmentRefrigerationColdStorage =>
      'Refrigeración y almacenamiento en frío';

  @override
  String get segmentCookingLineEquipment => 'Equipos de línea de cocina';

  @override
  String get segmentWashupDishwash => 'Fregadero / Lavado de vajilla';

  @override
  String get segmentCleaningSanitation => 'Limpieza y saneamiento';

  @override
  String get segmentCleaningChemicals => 'Productos de limpieza y consumibles';

  @override
  String get segmentDryAmbientStorage => 'Almacenamiento seco y ambiente';

  @override
  String get segmentDeliveriesGoodsIn => 'Entregas y recepción de mercancía';

  @override
  String get segmentUtilitiesSafety => 'Servicios e instalaciones y seguridad';

  @override
  String get segmentWastePestControl => 'Residuos y control de plagas';

  @override
  String get segmentPreventiveMaintenance =>
      'Mantenimiento preventivo (equipos de cocina)';

  @override
  String get segmentStockControl => 'Control de existencias';

  @override
  String get segmentOpeningProcedures => 'Procedimientos de apertura';

  @override
  String get segmentClosingProcedures => 'Procedimientos de cierre';

  @override
  String get segmentServiceReadiness => 'Preparación para el servicio';

  @override
  String get segmentFrontOfHouse => 'Sala / Servicio';

  @override
  String get segmentBarBeverage => 'Bar y bebidas';

  @override
  String get segmentHotelSpecific => 'Específico del hotel';

  @override
  String get segmentManagementComplianceOversight =>
      'Gestión y supervisión de cumplimiento';

  @override
  String get segmentMaintenance => 'Mantenimiento';

  @override
  String get segmentHousekeeping => 'Limpieza';

  @override
  String get segmentReception => 'Recepción';

  @override
  String get segmentSecurity => 'Seguridad';

  @override
  String get freqDaily => 'Diario';

  @override
  String get freqWeekly => 'Semanal';

  @override
  String get freqPerShift => 'Por turno';

  @override
  String get freqThreeXDaily => '3 veces al día';

  @override
  String get freqTwoXDaily => '2 veces al día';

  @override
  String get freqPerBatch => 'Por lote';

  @override
  String get freqPerDelivery => 'Por entrega';

  @override
  String get freqPerUse => 'Por uso';

  @override
  String get freqPerService => 'Por servicio';

  @override
  String get freqTwoXPerService => '2 veces por servicio';

  @override
  String get freqEventBased => 'Basado en evento';

  @override
  String get freqAsNeeded => 'Según necesidad';

  @override
  String get freqMonthly => 'Mensual';

  @override
  String get freqCustom => 'Personalizado';

  @override
  String get jobRoleFieldLabel => 'Puesto';

  @override
  String get pinFieldLabel => 'PIN';

  @override
  String get addStaffMemberTitle => 'Añadir empleado';

  @override
  String get addLabel => 'Añadir';

  @override
  String get assignTasksTitle => 'Asignar tareas';

  @override
  String get noActiveSiteFoundError => 'No se encontró ningún local activo.';

  @override
  String get byPersonLabel => 'Por persona';

  @override
  String get byTaskLabel => 'Por tarea';

  @override
  String get noEquipmentOfTypeSetUp =>
      'Todavía no hay equipamiento de este tipo configurado.';

  @override
  String get applyButton => 'Aplicar';

  @override
  String get assignToTitle => 'Asignar a';

  @override
  String get noStaffMatchTiers =>
      'Ningún empleado coincide con el/los nivel(es) a los que se aplican estas tareas.';

  @override
  String get assignButton => 'Asignar';

  @override
  String get showInstructionsTooltip => 'Mostrar instrucciones';

  @override
  String get selectTasksToAssignLabel => 'Selecciona tareas para asignar';

  @override
  String get taskPresetsSectionTitle => 'Conjuntos de tareas';

  @override
  String get showAllPresetsButton => 'Mostrar todos los conjuntos';

  @override
  String get showTasksInGroupTooltip => 'Mostrar tareas de este grupo';

  @override
  String get applyToMultipleButton => 'Aplicar a varios';

  @override
  String get addCustomTaskButton => 'Añadir tarea personalizada';

  @override
  String get customTaskSectionTitle => 'Tarea personalizada';

  @override
  String get titleFieldLabel => 'Título';

  @override
  String get departmentSectionLabel => 'Departamento / sección';

  @override
  String get methodLabel => 'Método';

  @override
  String get methodTick => 'Marcar';

  @override
  String get methodData => 'Datos';

  @override
  String get methodDataTick => 'Datos + marcar';

  @override
  String get methodTickPhoto => 'Marcar + foto';

  @override
  String get methodDataPhoto => 'Datos + foto';

  @override
  String get methodNote => 'Nota';

  @override
  String get methodDataNote => 'Datos + nota';

  @override
  String get methodNotePhoto => 'Nota + foto';

  @override
  String get methodTickNote => 'Marcar + nota';

  @override
  String get methodMulti => 'Múltiple';

  @override
  String get requiresPhotoLabel => 'Requiere foto';

  @override
  String get requiresNotesLabel => 'Requiere notas';

  @override
  String get minLimitLabel => 'Límite mínimo';

  @override
  String get maxLimitLabel => 'Límite máximo';

  @override
  String get unitHintLabel => 'Unidad (p. ej. Celsius)';

  @override
  String get equipmentTypeOptionalLabel => 'Tipo de equipo (opcional)';

  @override
  String get noneLabel => 'Ninguno';

  @override
  String get priorityLabel => 'Prioridad';

  @override
  String get priorityCritical => 'Crítica';

  @override
  String get priorityHigh => 'Alta';

  @override
  String get priorityStandard => 'Estándar';

  @override
  String get requiresCorrectiveActionLabel =>
      'Requiere acción correctiva si falla';

  @override
  String get fixInstructionsLabel => 'Instrucciones de solución';

  @override
  String get customFieldsJsonLabel => 'Campos personalizados (JSON, opcional)';

  @override
  String get extraFieldsSectionTitle => 'Campos adicionales (opcional)';

  @override
  String get removeTooltip => 'Eliminar';

  @override
  String get fieldLabelHint => 'Etiqueta del campo (p. ej. número de pedido)';

  @override
  String get extraFieldTypeText => 'Texto';

  @override
  String get extraFieldTypeNumber => 'Número';

  @override
  String get extraFieldTypeDate => 'Fecha';

  @override
  String get addFieldTooltip => 'Añadir campo';

  @override
  String get saveCustomTaskButton => 'Guardar tarea personalizada';

  @override
  String get adHocLabel => 'Puntual';

  @override
  String get timeAllocatedLabel => 'Horario asignado';

  @override
  String get frequencyPrefixLabel => 'Frecuencia: ';

  @override
  String get atATimeLabel => 'A una hora concreta';

  @override
  String get fromStartOfShiftLabel => 'Desde el inicio del turno';

  @override
  String get fromClockInLabel => 'Desde el fichaje';

  @override
  String get availableFromEllipsis => 'Disponible desde…';

  @override
  String get untilEllipsis => 'hasta…';

  @override
  String assignTasksForStaffTitle(String name) {
    return 'Asignar tareas - $name';
  }

  @override
  String applyPresetToWhichOneTitle(String name) {
    return '¿Aplicar \"$name\" a cuál?';
  }

  @override
  String allPresetTasksAlreadyAssigned(String name) {
    return 'Todas las tareas de $name ya estaban asignadas';
  }

  @override
  String addedTasksFromPreset(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se añadieron $count tareas',
      one: 'Se añadió $count tarea',
    );
    return '$_temp0 de $name';
  }

  @override
  String applyPresetToTitle(String name) {
    return 'Aplicar \"$name\" a';
  }

  @override
  String assignTasksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Asignar $count tareas al personal…',
      one: 'Asignar $count tarea al personal…',
    );
    return '$_temp0';
  }

  @override
  String addedTasksAcrossStaffLabel(int count, int staffCount) {
    return 'Se añadieron $count asignaciones para $staffCount empleados';
  }

  @override
  String presetSectionPrefix(String segment) {
    return 'Sección: $segment';
  }

  @override
  String taskCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas',
      one: '$count tarea',
    );
    return '$_temp0';
  }

  @override
  String showAllRolesLabel(String jobRole) {
    return 'Mostrar todos los puestos (por defecto solo: $jobRole)';
  }

  @override
  String extraFieldSummary(String label, String type) {
    return '$label ($type)';
  }

  @override
  String noEquipmentSetUpForTemplate(String title) {
    return '$title - todavía no hay equipamiento configurado para esto';
  }

  @override
  String fromTimeLabel(String time) {
    return 'Desde $time';
  }

  @override
  String untilTimeLabel(String time) {
    return 'hasta $time';
  }

  @override
  String createdAssignmentsLabel(int count, String skippedNote) {
    return '$count asignaciones creadas$skippedNote.';
  }

  @override
  String skippedNoteLabel(int count) {
    return ' ($count omitidas - ya asignadas o el puesto no coincide)';
  }

  @override
  String get serviceProvidersTitle => 'Proveedores de servicios';

  @override
  String get myProvidersTab => 'Mis proveedores';

  @override
  String get findProviderTab => 'Buscar un proveedor';

  @override
  String get noBackendProviderNotice1 =>
      'Explorar los proveedores compartidos de otros locales necesita una cuenta de empresa real iniciada - no puede funcionar solo con el inicio de sesión de demostración local. Tus propios contactos en \"Mis proveedores\" funcionan de todas formas.';

  @override
  String get noBackendProviderNotice2 =>
      'Inicia sesión mediante Acceso de dirección con una cuenta de empresa real para usar esto.';

  @override
  String get providerDisclaimerText =>
      'VenuRite no verifica ni respalda a ningún proveedor listado. Las reseñas son de otros locales, no de VenuRite.';

  @override
  String get addProviderButton => 'Añadir un proveedor';

  @override
  String get noProvidersYetText =>
      'Todavía no has añadido ningún proveedor de servicios.';

  @override
  String get addServiceProviderDialogTitle =>
      'Añadir un proveedor de servicios';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get phoneOptionalLabel => 'Teléfono (opcional)';

  @override
  String get emailOptionalLabel => 'Correo (opcional)';

  @override
  String get notesOptionalPrivateLabel => 'Notas (opcional, privadas para ti)';

  @override
  String get happyToReviewShareLabel => 'Estoy dispuesto a reseñar y compartir';

  @override
  String get shareVisibilityExplanation =>
      'Otros locales verán tus valoraciones y reseñas, con el nombre/contacto difuminado hasta que lo desbloqueen.';

  @override
  String get rateThisProviderLabel => 'Valora este proveedor';

  @override
  String get priceRatingLabel => 'Precio';

  @override
  String get punctualityRatingLabel => 'Puntualidad';

  @override
  String get qualityRatingLabel => 'Calidad';

  @override
  String get availabilityRatingLabel => 'Disponibilidad';

  @override
  String get reviewOptionalLabel => 'Reseña (opcional)';

  @override
  String get reviewHintText =>
      'Describe tu experiencia - por favor no menciones el nombre del negocio ni incluyas datos de contacto.';

  @override
  String get sessionExpiredMessage =>
      'Tu sesión ha caducado - inicia sesión de nuevo.';

  @override
  String get sharedWithOtherVenuesLabel => 'Compartido con otros locales';

  @override
  String get privateLabel => 'Privado';

  @override
  String get rateReviewsButton => 'Valorar / Reseñas';

  @override
  String get searchByCategoryOrNameHint => 'Buscar por categoría o nombre';

  @override
  String get noContactsUnlockedThisMonth =>
      'Ningún contacto desbloqueado este mes todavía.';

  @override
  String get noSharedProvidersYetText =>
      'Todavía no hay proveedores compartidos - sé el primero en compartir uno desde \"Mis proveedores.\"';

  @override
  String get noProvidersMatchSearchText =>
      'Ningún proveedor coincide con tu búsqueda.';

  @override
  String get noRatingsYetText => 'Sin valoraciones todavía';

  @override
  String get hiddenUntilUnlockedText => 'Oculto hasta desbloquear';

  @override
  String get unnamedPlaceholder => '(sin nombre)';

  @override
  String get readReviewsButton => 'Leer reseñas';

  @override
  String get unlockContactDetailsButton => 'Desbloquear datos de contacto';

  @override
  String get reviewsTitle => 'Reseñas';

  @override
  String get noReviewsYetText => 'Todavía no hay reseñas.';

  @override
  String get addYourRatingLabel => 'Añade tu valoración';

  @override
  String get submittingEllipsis => 'Enviando...';

  @override
  String get submitRatingButton => 'Enviar valoración';

  @override
  String reviewContainsInfoWarningShort(String found) {
    return 'Tu reseña parece incluir $found. Elimina los datos de contacto o el nombre del negocio antes de enviarla.';
  }

  @override
  String reviewContainsInfoWarningLong(String found) {
    return 'Tu reseña parece incluir $found. Elimina los datos de contacto o el nombre del negocio antes de enviarla - las reseñas siguen siendo útiles (y justas) cuando describen la experiencia, no a quién llamar directamente.';
  }

  @override
  String contactsUnlockedThisMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contactos desbloqueados este mes.',
      one: '$count contacto desbloqueado este mes.',
    );
    return '$_temp0';
  }

  @override
  String priceValueLabel(String value) {
    return 'Precio $value';
  }

  @override
  String punctualityValueLabel(String value) {
    return 'Puntualidad $value';
  }

  @override
  String qualityValueLabel(String value) {
    return 'Calidad $value';
  }

  @override
  String availabilityValueLabel(String value) {
    return 'Disponibilidad $value';
  }

  @override
  String ratingReviewCountSuffix(String parts, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reseñas',
      one: '$count reseña',
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
    return 'Precio $price - Puntualidad $punctuality - Calidad $quality - Disponibilidad $availability';
  }

  @override
  String phonePrefixLabel(String value) {
    return 'Teléfono: $value';
  }

  @override
  String emailPrefixLabel(String value) {
    return 'Correo: $value';
  }

  @override
  String get supplierCategoryFreshProduce => 'Productos frescos';

  @override
  String get supplierCategoryMeatPoultry => 'Carne y aves';

  @override
  String get supplierCategoryDairyEggs => 'Lácteos y huevos';

  @override
  String get supplierCategoryFrozenGoods => 'Productos congelados';

  @override
  String get supplierCategoryDryAmbientGoods => 'Productos secos y ambiente';

  @override
  String get supplierCategoryDrinksBeverages => 'Bebidas';

  @override
  String get supplierCategoryChemicalsCleaningSupplies =>
      'Productos químicos y de limpieza';

  @override
  String get supplierCategoryEquipmentMaintenance =>
      'Equipamiento y mantenimiento';

  @override
  String get supplierCategoryOther => 'Otro';

  @override
  String get supplierStatusApproved => 'Aprobado';

  @override
  String get supplierStatusPending => 'Pendiente';

  @override
  String get supplierStatusSuspended => 'Suspendido';

  @override
  String get addEquipmentTitle => 'Añadir equipamiento';

  @override
  String get venueSetupTitle => 'Configuración del local';

  @override
  String get nextButton => 'Siguiente';

  @override
  String get finishSetupButton => 'Finalizar configuración';

  @override
  String get renameAreaTitle => 'Renombrar zona';

  @override
  String get renameEquipmentTitle => 'Renombrar equipamiento';

  @override
  String get saveButton => 'Guardar';

  @override
  String get retireEquipmentTitle => 'Retirar equipamiento';

  @override
  String get retireEquipmentConfirmText =>
      'Retirar este equipamiento también desasignará cualquier tarea actualmente asignada a él. Se conserva el historial de envíos pasados. ¿Continuar?';

  @override
  String get retireButton => 'Retirar';

  @override
  String get areasStepTitle => 'Zonas';

  @override
  String get areasStepIntro => 'Añade las zonas operativas de este local.';

  @override
  String get areaSuggestionKitchen => 'Cocina';

  @override
  String get areaSuggestionStorage => 'Almacén';

  @override
  String get areaSuggestionReceiving => 'Recepción';

  @override
  String get areaSuggestionFrontOfHouse => 'Sala';

  @override
  String get areaNameLabel => 'Nombre de la zona';

  @override
  String get addAreaTooltip => 'Añadir zona';

  @override
  String get renameTooltip => 'Renombrar';

  @override
  String get equipmentStepTitle => 'Equipamiento';

  @override
  String get equipmentStepIntro =>
      'Añade instancias de equipamiento con nombre, p. ej. \"Nevera 1\", \"Nevera 2\".';

  @override
  String get showAllEquipmentTypesButton =>
      'Mostrar todos los tipos de equipamiento';

  @override
  String get equipmentTypeLabel => 'Tipo de equipamiento';

  @override
  String get somethingElseOption => 'Algo más...';

  @override
  String get newEquipmentTypeNameLabel =>
      'Nombre del nuevo tipo de equipamiento';

  @override
  String get confirmNewEquipmentTypeTooltip =>
      'Confirmar nuevo tipo de equipamiento';

  @override
  String get noAreasForDeptText =>
      'Todavía no hay zonas configuradas para tu departamento - el equipamiento se puede añadir igualmente sin una.';

  @override
  String get noAreasAddOneText =>
      'Todavía no se ha añadido ninguna zona - vuelve atrás para añadir una.';

  @override
  String get equipmentNameLabel => 'Nombre del equipamiento';

  @override
  String get equipmentNameHint =>
      'p. ej. Cámara de carne, Nevera de postres, Freidora de bar';

  @override
  String get modelOptionalLabel => 'Modelo (opcional)';

  @override
  String get serialNumberOptionalLabel => 'Número de serie (opcional)';

  @override
  String get retireTooltip => 'Retirar';

  @override
  String get reactivateTooltip => 'Reactivar';

  @override
  String get unknownTypeLabel => 'Tipo desconocido';

  @override
  String get unknownAreaLabel => 'Zona desconocida';

  @override
  String get staffStepTitle => 'Personal';

  @override
  String get staffStepIntro =>
      'Añade miembros del personal y asigna su nivel de rol.';

  @override
  String get addStaffMemberButton => 'Añadir miembro del personal';

  @override
  String get suppliersStepTitle => 'Proveedores';

  @override
  String get suppliersStepIntro =>
      'Añade los proveedores con los que trabaja este local. Las marcas de aprobación aparecen en la exportación EHO - los proveedores suspendidos se muestran a los gerentes, no se ocultan silenciosamente.';

  @override
  String get supplierNameLabel => 'Nombre del proveedor';

  @override
  String get contactOptionalLabel => 'Contacto (opcional)';

  @override
  String get phoneOrEmailHint => 'Teléfono o correo';

  @override
  String get approvalStatusLabel => 'Estado de aprobación';

  @override
  String get addSupplierButton => 'Añadir proveedor';

  @override
  String venueSetupStepTitle(int step) {
    return 'Configuración del local - Paso $step de 4';
  }

  @override
  String modelPrefixLabel(String value) {
    return 'Modelo: $value';
  }

  @override
  String serialPrefixLabel(String value) {
    return 'N.º de serie: $value';
  }

  @override
  String retiredSuffixLabel(String name) {
    return '$name (retirado)';
  }

  @override
  String get addEquipmentTooltip => 'Añadir equipamiento';

  @override
  String get newPinLabel => 'PIN nuevo';

  @override
  String get editDetailsTitle => 'Editar datos';

  @override
  String get sectionLabel => 'Sección';

  @override
  String get noSectionOption => 'Sin sección';

  @override
  String get inactiveParenSuffix => ' (inactiva)';

  @override
  String get noSpecificTeamOption => 'Sin equipo específico';

  @override
  String get noSectionsSetupText =>
      'Todavía no hay secciones configuradas en este local - añade una primero en Gestión de Departamentos.';

  @override
  String get reportsToFieldLabel => 'Reporta a';

  @override
  String get notSetOption => 'Sin definir';

  @override
  String get deactivateStaffMemberTitle => 'Desactivar empleado';

  @override
  String get staffManagementTitle => 'Gestión de Personal';

  @override
  String get addStaffTooltip => 'Añadir personal';

  @override
  String get bulkImportTooltip => 'Importación masiva';

  @override
  String get deactivatedSuffixLabel => '(desactivado)';

  @override
  String get moreActionsTooltip => 'Más acciones';

  @override
  String get changeTierMenuItem => 'Cambiar nivel';

  @override
  String get changeSectionMenuItem => 'Cambiar sección';

  @override
  String get assignSupervisionMenuItem => 'Asignar supervisión';

  @override
  String get reportsToMenuItem => 'Reporta a';

  @override
  String get resetPinMenuItem => 'Restablecer PIN';

  @override
  String get trainingRecordsMenuItem => 'Registros de formación';

  @override
  String unknownUserIdFallback(String id) {
    return 'usuario n.º $id';
  }

  @override
  String resetPinForUserTitle(String name) {
    return 'Restablecer PIN - $name';
  }

  @override
  String pinResetForUserMessage(String name) {
    return 'PIN restablecido para $name';
  }

  @override
  String changeRoleTierTitle(String name) {
    return 'Cambiar nivel de puesto - $name';
  }

  @override
  String changeSectionTitle(String name) {
    return 'Cambiar sección - $name';
  }

  @override
  String assignSupervisionTitle(String name) {
    return 'Asignar supervisión - $name';
  }

  @override
  String supervisionScopeUpdatedMessage(String name) {
    return 'Ámbito de supervisión actualizado para $name';
  }

  @override
  String reportsToTitle(String name) {
    return 'Reporta a - $name';
  }

  @override
  String deactivateStaffConfirmText(String name) {
    return '$name ya no podrá iniciar sesión. Sus asignaciones de tareas activas serán desasignadas. Su historial de envíos no se ve afectado. Esto se puede revertir más tarde.';
  }

  @override
  String reportsToSubtitle(String name) {
    return 'Reporta a $name';
  }

  @override
  String deactivatedOnByLabel(String date, String name) {
    return 'el $date por $name';
  }

  @override
  String get darkModeLabel => 'Modo oscuro';

  @override
  String get brandIdentityIntro =>
      'Una identidad de marca, compartida en toda la empresa - se aplica a cada local, no por local.';

  @override
  String get companyNameLabel => 'Nombre de la empresa';

  @override
  String get companyLogoLabel => 'Logo de la empresa';

  @override
  String get chooseLogoButton => 'Elegir logo';

  @override
  String get changeLogoButton => 'Cambiar logo';

  @override
  String get brandColourLabel => 'Color de marca';

  @override
  String get customHexColourLabel => 'Color hex personalizado';

  @override
  String get enterValidHexColourError => 'Introduce un color hex válido';

  @override
  String get contactPhoneLabel => 'Teléfono de contacto';

  @override
  String get contactEmailLabel => 'Correo de contacto';

  @override
  String get savingEllipsisLabel => 'Guardando...';

  @override
  String get saveBrandingButton => 'Guardar marca';

  @override
  String get brandingSavedMessage => 'Marca guardada';

  @override
  String get customSwatchTooltip => 'Personalizado';

  @override
  String get rosterAddonTitle => 'Turnos de personal (+6-10£/local/mes)';

  @override
  String get rosterAddonSubtitle =>
      'Deja que el personal vea y reclame turnos abiertos por sí mismo - un gerente publica turnos, el personal los elige. 6£/mes por local con menos de 10 empleados, 10£/mes para 10 o más.';

  @override
  String get enableRosterTitle => '¿Activar turnos?';

  @override
  String get confirmButton => 'Confirmar';

  @override
  String get clearDemoDataTitle => '¿Borrar datos de demostración?';

  @override
  String get clearDemoDataConfirmText =>
      'Esto elimina permanentemente cada empleado, sucursal y departamento de demostración, y cierra tu sesión. No se puede deshacer.';

  @override
  String get clearEverythingButton => 'Borrar todo';

  @override
  String get clearDemoDataCardTitle => 'Borrar datos de demostración';

  @override
  String get clearDemoDataCardBody =>
      'Elimina cada empleado, sucursal y departamento de demostración para que puedas configurar los tuyos desde cero.';

  @override
  String get clearDemoDataButton => 'Borrar datos de demostración';

  @override
  String get temperatureUnitLabel => 'Unidad de temperatura';

  @override
  String get celsiusLabel => 'Celsius (°C)';

  @override
  String get fahrenheitLabel => 'Fahrenheit (°F)';

  @override
  String get comingSoonLabel => 'Próximamente';

  @override
  String get presetColorOceanTeal => 'Turquesa Océano';

  @override
  String get presetColorNavy => 'Azul Marino';

  @override
  String get presetColorIndigo => 'Índigo';

  @override
  String get presetColorSlate => 'Pizarra';

  @override
  String get presetColorPlum => 'Ciruela';

  @override
  String get presetColorForest => 'Bosque';

  @override
  String get presetColorUmber => 'Sombra';

  @override
  String get presetColorCharcoal => 'Carbón';

  @override
  String couldNotGetPriceError(String error) {
    return 'No se pudo obtener un precio: $error';
  }

  @override
  String enableRosterConfirmText(String amount) {
    return 'Según tu número actual de empleados, esto añadirá $amount a tu domiciliación bancaria mensual.';
  }

  @override
  String get departmentLabel => 'Departamento';

  @override
  String get noDepartmentOption => 'Sin departamento';

  @override
  String get removeAnywayButton => 'Eliminar de todos modos';

  @override
  String get branchTeamStructureTitle => 'Estructura del equipo del local';

  @override
  String get noStaffAtBranchText => 'Todavía no hay personal en este local.';

  @override
  String get changeManagerMenuItem => 'Cambiar gerente';

  @override
  String get moveDepartmentMenuItem => 'Mover departamento/equipo';

  @override
  String get editJobTitleMenuItem => 'Editar puesto';

  @override
  String get removeFromBranchMenuItem => 'Eliminar de este local';

  @override
  String changeManagerTitle(String name) {
    return 'Cambiar gerente - $name';
  }

  @override
  String moveDepartmentTitle(String name) {
    return 'Mover departamento/equipo - $name';
  }

  @override
  String changeTierTitle2(String name) {
    return 'Cambiar nivel - $name';
  }

  @override
  String editJobTitleTitle(String name) {
    return 'Editar puesto - $name';
  }

  @override
  String removeFromBranchTitle(String name) {
    return 'Eliminar a $name de este local';
  }

  @override
  String removeFromBranchConfirmText(String name) {
    return '$name ya no podrá iniciar sesión. Esto se puede revertir más tarde.';
  }

  @override
  String reportsWillBeUnassignedText(int count, String name, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personas reportan',
      one: '$count persona reporta',
    );
    return '$_temp0 actualmente a $name: $names. Eliminar a $name los dejará sin asignar hasta que se reasignen.';
  }

  @override
  String reassignToManagerLabel(String name) {
    return 'Reasignarlos en su lugar al propio gerente de $name';
  }

  @override
  String reportsCountBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subordinados',
      one: '$count subordinado',
    );
    return '$_temp0';
  }

  @override
  String get regionalManagerAssignedTitle => 'Gerente regional asignado';

  @override
  String get noOrganisationOnSessionError => 'No hay empresa en esta sesión.';

  @override
  String get newRegionNameTitle => 'Nombre de la nueva región';

  @override
  String get renameRegionTitle => 'Renombrar región';

  @override
  String get renameVenueTitle => 'Renombrar local';

  @override
  String get newVenueNameTitle => 'Nombre del nuevo local';

  @override
  String get doneButton => 'Hecho';

  @override
  String get resetPasswordQuestionTitle => '¿Restablecer contraseña?';

  @override
  String get resetButton => 'Restablecer';

  @override
  String get passwordResetTitle => 'Contraseña restablecida';

  @override
  String get giveNewTempPasswordText =>
      'Dale a esta persona su nueva contraseña temporal.';

  @override
  String get organisationTitle => 'Empresa';

  @override
  String get headOfficeLabel => 'Oficina Central';

  @override
  String get addRegionMenuItem => 'Añadir región';

  @override
  String get addVenueNoRegionMenuItem => 'Añadir local (sin región)';

  @override
  String get venuesNoRegionLabel => 'Locales (sin región)';

  @override
  String get resetPasswordTooltip => 'Restablecer contraseña';

  @override
  String get addVenueMenuItem => 'Añadir local';

  @override
  String get assignRegionalManagerMenuItem => 'Asignar gerente regional';

  @override
  String get reassignRegionalManagerMenuItem => 'Reasignar gerente regional';

  @override
  String get noRegionalManagerYetText => 'Todavía no hay gerente regional';

  @override
  String get noVenuesInRegionText => 'Todavía no hay locales en esta región.';

  @override
  String get noVenueManagerYetText => 'Todavía no hay gerente de local';

  @override
  String assignRegionalManagerTitle(String region) {
    return 'Asignar gerente regional - $region';
  }

  @override
  String accountLiveGiveSignInDetails(String name) {
    return 'La cuenta ya está activa. Dale a $name sus datos de inicio de sesión - usa Acceso de dirección.';
  }

  @override
  String emailColonLabel(String email) {
    return 'Correo: $email';
  }

  @override
  String temporaryPasswordColonLabel(String password) {
    return 'Contraseña temporal: $password';
  }

  @override
  String resetPasswordConfirmText(String name) {
    return 'Esto invalida inmediatamente la contraseña actual de $name. Obtendrás una nueva contraseña temporal para transmitir.';
  }

  @override
  String venueManagerSuffixLabel(String name) {
    return '$name  ·  Gerente de local';
  }

  @override
  String get noSignedInUserError =>
      'No se encontró ningún usuario con sesión iniciada.';

  @override
  String get customCategoryTitleLabel => 'Título de categoría personalizado';

  @override
  String get approvalNoteLabel =>
      'Nota de aprobación / diligencia debida (opcional)';

  @override
  String get supplierManagementTitle => 'Gestión de Proveedores';

  @override
  String get noSuppliersAddedYetText =>
      'Todavía no se han añadido proveedores.';

  @override
  String get inactiveStandaloneLabel => '(inactivo)';

  @override
  String get changeApprovalStatusMenuItem => 'Cambiar estado de aprobación';

  @override
  String editDetailsForSupplierTitle(String name) {
    return 'Editar datos - $name';
  }

  @override
  String changeApprovalStatusTitle(String name) {
    return 'Cambiar estado de aprobación - $name';
  }

  @override
  String get newVenueTypeTitle => 'Nuevo tipo de local';

  @override
  String get renameOrganisationTitle => 'Renombrar empresa';

  @override
  String get resetSetupCodeTitle => '¿Restablecer código de configuración?';

  @override
  String get resetSetupCodeConfirmText =>
      'Esto desconectará todas las tabletas que usan actualmente este local hasta que reciban el nuevo código. ¿Continuar?';

  @override
  String get resetCodeButton => 'Restablecer código';

  @override
  String get createNewVenueTitle => 'Crear nuevo local';

  @override
  String get multiSiteSupportPartialText =>
      'El soporte multi-local es parcial: el equipamiento, el personal y las listas de tareas todavía no se filtran por local, así que el uso diario de un segundo local todavía no está totalmente soportado. Crear uno es seguro, pero verás los datos de este local y del local original mezclados en listas compartidas hasta que eso se implemente.';

  @override
  String get createButton => 'Crear';

  @override
  String get venueDetailsTitle => 'Detalles del local';

  @override
  String get billingLabel => 'Facturación';

  @override
  String get billingSubtitleText => 'Plan, estado, domiciliación bancaria';

  @override
  String get activeLabel => 'Activo';

  @override
  String get setAsActiveButton => 'Establecer como activo';

  @override
  String get tabletSetupCodeTitle => 'Código de configuración de la tableta';

  @override
  String get tabletSetupCodeExplanation =>
      'Introduce esto una vez en una tableta nueva para que pueda mostrar la lista de personal de este local.';

  @override
  String get generateCodeButton => 'Generar código';

  @override
  String get venueTypeSectionTitle => 'Tipo de local';

  @override
  String get renamePresetTitle => 'Renombrar conjunto';

  @override
  String get noTaskTemplatesExistYetText =>
      'Todavía no existen plantillas de tareas.';

  @override
  String get addTaskToPresetTitle => 'Añadir tarea al conjunto';

  @override
  String get taskFieldLabel => 'Tarea';

  @override
  String get defaultFrequencyLabel => 'Frecuencia predeterminada';

  @override
  String get noPresetsYetText => 'Todavía no hay conjuntos.';

  @override
  String get createPresetButton => 'Crear conjunto';

  @override
  String get presetVerificationBannerText =>
      'Los límites de las tareas se han investigado y documentado (etiquetados [LAW]/[FSA]/[BEST] en las instrucciones de cada tarea) pero todavía no han sido aprobados por un profesional cualificado en seguridad alimentaria. No los trates como legalmente autorizados hasta que se verifiquen.';

  @override
  String get equipmentPresetsSectionTitle => 'Conjuntos de equipamiento';

  @override
  String get sectionPresetsSectionTitle => 'Conjuntos de sección';

  @override
  String get addTaskButton => 'Añadir tarea';

  @override
  String get newPresetSectionTitle => 'Nuevo conjunto';

  @override
  String get sectionSegmentOptionalLabel => 'Sección / segmento (opcional)';

  @override
  String get setEquipmentOrSectionHint =>
      'Define un tipo de equipamiento o una sección (al menos uno).';

  @override
  String equipmentTypeFallback(String id) {
    return 'Tipo de equipamiento n.º $id';
  }

  @override
  String taskFallback(String id) {
    return 'Tarea n.º $id';
  }

  @override
  String get departmentCategoryKitchen => 'Cocina';

  @override
  String get departmentCategoryFrontOfHouse => 'Sala';

  @override
  String get departmentCategoryBar => 'Bar';

  @override
  String get departmentCategoryManagement => 'Dirección';

  @override
  String get departmentCategoryMaintenance => 'Mantenimiento';

  @override
  String get departmentCategoryHousekeeping => 'Limpieza';

  @override
  String get departmentCategoryReception => 'Recepción';

  @override
  String get departmentCategorySecurity => 'Seguridad';

  @override
  String get addDepartmentButton => 'Añadir departamento';

  @override
  String get departmentManagementTitle => 'Gestión de Departamentos';

  @override
  String get noDepartmentsAddedYetText =>
      'Todavía no se han añadido departamentos.';

  @override
  String get noTeamsYetText => 'Todavía no hay equipos';

  @override
  String get editMenuItem => 'Editar';

  @override
  String get addTeamButton => 'Añadir equipo';

  @override
  String editDepartmentTitle(String name) {
    return 'Editar - $name';
  }

  @override
  String addTeamTitle(String name) {
    return 'Añadir equipo - $name';
  }

  @override
  String renameTeamTitle(String name) {
    return 'Renombrar - $name';
  }

  @override
  String teamCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count equipos',
      one: '$count equipo',
    );
    return '$_temp0';
  }

  @override
  String get documentCategoryPolicy => 'Política';

  @override
  String get documentCategoryCertificate => 'Certificado';

  @override
  String get documentCategoryProcedure => 'Procedimiento';

  @override
  String get documentCategoryEhoReport => 'Informe EHO';

  @override
  String get addDocumentTitle => 'Añadir documento';

  @override
  String get noExpiryDateText => 'Sin fecha de caducidad';

  @override
  String get setExpiryButton => 'Establecer caducidad';

  @override
  String get couldNotOpenFileText => 'No se pudo abrir este archivo.';

  @override
  String get documentCentreTitle => 'Centro de documentos';

  @override
  String get validLabel => 'Válido';

  @override
  String get expiringSoonLabel => 'Caduca pronto';

  @override
  String get expiredLabel => 'Caducado';

  @override
  String get allFilterLabel => 'Todos';

  @override
  String get noDocumentsYetText => 'Todavía no hay documentos.';

  @override
  String get openMenuItem => 'Abrir';

  @override
  String expiresOnLabel(String date) {
    return 'Caduca $date';
  }

  @override
  String get planFriends => 'Friends';

  @override
  String get planStandard => 'Standard';

  @override
  String get planPremier => 'Premier';

  @override
  String get noPlanSelectedText => 'Ningún plan seleccionado';

  @override
  String get codeNotRecognisedText => 'Ese código no fue reconocido.';

  @override
  String get couldNotReachServerText => 'No se pudo contactar con el servidor.';

  @override
  String get discountAppliedText => 'Código de descuento aplicado.';

  @override
  String get couldNotOpenBrowserText => 'No se pudo abrir el navegador';

  @override
  String get noSubscriptionFoundText =>
      'No se encontró ninguna suscripción para esta empresa.';

  @override
  String get discountAppliedBadge => 'Descuento aplicado';

  @override
  String get directDebitSetUpText =>
      'La domiciliación bancaria está configurada para esta empresa.';

  @override
  String get directDebitNotSetUpText =>
      'Todavía no has configurado la domiciliación bancaria. Serás llevado a GoCardless - VenuRite nunca ve tus datos bancarios directamente.';

  @override
  String get discountCodeOptionalLabel => 'Código de descuento (opcional)';

  @override
  String get discountCodeHintText =>
      '¿Tienes un código \'Friends\'? Introdúcelo aquí';

  @override
  String get setUpDirectDebitButton => 'Configurar domiciliación bancaria';

  @override
  String get freeAccessCodeTitle => 'Código de acceso gratuito';

  @override
  String get freeAccessActiveText =>
      'El acceso gratuito está activo para esta empresa - no se requiere domiciliación bancaria ni pago con tarjeta.';

  @override
  String get freeAccessPromptText =>
      '¿Tienes un código de acceso gratuito? Introdúcelo aquí para usar la app completa sin configurar el pago.';

  @override
  String get redeemCodeButton => 'Canjear código';

  @override
  String get onTrialText => 'En periodo de prueba';

  @override
  String get paymentFailedGraceText =>
      'Un pago reciente falló. Actualiza tu domiciliación bancaria - el acceso continúa durante este periodo de gracia.';

  @override
  String get directDebitCancelledRestrictedText =>
      'Tu domiciliación bancaria fue cancelada. El acceso está restringido a solo lectura hasta que se configure de nuevo la facturación.';

  @override
  String get paymentOverdueRestrictedText =>
      'El pago lleva demasiado tiempo pendiente. El acceso está restringido a solo lectura hasta que se resuelva.';

  @override
  String couldNotLoadBillingDetailsError(String error) {
    return 'No se pudieron cargar los detalles de facturación: $error';
  }

  @override
  String pricePerMonthBilledLabel(String price, int units) {
    return '$price GBP/mes ($units locales facturados)';
  }

  @override
  String onTrialUntilText(String date) {
    return 'En periodo de prueba hasta $date';
  }

  @override
  String get reportedIssuesTitle => 'Problemas reportados';

  @override
  String get noDeliveriesLoggedText =>
      'No se han registrado entregas para este proveedor en este período.';

  @override
  String get scorecardCategoriesExplanation =>
      'Cada categoría a continuación cuenta de forma independiente - una entrega puede aparecer en más de una fila (p. ej. tardía Y dañada).';

  @override
  String get rejectedOutrightLabel => 'Rechazada por completo';

  @override
  String get acceptedPartiallyLabel => 'Aceptada parcialmente';

  @override
  String get reportedIssuesExplanation =>
      'Problemas de suministro reportados contra este proveedor - un registro separado del cuadro de mando de entregas anterior, no combinado con él.';

  @override
  String deliveryScorecardTitle(int count) {
    return 'Cuadro de mando de entregas ($count entregas)';
  }

  @override
  String countPercentLabel(int count, int rate) {
    return '$count ($rate%)';
  }

  @override
  String get missingNameError => 'Falta el nombre';

  @override
  String get missingJobTitleError => 'Falta el puesto';

  @override
  String get pinMustBe4DigitsError =>
      'El PIN debe tener exactamente 4 dígitos (o dejarse en blanco)';

  @override
  String get bulkStaffImportTitle => 'Importación masiva de personal';

  @override
  String get csvColumnsInstructionsText =>
      'Columnas CSV: nombre, puesto, nivel de puesto, rol de trabajo (opcional), PIN (opcional). Una fila de encabezado está bien - se detecta automáticamente. Deja el PIN en blanco para que se genere uno por ti.';

  @override
  String get chooseCsvFileButton => 'Elegir archivo CSV';

  @override
  String get chooseDifferentFileButton => 'Elegir un archivo diferente';

  @override
  String get noteDownPinsText =>
      ' Anota cada PIN a continuación antes de salir de esta pantalla.';

  @override
  String get importingEllipsisLabel => 'Importando...';

  @override
  String roleTierMustBeOneOfError(String list) {
    return 'El nivel de puesto debe ser uno de: $list';
  }

  @override
  String notAllowedToCreateTierError(String tier) {
    return 'No tienes permiso para crear una cuenta $tier';
  }

  @override
  String jobRoleMustBeOneOfError(String list) {
    return 'El rol de trabajo debe ser uno de: $list';
  }

  @override
  String csvExampleText(String example) {
    return 'Ejemplo: $example';
  }

  @override
  String rowsFoundLabel(String fileName, int count) {
    return '$fileName - $count filas encontradas';
  }

  @override
  String needFixingSuffix(int count) {
    return ', $count necesitan corrección';
  }

  @override
  String createdCountLabel(int count) {
    return '$count creados';
  }

  @override
  String failedSuffixLabel(int count) {
    return ', $count fallidos';
  }

  @override
  String importStaffCountButton(int count) {
    return 'Importar $count empleados';
  }

  @override
  String rowNumberFallback(int number) {
    return 'Fila $number';
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
      'Nivel 2 de Higiene y Seguridad Alimentaria';

  @override
  String get trainingAllergenAwareness => 'Concienciación sobre alérgenos';

  @override
  String get trainingCoshh =>
      'COSHH (Control de sustancias peligrosas para la salud)';

  @override
  String get trainingFireSafety => 'Seguridad contra incendios';

  @override
  String get trainingManualHandling => 'Manejo manual';

  @override
  String get trainingFirstAid => 'Primeros auxilios en el trabajo';

  @override
  String get trainingInduction => 'Inducción completada';

  @override
  String get itemFieldLabel => 'Elemento';

  @override
  String get customItemTitleLabel => 'Título de elemento personalizado';

  @override
  String get expiryNoneLabel => 'Caducidad: ninguna';

  @override
  String get clearExpiryTooltip => 'Borrar caducidad';

  @override
  String get certificateReferenceLabel =>
      'Referencia del certificado (opcional)';

  @override
  String get certificateReferenceHint =>
      'p. ej. número de certificado, proveedor';

  @override
  String get noTrainingRecordsYetText =>
      'Todavía no hay registros de formación.';

  @override
  String get addRecordButton => 'Añadir registro';

  @override
  String get currentLabel => 'Vigente';

  @override
  String get supersededLabel => '(sustituido)';

  @override
  String get noExpiryLabel => 'Sin caducidad';

  @override
  String addTrainingRecordTitle(String name) {
    return 'Añadir registro de formación - $name';
  }

  @override
  String completedOnLabel(String date) {
    return 'Completado: $date';
  }

  @override
  String expiryOnLabel(String date) {
    return 'Caducidad: $date';
  }

  @override
  String trainingRecordsTitle(String name) {
    return 'Registros de formación - $name';
  }

  @override
  String fullHistoryLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Historial completo ($count registros anteriores)',
      one: 'Historial completo ($count registro anterior)',
    );
    return '$_temp0';
  }

  @override
  String completedDateLabel(String date) {
    return 'Completado $date';
  }

  @override
  String certRefLabel(String ref) {
    return 'Ref.: $ref';
  }

  @override
  String get twoFactorNowOnText =>
      'La autenticación de dos factores ya está activada.';

  @override
  String get turnOffTwoFactorTitle =>
      '¿Desactivar la autenticación de dos factores?';

  @override
  String get turnOffTwoFactorConfirmText =>
      'Esta cuenta iniciará sesión solo con una contraseña de nuevo.';

  @override
  String get turnOffButton => 'Desactivar';

  @override
  String get twoFactorAuthTitle => 'Autenticación de dos factores';

  @override
  String get twoFactorOnText =>
      'La autenticación de dos factores está ACTIVADA para esta cuenta.';

  @override
  String get twoFactorOffText =>
      'La autenticación de dos factores está DESACTIVADA - actívala para una capa extra de protección en esta cuenta directiva.';

  @override
  String get enableTwoFactorButton => 'Activar autenticación de dos factores';

  @override
  String get scanAuthenticatorText =>
      'Escanea esto con tu app de autenticación (Google Authenticator, Authy, etc.), luego introduce el código de 6 dígitos que muestra.';

  @override
  String get cantScanManualEntryText =>
      '¿No puedes escanear? Introduce este código manualmente:';

  @override
  String get requiredFieldError => 'Obligatorio';

  @override
  String get joinExistingCompanyTitle => 'Unirse a una empresa existente';

  @override
  String get enterInviteCodeText =>
      'Introduce el código de invitación que te dio tu gerente.';

  @override
  String get inviteCodeLabel => 'Código de invitación';

  @override
  String get yourNameLabel => 'Tu nombre';

  @override
  String get yourEmailLabel => 'Tu correo';

  @override
  String get enterValidEmailError => 'Introduce un correo válido';

  @override
  String get choosePasswordLabel => 'Elige una contraseña';

  @override
  String get joinButton => 'Unirse';

  @override
  String get youreInSignInText =>
      'Ya estás dentro. Inicia sesión con tu correo y la contraseña que acabas de elegir.';

  @override
  String get newBranchNameTitle => 'Nombre de la nueva sucursal';

  @override
  String get renameBranchTitle => 'Renombrar sucursal';

  @override
  String get branchManagerNameTitle => 'Nombre del gerente de sucursal';

  @override
  String get accountCreatedTitle => 'Cuenta creada';

  @override
  String get giveNameAndPinText =>
      'Dale a esta persona su nombre (para tocar en la pantalla de inicio de sesión) y este PIN.';

  @override
  String get branchesTitle => 'Sucursales';

  @override
  String get noRegionSetText =>
      'Tu cuenta no tiene una región configurada - contacta a tu director.';

  @override
  String get noBranchesInRegionText =>
      'Todavía no hay sucursales en tu región.';

  @override
  String get addBranchManagerMenuItem => 'Añadir gerente de sucursal';

  @override
  String nameColonLabel(String name) {
    return 'Nombre: $name';
  }

  @override
  String pinColonLabel(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get deleteSelectedEvidenceTitle =>
      '¿Eliminar las evidencias seleccionadas?';

  @override
  String get deleteButton => 'Eliminar';

  @override
  String get photoEvidenceTitle => 'Evidencia fotográfica';

  @override
  String get onThisDeviceLabel => 'En este dispositivo';

  @override
  String get deletingFreesSpaceText =>
      'Eliminar también libera espacio en el dispositivo. Los PDF de EHO exportados ya contienen sus propias copias y no se ven afectados.';

  @override
  String get noEvidencePhotosYetText => 'Todavía no hay fotos de evidencia.';

  @override
  String deleteEvidenceConfirmText(int count, String bytes) {
    return 'Esto elimina permanentemente $count fotos ($bytes) de este dispositivo. Los PDF ya exportados no se ven afectados. Esto no se puede deshacer.';
  }

  @override
  String evidencePhotosCountLabel(int count, String bytes) {
    return '$count fotos de evidencia · $bytes en total';
  }

  @override
  String deleteSelectedButton(int count, String bytes) {
    return 'Eliminar $count seleccionadas ($bytes)';
  }

  @override
  String get addTeamMemberTitle => 'Añadir miembro del equipo';

  @override
  String get createsTapNamePinAccountText =>
      'Crea una cuenta de nombre-táctil + PIN para tu propio local.';

  @override
  String get createAccountButton => 'Crear cuenta';

  @override
  String get shiftLogTitle => 'Registro de turnos';

  @override
  String get noClockInsYetText => 'Todavía no se han registrado fichajes.';

  @override
  String get stillClockedInText => 'Todavía fichado';

  @override
  String clockInLabel(String time) {
    return 'Entrada: $time';
  }

  @override
  String clockOutLabel(String time) {
    return 'Salida: $time';
  }

  @override
  String durationHoursMinutesLabel(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get inviteCreatedTitle => 'Invitación creada';

  @override
  String get orShareCodeText =>
      'O comparte este código - lo introducirán en la pantalla \"Unirse a una empresa existente\":';

  @override
  String shareInviteExpiresText(int days) {
    return 'Comparte esto con la persona que se une - funciona una vez y caduca en $days días.';
  }

  @override
  String get contactVenuRiteTitle => 'Contactar con VenuRite';

  @override
  String get contactVenuRiteIntroText =>
      'Ya seas un grupo grande que necesita ayuda con la configuración, o simplemente tengas una pregunta - estaremos encantados de ayudar.';

  @override
  String get emailUsButton => 'Envíanos un correo';

  @override
  String taskCountOverdueLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas atrasadas',
      one: '$count tarea atrasada',
    );
    return '$_temp0';
  }

  @override
  String acrossStaffMembersLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Entre $count empleados',
      one: 'Entre $count empleado',
    );
    return '$_temp0';
  }

  @override
  String moreStaffMembersLabel(int count) {
    return '+$count empleados más';
  }

  @override
  String failCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fallos',
      one: '$count fallo',
    );
    return '$_temp0';
  }

  @override
  String notCompletedCountLabel(int count) {
    return '$count sin completar';
  }

  @override
  String issuesRaisedCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problemas notificados',
      one: '$count problema notificado',
    );
    return '$_temp0';
  }

  @override
  String shiftSummaryTitle(String name) {
    return 'Resumen del turno - $name';
  }

  @override
  String get faqQ1 => '¿Quién puede ver lo que registro?';

  @override
  String get faqA1 =>
      'Tu gerente y cualquiera por encima de él en tu local pueden ver las tareas que completas. A una persona identificada nunca se le muestra una puntuación calificada ni una tabla de clasificación - solo una lista simple de lo que hizo y cuándo.';

  @override
  String get faqQ2 => '¿Qué pasa si me pierdo una tarea durante mi turno?';

  @override
  String get faqA2 =>
      'Se registra como no completada, no como fallo - una tarea abandonada a mitad de turno es un comportamiento esperado y permitido, simplemente nunca oculto. Tu gerente la ve como su propio estado distinto.';

  @override
  String get faqQ3 => '¿Puedo volver y terminar una tarea que me salté?';

  @override
  String get faqA3 =>
      'Sí, en cualquier momento antes de que termine tu turno - permanece disponible en tu lista de tareas hasta que la completes o termine tu turno.';

  @override
  String get faqQ4 =>
      '¿Qué pasa si fallo una comprobación (p. ej. una nevera está demasiado caliente)?';

  @override
  String get faqA4 =>
      'Regístrala como FALLO, anota la acción correctiva que tomaste (o que la reportaste), y añade una foto si se te pide. Para esto es exactamente el sistema - un FALLO registrado con una solución es una historia de éxito para un inspector, no un problema para ti.';

  @override
  String get faqQ5 =>
      '¿Necesito fichar entrada y salida por separado de iniciar sesión?';

  @override
  String get faqA5 =>
      'No - iniciar sesión con tu PIN al principio de tu turno es tu fichaje de entrada. Usa \'Terminar turno\' cuando acabes, lo que también te muestra cualquier cosa que aún necesites completar.';

  @override
  String get faqQ6 => 'Reporté un problema - ¿qué le pasa?';

  @override
  String get faqA6 =>
      'Va a tu gerente (o escala más si no se gestiona a tiempo). Puedes comprobar su estado en cualquier momento desde \"Mis problemas reportados.\"';

  @override
  String get troubleQ1 => 'Mi PIN no funciona';

  @override
  String get troubleA1 =>
      'Comprueba que estás tocando primero tu propio nombre, y luego introduciendo el PIN - un PIN incorrecto en el nombre correcto da un mensaje claro de rechazo. Si sigue sin funcionar, pide a un gerente que compruebe que tu cuenta está activa y que restablezca tu PIN si es necesario.';

  @override
  String get troubleQ2 => 'Falta en mi lista una tarea que debería tener';

  @override
  String get troubleA2 =>
      'Pide a tu gerente que compruebe que está asignada a tu puesto/sección en Asignar Tareas. Las tareas solo aparecen para los puestos y departamentos para los que se han activado.';

  @override
  String get troubleQ3 => 'La app no me deja hacer una foto';

  @override
  String get troubleA3 =>
      'Asegúrate de que la app tiene permiso de cámara (comprueba los ajustes de tu dispositivo). En Windows, si no se detecta ninguna cámara, se te ofrecerá un selector de archivos en su lugar.';

  @override
  String get troubleQ4 =>
      'No puedo enviar una comprobación / no pasa nada al pulsar Enviar';

  @override
  String get troubleA4 =>
      'Esto puede pasar si la cuenta de tu empresa necesita atención de facturación - verás un mensaje claro si es así. Si no, comprueba que cada campo obligatorio (incluida cualquier foto) esté completado.';

  @override
  String get troubleQ5 => 'La app parece atascada / congelada';

  @override
  String get troubleA5 =>
      'Intenta cerrarla y volver a abrirla. Tu progreso hasta tu última tarea completada siempre se guarda a medida que avanzas, así que nada ya enviado se pierde.';

  @override
  String get troubleQ6 => 'No veo las mismas tareas que ayer';

  @override
  String get troubleA6 =>
      'Eso es normal si tu horario incluye tareas puntuales, o tareas ligadas a una franja horaria - solo aparecen cuando vencen. Pregunta a tu gerente si algo parece realmente incorrecto.';

  @override
  String taskOverdueSinceLabel(String title, String date) {
    return '$title - atrasada desde $date';
  }

  @override
  String get uploadCertificateDocumentButton => 'Subir foto del certificado';

  @override
  String get certificateDocumentUploadedLabel => 'Certificado subido';

  @override
  String get viewCertificateDocumentTooltip => 'Ver documento del certificado';

  @override
  String get certificateUploadFailed =>
      'No se pudo subir el certificado. Inténtalo de nuevo.';

  @override
  String get certificationRequirementsTitle => 'Requisitos de certificación';

  @override
  String get certificationRequirementsFloorNotice =>
      'Algunas certificaciones siempre son obligatorias para ciertos roles y no se pueden eliminar aquí (por ejemplo, los roles de manipulación de alimentos siempre requieren Higiene Alimentaria Nivel 2 y Conocimiento de Alérgenos). Puedes añadir requisitos adicionales a continuación.';

  @override
  String get noExtraCertificationRequirementsText =>
      'Aún no se han añadido requisitos adicionales.';

  @override
  String get addRequirementButton => 'Anadir requisito';

  @override
  String get addCertificationRequirementTitle =>
      'Añadir requisito de certificación';

  @override
  String get removeCertificationRequirementTitle => '¿Eliminar este requisito?';

  @override
  String get removeCertificationRequirementBody =>
      'El personal en este rol ya no necesitará esta certificación para ser programado. Esto no afecta a las certificaciones siempre obligatorias.';

  @override
  String get removeButton => 'Eliminar';

  @override
  String get cannotClaimShiftTitle => 'Aún no puedes reclamar este turno';

  @override
  String missingCertificationsMessage(String certs) {
    return 'Este puesto requiere lo siguiente, que falta o ha caducado: $certs. Pregunta a tu gerente sobre cómo renovarlo.';
  }

  @override
  String cannotAssignShiftTitle(String name) {
    return 'No se puede asignar este turno a $name';
  }

  @override
  String get allergenCelery => 'Apio';

  @override
  String get allergenGluten => 'Cereales que contienen gluten';

  @override
  String get allergenCrustaceans => 'Crustáceos';

  @override
  String get allergenEggs => 'Huevos';

  @override
  String get allergenFish => 'Pescado';

  @override
  String get allergenLupin => 'Altramuces';

  @override
  String get allergenMilk => 'Leche';

  @override
  String get allergenMolluscs => 'Moluscos';

  @override
  String get allergenMustard => 'Mostaza';

  @override
  String get allergenTreeNuts => 'Frutos de cáscara';

  @override
  String get allergenPeanuts => 'Cacahuetes';

  @override
  String get allergenSesame => 'Granos de sésamo';

  @override
  String get allergenSoya => 'Soja';

  @override
  String get allergenSulphites => 'Dióxido de azufre y sulfitos';

  @override
  String get allergenStatusContains => 'Contiene';

  @override
  String get allergenStatusMayContain => 'Puede contener';

  @override
  String get menuManagementTitle => 'Menú y alérgenos';

  @override
  String get addDishButton => 'Añadir plato';

  @override
  String get addDishTitle => 'Añadir un plato';

  @override
  String get dishNameLabel => 'Nombre del plato';

  @override
  String get dishCategoryLabel => 'Categoría (opcional)';

  @override
  String get noDishesYetText => 'Aún no se han añadido platos.';

  @override
  String get draftLabel => 'Borrador';

  @override
  String get addIngredientTitle => 'Añadir ingrediente';

  @override
  String get ingredientNameLabel => 'Nombre del ingrediente';

  @override
  String get addButton => 'Añadir';

  @override
  String get addIngredientButton => 'Añadir ingrediente';

  @override
  String get ingredientsHeading => 'Ingredientes';

  @override
  String get suggestedAllergensHeading =>
      'Alérgenos sugeridos (aún no publicados)';

  @override
  String get publishedAllergensHeading => 'Alérgenos publicados';

  @override
  String get noAllergensIdentifiedText =>
      'No se identificaron alérgenos en los ingredientes actuales.';

  @override
  String get reviewAllergensTitle => 'Revisa los alérgenos antes de publicar';

  @override
  String get allergenStatusNone => 'Ninguno';

  @override
  String get approveButton => 'Aprobar y publicar';

  @override
  String get reviewAndApproveButton => 'Revisar y aprobar';

  @override
  String get reviewAndReapproveButton => 'Revisar y volver a aprobar';

  @override
  String get allergenMatrixTitle => 'Matriz de alérgenos';

  @override
  String get allergenMatrixLegend => 'Leyenda';

  @override
  String get noApprovedDishesYetText =>
      'Aún no hay platos aprobados. Pide a un gerente que revise y apruebe los platos en Menú y alérgenos.';

  @override
  String get exportAsPdfButton => 'Exportar como PDF';

  @override
  String get allergenMatrixSubtitle =>
      'Comprueba que contiene un plato antes de que llegue al cliente';

  @override
  String get assignmentRejectedMessage =>
      'Esta asignacion fue rechazada. Comprueba el puesto y los certificados del empleado e intentalo de nuevo.';

  @override
  String get sopTemplateCleaningSchedule => 'Horario de limpieza';

  @override
  String get sopTemplateAllergenControl => 'Control de alergenos';

  @override
  String get sopTemplateDeliveryAndStorage => 'Entrega y almacenamiento';

  @override
  String get sopTemplatePersonalHygiene => 'Higiene personal';

  @override
  String get sopTemplatePestControl => 'Control de plagas';

  @override
  String get generateSopTitle => 'Generar documento SOP';

  @override
  String get sopGenerationDisclaimer =>
      'Esto crea una primera version redactada por IA de un documento de procedimiento, usando practicas generales de seguridad alimentaria del Reino Unido. Es solo un punto de partida - leelo con atencion y edita cualquier cosa especifica de tu local antes de guardarlo como documento activo.';

  @override
  String get sopTemplateFieldLabel => 'Tipo de documento';

  @override
  String get sopExtraContextLabel => 'Detalles adicionales (opcional)';

  @override
  String get sopExtraContextHint =>
      'ej. equipo especifico, roles del personal o normas propias a incluir';

  @override
  String get generatingText => 'Generando...';

  @override
  String get generateDraftButton => 'Generar borrador';

  @override
  String get documentTitleLabel => 'Titulo del documento';

  @override
  String get reviewAndEditDraftLabel => 'Revisa y edita el borrador';

  @override
  String get saveAsDocumentButton => 'Guardar en el Centro de Documentos';

  @override
  String get generateWithAiButton => 'Generar con IA';

  @override
  String get shiftPeriodsTitle => 'Periodos de turno';

  @override
  String get shiftPeriodsDescription =>
      'Divide el dia en 2 o 3 periodos (p. ej. Manana/Tarde/Noche). El calendario de turnos y la asignacion automatica los usan para filtrar y planificar por franja horaria.';

  @override
  String shiftPeriodCountOption(int count) {
    return '$count periodos';
  }

  @override
  String get shiftPeriodNameLabel => 'Nombre del periodo';

  @override
  String get shiftPeriodStartsLabel => 'Empieza';

  @override
  String get shiftPeriodEndsLabel => 'Termina';

  @override
  String get shiftPeriodsSavedMessage => 'Periodos guardados';

  @override
  String shiftPeriodsSaveFailedMessage(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get shiftPeriodDefaultDay => 'Dia';

  @override
  String get shiftPeriodDefaultNight => 'Noche';

  @override
  String get shiftPeriodDefaultMorning => 'Manana';

  @override
  String get shiftPeriodDefaultAfternoon => 'Tarde';

  @override
  String get rotaWeekTitle => 'Calendario de turnos';

  @override
  String get rosterAddonNotEnabledText =>
      'La gestion de turnos aun no esta activada para este local.';

  @override
  String get rotaTodayButton => 'Hoy';

  @override
  String get rotaFilterPeriodLabel => 'Periodo';

  @override
  String get rotaFilterAllLabel => 'Todos';

  @override
  String get rotaFilterDepartmentLabel => 'Departamento';

  @override
  String get rotaFilterPersonLabel => 'Persona';

  @override
  String get rotaUnassignedRowLabel => 'Sin asignar';

  @override
  String get setUpShiftPeriodsFirstText =>
      'Configura primero los periodos de turno (pantalla Periodos de turno).';

  @override
  String get addStaffingRequirementTitle => 'Anadir requisito de personal';

  @override
  String get anyDepartmentLabel => 'Cualquier departamento';

  @override
  String get unknownDepartmentLabel => 'Departamento desconocido';

  @override
  String get anyRoleLabel => 'Cualquier puesto';

  @override
  String get staffNeededLabel => 'Personal necesario';

  @override
  String get standbyNeededLabel => 'Reserva necesaria';

  @override
  String shiftsGeneratedMessage(int count) {
    return 'Se crearon $count turnos para esa semana.';
  }

  @override
  String shiftGenerationFailedMessage(String error) {
    return 'Error: $error';
  }

  @override
  String plusStandbyCountLabel(int count) {
    return ' + $count en reserva';
  }

  @override
  String get masterRotaSettingsTitle => 'Ajustes del turno maestro';

  @override
  String get masterRotaSettingsDescription =>
      'Define cuantas personas (y de reserva) se necesitan por dia/periodo/departamento o puesto, luego genera turnos reales para una semana de una vez.';

  @override
  String get noRequirementsYetText => 'Aun no se han configurado requisitos.';

  @override
  String get generateThisWeekButton => 'Generar esta semana';

  @override
  String get generateNextWeekButton => 'Generar la proxima semana';

  @override
  String get rotaFilterRoleLabel => 'Puesto';

  @override
  String get rotaStaffViewLabel => 'Vista de personal';

  @override
  String get rotaSlotsViewLabel => 'Vista de puestos';

  @override
  String get rotaSlotDetailTitle => 'Quien esta en este turno';

  @override
  String get rotaAssignedLabel => 'Asignados';

  @override
  String get rotaStandbyLabel => 'Reserva';

  @override
  String get rotaNoneAssignedText => 'Ninguno aun';

  @override
  String rotaUnfilledCountText(int count) {
    return 'Aun se necesitan $count';
  }

  @override
  String get daysOffRequestedMessage => 'Dias libres solicitados.';

  @override
  String get bookDaysOffToggleLabel => 'Solicitar dias libres';

  @override
  String get submitDaysOffButton => 'Enviar dias libres';

  @override
  String get alreadyRequestedOffText => 'Ya solicitado';

  @override
  String get noShiftsThisPeriodText => 'Sin turnos';

  @override
  String get youAreStandbyText => 'Estas en reserva';

  @override
  String get youAreAssignedText => 'Estas en este turno';

  @override
  String get joinStandbyButton => 'Unirse como reserva';

  @override
  String get shiftFullText => 'Completo';

  @override
  String get rotaClaimCalendarTitle => 'Reclamar turnos (calendario)';

  @override
  String get rotaMonthTitle => 'Vista mensual de turnos';

  @override
  String rotaMonthShiftCountText(int count) {
    return '$count turnos';
  }

  @override
  String get fairAutoAssignTitle => 'Asignacion automatica justa';

  @override
  String get fairAutoAssignDescription =>
      'Marca los turnos y el personal a incluir, luego revisa una vista previa de una asignacion automatica justa y explicable antes de confirmar.';

  @override
  String get selectShiftsLabel => 'Turnos abiertos a incluir';

  @override
  String get selectStaffLabel => 'Personal a incluir';

  @override
  String get noOpenShiftsThisWeekText => 'No hay turnos abiertos esta semana.';

  @override
  String get selectAllLabel => 'Seleccionar todo';

  @override
  String get previewAutoAssignButton => 'Vista previa de asignacion automatica';

  @override
  String get noShiftsOrStaffSelectedText =>
      'Selecciona al menos un turno y un miembro del personal.';

  @override
  String get fairAutoAssignPreviewTitle => 'Vista previa de asignaciones';

  @override
  String get unfilledShiftLabel => 'Sin cubrir';

  @override
  String get confirmAssignmentsButton => 'Confirmar asignaciones';

  @override
  String assignmentsConfirmedMessage(int count) {
    return '$count turno(s) asignado(s).';
  }

  @override
  String fairAutoAssignSummaryText(int filled, int total) {
    return '$filled de $total turno(s) se pueden cubrir con tu seleccion.';
  }
}
