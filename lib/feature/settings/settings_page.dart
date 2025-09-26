import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/services/purchase_service.dart';
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
  final _ps = sl<PurchaseService>();
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
    } catch (_) {
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
      body: BlocProvider(
        create: (_) => sl<CountryCubit>(),
        child: Padding(
          padding: AppPaddings.columnPadding,
          child: Column(
            children: [
              const CountryTile(),
              // Add Partner: yalnızca collabUnlocked ise geçişe izin ver, değilse uyarı göster
              ValueListenableBuilder<bool>(
                valueListenable: _ps.collabUnlocked,
                builder: (context, collabUnlocked, _) {
                  return SettingsPageListtile(
                    title: context.loc.addPartnerTitle,
                    enabled: collabUnlocked,
                    onTap: () async {
                      if (!collabUnlocked) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text(context.loc.partnerFeatureRequired),
                            ),
                          );
                        }
                        return;
                      }
                      if (!context.mounted) return;
                      context.go(AppRoute.collaborators.path);
                    },
                  );
                },
              ),
              // Enable partner feature: servis hazır ve ürün yüklü olmazsa disabled
              ValueListenableBuilder<bool>(
                valueListenable: _ps.collabUnlocked,
                builder: (context, collabUnlocked, _) {
                  if (collabUnlocked) return const SizedBox.shrink();

                  final partnerProductReady = _ps.collabUnlockProduct != null;
                  final enabled = _iapInit && _ps.isAvailable && partnerProductReady && !_iapBusy;

                  return SettingsPageListtile(
                    title: context.loc.enablePartnerFeatureTitle,
                    enabled: enabled,
                    onTap: () async {
                      if (!enabled) return;
                      setState(() => _iapBusy = true);
                      final ok = await _ps.buyCollabUnlock();
                      if (!mounted) return;
                      setState(() => _iapBusy = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? context.loc.purchaseSuccess
                                : context.loc.purchaseFailed,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // Remove ads
              ValueListenableBuilder<bool>(
                valueListenable: _ps.removeAds,
                builder: (context, removeAds, _) {
                  if (removeAds) return const SizedBox.shrink();
                  final removeAdsReady = _ps.removeAdsProduct != null;
                  final enabled = _iapInit && _ps.isAvailable && removeAdsReady && !_iapBusy;
                  return SettingsPageListtile(
                    title: context.loc.removeAdsTitle,
                    enabled: enabled,
                    onTap: () async {
                      if (!enabled) return;
                      setState(() => _iapBusy = true);
                      final ok = await _ps.buyRemoveAds();
                      if (!mounted) return;
                      setState(() => _iapBusy = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? context.loc.purchaseSuccess
                                : context.loc.purchaseFailed,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // Restore purchases
              SettingsPageListtile(
                title: context.loc.restorePurchasesTitle,
                enabled: _iapInit && _ps.isAvailable && !_iapBusy,
                onTap: () async {
                  if (!(_iapInit && _ps.isAvailable)) return;
                  setState(() => _iapBusy = true);
                  await _ps.restorePurchases();
                  if (!mounted) return;
                  setState(() => _iapBusy = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.loc.restoringPurchasesMessage),
                    ),
                  );
                },
              ),
              _logoutButton(context),
            ],
          ),
        ),
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
