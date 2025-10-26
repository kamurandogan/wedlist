// ignore_for_file: unintended_html_in_doc_comment

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wedlist/core/constants/strings.dart';

/// Reklamları (başlatma, yükleme, önbellekleme ve gösterme) merkezi olarak yöneten servis.
/// Banner, Geçiş (Interstitial) ve Ödüllü (Rewarded) reklam yardımcı metotları sağlar.
///
/// Kullanım:
///   await sl<AdsService>().init();  // main içinde başlangıçta zaten çağrılıyor
///   Banner: BannerAd? ad = sl<AdsService>().createAnchoredBanner();
///   Interstitial: await sl<AdsService>().showInterstitial();
///   Rewarded: final success = await sl<AdsService>().showRewarded(onReward: (reward) { ... });
///
/// Varsayılan olarak TEST kimlikleri kullanılır. Yayına çıkmadan önce prod ID'lerle değiştirin.
/// TO:DO(kamuran): IOS prod ID'leri eklenecek
class AdsService {
  bool _initialized = false;
  Completer<void>? _initializing;

  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;

  // Yeni bir banner oluştururken önceki banner'ı temizlemek için referans tutulur.
  BannerAd? _currentBanner;

  // Interstitial uygunluk/kısıtlama için basit soğuma (cooldown) ve son gösterim zamanı
  DateTime? _lastInterstitialShownAt;
  Duration interstitialCooldown = const Duration(seconds: 60);
  // Uygulama oturumu boyunca sadece 1 kez göster (uygulama kapanana kadar)
  bool _interstitialShownThisSession = false;

  bool get isInitialized => _initialized;
  bool get canShowInterstitial {
    if (!_adsSupported) return false;
    if (_interstitialShownThisSession) return false; // oturum başına 1 kez
    final last = _lastInterstitialShownAt;
    if (last == null) return true;
    return DateTime.now().difference(last) >= interstitialCooldown;
  }

  // Google Mobile Ads only supports Android/iOS. Web/desktop are not supported.
  bool get _adsSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  // Entitlement-based kill switch (e.g., Remove Ads purchase)
  bool _adsGloballyDisabled = false;
  void disableAds() => _adsGloballyDisabled = true;
  void enableAds() => _adsGloballyDisabled = false;
  bool get adsEnabled => _adsSupported && !_adsGloballyDisabled;

  /// Google Mobile Ads SDK'yı başlatır (idempotent: tekrar çağrılırsa hızlı döner).
  Future<void> init() async {
    if (_initialized) return;
    if (_initializing != null) return _initializing!.future;
    _initializing = Completer<void>();
    try {
      // Skip completely on unsupported platforms (Windows, Linux, macOS, Web)
      if (!adsEnabled) {
        if (kDebugMode) {
          debugPrint(
            'Ads disabled: platform not supported ($defaultTargetPlatform${kIsWeb ? ' web' : ''})',
          );
        }
        _initialized =
            true; // mark as no-op initialized to avoid repeated attempts
        _initializing!.complete();
        return;
      }
      final status = await MobileAds.instance.initialize();
      if (kDebugMode) {
        debugPrint('Ads initialized: ${status.adapterStatuses.keys}');
      }
      _initialized = true;
      _initializing!.complete();
      _warmUp();
    } catch (e, st) {
      if (kDebugMode) debugPrint('Ads init error: $e\n$st');
      _initializing!.completeError(e, st);
    } finally {
      _initializing = null;
    }
  }

  /// İlk gösterim süresini kısaltmak için interstitial & rewarded reklamları önceden yükle.
  void _warmUp() {
    // Bu çağrıları beklemiyoruz; arka planda yükleme yapacaklar.
    // ignore: unawaited_futures
    _loadInterstitial();
    // ignore: unawaited_futures
    _loadRewarded();
  }

  // -------------------- Banner -------------------- //

