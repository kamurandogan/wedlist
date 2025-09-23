// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'WedList';

  @override
  String get welcomeMessage => 'Bem-vindo ao WedList';

  @override
  String get helloText => 'Olá,';

  @override
  String get totalPaidTitle => 'Total Pago';

  @override
  String get remainingDaysTitle => 'Dias Restantes';

  @override
  String get progressTitle => 'Progresso';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get addPartnerTitle => 'Adicionar Parceiro';

  @override
  String get manageSubscriptionTitle => 'Gerenciar Assinatura';

  @override
  String get partnerTitle => 'Parceiro';

  @override
  String get partnerAdded => 'Parceiro adicionado';

  @override
  String get partnerRemoved => 'Parceiro removido';

  @override
  String get logoutButtonText => 'Sair';

  @override
  String get pendingInvitations => 'Convites Pendentes';

  @override
  String get pendingText => 'Pendente';

  @override
  String get noPartnersText => 'Nenhum parceiro adicionado ainda.';

  @override
  String get changeCountry => 'Alterar País';

  @override
  String get addItemTitle => 'Adicionar Item';

  @override
  String get priceTitleTextfield => 'Preço';

  @override
  String get descriptionTitleTextfield => 'Descrição';

  @override
  String get addPhotoButtonText => 'Adicionar Foto';

  @override
  String get addItemButtonText => 'Adicionar';

  @override
  String get itemAddedSuccess => 'Item adicionado com sucesso!';

  @override
  String get itemLoadingButtonText => 'Carregando...';

  @override
  String get wishListTitle => 'Lista de Desejos';

  @override
  String get itemsTitle => 'Itens';

  @override
  String get saveButtonText => 'Salvar';

  @override
  String get needCategoryErrorText => 'Nome da categoria é obrigatório';

  @override
  String get categoryUpdatedText => 'Categoria atualizada';

  @override
  String get categoryCreatedText => 'Categoria criada';

  @override
  String get completedCategoryText => 'Concluído';

  @override
  String get somethingWentWrongErrorText => 'Algo deu errado. Tente novamente.';

  @override
  String get addCategoryButtonText => 'Adicionar Categoria';

  @override
  String get addCategoryTextfieldHint =>
      'Insira o nome da categoria ex. Cozinha';

  @override
  String get addCategoryTextfieldLabel => 'Nome da categoria';

  @override
  String get itemFieldHint => 'Insira o nome do item ex. Torradeira';

  @override
  String get itemFieldLabel => 'Item';

  @override
  String get notificationAcceptSuccess => 'Colaboração aceita';

  @override
  String get notificationRejectSuccess => 'Solicitação recusada';

  @override
  String get deleteItemTitle => 'Excluir Item';

  @override
  String get deleteItemQuestion =>
      'Excluir este item permanentemente? Esta ação não pode ser desfeita.';

  @override
  String get deleteCancel => 'Cancelar';

  @override
  String get deleteConfirm => 'Excluir';

  @override
  String get deleteItemDone => 'Item excluído';

  @override
  String get notificationsEmpty => 'Você ainda não tem notificações';

  @override
  String get errorPrefix => 'Erro:';

  @override
  String get collabRequestAcceptedTitle =>
      'Seu pedido de colaboração foi aceito';

  @override
  String get collabRequestRejectedTitle =>
      'Seu pedido de colaboração foi recusado';

  @override
  String get notificationItemAddedBody => 'Adicionado à lista';

  @override
  String get notificationItemDeletedBody => 'Removido da lista';

  @override
  String get notificationItemAddedSuffix => 'adicionado';

  @override
  String get notificationItemDeletedSuffix => 'excluído';

  @override
  String get onboardingTitle1 => 'Planeje seu enxoval facilmente';

  @override
  String get onboardingBody1 =>
      'Gerencie todos os preparativos do casamento pelo celular, categorize suas necessidades e não perca nenhum detalhe.';

  @override
  String get onboardingTitle2 => 'Acompanhe junto com seu parceiro';

  @override
  String get onboardingBody2 =>
      'Trabalhe na mesma lista com seu parceiro, veja instantaneamente quem comprou o quê e o que falta, e avancem juntos.';

  @override
  String get onboardingTitle3 => 'Controle seus gastos';

  @override
  String get onboardingBody3 =>
      'Não ultrapasse seu orçamento, veja instantaneamente seus gastos totais e por categoria, e acompanhe tudo pelo celular.';

  @override
  String get selectCountryTitle => 'Selecione seu país';

  @override
  String get collaboratorEmailLabel => 'Adicionar colaborador por e-mail';

  @override
  String get partnerFeatureRequired => 'Recurso de parceiro necessário';

  @override
  String get enablePartnerFeatureTitle => 'Ativar recurso de parceiro';

  @override
  String get purchaseUnsupported =>
      'Compras no aplicativo não são suportadas neste dispositivo ou nenhuma conta da loja está disponível.';

  @override
  String get purchaseSuccess => 'Compra concluída com sucesso';

  @override
  String get purchaseFailed => 'A compra não pôde ser concluída';

  @override
  String get removeAdsTitle => 'Remover anúncios';

  @override
  String get restorePurchasesTitle => 'Restaurar compras';

  @override
  String get restoringPurchasesMessage => 'Restaurando compras';

  @override
  String get alreadyHasPartnerError =>
      'Você já tem um parceiro. Remova primeiro o parceiro atual.';

  @override
  String get userNotFoundError => 'Usuário não encontrado';

  @override
  String get cannotInviteSelfError => 'Você não pode se convidar';

  @override
  String get targetNotEntitledError =>
      'O usuário não comprou o recurso de parceiro';

  @override
  String get inviteAlreadyPendingError =>
      'Já existe um convite pendente para este usuário';

  @override
  String get genericUserLabel => 'Um usuário';

  @override
  String collabRequestTitle(Object inviter) {
    return '$inviter convidou você como colaborador';
  }
}
