// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'WedList';

  @override
  String get welcomeMessage => 'Bienvenido a WedList';

  @override
  String get helloText => 'Hola,';

  @override
  String get totalPaidTitle => 'Total Pagado';

  @override
  String get remainingDaysTitle => 'Días Restantes';

  @override
  String get progressTitle => 'Progreso';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get addPartnerTitle => 'Agregar Pareja';

  @override
  String get manageSubscriptionTitle => 'Gestionar Suscripción';

  @override
  String get partnerTitle => 'Pareja';

  @override
  String get partnerAdded => 'Pareja agregada';

  @override
  String get partnerRemoved => 'Pareja eliminada';

  @override
  String get logoutButtonText => 'Cerrar sesión';

  @override
  String get pendingInvitations => 'Invitaciones Pendientes';

  @override
  String get pendingText => 'Pendiente';

  @override
  String get noPartnersText => 'Aún no se han agregado parejas.';

  @override
  String get changeCountry => 'Cambiar País';

  @override
  String get addItemTitle => 'Agregar Ítem';

  @override
  String get priceTitleTextfield => 'Precio';

  @override
  String get descriptionTitleTextfield => 'Descripción';

  @override
  String get addPhotoButtonText => 'Agregar Foto';

  @override
  String get addItemButtonText => 'Agregar';

  @override
  String get itemAddedSuccess => '¡Ítem agregado con éxito!';

  @override
  String get itemLoadingButtonText => 'Cargando...';

  @override
  String get wishListTitle => 'Lista de Deseos';

  @override
  String get itemsTitle => 'Ítems';

  @override
  String get saveButtonText => 'Guardar';

  @override
  String get needCategoryErrorText => 'Se requiere nombre de categoría';

  @override
  String get categoryUpdatedText => 'Categoría actualizada';

  @override
  String get categoryCreatedText => 'Categoría creada';

  @override
  String get completedCategoryText => 'Completado';

  @override
  String get somethingWentWrongErrorText =>
      'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get addCategoryButtonText => 'Agregar Categoría';

  @override
  String get addCategoryTextfieldHint =>
      'Ingrese nombre de categoría ej. Cocina';

  @override
  String get addCategoryTextfieldLabel => 'Nombre de categoría';

  @override
  String get itemFieldHint => 'Ingrese nombre del ítem ej. Tostadora';

  @override
  String get itemFieldLabel => 'Ítem';

  @override
  String get notificationAcceptSuccess => 'Colaboración aceptada';

  @override
  String get notificationRejectSuccess => 'Solicitud rechazada';

  @override
  String get deleteItemTitle => 'Eliminar Ítem';

  @override
  String get deleteItemQuestion =>
      '¿Eliminar permanentemente este ítem? Esta acción no se puede deshacer.';

  @override
  String get deleteCancel => 'Cancelar';

  @override
  String get deleteConfirm => 'Eliminar';

  @override
  String get deleteItemDone => 'Ítem eliminado';

  @override
  String get notificationsEmpty => 'Aún no tienes notificaciones';

  @override
  String get errorPrefix => 'Error:';

  @override
  String get collabRequestAcceptedTitle =>
      'Tu solicitud de colaboración fue aceptada';

  @override
  String get collabRequestRejectedTitle =>
      'Tu solicitud de colaboración fue rechazada';

  @override
  String get notificationItemAddedBody => 'Agregado a la lista';

  @override
  String get notificationItemDeletedBody => 'Eliminado de la lista';

  @override
  String get notificationItemAddedSuffix => 'añadido';

  @override
  String get notificationItemDeletedSuffix => 'eliminado';

  @override
  String get onboardingTitle1 => 'Planifica tu ajuar fácilmente';

  @override
  String get onboardingBody1 =>
      'Gestiona todos tus preparativos de boda desde tu teléfono, categoriza tus necesidades y no te pierdas ningún detalle.';

  @override
  String get onboardingTitle2 => 'Haz el seguimiento junto a tu pareja';

  @override
  String get onboardingBody2 =>
      'Trabaja en la misma lista con tu pareja, ve al instante quién compró qué y qué queda, y disfruta avanzando juntos.';

  @override
  String get onboardingTitle3 => 'Controla tus gastos';

  @override
  String get onboardingBody3 =>
      'No excedas tu presupuesto, ve al instante tus gastos totales y por categoría, y haz el seguimiento desde tu móvil.';

  @override
  String get selectCountryTitle => 'Seleccione su país';

  @override
  String get collaboratorEmailLabel =>
      'Agregar colaborador por correo electrónico';

  @override
  String get purchaseUnsupported =>
      'Las compras dentro de la aplicación no son compatibles en este dispositivo o no hay una cuenta de tienda disponible.';

  @override
  String get purchaseSuccess => 'Compra exitosa';

  @override
  String get purchaseFailed => 'No se pudo completar la compra';

  @override
  String get removeAdsTitle => 'Eliminar anuncios';

  @override
  String get restorePurchasesTitle => 'Restaurar compras';

  @override
  String get restoringPurchasesMessage => 'Restaurando compras';

  @override
  String get alreadyHasPartnerError =>
      'Ya tienes una pareja. Elimina primero a la pareja actual.';

  @override
  String get userNotFoundError => 'Usuario no encontrado';

  @override
  String get cannotInviteSelfError => 'No puedes invitarte a ti mismo';

  @override
  String get inviteAlreadyPendingError =>
      'Ya hay una invitación pendiente para este usuario';

  @override
  String get genericUserLabel => 'Un usuario';

  @override
  String collabRequestTitle(Object inviter) {
    return '$inviter te invitó como colaborador';
  }

  @override
  String get deleteAccountTitle => 'Eliminar cuenta';

  @override
  String get supportAndHelpTitle => 'Soporte y Ayuda';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get signInButtonText => 'Iniciar sesión';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get registerHere => 'Regístrate aquí';

  @override
  String get signInWithApple => 'Iniciar con Apple';

  @override
  String get signInWithGoogle => 'Iniciar con Google';

  @override
  String get loginRequiredForSection => 'Inicia sesión para ver esta sección.';

  @override
  String get loginRequiredForWishlist =>
      'Inicia sesión para ver tu lista de deseos.';

  @override
  String get verificationEmailResent =>
      'El correo de verificación ha sido reenviado.';

  @override
  String get emailNotVerifiedYet =>
      'Tu correo aún no está verificado. Revisa tu bandeja e haz clic en el enlace.';

  @override
  String get verificationTitle => 'Verificación';

  @override
  String get verificationInstruction =>
      'Haz clic en el enlace de verificación enviado a tu correo.';

  @override
  String verificationInstructionWithEmail(String email) {
    return 'Haz clic en el enlace de verificación enviado a $email.';
  }

  @override
  String get resendButton => 'Reenviar';

  @override
  String get checkVerificationButton => 'Comprobar verificación';

  @override
  String get accountDeletedPermanently =>
      'Tu cuenta ha sido eliminada permanentemente.';

  @override
  String get reauthRequiredMessage =>
      'Por seguridad, inicia sesión de nuevo y vuelve a intentar eliminar tu cuenta.';

  @override
  String get deleteAccountWarning =>
      'Vas a eliminar permanentemente tu cuenta y los datos asociados. Esta acción no se puede deshacer.';

  @override
  String get deleteAccountExportNotice =>
      'Asegúrate de exportar los datos importantes antes de continuar.';

  @override
  String get deleteAccountConfirmButton => 'Eliminar mi cuenta permanentemente';

  @override
  String get bottomNavHome => 'Inicio';

  @override
  String get bottomNavWishlist => 'Lista de Deseos';

  @override
  String get bottomNavDowryList => 'Lista de Dote';

  @override
  String get bottomNavNotification => 'Notificaciones';

  @override
  String get cancel => 'Cancelar';

  @override
  String get itemLimitReachedTitle => 'Límite de artículos alcanzado';

  @override
  String itemLimitReachedMessage(int count) {
    return 'Has añadido $count artículos. Para continuar:';
  }

  @override
  String get watchAdForItemsButton => 'Ver anuncio (+5 artículos)';

  @override
  String get buyRemoveAdsButton => 'Quitar anuncios (Ilimitado)';

  @override
  String itemsRemainingInfo(int count) {
    return '$count artículos restantes';
  }

  @override
  String freeItemsRemaining(int count) {
    return 'Gratis: $count artículos restantes';
  }

  @override
  String get adOptionFreeLabel => 'Gratis';

  @override
  String get adOptionPremiumLabel => 'Funciones premium';

  @override
  String get adOptionRecommendedBadge => 'RECOMENDADO';

  @override
  String get adLoadingText => 'Cargando anuncio...';

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String get onlineModeRequired => 'This feature requires internet connection';

  @override
  String get skipLogin => 'Explore First';

  @override
  String get createAccountOrLogin => 'Create Account / Sign In';

  @override
  String get offlineOnboardingMessage =>
      'Create an account to manage your wedding list together with your partner, or explore the app first!';

  @override
  String get offlineModeActive => 'You\'re in Offline Mode';

  @override
  String get loginToSyncData =>
      'Sign in to back up your data and share with your partner';

  @override
  String get loginButton => 'Sign In';

  @override
  String get migrationInProgress => 'Syncing your data...';

  @override
  String get migrationSuccess => 'Your data has been successfully synced';

  @override
  String get migrationFailed => 'Sync failed. Please try again.';

  @override
  String get offlineDataWillSync =>
      'Your data will be automatically synced when you sign in';

  @override
  String migrationPartialSuccess(int migratedCount, int failedCount) {
    return '$migratedCount items synced, $failedCount items failed';
  }
}
