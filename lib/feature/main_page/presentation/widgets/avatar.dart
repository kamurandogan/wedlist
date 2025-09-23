part of '../pages/user_detail_line_page.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    required this.radius,
    this.imageProvider,
    this.borderWidth = 2.0,
    this.borderColor,
    this.showOverlay = false,
    this.overlayText,
    this.overlayColor,
    this.overlayTextStyle,
    this.overlayIcon,
    super.key,
  });

  final double radius;
  final ImageProvider? imageProvider;
  final double borderWidth;
  final Color? borderColor;
  final bool showOverlay;
  final String? overlayText;
  final Color? overlayColor;
  final TextStyle? overlayTextStyle;
  final IconData? overlayIcon;

  @override
  Widget build(BuildContext context) {
    final provider = imageProvider ?? const AssetImage('assets/images/default_avatar.png');
    final color = borderColor ?? Theme.of(context).colorScheme.primary;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        var diameter = radius * 2;
        final finiteW = maxW.isFinite;
        final finiteH = maxH.isFinite;
        if (finiteW && finiteH) {
          final bound = maxW < maxH ? maxW : maxH;
          diameter = diameter < bound ? diameter : bound;
        } else if (finiteW && !finiteH) {
          diameter = diameter < maxW ? diameter : maxW;
        } else if (!finiteW && finiteH) {
          diameter = diameter < maxH ? diameter : maxH;
        }

        return Center(
          child: SizedBox(
            width: diameter,
            height: diameter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Base image clipped in a circle
                ClipOval(
                  child: Image(
                    image: provider,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    width: diameter,
                    height: diameter,
                  ),
                ),
                // Dark overlay fully covering the avatar area
                if (showOverlay)
                  Positioned.fill(
                    child: ClipOval(
                      child: ColoredBox(
                        color: (overlayColor ?? Colors.black).withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                // Border on top so it stays visible
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: borderWidth),
                    ),
                  ),
                ),
                if (showOverlay)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        overlayIcon ?? Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: diameter * 0.18,
                      ),
                      SizedBox(height: diameter * 0.04),
                      Text(
                        overlayText ?? 'Fotoğraf yükle',
                        textAlign: TextAlign.center,
                        style: overlayTextStyle ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
