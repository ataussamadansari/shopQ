// =============================================================================
//  MODELS  —  ShopQ  (Blinkit / Apna Mart style)
//  Every section type is derived from screenshot analysis.
//  Fully dynamic: the UI reads `sectionType` and renders accordingly.
// =============================================================================

// ─────────────────────────────────────────────────────────────────────────────
//  SectionType enum  — every distinct layout visible in the screenshots
// ─────────────────────────────────────────────────────────────────────────────

enum SectionType {
  /// Full-width auto-scrolling hero image carousel
  bannerSlider,

  /// 2-column promo chip row (e.g. BUY1GET1 | 50% OFF)
  offerCardRow,

  /// Horizontal scrollable pill chips  (icon + label)
  categoryChips,

  /// Horizontal scrollable product cards
  productCarousel,

  /// 2-col / 3-col product grid (used in Fresh tab)
  productGrid,

  /// Single full-width clickable banner
  singleBanner,

  /// Horizontal scrollable featured promo tiles (Factory Sale / Price Drop…)
  promoTileRow,

  /// 3-col or 4-col square category image grid
  categoryGrid,

  /// Coloured-bg brand block: banner image + product cards + "View All" footer
  brandSection,

  /// 4-col circular store-icon grid  (Shop By Store)
  storeGrid,

  /// 3-col ornate Ramadan / festival category grid
  iftaariGrid,

  /// Horizontal recipe cards with "VIEW RECIPE" CTA
  recipeCarousel,

  /// Full-width coloured delivery / coupon strip
  offerStrip,

  unknown,
}

