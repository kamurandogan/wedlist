// Gerekli Flutter ve proje içi paketler import ediliyor
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/feature/main_page/presentation/blocs/cubit/navigation_cubit.dart';
import 'package:wedlist/feature/notification/presentation/bloc/notification_bloc.dart';

/// Uygulamanın alt kısmında gezinme için kullanılan, erişilebilirlik ve performans odaklı özel bottom navigation bar.
class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  static const double _barHeight = 80;
  static const double _iconSize = 32;
  static const double _radius = 60;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<NavigationCubit, SelectedPage>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: SizedBox(
              height: _barHeight,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_radius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _navIcon(
                        context,
                        icon: HugeIcons.strokeRoundedHome01,
                        selected: state == SelectedPage.home,
                        onTap: () => context.read<NavigationCubit>().changePage(
                          SelectedPage.home,
                        ),
                        tooltip: 'Home',
                      ),
                      _navIcon(
                        context,
                        icon: HugeIcons.strokeRoundedMenu01,
                        selected: state == SelectedPage.wishlist,
                        onTap: () => context.read<NavigationCubit>().changePage(
                          SelectedPage.wishlist,
                        ),
                        tooltip: 'Wishlist',
                      ),
                      _navIcon(
                        context,
                        icon: HugeIcons.strokeRoundedFavourite,
                        selected: state == SelectedPage.dowryList,
                        onTap: () => context.read<NavigationCubit>().changePage(
                          SelectedPage.dowryList,
                        ),
                        tooltip: 'Dowry List',
                      ),
                      BlocBuilder<NotificationBloc, NotificationState>(
                        builder: (context, nstate) {
                          var unread = 0;
                          if (nstate is NotificationLoaded) {
                            unread = nstate.items.where((e) => !e.read).length;
                          }
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _navIcon(
                                context,
                                icon: HugeIcons.strokeRoundedNotification01,
                                selected: state == SelectedPage.notification,
                                onTap: () => context
                                    .read<NavigationCubit>()
                                    .changePage(SelectedPage.notification),
                                tooltip: 'Notification',
                              ),
                              if (unread > 0)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      unread > 99 ? '99+' : '$unread',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _navIcon(
    BuildContext context, {
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Semantics(
      selected: selected,
      label: tooltip,
      button: true,
      child: IconButton(
        onPressed: onTap,
        tooltip: tooltip,
        icon: HugeIcon(
          icon: icon,
          size: _iconSize,
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).disabledColor,
        ),
        splashRadius: 28,
      ),
    );
  }
}
