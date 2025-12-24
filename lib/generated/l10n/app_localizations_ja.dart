// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'WedList';

  @override
  String get welcomeMessage => 'WedListへようこそ';

  @override
  String get helloText => 'こんにちは、';

  @override
  String get totalPaidTitle => '支払総額';

  @override
  String get remainingDaysTitle => '残り日数';

  @override
  String get progressTitle => '進捗';

  @override
  String get settingsTitle => '設定';

  @override
  String get addPartnerTitle => 'パートナーを追加';

  @override
  String get manageSubscriptionTitle => 'サブスクリプション管理';

  @override
  String get partnerTitle => 'パートナー';

  @override
  String get partnerAdded => 'パートナーを追加しました';

  @override
  String get partnerRemoved => 'パートナーを削除しました';

  @override
  String get logoutButtonText => 'ログアウト';

  @override
  String get pendingInvitations => '保留中の招待';

  @override
  String get pendingText => '保留中';

  @override
  String get noPartnersText => 'まだパートナーが追加されていません。';

  @override
  String get changeCountry => '国を変更';

  @override
  String get addItemTitle => 'アイテムを追加';

  @override
  String get priceTitleTextfield => '価格';

  @override
  String get descriptionTitleTextfield => '説明';

  @override
  String get addPhotoButtonText => '写真を追加';

  @override
  String get addItemButtonText => '追加';

  @override
  String get itemAddedSuccess => 'アイテムを追加しました！';

  @override
  String get itemLoadingButtonText => '読み込み中...';

  @override
  String get wishListTitle => 'ウィッシュリスト';

  @override
  String get itemsTitle => 'アイテム';

  @override
  String get saveButtonText => '保存';

  @override
  String get needCategoryErrorText => 'カテゴリ名は必須です';

  @override
  String get categoryUpdatedText => 'カテゴリを更新しました';

  @override
  String get categoryCreatedText => 'カテゴリを作成しました';

  @override
  String get completedCategoryText => '完了';

  @override
  String get somethingWentWrongErrorText => 'エラーが発生しました。再試行してください。';

  @override
  String get addCategoryButtonText => 'カテゴリを追加';

  @override
  String get addCategoryTextfieldHint => 'カテゴリ名を入力 例: キッチン';

  @override
  String get addCategoryTextfieldLabel => 'カテゴリ名';

  @override
  String get itemFieldHint => 'アイテム名を入力 例: トースター';

  @override
  String get itemFieldLabel => 'アイテム';

  @override
  String get notificationAcceptSuccess => 'コラボが承認されました';

  @override
  String get notificationRejectSuccess => 'リクエストは拒否されました';

  @override
  String get deleteItemTitle => 'アイテムを削除';

  @override
  String get deleteItemQuestion => 'このアイテムを完全に削除しますか？ この操作は元に戻せません。';

  @override
  String get deleteCancel => 'キャンセル';

  @override
  String get deleteConfirm => '削除';

  @override
  String get deleteItemDone => 'アイテムを削除しました';

  @override
  String get notificationsEmpty => '通知はまだありません';

  @override
  String get errorPrefix => 'エラー：';

  @override
  String get collabRequestAcceptedTitle => 'コラボ依頼が承認されました';

  @override
  String get collabRequestRejectedTitle => 'コラボ依頼が拒否されました';

  @override
  String get notificationItemAddedBody => 'リストに追加されました';

  @override
  String get notificationItemDeletedBody => 'リストから削除されました';

  @override
  String get notificationItemAddedSuffix => '追加';

  @override
  String get notificationItemDeletedSuffix => '削除';

  @override
  String get onboardingTitle1 => '持参品を簡単に計画';

  @override
  String get onboardingBody1 => '結婚準備をすべてスマホで管理し、必要なものをカテゴリ分けして、細部まで見逃しません。';

  @override
  String get onboardingTitle2 => 'パートナーと一緒に管理';

  @override
  String get onboardingBody2 =>
      '同じリストをパートナーと共有し、誰が何を買ったか、何が残っているかをすぐに確認、一緒に進めましょう。';

  @override
  String get onboardingTitle3 => '支出をコントロール';

  @override
  String get onboardingBody3 => '予算を超えず、合計やカテゴリごとの支出をすぐに確認、すべてをスマホで管理できます。';

  @override
  String get selectCountryTitle => '国を選択してください';

  @override
  String get collaboratorEmailLabel => 'メールで共同作業者を追加';

  @override
  String get purchaseUnsupported =>
      'このデバイスではアプリ内購入がサポートされていないか、利用可能なストアアカウントがありません。';

  @override
  String get purchaseSuccess => '購入に成功しました';

  @override
  String get purchaseFailed => '購入を完了できませんでした';

  @override
  String get removeAdsTitle => '広告を削除';

  @override
  String get restorePurchasesTitle => '購入を復元';

  @override
  String get restoringPurchasesMessage => '購入を復元しています';

  @override
  String get alreadyHasPartnerError => 'すでにパートナーがいます。まず現在のパートナーを削除してください。';

  @override
  String get userNotFoundError => 'ユーザーが見つかりません';

  @override
  String get cannotInviteSelfError => '自分自身を招待することはできません';

  @override
  String get inviteAlreadyPendingError => 'このユーザーにはすでに保留中の招待があります';

  @override
  String get genericUserLabel => 'あるユーザー';

  @override
  String collabRequestTitle(Object inviter) {
    return '$inviter があなたを共同編集者として招待しました';
  }

  @override
  String get deleteAccountTitle => 'アカウントを削除';

  @override
  String get supportAndHelpTitle => 'サポートとヘルプ';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get signInButtonText => 'ログイン';

  @override
  String get dontHaveAccount => 'アカウントをお持ちではありませんか？';

  @override
  String get registerHere => 'こちらで登録';

  @override
  String get signInWithApple => 'Appleでサインイン';

  @override
  String get signInWithGoogle => 'Googleでサインイン';

  @override
  String get loginRequiredForSection => 'このセクションを見るにはログインしてください。';

  @override
  String get loginRequiredForWishlist => 'ウィッシュリストを見るにはログインしてください。';

  @override
  String get verificationEmailResent => '確認メールを再送しました。';

  @override
  String get emailNotVerifiedYet =>
      'メールアドレスはまだ確認されていません。受信ボックスを確認してリンクをクリックしてください。';

  @override
  String get verificationTitle => '確認';

  @override
  String get verificationInstruction => 'メールで送信された確認リンクをクリックしてください。';

  @override
  String verificationInstructionWithEmail(String email) {
    return '$email に送信された確認リンクをクリックしてください。';
  }

  @override
  String get resendButton => '再送';

  @override
  String get checkVerificationButton => '確認をチェック';

  @override
  String get accountDeletedPermanently => 'アカウントは永久に削除されました。';

  @override
  String get reauthRequiredMessage =>
      'セキュリティ上の理由から、再度ログインしてからアカウントの削除をお試しください。';

  @override
  String get deleteAccountWarning => 'アカウントと関連データを永久に削除しようとしています。この操作は元に戻せません。';

  @override
  String get deleteAccountExportNotice => '続行する前に重要なデータをエクスポートしてください。';

  @override
  String get deleteAccountConfirmButton => 'アカウントを永久に削除';

  @override
  String get bottomNavHome => 'ホーム';

  @override
  String get bottomNavWishlist => 'ウィッシュリスト';

  @override
  String get bottomNavDowryList => '持参金リスト';

  @override
  String get bottomNavNotification => '通知';

  @override
  String get cancel => 'キャンセル';

  @override
  String get itemLimitReachedTitle => 'アイテム制限に達しました';

  @override
  String itemLimitReachedMessage(int count) {
    return '$count個のアイテムを追加しました。続行するには:';
  }

  @override
  String get watchAdForItemsButton => '広告を見る（+5アイテム）';

  @override
  String get buyRemoveAdsButton => '広告を削除（無制限）';

  @override
  String itemsRemainingInfo(int count) {
    return '残り$countアイテム';
  }

  @override
  String freeItemsRemaining(int count) {
    return '無料：残り$countアイテム';
  }

  @override
  String get adOptionFreeLabel => '無料';

  @override
  String get adOptionPremiumLabel => 'プレミアム機能';

  @override
  String get adOptionRecommendedBadge => 'おすすめ';

  @override
  String get adLoadingText => '広告を読み込んでいます...';

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
