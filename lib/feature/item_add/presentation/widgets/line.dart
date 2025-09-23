part of '../../add_item_screen.dart';

class Line extends StatefulWidget {
  const Line({
    required this.title,
    required this.value,
    this.onChanged,
    super.key,
  });
  final String title;
  final String value;
  final ValueChanged<String>? onChanged;

  @override
  State<Line> createState() => _LineState();
}

class _LineState extends State<Line> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(Line oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  void _handleControllerChanged() {
    if (widget.onChanged != null && _controller.text != widget.value) {
      widget.onChanged!(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPriceField =
        widget.title.toLowerCase().contains('ücret') ||
        widget.title.toLowerCase().contains('price');
    return Padding(
      padding: AppPaddings.smallOnlyTop,
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        keyboardType: isPriceField
            ? const TextInputType.numberWithOptions(decimal: true)
            : null,
        inputFormatters: isPriceField
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('^[0-9]*[.,]?[0-9]*')),
              ]
            : null,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: widget.title,
          border: const UnderlineInputBorder(),

          enabledBorder: const UnderlineInputBorder(),
          focusedBorder: const UnderlineInputBorder(),
        ),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
