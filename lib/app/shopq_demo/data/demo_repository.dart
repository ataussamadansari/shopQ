import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/banner_item.dart';
import '../models/category_item.dart';
import '../models/order_status_step.dart';
import '../models/product.dart';

class DemoRepository {
  DemoRepository._();

  static const List<String> searchFilters = <String>[
    'Under \$50',
    '4.0+ Rating',
    'Flash Sale',
    'In Stock',
  ];

  static const List<String> addresses = <String>[
    'Home - 221B Baker Street, London',
    'Office - 8th Ave, New York, NY',
    'Parents - 14 River Park, Austin, TX',
  ];

  static const List<CategoryItem> categories = <CategoryItem>[
    CategoryItem(id: 'grocery', title: 'Grocery', icon: CupertinoIcons.cart),
    CategoryItem(id: 'fashion', title: 'Fashion', icon: CupertinoIcons.bag),
    CategoryItem(id: 'electronics', title: 'Electronics', icon: CupertinoIcons.device_phone_portrait),
    CategoryItem(id: 'beauty', title: 'Beauty', icon: CupertinoIcons.heart_circle),
    CategoryItem(id: 'sports', title: 'Sports', icon: CupertinoIcons.sportscourt),
    CategoryItem(id: 'home', title: 'Home', icon: CupertinoIcons.house),
  ];

  static const List<BannerItem> banners = <BannerItem>[
    BannerItem(
      id: 'b1',
      title: 'Fresh Weekend Deals',
      subtitle: 'Save up to 40% on groceries',
      imageAsset: 'assets/images/img_2.png',
      accentColor: Color(0xFF15803D),
    ),
    BannerItem(
      id: 'b2',
      title: 'Tech Flash Sale',
      subtitle: 'Top gadgets from \$29 only',
      imageAsset: 'assets/images/img_6.png',
      accentColor: Color(0xFF1D4ED8),
    ),
    BannerItem(
      id: 'b3',
      title: 'Style Your Day',
      subtitle: 'New arrivals for every occasion',
      imageAsset: 'assets/images/img_10.png',
      accentColor: Color(0xFF0F172A),
    ),
  ];

