import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WedlistHeaderSvg extends StatelessWidget {
  WedlistHeaderSvg({super.key});

  final Widget _logoSvg = SvgPicture.asset(
    'assets/images/header_light.svg',
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.15, child: _logoSvg);
  }
}
