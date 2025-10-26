// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'WedList';

  @override
  String get welcomeMessage => 'Bienvenue sur WedList';

  @override
  String get helloText => 'Bonjour,';

  @override
  String get totalPaidTitle => 'Total Payé';

  @override
  String get remainingDaysTitle => 'Jours Restants';

  @override
  String get progressTitle => 'Progression';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get addPartnerTitle => 'Ajouter un partenaire';

  @override
  String get manageSubscriptionTitle => 'Gérer l\'abonnement';

  @override
  String get partnerTitle => 'Partenaire';

  @override
  String get partnerAdded => 'Partenaire ajouté';

  @override
  String get partnerRemoved => 'Partenaire supprimé';

  @override
  String get logoutButtonText => 'Déconnexion';

  @override
  String get pendingInvitations => 'Invitations en attente';

  @override
  String get pendingText => 'En attente';

  @override
  String get noPartnersText => 'Aucun partenaire ajouté pour le moment.';

  @override
  String get changeCountry => 'Changer de pays';

  @override
  String get addItemTitle => 'Ajouter un article';

  @override
  String get priceTitleTextfield => 'Prix';

  @override
  String get descriptionTitleTextfield => 'Description';

  @override
  String get addPhotoButtonText => 'Ajouter une photo';

  @override
  String get addItemButtonText => 'Ajouter';

  @override
  String get itemAddedSuccess => 'Article ajouté avec succès !';

  @override
  String get itemLoadingButtonText => 'Chargement...';

  @override
  String get wishListTitle => 'Liste de souhaits';

  @override
  String get itemsTitle => 'Articles';

  @override
  String get saveButtonText => 'Enregistrer';

  @override
  String get needCategoryErrorText => 'Nom de catégorie requis';

  @override
  String get categoryUpdatedText => 'Catégorie mise à jour';

  @override
  String get categoryCreatedText => 'Catégorie créée';

  @override
  String get completedCategoryText => 'Terminé';

  @override
  String get somethingWentWrongErrorText =>
      'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get addCategoryButtonText => 'Ajouter une catégorie';

  @override
  String get addCategoryTextfieldHint =>
      'Entrez le nom de catégorie ex. Cuisine';

  @override
  String get addCategoryTextfieldLabel => 'Nom de catégorie';

  @override
  String get itemFieldHint => 'Entrez le nom de l\'article ex. Grille-pain';

  @override
  String get itemFieldLabel => 'Article';

  @override
  String get notificationAcceptSuccess => 'Collaboration acceptée';

  @override
  String get notificationRejectSuccess => 'Demande refusée';

  @override
  String get deleteItemTitle => 'Supprimer l\'article';

  @override
  String get deleteItemQuestion =>
      'Supprimer définitivement cet article ? Cette action est irréversible.';

  @override
  String get deleteCancel => 'Annuler';

  @override
  String get deleteConfirm => 'Supprimer';

  @override
  String get deleteItemDone => 'Article supprimé';

  @override
  String get notificationsEmpty => 'Vous n\'avez pas encore de notifications';

  @override
  String get errorPrefix => 'Erreur :';

  @override
  String get collabRequestAcceptedTitle =>
      'Votre demande de collaboration a été acceptée';

  @override
  String get collabRequestRejectedTitle =>
      'Votre demande de collaboration a été refusée';

  @override
  String get notificationItemAddedBody => 'Ajouté à la liste';

  @override
  String get notificationItemDeletedBody => 'Retiré de la liste';

  @override
  String get notificationItemAddedSuffix => 'ajouté';

  @override
  String get notificationItemDeletedSuffix => 'supprimé';

  @override
  String get onboardingTitle1 => 'Planifiez votre trousseau facilement';

  @override
  String get onboardingBody1 =>
      'Gérez tous vos préparatifs de mariage depuis votre téléphone, catégorisez vos besoins et ne manquez aucun détail.';

  @override
  String get onboardingTitle2 => 'Suivez avec votre partenaire';

  @override
  String get onboardingBody2 =>
      'Travaillez sur la même liste avec votre conjoint, voyez instantanément qui a acheté quoi et ce qu\'il reste, et progressez ensemble.';

  @override
  String get onboardingTitle3 => 'Contrôlez vos dépenses';

  @override
  String get onboardingBody3 =>
      'Ne dépassez pas votre budget, voyez instantanément vos dépenses totales et par catégorie, et suivez tout depuis votre mobile.';

  @override
  String get selectCountryTitle => 'Sélectionnez votre pays';

  @override
  String get collaboratorEmailLabel => 'Ajouter un collaborateur par e-mail';

  @override
  String get partnerFeatureRequired => 'Fonction de partenaire requise';

  @override
  String get enablePartnerFeatureTitle => 'Activer la fonction partenaire';

  @override
  String get purchaseUnsupported =>
      'Les achats intégrés ne sont pas pris en charge sur cet appareil ou aucun compte de magasin n\'est disponible.';

  @override
  String get purchaseSuccess => 'Achat réussi';

  @override
  String get purchaseFailed => 'L\'achat n\'a pas pu être effectué';

  @override
  String get removeAdsTitle => 'Supprimer les publicités';

  @override
  String get restorePurchasesTitle => 'Restaurer les achats';

  @override
  String get restoringPurchasesMessage => 'Restauration des achats';

  @override
  String get alreadyHasPartnerError =>
      'Vous avez déjà un partenaire. Supprimez d\'abord le partenaire actuel.';

  @override
  String get userNotFoundError => 'Utilisateur introuvable';

  @override
  String get cannotInviteSelfError =>
      'Vous ne pouvez pas vous inviter vous-même';

  @override
  String get targetNotEntitledError =>
      'L\'utilisateur n\'a pas acheté la fonction partenaire';

  @override
  String get inviteAlreadyPendingError =>
      'Il y a déjà une invitation en attente pour cet utilisateur';

  @override
  String get genericUserLabel => 'Un utilisateur';

  @override
  String collabRequestTitle(Object inviter) {
    return '$inviter vous a invité comme collaborateur';
  }

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get supportAndHelpTitle => 'Support & Aide';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get signInButtonText => 'Se connecter';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get registerHere => 'Inscrivez-vous ici';

  @override
  String get signInWithApple => 'Se connecter avec Apple';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get loginRequiredForSection =>
      'Veuillez vous connecter pour voir cette section.';

  @override
  String get loginRequiredForWishlist =>
      'Veuillez vous connecter pour voir votre liste de souhaits.';

  @override
  String get verificationEmailResent => 'E-mail de vérification renvoyé.';

  @override
  String get emailNotVerifiedYet =>
      'Votre adresse e-mail n\'est pas encore vérifiée. Veuillez vérifier votre boîte et cliquer sur le lien.';

  @override
  String get verificationTitle => 'Vérification';

  @override
  String get verificationInstruction =>
      'Veuillez cliquer sur le lien de vérification envoyé à votre e-mail.';

  @override
  String verificationInstructionWithEmail(String email) {
    return 'Veuillez cliquer sur le lien envoyé à $email.';
  }

  @override
  String get resendButton => 'Renvoyer';

  @override
  String get checkVerificationButton => 'Vérifier';

  @override
  String get accountDeletedPermanently =>
      'Votre compte a été supprimé définitivement.';

  @override
  String get reauthRequiredMessage =>
      'Pour des raisons de sécurité, reconnectez-vous puis réessayez de supprimer votre compte.';

  @override
  String get deleteAccountWarning =>
      'Vous êtes sur le point de supprimer définitivement votre compte et ses données. Cette action est irréversible.';

  @override
  String get deleteAccountExportNotice =>
      'Assurez-vous d\'exporter les données importantes avant de continuer.';

  @override
  String get deleteAccountConfirmButton =>
      'Supprimer mon compte définitivement';

  @override
  String get bottomNavHome => 'Accueil';

  @override
  String get bottomNavWishlist => 'Liste de Souhaits';

  @override
  String get bottomNavDowryList => 'Liste de Dot';

  @override
  String get bottomNavNotification => 'Notifications';

  @override
  String get cancel => 'Annuler';

  @override
  String get itemLimitReachedTitle => 'Limite d\'articles atteinte';

  @override
  String itemLimitReachedMessage(int count) {
    return 'Vous avez ajouté $count articles. Pour continuer:';
  }

  @override
  String get watchAdForItemsButton => 'Regarder une pub (+5 articles)';

  @override
  String get buyRemoveAdsButton => 'Supprimer les pubs (Illimité)';

  @override
  String itemsRemainingInfo(int count) {
    return '$count articles restants';
  }

  @override
  String freeItemsRemaining(int count) {
    return 'Gratuit: $count articles restants';
  }

  @override
  String get adOptionFreeLabel => 'Gratuit';

  @override
  String get adOptionPremiumLabel => 'Fonctionnalités premium';

  @override
  String get adOptionRecommendedBadge => 'RECOMMANDÉ';

  @override
  String get adLoadingText => 'Chargement de la pub...';
}
