// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'WedList';

  @override
  String get welcomeMessage => '欢迎使用 WedList';

  @override
  String get helloText => '你好，';

  @override
  String get totalPaidTitle => '已支付总额';

  @override
  String get remainingDaysTitle => '剩余天数';

  @override
  String get progressTitle => '进度';

  @override
  String get settingsTitle => '设置';

  @override
  String get addPartnerTitle => '添加伙伴';

  @override
  String get manageSubscriptionTitle => '管理订阅';

  @override
  String get partnerTitle => '伙伴';

  @override
  String get partnerAdded => '已添加伙伴';

  @override
  String get partnerRemoved => '已移除伙伴';

  @override
  String get logoutButtonText => '退出登录';

  @override
  String get pendingInvitations => '待处理邀请';

  @override
  String get pendingText => '待处理';

  @override
  String get noPartnersText => '尚未添加伙伴。';

  @override
  String get changeCountry => '更改国家';

  @override
  String get addItemTitle => '添加项目';

  @override
  String get priceTitleTextfield => '价格';

  @override
  String get descriptionTitleTextfield => '描述';

  @override
  String get addPhotoButtonText => '添加照片';

  @override
  String get addItemButtonText => '添加';

  @override
  String get itemAddedSuccess => '项目已成功添加！';

  @override
  String get itemLoadingButtonText => '加载中...';

  @override
  String get wishListTitle => '心愿单';

  @override
  String get itemsTitle => '项目';

  @override
  String get saveButtonText => '保存';

  @override
  String get needCategoryErrorText => '类别名称必填';

  @override
  String get categoryUpdatedText => '类别已更新';

  @override
  String get categoryCreatedText => '类别已创建';

  @override
  String get completedCategoryText => '已完成';

  @override
  String get somethingWentWrongErrorText => '发生错误，请重试。';

  @override
  String get addCategoryButtonText => '添加类别';

  @override
  String get addCategoryTextfieldHint => '输入类别名称 例如 厨房';

  @override
  String get addCategoryTextfieldLabel => '类别名称';

  @override
  String get itemFieldHint => '输入项目名称 例如 烤面包机';

  @override
  String get itemFieldLabel => '项目';

  @override
  String get notificationAcceptSuccess => '协作已接受';

  @override
  String get notificationRejectSuccess => '请求已拒绝';

  @override
  String get deleteItemTitle => '删除项目';

  @override
  String get deleteItemQuestion => '确定永久删除此项目？此操作无法撤销。';

  @override
  String get deleteCancel => '取消';

  @override
  String get deleteConfirm => '删除';

  @override
  String get deleteItemDone => '项目已删除';

  @override
  String get notificationsEmpty => '暂无通知';

  @override
  String get errorPrefix => '错误：';

  @override
  String get collabRequestAcceptedTitle => '您的协作请求已被接受';

  @override
  String get collabRequestRejectedTitle => '您的协作请求已被拒绝';

  @override
  String get notificationItemAddedBody => '已添加到列表';

  @override
  String get notificationItemDeletedBody => '已从列表移除';

  @override
  String get notificationItemAddedSuffix => '已添加';

  @override
  String get notificationItemDeletedSuffix => '已删除';

  @override
  String get onboardingTitle1 => '轻松规划你的嫁妆';

  @override
  String get onboardingBody1 => '用手机管理所有婚礼准备工作，分类你的需求，不遗漏任何细节。';

  @override
  String get onboardingTitle2 => '与伴侣一起跟进';

  @override
  String get onboardingBody2 => '与伴侣在同一个清单上协作，实时查看谁买了什么、还剩下什么，一起进步。';

  @override
  String get onboardingTitle3 => '掌控你的支出';

  @override
  String get onboardingBody3 => '不超预算，实时查看总支出和分类支出，随时随地用手机追踪一切。';

  @override
  String get selectCountryTitle => '请选择您的国家';

  @override
  String get collaboratorEmailLabel => '通过电子邮件添加协作者';

  @override
  String get partnerFeatureRequired => '需要合作伙伴功能';

  @override
  String get enablePartnerFeatureTitle => '启用合作伙伴功能';

  @override
  String get purchaseUnsupported => '此设备不支持应用内购买，或没有可用的商店账户。';

  @override
  String get purchaseSuccess => '购买成功';

  @override
  String get purchaseFailed => '购买无法完成';

  @override
  String get removeAdsTitle => '移除广告';

  @override
  String get restorePurchasesTitle => '恢复购买';

  @override
  String get restoringPurchasesMessage => '正在恢复购买';

  @override
  String get alreadyHasPartnerError => '您已拥有一位伙伴。请先移除当前伙伴。';

  @override
  String get userNotFoundError => '未找到用户';

  @override
  String get cannotInviteSelfError => '不能邀请自己';

  @override
  String get targetNotEntitledError => '该用户尚未购买合作伙伴功能';

  @override
  String get inviteAlreadyPendingError => '已存在发往该用户的待处理邀请';

  @override
  String get genericUserLabel => '一位用户';

  @override
  String collabRequestTitle(Object inviter) {
    return '$inviter 邀请您成为协作者';
  }

  @override
  String get deleteAccountTitle => '删除账户';

  @override
  String get supportAndHelpTitle => '支持与帮助';
}
