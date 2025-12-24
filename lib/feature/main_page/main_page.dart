import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/services/ads_service.dart';
import 'package:wedlist/core/services/purchase_service.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/core/widgets/bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:wedlist/feature/dowrylist/dowry_view.dart';
import 'package:wedlist/feature/home/home_page.dart';
import 'package:wedlist/feature/main_page/presentation/blocs/cubit/navigation_cubit.dart';
import 'package:wedlist/feature/notification/presentation/ui/pages/notification_page.dart';
import 'package:wedlist/feature/wishlist/wishlist_page.dart';
import 'package:wedlist/injection_container.dart';

part 'presentation/widgets/my_appbar.dart';
part 'presentation/widgets/tabbar.dart';
part 'presentation/widgets/tabview.dart';

/// Ana sayfa (MainPage) uygulamanın tab tab tabanlı yapısının yönetildiği ana ekrandır.
/// BottomNavigationBar ve sayfa geçişi burada yönetilir.
final class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Timer? _interstitialTimer;

  @override
  void initState() {
    super.initState();
    _initMonetization();
  }

  Future<void> _initMonetization() async {
    await sl<PurchaseService>().init();
    final remove = sl<PurchaseService>().removeAds.value;
    if (remove) {
      sl<AdsService>().disableAds();
    } else {
      sl<AdsService>().enableAds();
    }
    if (!remove) {
      _scheduleInterstitial();
      sl<PurchaseService>().removeAds.addListener(_onEntitlementChanged);
    }
  }

  void _onEntitlementChanged() {
    final remove = sl<PurchaseService>().removeAds.value;
    if (remove) {
      sl<AdsService>().disableAds();
    } else {
      sl<AdsService>().enableAds();
    }
    if (remove) {
      _interstitialTimer?.cancel();
    } else {
      _scheduleInterstitial();
    }
  }

  void _scheduleInterstitial() {
    _interstitialTimer?.cancel();
    _interstitialTimer = Timer(const Duration(seconds: 10), () async {
      if (!mounted) return;
      try {
        // showInterstitial uygun değilse false döner ve preload tetikler
        await sl<AdsService>().showInterstitial();
      } on Exception {
        // sessizce yoksay
      }
    });
  }

  @override
  void dispose() {
    _interstitialTimer?.cancel();
    sl<PurchaseService>().removeAds.removeListener(_onEntitlementChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, SelectedPage>(
      builder: (context, state) {
        return PopScope(
          canPop: state == SelectedPage.home,
          onPopInvokedWithResult: (didPop, result) {
            // Ana tabda değilsek, geri tuşu ana taba götürsün; uygulamadan çıkmasın
            if (!didPop && state != SelectedPage.home) {
              context.read<NavigationCubit>().changePage(SelectedPage.home);
            }
          },
          child: Scaffold(
            bottomNavigationBar: const CustomBottomNavigationBar(),
            body: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 55),
              child: Column(
                children: [
                  // Banner sadece reklamlar açıksa gösterilir
                  // ValueListenableBuilder<bool>(
                  //   valueListenable: sl<PurchaseService>().removeAds,
                  //   builder: (context, removed, _) {
                  //     if (removed) return const SizedBox(height: 0);
                  //     return const BannerAdWidget();
                  //   },
                  // ),
                  // const SizedBox(height: 8),
                  // // Aşağıdaki sayfa alanı, bounded (sınırlı) yükseklik için Expanded ile sarmalanır
                  Expanded(
                    // NavigationCubit içindeki state'e göre sayfa gösterilir
                    child: _getSelectedPage(state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getSelectedPage(SelectedPage state) {
    switch (state) {
      case SelectedPage.home:
        return const HomePage();
      case SelectedPage.wishlist:
        return const WishlistPage();
      case SelectedPage.dowryList:
        return const DowryView();
      case SelectedPage.notification:
        return NotificationPage();
    }
  }
}
