import 'package:flutter/material.dart';

import '../data/models/home/offer_payload.dart';

class OfferStripWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final OfferPayload? offer;

  const OfferStripWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.offer,
  });

  @override
  Widget build(BuildContext context) {
    if (offer == null) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    final themeColor = _hexToColor(offer?.themeColor);
    final baseColor = themeColor ?? const Color(0xFF0C831F);
    final cta = offer?.cta?.trim();

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              baseColor,
              Color.lerp(baseColor, Colors.white, 0.28) ?? baseColor,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: baseColor.withAlpha(45),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          height: 1.35,
                        ),
                      ),
                    ),
                  if (cta != null && cta.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: baseColor,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Text(
                          cta,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(28),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.local_offer_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      return null;
    }

    final buffer = StringBuffer();
    if (hex.length == 7 || hex.length == 6) {
      buffer.write("ff");
    }
    buffer.write(hex.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
