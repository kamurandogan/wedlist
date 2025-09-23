import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WedlistLogoSvg extends StatelessWidget {
  WedlistLogoSvg({super.key, this.heightScale = 0.1});

  final Widget _logoSvg = SvgPicture.asset('assets/images/wedlist.svg');
  final double heightScale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * heightScale,
      child: _logoSvg,
    );
  }
}
