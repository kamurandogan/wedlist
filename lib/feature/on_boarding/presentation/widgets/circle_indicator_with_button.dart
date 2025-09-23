part of '../../on_boarding_page.dart';

class CircleIndicatorWithButton extends StatelessWidget {
  const CircleIndicatorWithButton({
    required this.progress,
    super.key,
    this.child,
  });

  final double progress;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 5,
              backgroundColor: AppColors.bg.withValues(alpha: .3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.textColor),
            ),
          ),
          child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
