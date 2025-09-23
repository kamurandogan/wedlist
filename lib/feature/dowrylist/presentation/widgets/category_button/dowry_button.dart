part of '../../pages/category_button_dowry.dart';

class DowryCategoryButton extends StatelessWidget {
  const DowryCategoryButton({
    required this.categoryName,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  final String categoryName;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? AppColors.primary : Colors.transparent;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: bg,
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.4),
          width: 1.2,
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: onPressed,
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
