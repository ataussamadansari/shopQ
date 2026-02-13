import 'package:flutter/material.dart';

class MicroActionButton extends StatefulWidget {
  const MicroActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.filled = true,
    this.expand = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool filled;
  final bool expand;
  final EdgeInsets padding;

  @override
  State<MicroActionButton> createState() => _MicroActionButtonState();
}

class _MicroActionButtonState extends State<MicroActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = widget.filled ? colorScheme.primary : Colors.white;
    final foreground = widget.filled ? Colors.white : colorScheme.primary;

    final button = GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        scale: _pressed ? 0.97 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.filled ? background : colorScheme.primary,
            ),
            boxShadow: widget.filled
                ? <BoxShadow>[
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.icon != null) ...<Widget>[
                Icon(widget.icon, size: 18, color: foreground),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!widget.expand) {
      return button;
    }
    return SizedBox(width: double.infinity, child: button);
  }
}
