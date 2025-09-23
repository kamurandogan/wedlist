import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/user/user_service.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/core/widgets/wedlist_logo_svg/wedlist_logo_svg.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';
import 'package:wedlist/injection_container.dart';

part 'presentation/widgets/splash_page_mixin.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SplashPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: AppPaddings.columnPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: WedlistLogoSvg(
                heightScale: .15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
