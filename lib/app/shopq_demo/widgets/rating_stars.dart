import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 14,
  });

  final double rating;
  final int? reviewCount;
  final double starSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ...List<Widget>.generate(5, (index) {
          final starIndex = index + 1;
          if (rating >= starIndex) {
            return Icon(
              CupertinoIcons.star_fill,
              size: starSize,
              color: const Color(0xFFF59E0B),
            );
          }
          if (rating > starIndex - 1 && rating < starIndex) {
            return Icon(
              CupertinoIcons.star_lefthalf_fill,
              size: starSize,
              color: const Color(0xFFF59E0B),
            );
          }
          return Icon(
            CupertinoIcons.star,
            size: starSize,
            color: const Color(0xFFF59E0B),
          );
        }),
        const SizedBox(width: 6),
        Text(
          reviewCount == null
              ? rating.toStringAsFixed(1)
              : '${rating.toStringAsFixed(1)} (${reviewCount!})',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
