import '../../data/models/home/home_model.dart';

class DummyData {
  static HomeModel home() {
    return HomeModel.fromJson({
      "success": true,
      "message": "Home",
      "data": {
        "tabs": [
          {"key": "all", "label": "All", "icon": "grid", "themeColor": "#3B82F6"},
          {"key": "ramadan", "label": "Ramadan", "icon": "moon", "themeColor": "#059669"},
          {"key": "deals", "label": "Deals", "icon": "tag", "themeColor": "#F59E0B"},
          {"key": "fresh", "label": "Fresh", "icon": "apple", "themeColor": "#16A34A"},
          {"key": "kirana", "label": "Kirana", "icon": "bag", "themeColor": "#9333EA"},
          {"key": "body", "label": "Body Care", "icon": "sparkles", "themeColor": "#EC4899"},
          {"key": "categories", "label": "Categories", "icon": "grid", "themeColor": "#2563EB"}
        ],

        "sections": [

          /// BANNER
          {
            "id": "hero",
            "type": "banner_slider",
            "title": "Top Picks",
            "payload": [
              {
                "id": 1,
                "title": "Factory Sale",
                "image_url":
                "https://images.unsplash.com/photo-1607082349566-187342175e2f"
              },
              {
                "id": 2,
                "title": "Price Drop",
                "image_url":
                "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da"
              }
            ]
          },

          /// PRODUCT CAROUSEL
          {
            "id": "cold_drinks",
            "type": "product_carousel",
            "title": "Cold Drinks",
            "payload": List.generate(8, (i) {
              return {
                "id": i,
                "title": "Mango Juice ${i + 1}",
                "slug": "mango-${i + 1}",
                "price": 42,
                "mrp": 85,
                "discount_percent": 50,
                "stock": 50,
                "in_stock": true,
                "image":
                "https://images.unsplash.com/photo-1622597467836-f3285f2131b7",
                "seller_name": "Demo Store"
              };
            })
          },

          /// CATEGORY GRID
          {
            "id": "fruits_categories",
            "type": "category_grid",
            "title": "Fruits & Vegetables",
            "payload": [
              {
                "id": 1,
                "name": "Fruits",
                "slug": "fruits",
                "featured_image":
                "https://images.unsplash.com/photo-1619566636858-adf3ef46400b"
              },
              {
                "id": 2,
                "name": "Vegetables",
                "slug": "vegetables",
                "featured_image":
                "https://images.unsplash.com/photo-1540420773420-3366772f4999"
              },
              {
                "id": 3,
                "name": "Onion & Potato",
                "slug": "onion",
                "featured_image":
                "https://images.unsplash.com/photo-1582515073490-dc66e1f4a0f9"
              }
            ]
          },

          /// OFFER STRIP
          {
            "id": "free_delivery",
            "type": "offer_strip",
            "title": "Free delivery over ₹499",
            "subtitle": "No coupon needed",
            "payload": {"cta": "Shop Now", "themeColor": "#FACC15"}
          }
        ]
      }
    });
  }
}