extension SectionTypeX on String {
  SectionType toSectionType() {
    const map = {
      'banner_slider'    : SectionType.bannerSlider,
      'offer_card_row'   : SectionType.offerCardRow,
      'category_chips'   : SectionType.categoryChips,
      'product_carousel' : SectionType.productCarousel,
      'product_grid'     : SectionType.productGrid,
      'single_banner'    : SectionType.singleBanner,
      'promo_tile_row'   : SectionType.promoTileRow,
      'category_grid'    : SectionType.categoryGrid,
      'brand_section'    : SectionType.brandSection,
      'store_grid'       : SectionType.storeGrid,
      'iftaari_grid'     : SectionType.iftaariGrid,
      'recipe_carousel'  : SectionType.recipeCarousel,
      'offer_strip'      : SectionType.offerStrip,
    };
    return map[this] ?? SectionType.unknown;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Root
// ─────────────────────────────────────────────────────────────────────────────

class HomeModel {
  final bool success;
  final String message;
  final HomeData data;

  const HomeModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> j) => HomeModel(
    success: j['success'] ?? false,
    message: j['message'] ?? '',
    data: HomeData.fromJson(j['data'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class HomeData {
  final List<TabItem> tabs;
  final List<SectionModel> sections;

  const HomeData({required this.tabs, required this.sections});

  factory HomeData.fromJson(Map<String, dynamic> j) => HomeData(
    tabs: (j['tabs'] as List).map((e) => TabItem.fromJson(e)).toList(),
    sections:
    (j['sections'] as List).map((e) => SectionModel.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'tabs': tabs.map((e) => e.toJson()).toList(),
    'sections': sections.map((e) => e.toJson()).toList(),
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  TabItem
// ─────────────────────────────────────────────────────────────────────────────

class TabItem {
  final String key;
  final String label;

  /// Icon name (maps to an IconData in the UI layer)
  final String icon;

  /// Hex colour used for active indicator + themed backgrounds
  final String themeColor;

  const TabItem({
    required this.key,
    required this.label,
    required this.icon,
    required this.themeColor,
  });

  factory TabItem.fromJson(Map<String, dynamic> j) => TabItem(
    key: j['key'],
    label: j['label'],
    icon: j['icon'],
    themeColor: j['theme_color'],
  );

  Map<String, dynamic> toJson() => {
    'key': key,
    'label': label,
    'icon': icon,
    'theme_color': themeColor,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  SectionModel  — polymorphic wrapper
// ─────────────────────────────────────────────────────────────────────────────

class SectionModel {
  final String id;
  final SectionType sectionType;
  final String? title;
  final String? subtitle;
  final String? viewAllRoute;

  // ── typed payload (exactly one will be non-null) ──────────────────────────
  final List<BannerItem>? banners;           // banner_slider
  final List<OfferCard>? offerCards;         // offer_card_row
  final List<CategoryChip>? chips;           // category_chips
  final List<ProductItem>? products;         // product_carousel / product_grid
  final List<PromoTile>? promoTiles;         // promo_tile_row
  final List<CategoryGridItem>? gridItems;   // category_grid
  final BrandSectionData? brandSection;      // brand_section
  final List<StoreItem>? stores;             // store_grid
  final List<IftaariItem>? iftaariItems;     // iftaari_grid
  final List<RecipeItem>? recipes;           // recipe_carousel
  final BannerItem? singleBanner;            // single_banner
  final OfferStripData? offerStrip;          // offer_strip

  const SectionModel({
    required this.id,
    required this.sectionType,
    this.title,
    this.subtitle,
    this.viewAllRoute,
    this.banners,
    this.offerCards,
    this.chips,
    this.products,
    this.promoTiles,
    this.gridItems,
    this.brandSection,
    this.stores,
    this.iftaariItems,
    this.recipes,
    this.singleBanner,
    this.offerStrip,
  });

  factory SectionModel.fromJson(Map<String, dynamic> j) {
    final st = (j['type'] as String).toSectionType();
    final p = j['payload'];

    return SectionModel(
      id: j['id'],
      sectionType: st,
      title: j['title'],
      subtitle: j['subtitle'],
      viewAllRoute: j['view_all_route'],
      banners:      st == SectionType.bannerSlider   && p is List ? _banners(p)   : null,
      offerCards:   st == SectionType.offerCardRow   && p is List ? _offerCards(p): null,
      chips:        st == SectionType.categoryChips  && p is List ? _chips(p)     : null,
      products:     (st == SectionType.productCarousel || st == SectionType.productGrid) && p is List
          ? _products(p) : null,
      promoTiles:   st == SectionType.promoTileRow   && p is List ? _promos(p)    : null,
      gridItems:    st == SectionType.categoryGrid   && p is List ? _gridItems(p) : null,
      brandSection: st == SectionType.brandSection   && p is Map  ? BrandSectionData.fromJson(p as Map<String,dynamic>) : null,
      stores:       st == SectionType.storeGrid      && p is List ? _stores(p)    : null,
      iftaariItems: st == SectionType.iftaariGrid    && p is List ? _iftaari(p)   : null,
      recipes:      st == SectionType.recipeCarousel && p is List ? _recipes(p)   : null,
      singleBanner: st == SectionType.singleBanner   && p is Map  ? BannerItem.fromJson(p as Map<String,dynamic>) : null,
      offerStrip:   st == SectionType.offerStrip     && p is Map  ? OfferStripData.fromJson(p as Map<String,dynamic>) : null,
    );
  }

  static List<BannerItem>       _banners(List l)    => l.map((e) => BannerItem.fromJson(e)).toList();
  static List<OfferCard>        _offerCards(List l) => l.map((e) => OfferCard.fromJson(e)).toList();
  static List<CategoryChip>     _chips(List l)      => l.map((e) => CategoryChip.fromJson(e)).toList();
  static List<ProductItem>      _products(List l)   => l.map((e) => ProductItem.fromJson(e)).toList();
  static List<PromoTile>        _promos(List l)      => l.map((e) => PromoTile.fromJson(e)).toList();
  static List<CategoryGridItem> _gridItems(List l)  => l.map((e) => CategoryGridItem.fromJson(e)).toList();
  static List<StoreItem>        _stores(List l)      => l.map((e) => StoreItem.fromJson(e)).toList();
  static List<IftaariItem>      _iftaari(List l)     => l.map((e) => IftaariItem.fromJson(e)).toList();
  static List<RecipeItem>       _recipes(List l)     => l.map((e) => RecipeItem.fromJson(e)).toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': sectionType.name,
    'title': title,
    'subtitle': subtitle,
    'view_all_route': viewAllRoute,
    'payload': _payload(),
  };

  dynamic _payload() {
    if (banners != null)      return banners!.map((e) => e.toJson()).toList();
    if (offerCards != null)   return offerCards!.map((e) => e.toJson()).toList();
    if (chips != null)        return chips!.map((e) => e.toJson()).toList();
    if (products != null)     return products!.map((e) => e.toJson()).toList();
    if (promoTiles != null)   return promoTiles!.map((e) => e.toJson()).toList();
    if (gridItems != null)    return gridItems!.map((e) => e.toJson()).toList();
    if (brandSection != null) return brandSection!.toJson();
    if (stores != null)       return stores!.map((e) => e.toJson()).toList();
    if (iftaariItems != null) return iftaariItems!.map((e) => e.toJson()).toList();
    if (recipes != null)      return recipes!.map((e) => e.toJson()).toList();
    if (singleBanner != null) return singleBanner!.toJson();
    if (offerStrip != null)   return offerStrip!.toJson();
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BannerItem  (hero slider + single_banner)
// ─────────────────────────────────────────────────────────────────────────────

class BannerItem {
  final int id;
  final String title;
  final String? subtitle;
  final String imageUrl;

  /// Background gradient/color behind the image
  final String bgColor;
  final String? route;

  const BannerItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    required this.bgColor,
    this.route,
  });

  factory BannerItem.fromJson(Map<String, dynamic> j) => BannerItem(
    id: j['id'],
    title: j['title'],
    subtitle: j['subtitle'],
    imageUrl: j['image_url'],
    bgColor: j['bg_color'] ?? '#FFFFFF',
    route: j['route'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'image_url': imageUrl,
    'bg_color': bgColor,
    'route': route,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  OfferCard  (2-col promo chip: BUY1GET1, 50%OFF…)
// ─────────────────────────────────────────────────────────────────────────────

class OfferCard {
  final String id;
  final String label;

  /// e.g. "BUY 1\nGET 1", "50%\nOFF"
  final String displayText;
  final String imageUrl;
  final String bgColor;
  final String route;

  const OfferCard({
    required this.id,
    required this.label,
    required this.displayText,
    required this.imageUrl,
    required this.bgColor,
    required this.route,
  });

  factory OfferCard.fromJson(Map<String, dynamic> j) => OfferCard(
    id: j['id'],
    label: j['label'],
    displayText: j['display_text'],
    imageUrl: j['image_url'],
    bgColor: j['bg_color'],
    route: j['route'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'display_text': displayText,
    'image_url': imageUrl,
    'bg_color': bgColor,
    'route': route,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  CategoryChip  (horizontal pill with icon image)
// ─────────────────────────────────────────────────────────────────────────────

class CategoryChip {
  final int id;
  final String name;
  final String slug;
  final String imageUrl;
  final String route;

  const CategoryChip({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.route,
  });

  factory CategoryChip.fromJson(Map<String, dynamic> j) => CategoryChip(
    id: j['id'],
    name: j['name'],
    slug: j['slug'],
    imageUrl: j['image_url'],
    route: j['route'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'image_url': imageUrl,
    'route': route,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  ProductItem
// ─────────────────────────────────────────────────────────────────────────────

/// Badge shown on top-left of a product card
enum ProductBadgeType { percentOff, flatOff, highInProtein, qualityChecked, none }

extension ProductBadgeTypeX on String {
  ProductBadgeType toBadgeType() {
    switch (this) {
      case 'percent_off'     : return ProductBadgeType.percentOff;
      case 'flat_off'        : return ProductBadgeType.flatOff;
      case 'high_in_protein' : return ProductBadgeType.highInProtein;
      case 'quality_checked' : return ProductBadgeType.qualityChecked;
      default                : return ProductBadgeType.none;
    }
  }
}

class ProductBadge {
  final ProductBadgeType type;
  final String label; // e.g. "50% OFF", "₹3 OFF", "High in Protein"

  const ProductBadge({required this.type, required this.label});

  factory ProductBadge.fromJson(Map<String, dynamic> j) => ProductBadge(
    type: (j['type'] as String).toBadgeType(),
    label: j['label'],
  );

  Map<String, dynamic> toJson() => {'type': type.name, 'label': label};
}

/// The purple "locked" offer price badge (member / app-exclusive price)
class LockedOffer {
  final int offerPrice;
  final String label; // e.g. "OFFER", "OFFER PRICE"

  const LockedOffer({required this.offerPrice, required this.label});

  factory LockedOffer.fromJson(Map<String, dynamic> j) =>
      LockedOffer(offerPrice: j['offer_price'], label: j['label']);

  Map<String, dynamic> toJson() =>
      {'offer_price': offerPrice, 'label': label};
}

class ProductItem {
  final int id;
  final String title;
  final String slug;
  final String imageUrl;
  final int price;
  final int mrp;
  final String quantity; // "500 ml", "1 kg", "3 Pieces" …
  final String? brand;
  final bool inStock;
  final ProductBadge? badge;

  /// Purple locked-price badge (null = not applicable)
  final LockedOffer? lockedOffer;

  /// true → show "BUY 1 GET 1 FREE" ribbon
  final bool isBuy1Get1;

  /// "Quality Checked" golden side-ribbon (fresh produce)
  final bool hasQualityRibbon;

  final String route;

  const ProductItem({
    required this.id,
    required this.title,
    required this.slug,
    required this.imageUrl,
    required this.price,
    required this.mrp,
    required this.quantity,
    this.brand,
    this.inStock = true,
    this.badge,
    this.lockedOffer,
    this.isBuy1Get1 = false,
    this.hasQualityRibbon = false,
    required this.route,
  });

  factory ProductItem.fromJson(Map<String, dynamic> j) => ProductItem(
    id: j['id'],
    title: j['title'],
    slug: j['slug'],
    imageUrl: j['image_url'],
    price: j['price'],
    mrp: j['mrp'],
    quantity: j['quantity'],
    brand: j['brand'],
    inStock: j['in_stock'] ?? true,
    badge: j['badge'] != null ? ProductBadge.fromJson(j['badge']) : null,
    lockedOffer: j['locked_offer'] != null
        ? LockedOffer.fromJson(j['locked_offer'])
        : null,
    isBuy1Get1: j['is_buy1get1'] ?? false,
    hasQualityRibbon: j['has_quality_ribbon'] ?? false,
    route: j['route'] ?? '/product/${j['slug']}',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'image_url': imageUrl,
    'price': price,
    'mrp': mrp,
    'quantity': quantity,
    'brand': brand,
    'in_stock': inStock,
    'badge': badge?.toJson(),
    'badge2': badge?.toJson(),
    'locked_offer': lockedOffer?.toJson(),
    'is_buy1get1': isBuy1Get1,
    'has_quality_ribbon': hasQualityRibbon,
    'route': route,
  };

  int get discountPercent =>
      mrp > 0 ? (((mrp - price) / mrp) * 100).round() : 0;

  bool get hasDiscount => price < mrp;
}

// ─────────────────────────────────────────────────────────────────────────────
//  PromoTile  (Featured this Week row)
// ─────────────────────────────────────────────────────────────────────────────

class PromoTile {
  final String id;
  final String title;   // "Factory Sale"
  final String tag;     // "Upto 70% OFF"
  final String imageUrl;
  final String bgColor;
  final String route;

  const PromoTile({
    required this.id,
    required this.title,
    required this.tag,
    required this.imageUrl,
    required this.bgColor,
    required this.route,
  });

  factory PromoTile.fromJson(Map<String, dynamic> j) => PromoTile(
    id: j['id'],
    title: j['title'],
    tag: j['tag'],
    imageUrl: j['image_url'],
    bgColor: j['bg_color'],
    route: j['route'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tag': tag,
    'image_url': imageUrl,
    'bg_color': bgColor,
    'route': route,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  CategoryGridItem  (square image grid: Fruits, Vegetables, Onion & Potato…)
// ─────────────────────────────────────────────────────────────────────────────

class CategoryGridItem {
  final int id;
  final String name;
  final String slug;
  final String imageUrl;
  final String bgColor;
  final String route;

  /// Optional sub-items (e.g. Dairy & Breakfast → Milk & Fresh / Bread & Buns…)
  final List<CategoryGridItem>? children;

  const CategoryGridItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.bgColor,
    required this.route,
    this.children,
  });

  factory CategoryGridItem.fromJson(Map<String, dynamic> j) => CategoryGridItem(
    id: j['id'],
    name: j['name'],
    slug: j['slug'],
    imageUrl: j['image_url'],
    bgColor: j['bg_color'] ?? '#F3F4F6',
    route: j['route'],
    children: (j['children'] as List?)
        ?.map((e) => CategoryGridItem.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'image_url': imageUrl,
    'bg_color': bgColor,
    'route': route,
    'children': children?.map((e) => e.toJson()).toList(),
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  BrandSectionData  (coloured bg + product cards + "View All" footer)
// ─────────────────────────────────────────────────────────────────────────────

class BrandSectionData {
  final String brandId;
  final String brandName;

  /// Full-width banner image inside the coloured block
  final String bannerImageUrl;
  final String bannerTitle;

  /// Background color of the whole block
  final String bgColor;
  final List<ProductItem> products;
  final String viewAllRoute;

  const BrandSectionData({
    required this.brandId,
    required this.brandName,
    required this.bannerImageUrl,
    required this.bannerTitle,
    required this.bgColor,
    required this.products,
    required this.viewAllRoute,
  });

  factory BrandSectionData.fromJson(Map<String, dynamic> j) => BrandSectionData(
    brandId: j['brand_id'],
    brandName: j['brand_name'],
    bannerImageUrl: j['banner_image_url'],
    bannerTitle: j['banner_title'],
    bgColor: j['bg_color'],
    products: (j['products'] as List)
        .map((e) => ProductItem.fromJson(e))
        .toList(),
    viewAllRoute: j['view_all_route'],
  );

  Map<String, dynamic> toJson() => {
    'brand_id': brandId,
    'brand_name': brandName,
    'banner_image_url': bannerImageUrl,
    'banner_title': bannerTitle,
    'bg_color': bgColor,
    'products': products.map((e) => e.toJson()).toList(),
    'view_all_route': viewAllRoute,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  StoreItem  (circular dome-style store icon)
// ─────────────────────────────────────────────────────────────────────────────

class StoreItem {
  final String id;
  final String name;
  final String imageUrl;
  final String bgColor;
  final String route;

  const StoreItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.bgColor,
    required this.route,
  });

  factory StoreItem.fromJson(Map<String, dynamic> j) => StoreItem(
    id: j['id'],
    name: j['name'],
    imageUrl: j['image_url'],
    bgColor: j['bg_color'],
    route: j['route'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image_url': imageUrl,
    'bg_color': bgColor,
    'route': route,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  IftaariItem  (Ramadan 3-col ornate grid)
// ─────────────────────────────────────────────────────────────────────────────

class IftaariItem {
  final String id;
  final String name;
  final String imageUrl;
  final String route;

  const IftaariItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.route,
  });

  factory IftaariItem.fromJson(Map<String, dynamic> j) => IftaariItem(
    id: j['id'],
    name: j['name'],
    imageUrl: j['image_url'],
    route: j['route'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image_url': imageUrl,
    'route': route,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  RecipeItem
// ─────────────────────────────────────────────────────────────────────────────

class RecipeItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String bgColor;
  final String route;

  const RecipeItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.bgColor,
    required this.route,
  });

  factory RecipeItem.fromJson(Map<String, dynamic> j) => RecipeItem(
    id: j['id'],
    title: j['title'],
    subtitle: j['subtitle'],
    imageUrl: j['image_url'],
    bgColor: j['bg_color'],
    route: j['route'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'image_url': imageUrl,
    'bg_color': bgColor,
    'route': route,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  OfferStripData  (full-width delivery / coupon strip)
// ─────────────────────────────────────────────────────────────────────────────

class OfferStripData {
  final String title;    // "Free delivery over ₹499"
  final String subtitle; // "No coupon needed"
  final String ctaLabel; // "Shop now"
  final String bgColor;
  final String route;

  const OfferStripData({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.bgColor,
    required this.route,
  });

  factory OfferStripData.fromJson(Map<String, dynamic> j) => OfferStripData(
    title: j['title'],
    subtitle: j['subtitle'],
    ctaLabel: j['cta_label'],
    bgColor: j['bg_color'],
    route: j['route'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'cta_label': ctaLabel,
    'bg_color': bgColor,
    'route': route,
  };
}