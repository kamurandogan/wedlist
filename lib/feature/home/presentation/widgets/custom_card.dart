part of '../../home_page.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({required this.cardHeight, super.key, this.cardColor = Colors.white, this.child});

  final double cardHeight;
  final Color? cardColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: AppPaddings.largeOnlyTop,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        width: screenWidth,
        height: screenHeight * cardHeight,
        child: Padding(
          padding: AppPaddings.mediumAll,
          child: child,
        ),
      ),
    );
  }
}
