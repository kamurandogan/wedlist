import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('nl'),
    Locale('pt'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// Application title displayed in the app bar and system UI.
  ///
  /// In en, this message translates to:
  /// **'WedList'**
  String get appTitle;

  /// Introductory welcome text shown on the home/dashboard screen.
  ///
  /// In en, this message translates to:
  /// **'Welcome to WedList'**
  String get welcomeMessage;

  /// Short greeting prefix before the user name (if any).
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get helloText;

  /// No description provided for @totalPaidTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaidTitle;

  /// No description provided for @remainingDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Remaining Days'**
  String get remainingDaysTitle;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @addPartnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Partner'**
  String get addPartnerTitle;

  /// No description provided for @manageSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscriptionTitle;

  /// No description provided for @partnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get partnerTitle;

  /// No description provided for @partnerAdded.
  ///
  /// In en, this message translates to:
  /// **'Partner added'**
  String get partnerAdded;

  /// No description provided for @partnerRemoved.
  ///
  /// In en, this message translates to:
  /// **'Partner removed'**
  String get partnerRemoved;

  /// No description provided for @logoutButtonText.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButtonText;

  /// No description provided for @pendingInvitations.
  ///
  /// In en, this message translates to:
  /// **'Pending Invitations'**
  String get pendingInvitations;

  /// No description provided for @pendingText.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingText;

  /// No description provided for @noPartnersText.
  ///
  /// In en, this message translates to:
  /// **'No partners added yet.'**
  String get noPartnersText;

  /// No description provided for @changeCountry.
  ///
  /// In en, this message translates to:
  /// **'Change Country'**
  String get changeCountry;

  /// No description provided for @addItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItemTitle;

  /// No description provided for @priceTitleTextfield.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceTitleTextfield;

  /// No description provided for @descriptionTitleTextfield.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionTitleTextfield;

  /// No description provided for @addPhotoButtonText.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhotoButtonText;

  /// No description provided for @addItemButtonText.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItemButtonText;

  /// No description provided for @itemAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Item added successfully!'**
  String get itemAddedSuccess;

  /// No description provided for @itemLoadingButtonText.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get itemLoadingButtonText;

  /// No description provided for @wishListTitle.
  ///
  /// In en, this message translates to:
  /// **'Wish List'**
  String get wishListTitle;

  /// No description provided for @itemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsTitle;

  /// No description provided for @saveButtonText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonText;

  /// No description provided for @needCategoryErrorText.
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get needCategoryErrorText;

  /// No description provided for @categoryUpdatedText.
  ///
  /// In en, this message translates to:
  /// **'Category updated'**
  String get categoryUpdatedText;

  /// No description provided for @categoryCreatedText.
  ///
  /// In en, this message translates to:
  /// **'Category created'**
  String get categoryCreatedText;

  /// No description provided for @completedCategoryText.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedCategoryText;

  /// No description provided for @somethingWentWrongErrorText.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrongErrorText;

  /// No description provided for @addCategoryButtonText.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategoryButtonText;

  /// No description provided for @addCategoryTextfieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter category name e.g. Kitchen'**
  String get addCategoryTextfieldHint;

  /// No description provided for @addCategoryTextfieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get addCategoryTextfieldLabel;

  /// No description provided for @itemFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter item name e.g. Toaster'**
  String get itemFieldHint;

  /// No description provided for @itemFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get itemFieldLabel;

  /// No description provided for @notificationAcceptSuccess.
  ///
  /// In en, this message translates to:
  /// **'Collaboration accepted'**
  String get notificationAcceptSuccess;

  /// No description provided for @notificationRejectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request declined'**
  String get notificationRejectSuccess;

  /// No description provided for @deleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItemTitle;

  /// No description provided for @deleteItemQuestion.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete this item? This action cannot be undone.'**
  String get deleteItemQuestion;

  /// No description provided for @deleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteCancel;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteConfirm;

  /// No description provided for @deleteItemDone.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get deleteItemDone;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications yet'**
  String get notificationsEmpty;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @collabRequestAcceptedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your collaboration request was accepted'**
  String get collabRequestAcceptedTitle;

  /// No description provided for @collabRequestRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your collaboration request was declined'**
  String get collabRequestRejectedTitle;

  /// No description provided for @notificationItemAddedBody.
  ///
  /// In en, this message translates to:
  /// **'Added to the list'**
  String get notificationItemAddedBody;

  /// No description provided for @notificationItemDeletedBody.
  ///
  /// In en, this message translates to:
  /// **'Removed from the list'**
  String get notificationItemDeletedBody;

  /// Suffix appended to an item title in notifications when an item is added (e.g. 'Toaster added').
  ///
  /// In en, this message translates to:
  /// **'added'**
  String get notificationItemAddedSuffix;

  /// Suffix appended to an item title in notifications when an item is deleted (e.g. 'Toaster deleted').
  ///
  /// In en, this message translates to:
  /// **'deleted'**
  String get notificationItemDeletedSuffix;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Dowry Easily'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Manage all your pre-wedding preparations from your phone, categorize your needs, and never miss a detail.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Track Together with Your Partner'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Work on the same list with your spouse, instantly see who bought what and what remains, and enjoy progressing together.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Control Your Expenses'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Don’t exceed your budget, instantly see your total and category-based expenses, and track everything from your mobile device.'**
  String get onboardingBody3;

  /// No description provided for @selectCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your country'**
  String get selectCountryTitle;

  /// No description provided for @collaboratorEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Add collaborator by email'**
  String get collaboratorEmailLabel;

  /// No description provided for @purchaseUnsupported.
  ///
  /// In en, this message translates to:
  /// **'In-app purchases not supported on this device or no store account is available.'**
  String get purchaseUnsupported;

  /// No description provided for @purchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful'**
  String get purchaseSuccess;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase could not be completed'**
  String get purchaseFailed;

  /// No description provided for @removeAdsTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAdsTitle;

  /// No description provided for @restorePurchasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchasesTitle;

  /// No description provided for @restoringPurchasesMessage.
  ///
  /// In en, this message translates to:
  /// **'Restoring purchases'**
  String get restoringPurchasesMessage;

  /// No description provided for @alreadyHasPartnerError.
  ///
  /// In en, this message translates to:
  /// **'You already have a partner. Remove the current partner first.'**
  String get alreadyHasPartnerError;

  /// No description provided for @userNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFoundError;

  /// No description provided for @cannotInviteSelfError.
  ///
  /// In en, this message translates to:
  /// **'You cannot invite yourself'**
  String get cannotInviteSelfError;

  /// No description provided for @inviteAlreadyPendingError.
  ///
  /// In en, this message translates to:
  /// **'There is already a pending invite to this user'**
  String get inviteAlreadyPendingError;

  /// No description provided for @genericUserLabel.
  ///
  /// In en, this message translates to:
  /// **'A user'**
  String get genericUserLabel;

  /// No description provided for @collabRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'{inviter} invited you as a collaborator'**
  String collabRequestTitle(Object inviter);

  /// Menu title that navigates to the account deletion screen.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountTitle;

  /// Menu title that opens the public support/help page.
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get supportAndHelpTitle;

  /// Title on the login page.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// Primary sign-in button label.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButtonText;

  /// Prompt shown before register link on login page.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Register link label on login page.
  ///
  /// In en, this message translates to:
  /// **'Register Here'**
  String get registerHere;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @loginRequiredForSection.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to view this section.'**
  String get loginRequiredForSection;

  /// No description provided for @loginRequiredForWishlist.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to view your wish list.'**
  String get loginRequiredForWishlist;

  /// No description provided for @verificationEmailResent.
  ///
  /// In en, this message translates to:
  /// **'Verification email has been resent.'**
  String get verificationEmailResent;

  /// No description provided for @emailNotVerifiedYet.
  ///
  /// In en, this message translates to:
  /// **'Your email address is not verified yet. Please check your inbox and click the link.'**
  String get emailNotVerifiedYet;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verificationTitle;

  /// No description provided for @verificationInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please click the verification link sent to your email.'**
  String get verificationInstruction;

  /// No description provided for @verificationInstructionWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Please click the verification link sent to {email}.'**
  String verificationInstructionWithEmail(String email);

  /// No description provided for @resendButton.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resendButton;

  /// No description provided for @checkVerificationButton.
  ///
  /// In en, this message translates to:
  /// **'Check Verification'**
  String get checkVerificationButton;

  /// No description provided for @accountDeletedPermanently.
  ///
  /// In en, this message translates to:
  /// **'Your account has been permanently deleted.'**
  String get accountDeletedPermanently;

  /// No description provided for @reauthRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, please sign in again and then retry deleting your account.'**
  String get reauthRequiredMessage;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'You are about to permanently delete your account and associated data. This action cannot be undone.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountExportNotice.
  ///
  /// In en, this message translates to:
  /// **'Make sure you export any important data before proceeding.'**
  String get deleteAccountExportNotice;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete my account'**
  String get deleteAccountConfirmButton;

  /// Bottom navigation bar tooltip for Home page.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNavHome;

  /// Bottom navigation bar tooltip for Wishlist page.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get bottomNavWishlist;

  /// Bottom navigation bar tooltip for Dowry List page.
  ///
  /// In en, this message translates to:
  /// **'Dowry List'**
  String get bottomNavDowryList;

  /// Bottom navigation bar tooltip for Notification page.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get bottomNavNotification;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @itemLimitReachedTitle.
  ///
  /// In en, this message translates to:
  /// **'Item Limit Reached'**
  String get itemLimitReachedTitle;

  /// No description provided for @itemLimitReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve added {count} items. To continue:'**
  String itemLimitReachedMessage(int count);

  /// No description provided for @watchAdForItemsButton.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad (+5 items)'**
  String get watchAdForItemsButton;

  /// No description provided for @buyRemoveAdsButton.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads (Unlimited)'**
  String get buyRemoveAdsButton;

  /// No description provided for @itemsRemainingInfo.
  ///
  /// In en, this message translates to:
  /// **'{count} items remaining'**
  String itemsRemainingInfo(int count);

  /// No description provided for @freeItemsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Free: {count} items left'**
  String freeItemsRemaining(int count);

  /// No description provided for @adOptionFreeLabel.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get adOptionFreeLabel;

  /// No description provided for @adOptionPremiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium features'**
  String get adOptionPremiumLabel;

  /// No description provided for @adOptionRecommendedBadge.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED'**
  String get adOptionRecommendedBadge;

  /// No description provided for @adLoadingText.
  ///
  /// In en, this message translates to:
  /// **'Loading ad...'**
  String get adLoadingText;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @onlineModeRequired.
  ///
  /// In en, this message translates to:
  /// **'This feature requires internet connection'**
  String get onlineModeRequired;

  /// No description provided for @skipLogin.
  ///
  /// In en, this message translates to:
  /// **'Explore First'**
  String get skipLogin;

  /// No description provided for @createAccountOrLogin.
  ///
  /// In en, this message translates to:
  /// **'Create Account / Sign In'**
  String get createAccountOrLogin;

  /// No description provided for @offlineOnboardingMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account to manage your wedding list together with your partner, or explore the app first!'**
  String get offlineOnboardingMessage;

  /// No description provided for @offlineModeActive.
  ///
  /// In en, this message translates to:
  /// **'You\'re in Offline Mode'**
  String get offlineModeActive;

  /// No description provided for @loginToSyncData.
  ///
  /// In en, this message translates to:
  /// **'Sign in to back up your data and share with your partner'**
  String get loginToSyncData;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @migrationInProgress.
  ///
  /// In en, this message translates to:
  /// **'Syncing your data...'**
  String get migrationInProgress;

  /// No description provided for @migrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your data has been successfully synced'**
  String get migrationSuccess;

  /// No description provided for @migrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Please try again.'**
  String get migrationFailed;

  /// No description provided for @offlineDataWillSync.
  ///
  /// In en, this message translates to:
  /// **'Your data will be automatically synced when you sign in'**
  String get offlineDataWillSync;

  /// No description provided for @migrationPartialSuccess.
  ///
  /// In en, this message translates to:
  /// **'{migratedCount} items synced, {failedCount} items failed'**
  String migrationPartialSuccess(int migratedCount, int failedCount);

  /// Title shown when feature requires internet but device is offline
  ///
  /// In en, this message translates to:
  /// **'Internet Connection Required'**
  String get internetConnectionRequired;

  /// Message explaining that wishlist feature needs internet connection
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection to view the wishlist.'**
  String get wishlistRequiresInternet;

  /// Instruction to user to check internet and retry
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get checkConnectionAndRetry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'nl',
    'pt',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
