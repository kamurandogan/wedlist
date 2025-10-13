import 'package:flutter/material.dart';

/// Shared pastel color palette for charts and legends.
class ChartPalette {
  const ChartPalette._();

  /// A vibrant yet soft pastel palette.
  static const List<Color> pastel = <Color>[
    Color(0xFFFFADAD), // light red
    Color(0xFFFFD6A5), // peach
    Color(0xFFFDFFB6), // banana
    Color(0xFFCAFFBF), // mint
    Color(0xFF9BF6FF), // cyan
    Color(0xFFA0C4FF), // light blue
    Color(0xFFBDB2FF), // lavender
    Color(0xFFFFC6FF), // pink
    Color(0xFFD0F4DE), // pale mint
    Color(0xFFFDE2E4), // blush
    Color(0xFFDFE7FD), // powder blue
    Color(0xFFCDEAC0), // pale green
  ];

  /// Returns a palette that can be adapted in future for dark/light.
  // ignore: avoid-unused-parameters
  static List<Color> adaptive(BuildContext context) => pastel;
}
