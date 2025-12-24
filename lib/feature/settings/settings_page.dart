import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/services/purchase_service.dart';
import 'package:wedlist/core/services/user_mode_service.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/settings/presentation/bloc/country_cubit.dart';
import 'package:wedlist/feature/settings/presentation/ui/atoms/country_tile.dart';
import 'package:wedlist/feature/settings/presentation/ui/atoms/settings_page_listtile.dart';
import 'package:wedlist/feature/settings/presentation/ui/organisms/logout_section.dart';
import 'package:wedlist/injection_container.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final PurchaseService _ps = sl<PurchaseService>();
  bool _iapInit = false;
  bool _iapBusy = false;

  @override
  void initState() {
    super.initState();
    _initIap();
  }

  Future<void> _initIap() async {
    setState(() => _iapBusy = true);
    try {
      await _ps.init();
      setState(() => _iapInit = true);
    } on Exception catch (_) {
      // sessiz: iPad/iOS store unavailable durumlarını UI'da disable edeceğiz
    } finally {
      if (mounted) setState(() => _iapBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.settingsTitle),
        leading: _prevNavigationButton(context),
      ),
      body: FutureBuilder<bool>(
        future: sl<UserModeService>().isOfflineMode(),
        builder: (context, snapshot) {
          final isOffline = snapshot.data ?? false;

          return BlocProvider(
            create: (_) => sl<CountryCubit>(),
            child: Padding(
              padding: AppPaddings.columnPadding,
              child: Column(
                children: [
                  // Çevrimdışı kullanıcılar için login prompt
                  if (isOffline) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_off_outlined,
                            size: 48,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.loc.offlineModeActive,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.loc.loginToSyncData,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.go(AppRoute.login.path);
                            },
                            icon: const Icon(Icons.login),
                            label: Text(context.loc.loginButton),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const CountryTile(),
                  // Add Partner - sadece giriş yapan kullanıcılar için
                  if (!isOffline)
                    SettingsPageListtile(
                      title: context.loc.addPartnerTitle,
                      onTap: () async {
                        if (!context.mounted) return;
                        await context.push(AppRoute.collaborators.path);
                      },
                    ),
                  // Hesabı sil - sadece giriş yapan kullanıcılar için
                  if (!isOffline)
                    SettingsPageListtile(
                      title: context.loc.deleteAccountTitle,
                      onTap: () {
                        context.push(AppRoute.deleteAccount.path);
                      },
                    ),
                  // Destek bağlantısı (App Store Connect Support URL ile aynı olmalı)
                  SettingsPageListtile(
                    title: context.loc.supportAndHelpTitle,
                    onTap: () async {
                      const url =
                          'https://sites.google.com/view/wedlist/support';
                      final uri = Uri.parse(url);
                      // capture UI deps before await to avoid context across async gap
                      final messenger = ScaffoldMessenger.of(context);
                      final errorText = '${context.loc.errorPrefix} $url';
                      final success = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!success && mounted) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(errorText)),
                        );
                      }
                    },
                  ),
                  // IAP uygunluk bilgilendirmesi (özellikle iPad için mağaza hesabı/yetersiz destek durumlarında)
                  if (!(_iapInit && _ps.isAvailable) ||
                      _ps.removeAdsProduct == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.loc.purchaseUnsupported,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Remove ads
                  ValueListenableBuilder<bool>(
                    valueListenable: _ps.removeAds,
                    builder: (context, removeAds, _) {
                      if (removeAds) return const SizedBox.shrink();
                      final removeAdsReady = _ps.removeAdsProduct != null;
                      final enabled =
                          _iapInit &&
                          _ps.isAvailable &&
                          removeAdsReady &&
                          !_iapBusy;
                      return SettingsPageListtile(
                        title: context.loc.removeAdsTitle,
                        enabled: enabled,
                        disabledMessage: context.loc.purchaseUnsupported,
                        onTap: () async {
                          if (!enabled) return;
                          setState(() => _iapBusy = true);
                          final messenger = ScaffoldMessenger.of(context);
                          final successText = context.loc.purchaseSuccess;
                          final failText = context.loc.purchaseFailed;
                          final ok = await _ps.buyRemoveAds();
                          if (!mounted) return;
                          setState(() => _iapBusy = false);
                          if (!mounted) return;
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(ok ? successText : failText),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Restore purchases
                  SettingsPageListtile(
                    title: context.loc.restorePurchasesTitle,
                    enabled:
                        _iapInit &&
                        _ps.isAvailable &&
                        _ps.removeAdsProduct != null &&
                        !_iapBusy,
                    disabledMessage: context.loc.purchaseUnsupported,
                    onTap: () async {
                      if (!(_iapInit && _ps.isAvailable)) return;
                      setState(() => _iapBusy = true);
                      final messenger = ScaffoldMessenger.of(context);
                      final restoringText =
                          context.loc.restoringPurchasesMessage;
                      await _ps.restorePurchases();
                      if (!mounted) return;
                      setState(() => _iapBusy = false);
                      if (!mounted) return;
                      messenger.showSnackBar(
                        SnackBar(content: Text(restoringText)),
                      );
                    },
                  ),
                  // Logout butonu sadece giriş yapılmışsa
                  if (!isOffline) _logoutButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // no-op

  Expanded _logoutButton(BuildContext context) {
    return Expanded(
      child: LogoutSection(
        onLogout: () async {
          try {
            await FirebaseAuth.instance.signOut();
          } finally {
            if (context.mounted) {
              context.go(AppRoute.login.path);
            }
          }
        },
      ),
    );
  }

  Widget _prevNavigationButton(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoute.main.path);
        }
      },
    );
  }
}
