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
}
