import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wedlist/core/services/ads_service.dart';
import 'package:wedlist/core/services/purchase_service.dart';
import 'package:wedlist/injection_container.dart';

/// BannerAd oluşturan, gösteren ve yaşam döngüsünü yöneten basit widget.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key, this.adSize = AdSize.banner});
  final AdSize adSize;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _banner;
  bool _loaded = false;
  Timer? _retryTimer;
  final Duration _retryDelay = const Duration(seconds: 20);

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Ensure we know entitlement state before showing ads
    await sl<PurchaseService>().init();
    final removeAds = sl<PurchaseService>().removeAds.value;
    sl<AdsService>().adsGloballyDisabled = removeAds;
    if (!removeAds) {
      await _load();
      // React to entitlement changes live
      sl<PurchaseService>().removeAds.addListener(_onEntitlementChanged);
    }
  }

  void _onEntitlementChanged() {
    final remove = sl<PurchaseService>().removeAds.value;
    sl<AdsService>().adsGloballyDisabled = remove;
    if (remove) {
      _retryTimer?.cancel();
      _banner?.dispose();
      if (mounted)
        setState(() {
          _banner = null;
          _loaded = false;
        });
    } else {
      // If entitlement revoked (rare), try to load again
      _load();
    }
  }

  Future<void> _load() async {
    // Eski banner'ı temizle
    _retryTimer?.cancel();
    _banner?.dispose();
    _banner = null;
    _loaded = false;

    await sl<AdsService>().init();
    final banner = sl<AdsService>().createAnchoredBanner(
      size: widget.adSize,
      onLoaded: () {
        if (mounted) setState(() => _loaded = true);
      },
      onFailed: (_) {
        if (!mounted) return;
        setState(() => _loaded = false);
        // 15-30 sn arası bekleme ile otomatik yeniden dene (burada 20 sn)
        _retryTimer?.cancel();
        _retryTimer = Timer(_retryDelay, () {
          if (!mounted) return;
          _load();
        });
      },
    );
    if (banner == null) {
      // Ads not supported on this platform; keep widget collapsed
      if (mounted) setState(() => _banner = null);
      return;
    }
    setState(() => _banner = banner);
  }

  @override
  void dispose() {
    _banner?.dispose();
    _retryTimer?.cancel();
    sl<PurchaseService>().removeAds.removeListener(_onEntitlementChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stabil yerleşim: Reklam yüklenmese bile hedef yükseklik kadar yer tut.
    final reservedHeight = widget.adSize.height.toDouble();
    return SizedBox(
      width: double.infinity,
      height: reservedHeight,
      child: _loaded && _banner != null
          ? Center(
              child: SizedBox(
                width: _banner!.size.width.toDouble(),
                height: _banner!.size.height.toDouble(),
                child: AdWidget(ad: _banner!),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
