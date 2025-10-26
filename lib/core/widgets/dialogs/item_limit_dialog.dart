import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/services/ads_service.dart';
import 'package:wedlist/core/services/item_limit_service.dart';
import 'package:wedlist/injection_container.dart';

/// Item limiti dolduğunda gösterilen dialog.
///
/// Kullanıcıya 3 seçenek sunar:
/// 1. Reklam izle (+5 item bonus kazan)
/// 2. Reklamsız satın al (sınırsız item)
/// 3. İptal (item ekleme iptal edilir)
///
/// Kullanım:
/// ```dart
/// final result = await showItemLimitDialog(context);
/// if (result == true) {
///   // Kullanıcı rewarded ad izledi, item eklenebilir
/// }
/// ```
Future<bool?> showItemLimitDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Dışarı tıklayarak kapatılamaz
    builder: (context) => const _ItemLimitDialog(),
  );
}

class _ItemLimitDialog extends StatefulWidget {
  const _ItemLimitDialog();

  @override
  State<_ItemLimitDialog> createState() => _ItemLimitDialogState();
}

class _ItemLimitDialogState extends State<_ItemLimitDialog> {
  final AdsService _adsService = sl<AdsService>();
  final ItemLimitService _limitService = sl<ItemLimitService>();

  bool _isLoadingAd = false;
  int _itemsAdded = 0;

  @override
  void initState() {
    super.initState();
    _loadItemCount();
  }

  Future<void> _loadItemCount() async {
    final count = await _limitService.getTotalItemsAdded();
    if (mounted) {
      setState(() => _itemsAdded = count);
    }
  }

  Future<void> _watchRewardedAd() async {
    setState(() => _isLoadingAd = true);

    try {
      final success = await _adsService.showRewarded(
        onReward: (reward) async {
          // Rewarded ad başarılı, bonus item ekle
          await _limitService.addBonusItems(ItemLimitService.bonusItemsPerAd);
        },
      );

      if (!mounted) return;

      if (success) {
        // Başarılı, dialog'u kapat ve true dön
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        // Reklam gösterilemedi veya kullanıcı iptal etti
        setState(() => _isLoadingAd = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.loc.purchaseFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoadingAd = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.loc.errorPrefix}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _goToRemoveAds() {
    // Settings sayfasına yönlendir
    Navigator.of(context).pop(false); // Dialog'u kapat
    context.push(AppRoute.settings.path);
  }

  void _cancel() {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hero Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              context.loc.itemLimitReachedTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              context.loc.itemLimitReachedMessage(_itemsAdded),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Loading indicator
            if (_isLoadingAd) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                context.loc.adLoadingText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Options Cards
            if (!_isLoadingAd) ...[
              // Reklam İzle Card (Primary)
              _OptionCard(
                icon: Icons.play_circle_filled,
                iconColor: Colors.green,
                title: context.loc.watchAdForItemsButton,
                subtitle: context.loc.adOptionFreeLabel,
                badge: context.loc.adOptionRecommendedBadge,
                badgeColor: Colors.green,
                onTap: _watchRewardedAd,
                isPrimary: true,
              ),
              const SizedBox(height: 12),

              // Reklamsız Satın Al Card
              _OptionCard(
                icon: Icons.diamond,
                iconColor: Colors.amber,
                title: context.loc.buyRemoveAdsButton,
                subtitle: context.loc.adOptionPremiumLabel,
                onTap: _goToRemoveAds,
                isPrimary: false,
              ),
              const SizedBox(height: 24),

              // İptal butonu
              TextButton(
                onPressed: _cancel,
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(
                  context.loc.cancel,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Modern option card widget
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isPrimary,
    this.badge,
    this.badgeColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isPrimary;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: isPrimary
          ? colorScheme.primaryContainer.withValues(alpha: 0.5)
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: isPrimary
                ? Border.all(
                    color: colorScheme.primary,
                    width: 2,
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor ?? colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badge!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
