// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'WedList';

  @override
  String get welcomeMessage => 'WedList\'e Hoş Geldiniz';

  @override
  String get helloText => 'Merhaba,';

  @override
  String get totalPaidTitle => 'Ödenen Toplam';

  @override
  String get remainingDaysTitle => 'Kalan Gün';

  @override
  String get progressTitle => 'İlerleme';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get addPartnerTitle => 'Eş Ekle';

  @override
  String get manageSubscriptionTitle => 'Aboneliği Yönet';

  @override
  String get partnerTitle => 'Eş';

  @override
  String get partnerAdded => 'Eş eklendi';

  @override
  String get partnerRemoved => 'Eş kaldırıldı';

  @override
  String get logoutButtonText => 'Çıkış';

  @override
  String get pendingInvitations => 'Bekleyen Davetler';

  @override
  String get pendingText => 'Bekliyor';

  @override
  String get noPartnersText => 'Henüz eş eklenmedi.';

  @override
  String get changeCountry => 'Ülke Değiştir';

  @override
  String get addItemTitle => 'Öğe Ekle';

  @override
  String get priceTitleTextfield => 'Fiyat';

  @override
  String get descriptionTitleTextfield => 'Açıklama';

  @override
  String get addPhotoButtonText => 'Fotoğraf Ekle';

  @override
  String get addItemButtonText => 'Ekle';

  @override
  String get itemAddedSuccess => 'Öğe başarıyla eklendi!';

  @override
  String get itemLoadingButtonText => 'Yükleniyor...';

  @override
  String get wishListTitle => 'İstek Listesi';

  @override
  String get itemsTitle => 'Öğeler';

  @override
  String get saveButtonText => 'Kaydet';

  @override
  String get needCategoryErrorText => 'Kategori adı gerekli';

  @override
  String get categoryUpdatedText => 'Kategori güncellendi';

  @override
  String get categoryCreatedText => 'Kategori oluşturuldu';

  @override
  String get completedCategoryText => 'Tamamlandı';

  @override
  String get somethingWentWrongErrorText =>
      'Bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get addCategoryButtonText => 'Kategori Ekle';

  @override
  String get addCategoryTextfieldHint => 'Kategori adı girin örn. Mutfak';

  @override
  String get addCategoryTextfieldLabel => 'Kategori adı';

  @override
  String get itemFieldHint => 'Öğe adı girin örn. Tost Makinesi';

  @override
  String get itemFieldLabel => 'Öğe';

  @override
  String get notificationAcceptSuccess => 'İş birliği kabul edildi';

  @override
  String get notificationRejectSuccess => 'İstek reddedildi';

  @override
  String get deleteItemTitle => 'Öğeyi Sil';

  @override
  String get deleteItemQuestion =>
      'Bu öğeyi kalıcı olarak silmek istiyor musunuz? Bu işlem geri alınamaz.';

  @override
  String get deleteCancel => 'İptal';

  @override
  String get deleteConfirm => 'Sil';

  @override
  String get deleteItemDone => 'Öğe silindi';

  @override
  String get notificationsEmpty => 'Henüz bildiriminiz yok';

  @override
  String get errorPrefix => 'Hata:';

  @override
  String get collabRequestAcceptedTitle => 'İş birliği isteğiniz kabul edildi';

  @override
  String get collabRequestRejectedTitle => 'İş birliği isteğiniz reddedildi';

  @override
  String get notificationItemAddedBody => 'Listeye eklendi';

  @override
  String get notificationItemDeletedBody => 'Listeden kaldırıldı';

  @override
  String get notificationItemAddedSuffix => 'eklendi';

  @override
  String get notificationItemDeletedSuffix => 'silindi';

  @override
  String get onboardingTitle1 => 'Çeyizini Kolayca Planla';

  @override
  String get onboardingBody1 =>
      'düğün öncesi tüm hazırlıklarını cebinden yönet, ihtiyaçlarını kategorilere ayır, hiçbir detayı atlama.';

  @override
  String get onboardingTitle2 => 'Partnerinle Birlikte Takip Et';

  @override
  String get onboardingBody2 =>
      'eşinle aynı listede çalış, kim ne aldı, ne kaldı anında görün, birlikte ilerlemenin keyfini çıkar.';

  @override
  String get onboardingTitle3 => 'Harcamalarını Kontrol Et';

  @override
  String get onboardingBody3 =>
      'bütçeni aşma, toplam giderini ve kategori bazlı harcamalarını anında gör, her şeyi mobil cihazından takip et.';

  @override
  String get selectCountryTitle => 'Ülkenizi seçin';

  @override
  String get collaboratorEmailLabel => 'E-posta ile ortak ekle';

  @override
  String get purchaseUnsupported =>
      'Bu cihazda mağaza faturalandırması desteklenmiyor veya mağaza hesabı bulunamadı.';

  @override
  String get purchaseSuccess => 'Satın alma başarılı';

  @override
  String get purchaseFailed => 'Satın alma tamamlanamadı';

  @override
  String get removeAdsTitle => 'Reklamları Kaldır';

  @override
  String get restorePurchasesTitle => 'Satın Alımları Geri Yükle';

  @override
  String get restoringPurchasesMessage => 'Satın alımlar geri yükleniyor';

  @override
  String get alreadyHasPartnerError =>
      'Zaten bir partneriniz var. Önce mevcut partneri kaldırın.';

  @override
  String get userNotFoundError => 'Kullanıcı bulunamadı';

  @override
  String get cannotInviteSelfError => 'Kendinizi ekleyemezsiniz';

  @override
  String get inviteAlreadyPendingError =>
      'Bu kullanıcıya zaten bekleyen bir davet var';

  @override
  String get genericUserLabel => 'Bir kullanıcı';

  @override
  String collabRequestTitle(Object inviter) {
    return '$inviter sizi ortak olarak davet etti';
  }

  @override
  String get deleteAccountTitle => 'Hesabı sil';

  @override
  String get supportAndHelpTitle => 'Destek ve Yardım';

  @override
  String get loginTitle => 'Giriş';

  @override
  String get signInButtonText => 'Giriş Yap';

  @override
  String get dontHaveAccount => 'Hesabın yok mu?';

  @override
  String get registerHere => 'Kayıt Ol';

  @override
  String get signInWithApple => 'Apple ile Giriş Yap';

  @override
  String get signInWithGoogle => 'Google ile Giriş Yap';

  @override
  String get loginRequiredForSection =>
      'Bu bölümü görmek için lütfen giriş yapın.';

  @override
  String get loginRequiredForWishlist =>
      'İstek listenizi görmek için lütfen giriş yapın.';

  @override
  String get verificationEmailResent =>
      'Doğrulama e-postası tekrar gönderildi.';

  @override
  String get emailNotVerifiedYet =>
      'E-posta adresiniz henüz doğrulanmadı. Lütfen e-postanızı kontrol edip gelen linke tıklayın.';

  @override
  String get verificationTitle => 'Doğrulama';

  @override
  String get verificationInstruction =>
      'Lütfen e-postanıza gönderilen doğrulama linkine tıklayın.';

  @override
  String verificationInstructionWithEmail(String email) {
    return 'Lütfen $email adresine gönderilen doğrulama linkine tıklayın.';
  }

  @override
  String get resendButton => 'Tekrar Gönder';

  @override
  String get checkVerificationButton => 'Doğrulamayı Kontrol Et';

  @override
  String get accountDeletedPermanently => 'Hesabınız kalıcı olarak silindi.';

  @override
  String get reauthRequiredMessage =>
      'Güvenlik nedeniyle lütfen yeniden giriş yapın ve ardından hesabı silmeyi tekrar deneyin.';

  @override
  String get deleteAccountWarning =>
      'Hesabınızı ve ilişkili verileri kalıcı olarak silmek üzeresiniz. Bu işlem geri alınamaz.';

  @override
  String get deleteAccountExportNotice =>
      'Devam etmeden önce önemli verilerinizi dışa aktardığınızdan emin olun.';

  @override
  String get deleteAccountConfirmButton => 'Hesabımı kalıcı olarak sil';

  @override
  String get bottomNavHome => 'Ana Sayfa';

  @override
  String get bottomNavWishlist => 'Dilek Listesi';

  @override
  String get bottomNavDowryList => 'Çeyiz Listesi';

  @override
  String get bottomNavNotification => 'Bildirimler';

  @override
  String get cancel => 'İptal';

  @override
  String get itemLimitReachedTitle => 'Item Limiti Doldu';

  @override
  String itemLimitReachedMessage(int count) {
    return '$count item eklediniz. Devam etmek için:';
  }

  @override
  String get watchAdForItemsButton => 'Reklam İzle (+5 item)';

  @override
  String get buyRemoveAdsButton => 'Reklamsız Satın Al (Sınırsız)';

  @override
  String itemsRemainingInfo(int count) {
    return '$count item hakkınız kaldı';
  }

  @override
  String freeItemsRemaining(int count) {
    return 'Ücretsiz: $count item kaldı';
  }

  @override
  String get adOptionFreeLabel => 'Ücretsiz';

  @override
  String get adOptionPremiumLabel => 'Premium özellikler';

  @override
  String get adOptionRecommendedBadge => 'ÖNERİLEN';

  @override
  String get adLoadingText => 'Reklam yükleniyor...';

  @override
  String get offlineMode => 'Çevrimdışı Mod';

  @override
  String get onlineModeRequired => 'Bu özellik internet bağlantısı gerektirir';

  @override
  String get skipLogin => 'Şimdilik Keşfet';

  @override
  String get createAccountOrLogin => 'Hesap Oluştur / Giriş Yap';

  @override
  String get offlineOnboardingMessage =>
      'Partnerinizle birlikte düğün listenizi yönetmek için hesap oluşturun veya önce uygulamayı keşfedin!';

  @override
  String get offlineModeActive => 'Çevrimdışı Moddasınız';

  @override
  String get loginToSyncData =>
      'Verilerinizi yedeklemek ve partnerinizle paylaşmak için giriş yapın';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get migrationInProgress => 'Verileriniz senkronize ediliyor...';

  @override
  String get migrationSuccess => 'Verileriniz başarıyla senkronize edildi';

  @override
  String get migrationFailed =>
      'Senkronizasyon başarısız oldu. Lütfen tekrar deneyin.';

  @override
  String get offlineDataWillSync =>
      'Giriş yaptığınızda verileriniz otomatik olarak senkronize edilecek';

  @override
  String migrationPartialSuccess(int migratedCount, int failedCount) {
    return '$migratedCount öğe senkronize edildi, $failedCount öğe başarısız oldu';
  }
}
