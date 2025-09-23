// Gerekli Flutter ve paket importları
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/feature/on_boarding/domain/entities/onboarding_entity.dart';
import 'package:wedlist/feature/on_boarding/presentation/blocs/cubit/cubit/page_view_cubit.dart';
import 'package:wedlist/feature/on_boarding/presentation/widgets/beck_button.dart';
import 'package:wedlist/feature/on_boarding/presentation/widgets/next_button.dart';
import 'package:wedlist/feature/on_boarding/presentation/widgets/onboarding_card.dart';

part 'presentation/widgets/circle_indicator_with_button.dart';
part 'presentation/widgets/on_boarding_mixin.dart';

// Onboarding ekranı için ana widget

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PageViewCubit(pageCount: 3),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> with OnboardingMixin<_OnboardingView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageViewCubit, PageViewCubitState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: pageViewBackgroundColor(state.currentIndex),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: OnboardingMixin.onboardingController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      context.read<PageViewCubit>().setPage(index);
                    },
                    itemBuilder: (context, index) {
                      return OnboardingCard(data: onboardingData[index]);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (state.isLastPage)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _selectCountyTitle(context),
                        const SizedBox(height: 8),
                        _selectCountry(),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),
                _progressButtonLine(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Text _selectCountyTitle(BuildContext context) {
    return Text(
      context.loc.selectCountryTitle,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  SizedBox _selectCountry() {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        value: _selectedCountry,
        items: OnboardingMixin._supportedCountries
            .map(
              (c) => DropdownMenuItem(
                value: c,
                child: Text(OnboardingMixin._countryLabels[c] ?? c),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _selectedCountry = v),
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
    );
  }

  Widget _progressButtonLine(BuildContext context, PageViewCubitState state) {
    final progress = (state.currentIndex + 1) / onboardingData.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (state.currentIndex == 0)
          const SizedBox(width: 64, height: 64)
        else
          CircleIndicatorWithButton(
            progress: progress,
            child: _backButton(context),
          ),
        CircleIndicatorWithButton(
          progress: progress,
          child: state.isLastPage ? _nextButtonForNavigator(context) : _nextButtonForForward(context),
        ),
      ],
    );
  }

  NextButton _nextButtonForForward(BuildContext context) {
    return NextButton(
      onTap: () {
        OnboardingMixin.onboardingController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        context.read<PageViewCubit>().nextPage();
      },
    );
  }

  NextButton _nextButtonForNavigator(BuildContext context) {
    return NextButton(
      onTap: () async {
        // BuildContext'ı async boşluklardan sonra kullanmamak için router'ı
        // "+await"
        final router = GoRouter.of(context);
        final prefs = await SharedPreferences.getInstance();
        if ((_selectedCountry ?? '').isNotEmpty) {
          await prefs.setString('selected_country', _selectedCountry!);
        }
        await prefs.setBool('onboarding_seen', true);
        router.go(AppRoute.login.path);
      },
      backgroundColor: AppColors.bg,
      iconColor: AppColors.textColor,
    );
  }

  BackButtonCircle _backButton(BuildContext context) {
    return BackButtonCircle(
      iconColor: AppColors.textColor,
      backgroundColor: AppColors.bg,
      onTap: () {
        OnboardingMixin.onboardingController.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        context.read<PageViewCubit>().previousPage();
      },
    );
  }
}
