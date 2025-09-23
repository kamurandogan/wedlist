part of 'category_buttons.dart';

final class CategoryButton extends StatelessWidget {
  const CategoryButton({
    required this.categoryName,
    required this.onPressed,
    this.isSelected = false,
    super.key,
  });

  final String categoryName;
  final bool isSelected;
  final VoidCallback onPressed;
  double get _buttonCircularRadius => 24;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_buttonCircularRadius)),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Text(
        categoryName,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
