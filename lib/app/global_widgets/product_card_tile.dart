import 'package:flutter/material.dart';

import 'app_network_image.dart';

class ProductCardTextData {
  final String title;
  final String? metaText;

  const ProductCardTextData({required this.title, this.metaText});
}

ProductCardTextData resolveProductCardText(
  String? rawTitle, {
  String? fallbackMeta,
}) {
  final normalizedTitle = _normalizeText(rawTitle);
  final normalizedFallback = _normalizeText(fallbackMeta);

  if (normalizedTitle.isEmpty) {
    return ProductCardTextData(
      title: "Fresh grocery item",
      metaText: normalizedFallback.isEmpty ? null : normalizedFallback,
    );
  }

  final parenthesizedMatch = _parenthesizedPackInfoPattern.firstMatch(
    normalizedTitle,
  );
  if (parenthesizedMatch != null) {
    final extractedMeta = parenthesizedMatch.group(1)?.trim();
    final cleanedTitle = normalizedTitle
        .substring(0, parenthesizedMatch.start)
        .replaceAll(RegExp(r"[\s,/-]+$"), "")
        .trim();

    return ProductCardTextData(
      title: cleanedTitle.isEmpty ? normalizedTitle : cleanedTitle,
      metaText: extractedMeta,
    );
  }

  final trailingMatch = _packInfoPattern.firstMatch(normalizedTitle);
  if (trailingMatch != null) {
    final extractedMeta = trailingMatch.group(0)?.trim();
    final cleanedTitle = normalizedTitle
        .substring(0, trailingMatch.start)
        .replaceAll(RegExp(r"[\s,/-]+$"), "")
        .trim();

    return ProductCardTextData(
      title: cleanedTitle.isEmpty ? normalizedTitle : cleanedTitle,
      metaText: extractedMeta,
    );
  }

  return ProductCardTextData(
    title: normalizedTitle,
    metaText: normalizedFallback.isEmpty ? null : normalizedFallback,
  );
}

class ProductCardTile extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? metaText;
  final num price;
  final num mrp;
  final int discountPercent;
  final bool isInStock;
  final double? width;
  final VoidCallback? onAddTap;
  final String fallbackAsset;

  const ProductCardTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.mrp,
    required this.discountPercent,
    required this.isInStock,
    this.metaText,
    this.width,
    this.onAddTap,
    this.fallbackAsset = "assets/images/img_1.png",
  });

  @override
  Widget build(BuildContext context) {
    final hasMetaText = metaText != null && metaText!.trim().isNotEmpty;

    return SizedBox(
      width: width,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E0D4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.06,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E5D7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: AppNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            fallbackAsset: fallbackAsset,
                          ),
                        ),
                      ),
                      if (discountPercent > 0)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: _DiscountBadge(
                            discountPercent: discountPercent,
                          ),
                        ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: _AddButton(
                          isEnabled: isInStock,
                          onTap: isInStock ? onAddTap : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 10, 4, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1A16),
                        height: 1.24,
                      ),
                    ),
                    if (hasMetaText) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_outlined,
                            size: 13,
                            color: Color(0xFF7A736B),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              metaText!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF7A736B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          _formatPrice(price),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF171412),
                          ),
                        ),
                        if (mrp > price) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _formatPrice(mrp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF8A847C),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(num amount) =>
      "\u20B9${amount % 1 == 0 ? amount.toInt() : amount}";
}

class _DiscountBadge extends StatelessWidget {
  final int discountPercent;

  const _DiscountBadge({required this.discountPercent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFF2C44E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        "$discountPercent%\nOFF",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 9,
          height: 1.05,
          fontWeight: FontWeight.w800,
          color: Color(0xFF4B3814),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onTap;

  const _AddButton({required this.isEnabled, this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderColor = isEnabled
        ? const Color(0xFF2E66F5)
        : const Color(0xFFCEC8BE);
    final foregroundColor = isEnabled
        ? const Color(0xFF2E66F5)
        : const Color(0xFF9E978E);

    return Material(
      color: Colors.white,
      elevation: 1.5,
      shadowColor: const Color(0x22000000),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minWidth: 52, minHeight: 30),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          child: Text(
            isEnabled ? "ADD" : "OUT",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}

String _normalizeText(String? value) {
  if (value == null) {
    return "";
  }

  return value.replaceAll(RegExp(r"\s+"), " ").trim();
}

final RegExp _packInfoPattern = RegExp(
  r"(\d+(?:\.\d+)?\s?(?:kg|g|gm|mg|ml|l|ltr|litre|litres|pcs?|pc|pack|packs|dozen|unit|units))$",
  caseSensitive: false,
);

final RegExp _parenthesizedPackInfoPattern = RegExp(
  r"\((\d+(?:\.\d+)?\s?(?:kg|g|gm|mg|ml|l|ltr|litre|litres|pcs?|pc|pack|packs|dozen|unit|units))\)$",
  caseSensitive: false,
);
