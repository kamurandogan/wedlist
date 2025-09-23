import 'package:flutter/material.dart';

final class AppPaddings {
  static const EdgeInsets smallAll = EdgeInsets.all(8);
  static const EdgeInsets mediumAll = EdgeInsets.all(16);
  static const EdgeInsets largeAll = EdgeInsets.all(24);
  static const EdgeInsets smallSymmetric = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );
  static const EdgeInsets mediumSymmetric = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets largeSymmetric = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  );
  static const EdgeInsets zero = EdgeInsets.zero;
  static const EdgeInsets smallOnlyTop = EdgeInsets.only(top: 8);
  static const EdgeInsets mediumOnlyTop = EdgeInsets.only(top: 16);

  static const EdgeInsets largeOnlyTop = EdgeInsets.only(top: 24);
  static const EdgeInsets xLargeOnlyTop = EdgeInsets.only(top: 40);
  static const EdgeInsets xLargeOnlyBottom = EdgeInsets.only(bottom: 32);
  static const EdgeInsets xLargeOnlyLeft = EdgeInsets.only(left: 32);
  static const EdgeInsets xLargeOnlyRight = EdgeInsets.only(right: 32);

  static const EdgeInsets smallOnlyBottom = EdgeInsets.only(bottom: 8);
  static const EdgeInsets mediumOnlyBottom = EdgeInsets.only(bottom: 16);
  static const EdgeInsets largeOnlyBottom = EdgeInsets.only(bottom: 24);
  static const EdgeInsets smallOnlyLeft = EdgeInsets.only(left: 8);
  static const EdgeInsets mediumOnlyLeft = EdgeInsets.only(left: 16);
  static const EdgeInsets largeOnlyLeft = EdgeInsets.only(left: 24);
  static const EdgeInsets smallOnlyRight = EdgeInsets.only(right: 8);
  static const EdgeInsets mediumOnlyRight = EdgeInsets.only(right: 16);
  static const EdgeInsets largeOnlyRight = EdgeInsets.only(right: 24);
  static const EdgeInsets columnPadding = EdgeInsets.only(
    left: 16,
    right: 16,
    top: 16,
    bottom: 30,
  );
}
