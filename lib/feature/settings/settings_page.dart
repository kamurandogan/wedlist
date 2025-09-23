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

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
              SettingsPageListtile(
                title: context.loc.addPartnerTitle,
                onTap: () async {
                  final ps = sl<PurchaseService>();
                  await ps.init();
                  if (!ps.collabUnlocked.value) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.loc.partnerFeatureRequired),
                        ),
                      );
                    }
                    return;
                  }
                  if (context.mounted) {
                    context.go(AppRoute.collaborators.path);
                  }
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: sl<PurchaseService>().collabUnlocked,
                builder: (context, collabUnlocked, _) {
                  if (collabUnlocked) return const SizedBox.shrink();
                  return SettingsPageListtile(
                    title: context.loc.enablePartnerFeatureTitle,
                    onTap: () async {
                      final ps = sl<PurchaseService>();
                      await ps.init();
                      if (!ps.isAvailable) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.loc.purchaseUnsupported),
                            ),
                          );
                        }
                        return;
                      }
                      final ok = await ps.buyCollabUnlock();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ok ? context.loc.purchaseSuccess : context.loc.purchaseFailed,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: sl<PurchaseService>().removeAds,
                builder: (context, removeAds, _) {
                  if (removeAds) return const SizedBox.shrink();
                  return _removeAdsPurchaseButton(context);
                },
              ),
              SettingsPageListtile(
                title: context.loc.restorePurchasesTitle,
                onTap: () async {
                  final ps = sl<PurchaseService>();
                  await ps.init();
                  await ps.restorePurchases();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.loc.restoringPurchasesMessage),
                      ),
                    );
                  }
                },
              ),
              _logoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  SettingsPageListtile _removeAdsPurchaseButton(BuildContext context) {
    return SettingsPageListtile(
      title: context.loc.removeAdsTitle,
      onTap: () async {
        final ps = sl<PurchaseService>();
        await ps.init();
        if (!ps.isAvailable) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.loc.purchaseUnsupported),
              ),
            );
          }
          return;
        }
        final ok = await ps.buyRemoveAds();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ok ? context.loc.purchaseSuccess : context.loc.purchaseFailed,
              ),
            ),
          );
        }
      },
    );
  }

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
