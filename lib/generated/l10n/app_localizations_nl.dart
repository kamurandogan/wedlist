// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'WedList';

  @override
  String get welcomeMessage => 'Welkom bij WedList';

  @override
  String get helloText => 'Hallo,';

  @override
  String get totalPaidTitle => 'Totaal Betaald';

  @override
  String get remainingDaysTitle => 'Resterende Dagen';

  @override
  String get progressTitle => 'Voortgang';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get addPartnerTitle => 'Partner toevoegen';

  @override
  String get manageSubscriptionTitle => 'Abonnement beheren';

  @override
  String get partnerTitle => 'Partner';

  @override
  String get partnerAdded => 'Partner toegevoegd';

  @override
  String get partnerRemoved => 'Partner verwijderd';

  @override
  String get logoutButtonText => 'Uitloggen';

  @override
  String get pendingInvitations => 'Openstaande Uitnodigingen';

  @override
  String get pendingText => 'Openstaand';

  @override
  String get noPartnersText => 'Nog geen partners toegevoegd.';

  @override
  String get changeCountry => 'Land wijzigen';

  @override
  String get addItemTitle => 'Item toevoegen';

  @override
  String get priceTitleTextfield => 'Prijs';

  @override
  String get descriptionTitleTextfield => 'Beschrijving';

  @override
  String get addPhotoButtonText => 'Foto toevoegen';

  @override
  String get addItemButtonText => 'Toevoegen';

  @override
  String get itemAddedSuccess => 'Item succesvol toegevoegd!';

  @override
  String get itemLoadingButtonText => 'Laden...';

  @override
  String get wishListTitle => 'Verlanglijst';

  @override
  String get itemsTitle => 'Items';

  @override
  String get saveButtonText => 'Opslaan';

  @override
  String get needCategoryErrorText => 'Categorienaam is verplicht';

  @override
  String get categoryUpdatedText => 'Categorie bijgewerkt';

  @override
  String get categoryCreatedText => 'Categorie aangemaakt';

  @override
  String get completedCategoryText => 'Voltooid';

  @override
  String get somethingWentWrongErrorText =>
      'Er is iets misgegaan. Probeer het opnieuw.';

  @override
  String get addCategoryButtonText => 'Categorie toevoegen';

  @override
  String get addCategoryTextfieldHint => 'Voer categorienaam in bijv. Keuken';

  @override
  String get addCategoryTextfieldLabel => 'Categorienaam';

  @override
  String get itemFieldHint => 'Voer itemnaam in bijv. Broodrooster';

  @override
  String get itemFieldLabel => 'Item';

  @override
  String get notificationAcceptSuccess => 'Samenwerking geaccepteerd';

  @override
  String get notificationRejectSuccess => 'Verzoek geweigerd';

  @override
  String get deleteItemTitle => 'Item verwijderen';

  @override
  String get deleteItemQuestion =>
      'Dit item permanent verwijderen? Dit kan niet ongedaan worden gemaakt.';

  @override
  String get deleteCancel => 'Annuleren';

  @override
  String get deleteConfirm => 'Verwijderen';

  @override
  String get deleteItemDone => 'Item verwijderd';

  @override
  String get notificationsEmpty => 'Nog geen meldingen';

  @override
  String get errorPrefix => 'Fout:';

  @override
  String get collabRequestAcceptedTitle =>
      'Je samenwerkingsverzoek is geaccepteerd';

  @override
  String get collabRequestRejectedTitle =>
      'Je samenwerkingsverzoek is geweigerd';

  @override
  String get notificationItemAddedBody => 'Toegevoegd aan de lijst';

  @override
  String get notificationItemDeletedBody => 'Verwijderd van de lijst';

  @override
  String get notificationItemAddedSuffix => 'toegevoegd';

  @override
  String get notificationItemDeletedSuffix => 'verwijderd';

  @override
  String get onboardingTitle1 => 'Plan je uitzet eenvoudig';

  @override
  String get onboardingBody1 =>
      'Beheer al je huwelijksvoorbereidingen vanaf je telefoon, categoriseer je behoeften en mis geen enkel detail.';

  @override
  String get onboardingTitle2 => 'Volg samen met je partner';

  @override
  String get onboardingBody2 =>
      'Werk samen aan dezelfde lijst met je partner, zie direct wie wat heeft gekocht en wat er nog over is, en maak samen voortgang.';

  @override
  String get onboardingTitle3 => 'Beheer je uitgaven';

  @override
  String get onboardingBody3 =>
      'Overschrijd je budget niet, zie direct je totale en categorie-uitgaven en volg alles vanaf je mobiel.';

  @override
  String get selectCountryTitle => 'Selecteer uw land';

  @override
  String get collaboratorEmailLabel => 'Voeg medewerker toe via e-mail';

  @override
  String get partnerFeatureRequired => 'Partnerfunctie vereist';

  @override
  String get enablePartnerFeatureTitle => 'Partnerfunctie inschakelen';

  @override
  String get purchaseUnsupported =>
      'Aankopen in de app worden niet ondersteund op dit apparaat of er is geen winkelaccount beschikbaar.';

  @override
  String get purchaseSuccess => 'Aankoop geslaagd';

  @override
  String get purchaseFailed => 'Aankoop kon niet worden voltooid';

  @override
  String get removeAdsTitle => 'Advertenties verwijderen';

  @override
  String get restorePurchasesTitle => 'Aankopen herstellen';

  @override
  String get restoringPurchasesMessage => 'Aankopen worden hersteld';

  @override
  String get alreadyHasPartnerError =>
      'Je hebt al een partner. Verwijder eerst de huidige partner.';

  @override
  String get userNotFoundError => 'Gebruiker niet gevonden';

  @override
  String get cannotInviteSelfError => 'Je kunt jezelf niet uitnodigen';

  @override
  String get targetNotEntitledError =>
      'De gebruiker heeft de partnerfunctie niet gekocht';

  @override
  String get inviteAlreadyPendingError =>
      'Er is al een lopende uitnodiging voor deze gebruiker';

  @override
  String get genericUserLabel => 'Een gebruiker';

  @override
  String collabRequestTitle(Object inviter) {
    return '$inviter heeft je uitgenodigd als medewerker';
  }

  @override
  String get deleteAccountTitle => 'Account verwijderen';

  @override
  String get supportAndHelpTitle => 'Support & Help';
}
