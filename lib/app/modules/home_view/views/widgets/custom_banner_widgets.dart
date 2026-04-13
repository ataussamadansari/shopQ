import 'package:flutter/material.dart';

import '../../../../data/models/home/section_item.dart';
import '../../../../global_widgets/app_network_image.dart';

class CustomBannerWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<SectionItem> banners;

  const CustomBannerWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.banners,
  });

  @override
  State<CustomBannerWidget> createState() => _CustomBannerWidgetState();
}

class _CustomBannerWidgetState extends State<CustomBannerWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (widget.title.trim().isNotEmpty || widget.subtitle != null)
          //   SectionTitle(
          //     title: widget.title.trim().isNotEmpty
          //         ? widget.title
          //         : "Special offers",
          //     subtitle: widget.subtitle,
          //   ),
          SizedBox(
            height: 192,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final banner = widget.banners[index];

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    index == 0 ? 16 : 8,
                    0,
                    index == widget.banners.length - 1 ? 16 : 8,
                    0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppNetworkImage(
                          imageUrl: banner.imageUrl,
                          fit: BoxFit.cover,
                          fallbackAsset: "assets/images/img_4.png",
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withAlpha(120),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        /*Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                banner.title?.trim().isNotEmpty == true
                                    ? banner.title!.trim()
                                    : "Everyday essentials",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  height: 1.05,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  "Explore now",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1D1D1B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: _currentIndex == index ? 20 : 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? const Color(0xFF0C831F)
                      : const Color(0xFFD4D0C6),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
