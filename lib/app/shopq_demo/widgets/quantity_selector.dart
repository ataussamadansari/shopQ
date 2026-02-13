import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: quantity > min ? () => onChanged(quantity - 1) : null,
            icon: const Icon(CupertinoIcons.minus),
          ),
          Text(
            '$quantity',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: quantity < max ? () => onChanged(quantity + 1) : null,
            icon: const Icon(CupertinoIcons.plus),
          ),
        ],
      ),
    );
  }
}