  static const List<Product> products = <Product>[
    Product(
      id: 'p1',
      name: 'Organic Apple Box',
      description: 'Fresh organic apples sourced from local farms. Crisp, sweet, and perfect for daily snacking.',
      imageAssets: <String>[
        'assets/images/img_1.png',
        'assets/images/img_2.png',
        'assets/images/img_3.png',
      ],
      price: 24.99,
      originalPrice: 34.99,
      rating: 4.5,
      reviewCount: 128,
      categoryId: 'grocery',
      isFeatured: true,
      isFlashSale: true,
      inStock: true,
    ),
    Product(
      id: 'p2',
      name: 'Wireless Earbuds Pro',
      description: 'Compact wireless earbuds with crisp sound, deep bass, and up to 24 hours total battery backup.',
      imageAssets: <String>[
        'assets/images/img_4.png',
        'assets/images/img_5.png',
        'assets/images/img_6.png',
      ],
      price: 49.99,
      originalPrice: 79.99,
      rating: 4.4,
      reviewCount: 302,
      categoryId: 'electronics',
      isFeatured: true,
      isFlashSale: true,
      inStock: true,
    ),
    Product(
      id: 'p3',
      name: 'Comfort Yoga Mat',
      description: 'Non-slip high-density yoga mat suitable for home workouts, stretching, and daily meditation.',
      imageAssets: <String>[
        'assets/images/img_7.png',
        'assets/images/img_8.png',
        'assets/images/img_9.png',
      ],
      price: 31.50,
      originalPrice: 45.00,
      rating: 4.7,
      reviewCount: 87,
      categoryId: 'sports',
      isFeatured: true,
      isFlashSale: false,
      inStock: true,
    ),
    Product(
      id: 'p4',
      name: 'Classic Denim Jacket',
      description: 'Everyday denim jacket with modern fit and durable stitching. Lightweight and easy to layer.',
      imageAssets: <String>[
        'assets/images/img_10.png',
        'assets/images/img_11.png',
        'assets/images/img_12.png',
      ],
      price: 59.00,
      originalPrice: 89.00,
      rating: 4.2,
      reviewCount: 63,
      categoryId: 'fashion',
      isFeatured: false,
      isFlashSale: true,
      inStock: true,
    ),
    Product(
      id: 'p5',
      name: 'Smart Watch Lite',
      description: 'Track your steps, sleep, and workouts with a bright display and all-day battery performance.',
      imageAssets: <String>[
        'assets/images/img_3.png',
        'assets/images/img_4.png',
        'assets/images/img_5.png',
      ],
      price: 74.99,
      originalPrice: 99.99,
      rating: 4.1,
      reviewCount: 190,
      categoryId: 'electronics',
      isFeatured: true,
      isFlashSale: false,
      inStock: true,
    ),
    Product(
      id: 'p6',
      name: 'Roasted Coffee Beans',
      description: 'Medium roast arabica blend with balanced aroma and rich flavor for espresso and filter brews.',
      imageAssets: <String>[
        'assets/images/img_6.png',
        'assets/images/img_7.png',
        'assets/images/img_8.png',
      ],
      price: 19.95,
      originalPrice: 27.50,
      rating: 4.8,
      reviewCount: 241,
      categoryId: 'grocery',
      isFeatured: false,
      isFlashSale: true,
      inStock: true,
    ),
    Product(
      id: 'p7',
      name: 'City Travel Backpack',
      description: 'Water-resistant backpack with laptop sleeve, ergonomic straps, and multiple quick-access pockets.',
      imageAssets: <String>[
        'assets/images/img_9.png',
        'assets/images/img_10.png',
        'assets/images/img_11.png',
      ],
      price: 46.80,
      originalPrice: 64.00,
      rating: 4.3,
      reviewCount: 115,
      categoryId: 'fashion',
      isFeatured: true,
      isFlashSale: false,
      inStock: true,
    ),
    Product(
      id: 'p8',
      name: 'Glow Skin Care Kit',
      description: 'Daily skin care kit with cleanser, serum, and moisturizer formulated for smooth and hydrated skin.',
      imageAssets: <String>[
        'assets/images/img_12.png',
        'assets/images/img_1.png',
        'assets/images/img_2.png',
      ],
      price: 39.99,
      originalPrice: 59.99,
      rating: 4.6,
      reviewCount: 176,
      categoryId: 'beauty',
      isFeatured: false,
      isFlashSale: true,
      inStock: false,
    ),
    Product(
      id: 'p9',
      name: 'Runner Pro Sneakers',
      description: 'Lightweight running sneakers with breathable mesh and responsive sole for long walks and runs.',
      imageAssets: <String>[
        'assets/images/img_5.png',
        'assets/images/img_6.png',
        'assets/images/img_7.png',
      ],
      price: 84.99,
      originalPrice: 119.00,
      rating: 4.4,
      reviewCount: 98,
      categoryId: 'fashion',
      isFeatured: false,
      isFlashSale: false,
      inStock: true,
    ),
    Product(
      id: 'p10',
      name: 'Kitchen Blender Plus',
      description: 'High-speed blender for shakes, smoothies, and sauces. Includes multi-speed controls and pulse mode.',
      imageAssets: <String>[
        'assets/images/img_8.png',
        'assets/images/img_9.png',
        'assets/images/img_10.png',
      ],
      price: 67.25,
      originalPrice: 89.99,
      rating: 4.0,
      reviewCount: 54,
      categoryId: 'home',
      isFeatured: true,
      isFlashSale: false,
      inStock: true,
    ),
  ];

  static const Map<String, List<String>> reviews = <String, List<String>>{
    'p1': <String>[
      'Fresh quality and neatly packed.',
      'Great taste. Good value for a weekly grocery order.',
    ],
    'p2': <String>[
      'Bass is surprisingly good for this size.',
      'Fast pairing and battery backup is reliable.',
      'Very lightweight and comfortable.',
    ],
    'p6': <String>[
      'The aroma is amazing and roast level is consistent.',
      'Perfect for my morning espresso routine.',
    ],
  };

  static const List<OrderStatusStep> orderTimeline = <OrderStatusStep>[
    OrderStatusStep(
      title: 'Order Confirmed',
      description: 'Your order has been received and is being prepared.',
      time: null,
      completed: true,
    ),
    OrderStatusStep(
      title: 'Packed',
      description: 'Items are packed and ready for dispatch.',
      time: null,
      completed: true,
    ),
    OrderStatusStep(
      title: 'Shipped',
      description: 'Shipment is on the way to your city hub.',
      time: null,
      completed: true,
    ),
    OrderStatusStep(
      title: 'Out for Delivery',
      description: 'Delivery partner is reaching your location.',
      time: null,
      completed: false,
    ),
    OrderStatusStep(
      title: 'Delivered',
      description: 'Package will be marked delivered when it reaches you.',
      time: null,
      completed: false,
    ),
  ];
}
