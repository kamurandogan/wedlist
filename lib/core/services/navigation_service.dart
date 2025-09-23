import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Uygulama genelinde kullanılacak olan NavigationService
/// Bu servis sayesinde context olmadan sayfa geçişleri yapılabilir
class NavigationService {
  /// GoRouter ile kullanılmak üzere Global NavigatorKey tanımı
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Mevcut BuildContext'e erişim
  /// Bu context sayesinde yönlendirmeler yapılır
  static BuildContext get context => navigatorKey.currentContext!;

  /// Belirtilen route'a geçiş yapar (go_router: go)
  /// Örn: NavigationService.go('/home')
  static void go(String location) {
    context.go(location);
  }

  /// Belirtilen route'u mevcut rotanın üstüne ekler (stack yapısı gibi)
  /// Örn: NavigationService.push('/details')
  static void push(String location) {
    context.push(location);
  }

  /// Geçerli rotayı değiştirir ve yerine yenisini koyar
  /// Geri tuşuna basıldığında önceki ekrana dönülmez
  static void pushReplacement(String location) {
    context.pushReplacement(location);
  }

  /// Navigator stack'inden bir adım geri çıkar
  /// İsteğe bağlı olarak sonuç döndürebilir
  static void pop<T extends Object?>([T? result]) {
    if (canPop()) {
      context.pop(result);
    }
  }

  /// Geri çıkılabilir bir rota olup olmadığını kontrol eder
  static bool canPop() {
    return Navigator.of(context).canPop();
  }
}
