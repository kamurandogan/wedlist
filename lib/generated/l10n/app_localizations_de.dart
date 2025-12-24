// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'WedList';

  @override
  String get welcomeMessage => 'Willkommen bei WedList';

  @override
  String get helloText => 'Hallo,';

  @override
  String get totalPaidTitle => 'Gesamt bezahlt';

  @override
  String get remainingDaysTitle => 'Verbleibende Tage';

  @override
  String get progressTitle => 'Fortschritt';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get addPartnerTitle => 'Partner hinzufügen';

  @override
  String get manageSubscriptionTitle => 'Abonnement verwalten';

  @override
  String get partnerTitle => 'Partner';

  @override
  String get partnerAdded => 'Partner hinzugefügt';

  @override
  String get partnerRemoved => 'Partner entfernt';

  @override
  String get logoutButtonText => 'Abmelden';

  @override
  String get pendingInvitations => 'Ausstehende Einladungen';

  @override
  String get pendingText => 'Ausstehend';

  @override
  String get noPartnersText => 'Noch keine Partner hinzugefügt.';

  @override
  String get changeCountry => 'Land ändern';

  @override
  String get addItemTitle => 'Artikel hinzufügen';

  @override
  String get priceTitleTextfield => 'Preis';

  @override
  String get descriptionTitleTextfield => 'Beschreibung';

  @override
  String get addPhotoButtonText => 'Foto hinzufügen';

  @override
  String get addItemButtonText => 'Hinzufügen';

  @override
  String get itemAddedSuccess => 'Artikel erfolgreich hinzugefügt!';

  @override
  String get itemLoadingButtonText => 'Lädt...';

  @override
  String get wishListTitle => 'Wunschliste';

  @override
  String get itemsTitle => 'Artikel';

  @override
  String get saveButtonText => 'Speichern';

  @override
  String get needCategoryErrorText => 'Kategoriename erforderlich';

  @override
  String get categoryUpdatedText => 'Kategorie aktualisiert';

  @override
  String get categoryCreatedText => 'Kategorie erstellt';

  @override
  String get completedCategoryText => 'Abgeschlossen';

  @override
  String get somethingWentWrongErrorText =>
      'Etwas ist schiefgelaufen. Bitte erneut versuchen.';

  @override
  String get addCategoryButtonText => 'Kategorie hinzufügen';

  @override
  String get addCategoryTextfieldHint => 'Kategoriename eingeben z.B. Küche';

  @override
  String get addCategoryTextfieldLabel => 'Kategoriename';

  @override
  String get itemFieldHint => 'Artikelnamen eingeben z.B. Toaster';

  @override
  String get itemFieldLabel => 'Artikel';

  @override
  String get notificationAcceptSuccess => 'Zusammenarbeit akzeptiert';

  @override
  String get notificationRejectSuccess => 'Anfrage abgelehnt';

  @override
  String get deleteItemTitle => 'Artikel löschen';

  @override
  String get deleteItemQuestion =>
      'Diesen Artikel endgültig löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get deleteCancel => 'Abbrechen';

  @override
  String get deleteConfirm => 'Löschen';

  @override
  String get deleteItemDone => 'Artikel gelöscht';

  @override
  String get notificationsEmpty => 'Noch keine Benachrichtigungen';

  @override
  String get errorPrefix => 'Fehler:';

  @override
  String get collabRequestAcceptedTitle =>
      'Ihre Kollaborationsanfrage wurde akzeptiert';

  @override
  String get collabRequestRejectedTitle =>
      'Ihre Kollaborationsanfrage wurde abgelehnt';

  @override
  String get notificationItemAddedBody => 'Zur Liste hinzugefügt';

  @override
  String get notificationItemDeletedBody => 'Von der Liste entfernt';

  @override
  String get notificationItemAddedSuffix => 'hinzugefügt';

  @override
  String get notificationItemDeletedSuffix => 'gelöscht';

  @override
  String get onboardingTitle1 => 'Plane deine Aussteuer einfach';

  @override
  String get onboardingBody1 =>
      'Verwalte alle deine Hochzeitsvorbereitungen von deinem Handy aus, kategorisiere deine Bedürfnisse und vergiss kein Detail.';

  @override
  String get onboardingTitle2 => 'Verfolge gemeinsam mit deinem Partner';

  @override
  String get onboardingBody2 =>
      'Arbeitet gemeinsam an derselben Liste, seht sofort, wer was gekauft hat und was noch fehlt, und macht gemeinsam Fortschritte.';

  @override
  String get onboardingTitle3 => 'Behalte deine Ausgaben im Blick';

  @override
  String get onboardingBody3 =>
      'Überschreite nicht dein Budget, sieh sofort deine Gesamt- und Kategoriekosten und verfolge alles auf deinem Handy.';

  @override
  String get selectCountryTitle => 'Wählen Sie Ihr Land';

  @override
  String get collaboratorEmailLabel => 'Mit E-Mail Mitwirkenden hinzufügen';

  @override
  String get purchaseUnsupported =>
      'In-App-Käufe werden auf diesem Gerät nicht unterstützt oder kein Store-Konto verfügbar.';

  @override
  String get purchaseSuccess => 'Kauf erfolgreich';

  @override
  String get purchaseFailed => 'Kauf konnte nicht abgeschlossen werden';

  @override
  String get removeAdsTitle => 'Werbung entfernen';

  @override
  String get restorePurchasesTitle => 'Käufe wiederherstellen';

  @override
  String get restoringPurchasesMessage => 'Wiederherstellung von Käufen';

  @override
  String get alreadyHasPartnerError =>
      'Sie haben bereits einen Partner. Entfernen Sie zuerst den aktuellen Partner.';

  @override
  String get userNotFoundError => 'Benutzer nicht gefunden';

  @override
  String get cannotInviteSelfError => 'Sie können sich nicht selbst einladen';

  @override
  String get inviteAlreadyPendingError =>
      'Es gibt bereits eine ausstehende Einladung an diesen Benutzer';

  @override
  String get genericUserLabel => 'Ein Benutzer';

  @override
  String collabRequestTitle(Object inviter) {
    return '$inviter hat Sie als Mitarbeiter eingeladen';
  }

  @override
  String get deleteAccountTitle => 'Konto löschen';

  @override
  String get supportAndHelpTitle => 'Support & Hilfe';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get signInButtonText => 'Anmelden';

  @override
  String get dontHaveAccount => 'Noch kein Konto?';

  @override
  String get registerHere => 'Hier registrieren';

  @override
  String get signInWithApple => 'Mit Apple anmelden';

  @override
  String get signInWithGoogle => 'Mit Google anmelden';

  @override
  String get loginRequiredForSection =>
      'Bitte melden Sie sich an, um diesen Bereich zu sehen.';

  @override
  String get loginRequiredForWishlist =>
      'Bitte melden Sie sich an, um Ihre Wunschliste zu sehen.';

  @override
  String get verificationEmailResent =>
      'Bestätigungs-E-Mail wurde erneut gesendet.';

  @override
  String get emailNotVerifiedYet =>
      'Ihre E-Mail-Adresse ist noch nicht verifiziert. Bitte prüfen Sie Ihr Postfach und klicken Sie auf den Link.';

  @override
  String get verificationTitle => 'Verifizierung';

  @override
  String get verificationInstruction =>
      'Bitte klicken Sie auf den Bestätigungslink, der an Ihre E-Mail gesendet wurde.';

  @override
  String verificationInstructionWithEmail(String email) {
    return 'Bitte klicken Sie auf den Bestätigungslink, der an $email gesendet wurde.';
  }

  @override
  String get resendButton => 'Erneut senden';

  @override
  String get checkVerificationButton => 'Verifizierung prüfen';

  @override
  String get accountDeletedPermanently => 'Ihr Konto wurde dauerhaft gelöscht.';

  @override
  String get reauthRequiredMessage =>
      'Aus Sicherheitsgründen melden Sie sich bitte erneut an und versuchen Sie dann, Ihr Konto zu löschen.';

  @override
  String get deleteAccountWarning =>
      'Sie sind dabei, Ihr Konto und zugehörige Daten dauerhaft zu löschen. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get deleteAccountExportNotice =>
      'Stellen Sie sicher, dass Sie wichtige Daten exportiert haben, bevor Sie fortfahren.';

  @override
  String get deleteAccountConfirmButton => 'Konto dauerhaft löschen';

  @override
  String get bottomNavHome => 'Startseite';

  @override
  String get bottomNavWishlist => 'Wunschliste';

  @override
  String get bottomNavDowryList => 'Mitgiftliste';

  @override
  String get bottomNavNotification => 'Benachrichtigungen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get itemLimitReachedTitle => 'Artikellimit erreicht';

  @override
  String itemLimitReachedMessage(int count) {
    return 'Sie haben $count Artikel hinzugefügt. Um fortzufahren:';
  }

  @override
  String get watchAdForItemsButton => 'Werbung ansehen (+5 Artikel)';

  @override
  String get buyRemoveAdsButton => 'Werbung entfernen (Unbegrenzt)';

  @override
  String itemsRemainingInfo(int count) {
    return '$count Artikel übrig';
  }

  @override
  String freeItemsRemaining(int count) {
    return 'Kostenlos: $count Artikel übrig';
  }

  @override
  String get adOptionFreeLabel => 'Kostenlos';

  @override
  String get adOptionPremiumLabel => 'Premium-Funktionen';

  @override
  String get adOptionRecommendedBadge => 'EMPFOHLEN';

  @override
  String get adLoadingText => 'Werbung wird geladen...';

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

  @override
  String get internetConnectionRequired => 'Internetverbindung erforderlich';

  @override
  String get wishlistRequiresInternet =>
      'Bitte überprüfen Sie Ihre Internetverbindung, um die Wunschliste anzuzeigen.';

  @override
  String get checkConnectionAndRetry =>
      'Verbindung prüfen und erneut versuchen';
}
