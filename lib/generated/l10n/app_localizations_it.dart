// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'WedList';

  @override
  String get welcomeMessage => 'Benvenuto su WedList';

  @override
  String get helloText => 'Ciao,';

  @override
  String get totalPaidTitle => 'Totale Pagato';

  @override
  String get remainingDaysTitle => 'Giorni Rimanenti';

  @override
  String get progressTitle => 'Progresso';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get addPartnerTitle => 'Aggiungi Partner';

  @override
  String get manageSubscriptionTitle => 'Gestisci Abbonamento';

  @override
  String get partnerTitle => 'Partner';

  @override
  String get partnerAdded => 'Partner aggiunto';

  @override
  String get partnerRemoved => 'Partner rimosso';

  @override
  String get logoutButtonText => 'Logout';

  @override
  String get pendingInvitations => 'Inviti in sospeso';

  @override
  String get pendingText => 'In sospeso';

  @override
  String get noPartnersText => 'Nessun partner aggiunto ancora.';

  @override
  String get changeCountry => 'Cambia Paese';

  @override
  String get addItemTitle => 'Aggiungi Elemento';

  @override
  String get priceTitleTextfield => 'Prezzo';

  @override
  String get descriptionTitleTextfield => 'Descrizione';

  @override
  String get addPhotoButtonText => 'Aggiungi Foto';

  @override
  String get addItemButtonText => 'Aggiungi';

  @override
  String get itemAddedSuccess => 'Elemento aggiunto con successo!';

  @override
  String get itemLoadingButtonText => 'Caricamento...';

  @override
  String get wishListTitle => 'Lista dei Desideri';

  @override
  String get itemsTitle => 'Elementi';

  @override
  String get saveButtonText => 'Salva';

  @override
  String get needCategoryErrorText => 'Nome categoria obbligatorio';

  @override
  String get categoryUpdatedText => 'Categoria aggiornata';

  @override
  String get categoryCreatedText => 'Categoria creata';

  @override
  String get completedCategoryText => 'Completato';

  @override
  String get somethingWentWrongErrorText =>
      'Qualcosa è andato storto. Riprova.';

  @override
  String get addCategoryButtonText => 'Aggiungi Categoria';

  @override
  String get addCategoryTextfieldHint => 'Inserisci nome categoria es. Cucina';

  @override
  String get addCategoryTextfieldLabel => 'Nome categoria';

  @override
  String get itemFieldHint => 'Inserisci nome elemento es. Tostapane';

  @override
  String get itemFieldLabel => 'Elemento';

  @override
  String get notificationAcceptSuccess => 'Collaborazione accettata';

  @override
  String get notificationRejectSuccess => 'Richiesta rifiutata';

  @override
  String get deleteItemTitle => 'Elimina Elemento';

  @override
  String get deleteItemQuestion =>
      'Eliminare definitivamente questo elemento? L\'azione non può essere annullata.';

  @override
  String get deleteCancel => 'Annulla';

  @override
  String get deleteConfirm => 'Elimina';

  @override
  String get deleteItemDone => 'Elemento eliminato';

  @override
  String get notificationsEmpty => 'Non hai ancora notifiche';

  @override
  String get errorPrefix => 'Errore:';

  @override
  String get collabRequestAcceptedTitle =>
      'La tua richiesta di collaborazione è stata accettata';

  @override
  String get collabRequestRejectedTitle =>
      'La tua richiesta di collaborazione è stata rifiutata';

  @override
  String get notificationItemAddedBody => 'Aggiunto alla lista';

  @override
  String get notificationItemDeletedBody => 'Rimosso dalla lista';

  @override
  String get notificationItemAddedSuffix => 'aggiunto';

  @override
  String get notificationItemDeletedSuffix => 'eliminato';

  @override
  String get onboardingTitle1 => 'Organizza il tuo corredo facilmente';

  @override
  String get onboardingBody1 =>
      'Gestisci tutti i preparativi per il matrimonio dal tuo telefono, categorizza le tue necessità e non perdere nessun dettaglio.';

  @override
  String get onboardingTitle2 => 'Tieni traccia insieme al partner';

  @override
  String get onboardingBody2 =>
      'Lavora sulla stessa lista con il tuo partner, vedi subito chi ha comprato cosa e cosa manca, e avanzate insieme.';

  @override
  String get onboardingTitle3 => 'Controlla le tue spese';

  @override
  String get onboardingBody3 =>
      'Non superare il budget, vedi subito le spese totali e per categoria, e tieni tutto sotto controllo dal tuo dispositivo mobile.';

  @override
  String get selectCountryTitle => 'Seleziona il tuo paese';

  @override
  String get collaboratorEmailLabel => 'Aggiungi collaboratore tramite e-mail';

  @override
  String get purchaseUnsupported =>
      'Acquisti in-app non supportati su questo dispositivo o nessun account del negozio disponibile.';

  @override
  String get purchaseSuccess => 'Acquisto riuscito';

  @override
  String get purchaseFailed => 'Impossibile completare l\'acquisto';

  @override
  String get removeAdsTitle => 'Rimuovi annunci';

  @override
  String get restorePurchasesTitle => 'Ripristina acquisti';

  @override
  String get restoringPurchasesMessage => 'Ripristino degli acquisti';

  @override
  String get alreadyHasPartnerError =>
      'Hai già un partner. Rimuovi prima il partner attuale.';

  @override
  String get userNotFoundError => 'Utente non trovato';

  @override
  String get cannotInviteSelfError => 'Non puoi invitare te stesso';

  @override
  String get inviteAlreadyPendingError =>
      'C\'è già un invito in sospeso per questo utente';

  @override
  String get genericUserLabel => 'Un utente';

  @override
  String collabRequestTitle(Object inviter) {
    return '$inviter ti ha invitato come collaboratore';
  }

  @override
  String get deleteAccountTitle => 'Elimina account';

  @override
  String get supportAndHelpTitle => 'Supporto e Aiuto';

  @override
  String get loginTitle => 'Accesso';

  @override
  String get signInButtonText => 'Accedi';

  @override
  String get dontHaveAccount => 'Non hai un account?';

  @override
  String get registerHere => 'Registrati qui';

  @override
  String get signInWithApple => 'Accedi con Apple';

  @override
  String get signInWithGoogle => 'Accedi con Google';

  @override
  String get loginRequiredForSection =>
      'Accedi per visualizzare questa sezione.';

  @override
  String get loginRequiredForWishlist =>
      'Accedi per visualizzare la tua lista dei desideri.';

  @override
  String get verificationEmailResent => 'Email di verifica reinviata.';

  @override
  String get emailNotVerifiedYet =>
      'La tua email non è ancora verificata. Controlla la posta e clicca sul link.';

  @override
  String get verificationTitle => 'Verifica';

  @override
  String get verificationInstruction =>
      'Clicca sul link di verifica inviato alla tua email.';

  @override
  String verificationInstructionWithEmail(String email) {
    return 'Clicca sul link inviato a $email.';
  }

  @override
  String get resendButton => 'Reinvia';

  @override
  String get checkVerificationButton => 'Controlla verifica';

  @override
  String get accountDeletedPermanently =>
      'Il tuo account è stato eliminato definitivamente.';

  @override
  String get reauthRequiredMessage =>
      'Per motivi di sicurezza, accedi di nuovo e riprova a eliminare l\'account.';

  @override
  String get deleteAccountWarning =>
      'Stai per eliminare definitivamente il tuo account e i dati associati. Questa azione non può essere annullata.';

  @override
  String get deleteAccountExportNotice =>
      'Assicurati di esportare i dati importanti prima di procedere.';

  @override
  String get deleteAccountConfirmButton =>
      'Elimina definitivamente il mio account';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavWishlist => 'Lista Desideri';

  @override
  String get bottomNavDowryList => 'Lista Dote';

  @override
  String get bottomNavNotification => 'Notifiche';

  @override
  String get cancel => 'Annulla';

  @override
  String get itemLimitReachedTitle => 'Limite articoli raggiunto';

  @override
  String itemLimitReachedMessage(int count) {
    return 'Hai aggiunto $count articoli. Per continuare:';
  }

  @override
  String get watchAdForItemsButton => 'Guarda annuncio (+5 articoli)';

  @override
  String get buyRemoveAdsButton => 'Rimuovi annunci (Illimitato)';

  @override
  String itemsRemainingInfo(int count) {
    return '$count articoli rimanenti';
  }

  @override
  String freeItemsRemaining(int count) {
    return 'Gratis: $count articoli rimanenti';
  }

  @override
  String get adOptionFreeLabel => 'Gratis';

  @override
  String get adOptionPremiumLabel => 'Funzionalità premium';

  @override
  String get adOptionRecommendedBadge => 'CONSIGLIATO';

  @override
  String get adLoadingText => 'Caricamento annuncio...';

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