  /// BannerAd oluşturur ve yüklemeye başlar. Widget ağaçtan kaldırıldığında dispose edilmelidir.
  /// Önceden bir banner varsa önce dispose edilir.
  BannerAd? createAnchoredBanner({
    AdSize size = AdSize.banner,
    void Function()? onLoaded,
    void Function(LoadAdError error)? onFailed,
  }) {
    if (!adsEnabled) {
      if (kDebugMode) {
        debugPrint('Banner ads are not supported on this platform.');
      }
      return null;
    }
    _currentBanner?.dispose();
    final banner = BannerAd(
      size: size,
      request: const AdRequest(),
      adUnitId: _bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner loaded: ${ad.adUnitId}');
          onLoaded?.call();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner failed: $error');
          onFailed?.call(error);
          ad.dispose();
        },
      ),
    )..load();
    _currentBanner = banner;
    return banner;
  }

  // -------------------- Interstitial -------------------- //

  Future<void> _loadInterstitial() async {
    if (!adsEnabled) return;
    if (_interstitial != null) return; // zaten yüklü
    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          ad.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial load failed: $error');
          _interstitial = null;
        },
      ),
    );
  }

  Future<bool> showInterstitial() async {
    if (!adsEnabled) return false;
    if (!_initialized) await init();

    // Uygunluk kontrolü: cooldown süresi doldu mu?
    if (!canShowInterstitial) {
      // Hazır değilse önceden yüklemeyi tetikle ve olumsuz dön
      // ignore: unawaited_futures
      _loadInterstitial();
      return false;
    }

    // Ad yoksa yüklemeyi dene (hızlıca dön)
    if (_interstitial == null) await _loadInterstitial();
    final ad = _interstitial;
    if (ad == null) return false; // load başarısız ise fallback: false

    final completer = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _interstitialShownThisSession = true; // oturum için kilitle
        _lastInterstitialShownAt = DateTime.now();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitial = null;
        // ignore: unawaited_futures
        _loadInterstitial(); // Sonraki için yeniden yükle
        completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial show failed: $error');
        ad.dispose();
        _interstitial = null;
        completer.complete(false);
      },
    );
    await ad.show();
    return completer.future;
  }

  // -------------------- Rewarded -------------------- //

  Future<void> _loadRewarded() async {
    if (!adsEnabled) return;
    if (_rewarded != null) return; // zaten yüklü
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewarded = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded load failed: $error');
          _rewarded = null;
        },
      ),
    );
  }

  Future<bool> showRewarded({
    required void Function(RewardItem reward) onReward,
  }) async {
    if (!adsEnabled) return false;
    if (!_initialized) await init();
    if (_rewarded == null) await _loadRewarded();
    final ad = _rewarded;
    if (ad == null) return false;
    final completer = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewarded = null;
        // ignore: unawaited_futures
        _loadRewarded(); // Sonraki gösterim için yeniden yükle
        completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Rewarded show failed: $error');
        ad.dispose();
        _rewarded = null;
        completer.complete(false);
      },
    );
    await ad.show(onUserEarnedReward: (ad, reward) => onReward(reward));
    return completer.future;
  }

  // -------------------- Temizlik -------------------- //

  void disposeBanner() {
    _currentBanner?.dispose();
    _currentBanner = null;
  }

  void disposeAll() {
    _interstitial?.dispose();
    _rewarded?.dispose();
    _currentBanner?.dispose();
    _interstitial = null;
    _rewarded = null;
    _currentBanner = null;
  }

  // -------------------- Reklam Birim Kimlikleri (Test) -------------------- //

  String get _bannerAdUnitId {
    // Debug / profile: Google test id kullan; Release: gerçek ID.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return kDebugMode
          ? AppStrings.admobTestBannerAndroid
          : AppStrings.admobProdBannerAndroid;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return kDebugMode
          ? AppStrings.admobTestBannerIOS
          : AppStrings.admobProdBannerIOS;
    }
    return 'test-banner';
  }

  String get _interstitialAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return kDebugMode
          ? AppStrings.admobTestInterstitialAndroid
          : AppStrings.admobProdInterstitialAndroid;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return kDebugMode
          ? AppStrings.admobTestInterstitialIOS
          : AppStrings.admobProdInterstitialIOS;
    }
    return 'test-interstitial';
  }

  String get _rewardedAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return kDebugMode
          ? AppStrings.admobTestRewardedAndroid
          : AppStrings.admobProdRewardedAndroid;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return kDebugMode
          ? AppStrings.admobTestRewardedIOS
          : AppStrings.admobProdRewardedIOS;
    }
    return 'test-rewarded';
  }
}
