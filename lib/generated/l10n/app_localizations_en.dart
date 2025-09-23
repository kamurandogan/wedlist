// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WedList';

  @override
  String get welcomeMessage => 'Welcome to WedList';

  @override
  String get helloText => 'Hello,';

  @override
  String get totalPaidTitle => 'Total Paid';

  @override
  String get remainingDaysTitle => 'Remaining Days';

  @override
  String get progressTitle => 'Progress';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get addPartnerTitle => 'Add Partner';

  @override
  String get manageSubscriptionTitle => 'Manage Subscription';

  @override
  String get partnerTitle => 'Partner';

  @override
  String get partnerAdded => 'Partner added';

  @override
  String get partnerRemoved => 'Partner removed';

  @override
  String get logoutButtonText => 'Logout';

  @override
  String get pendingInvitations => 'Pending Invitations';

  @override
  String get pendingText => 'Pending';

  @override
  String get noPartnersText => 'No partners added yet.';

  @override
  String get changeCountry => 'Change Country';

  @override
  String get addItemTitle => 'Add Item';

  @override
  String get priceTitleTextfield => 'Price';

  @override
  String get descriptionTitleTextfield => 'Description';

  @override
  String get addPhotoButtonText => 'Add Photo';

  @override
  String get addItemButtonText => 'Add Item';

  @override
  String get itemAddedSuccess => 'Item added successfully!';

  @override
  String get itemLoadingButtonText => 'Loading...';

  @override
  String get wishListTitle => 'Wish List';

  @override
  String get itemsTitle => 'Items';

  @override
  String get saveButtonText => 'Save';

  @override
  String get needCategoryErrorText => 'Category name is required';

  @override
  String get categoryUpdatedText => 'Category updated';

  @override
  String get categoryCreatedText => 'Category created';

  @override
  String get completedCategoryText => 'Completed';

  @override
  String get somethingWentWrongErrorText =>
      'Something went wrong. Please try again.';

  @override
  String get addCategoryButtonText => 'Add Category';

  @override
  String get addCategoryTextfieldHint => 'Enter category name e.g. Kitchen';

  @override
  String get addCategoryTextfieldLabel => 'Enter category name';

  @override
  String get itemFieldHint => 'Enter item name e.g. Toaster';

  @override
  String get itemFieldLabel => 'Item';

  @override
  String get notificationAcceptSuccess => 'Collaboration accepted';

  @override
  String get notificationRejectSuccess => 'Request declined';

  @override
  String get deleteItemTitle => 'Delete Item';

  @override
  String get deleteItemQuestion =>
      'Permanently delete this item? This action cannot be undone.';

  @override
  String get deleteCancel => 'Cancel';

  @override
  String get deleteConfirm => 'Delete';

  @override
  String get deleteItemDone => 'Item deleted';

  @override
  String get notificationsEmpty => 'You have no notifications yet';

  @override
  String get errorPrefix => 'Error:';

  @override
  String get collabRequestAcceptedTitle =>
      'Your collaboration request was accepted';

  @override
  String get collabRequestRejectedTitle =>
      'Your collaboration request was declined';

  @override
  String get notificationItemAddedBody => 'Added to the list';

  @override
  String get notificationItemDeletedBody => 'Removed from the list';

  @override
  String get notificationItemAddedSuffix => 'added';

  @override
  String get notificationItemDeletedSuffix => 'deleted';

  @override
  String get onboardingTitle1 => 'Plan Your Dowry Easily';

  @override
  String get onboardingBody1 =>
      'Manage all your pre-wedding preparations from your phone, categorize your needs, and never miss a detail.';

  @override
  String get onboardingTitle2 => 'Track Together with Your Partner';

  @override
  String get onboardingBody2 =>
      'Work on the same list with your spouse, instantly see who bought what and what remains, and enjoy progressing together.';

  @override
  String get onboardingTitle3 => 'Control Your Expenses';

  @override
  String get onboardingBody3 =>
      'Don’t exceed your budget, instantly see your total and category-based expenses, and track everything from your mobile device.';

  @override
  String get selectCountryTitle => 'Select your country';

  @override
  String get collaboratorEmailLabel => 'Add collaborator by email';

  @override
  String get partnerFeatureRequired => 'Partner feature required';

  @override
  String get enablePartnerFeatureTitle => 'Enable partner feature';

  @override
  String get purchaseUnsupported =>
      'In-app purchases not supported on this device or no store account is available.';

  @override
  String get purchaseSuccess => 'Purchase successful';

  @override
  String get purchaseFailed => 'Purchase could not be completed';

  @override
  String get removeAdsTitle => 'Remove ads';

  @override
  String get restorePurchasesTitle => 'Restore purchases';

  @override
  String get restoringPurchasesMessage => 'Restoring purchases';

  @override
  String get alreadyHasPartnerError =>
      'You already have a partner. Remove the current partner first.';

  @override
  String get userNotFoundError => 'User not found';

  @override
  String get cannotInviteSelfError => 'You cannot invite yourself';

  @override
  String get targetNotEntitledError =>
      'The user has not purchased the partner feature';

  @override
  String get inviteAlreadyPendingError =>
      'There is already a pending invite to this user';

  @override
  String get genericUserLabel => 'A user';

  @override
  String collabRequestTitle(Object inviter) {
    return '$inviter invited you as a collaborator';
  }
}
