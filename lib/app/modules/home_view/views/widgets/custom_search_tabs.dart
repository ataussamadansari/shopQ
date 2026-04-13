import 'package:flutter/material.dart';

import '../../../../data/models/home/tabs.dart';
import '../../../../global_widgets/sliver_appbar_delegate.dart';

class CustomSearchTabs extends StatelessWidget {
  final List<Tabs> tabs;

  const CustomSearchTabs({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final displayTabs = tabs.isNotEmpty ? tabs : _fallbackTabs();

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 125,
        maxHeight: 125,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSearchField(),
              const SizedBox(height: 12),
              _buildCategoryChips(displayTabs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Container(
        height: 46,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEDE7D3)),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Color(0xFF6F6B62)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Search 'milk', 'bread', 'snacks'",
                style: TextStyle(
                  color: Color(0xFF77736C),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.mic_none_rounded, color: Color(0xFF6F6B62)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips(List<Tabs> displayTabs) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: displayTabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = displayTabs[index];
          final color = _hexToColor(item.themeColor) ?? const Color(0xFF001B38);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIcon(item.icon),
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.label?.trim().isNotEmpty == true
                    ? item.label!.trim()
                    : "Category",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Tabs> _fallbackTabs() {
    return [
      Tabs(
        key: "groceries",
        label: "Groceries",
        icon: "grid",
        themeColor: "#0C831F",
      ),
      Tabs(key: "snacks", label: "Snacks", icon: "tag", themeColor: "#E15B64"),
      Tabs(
        key: "vegetables",
        label: "Veggies",
        icon: "leaf",
        themeColor: "#3E8F5D",
      ),
      Tabs(
        key: "cooking",
        label: "Cooking",
        icon: "rice",
        themeColor: "#F4A261",
      ),
    ];
  }
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

IconData _getIcon(String? iconName) {
  switch (iconName) {
    case "grid":
      return Icons.grid_view_rounded;
    case "tag":
      return Icons.local_offer_rounded;
    case "leaf":
      return Icons.eco_rounded;
    case "rice":
      return Icons.rice_bowl_rounded;
    default:
      return Icons.category_rounded;
  }
}
