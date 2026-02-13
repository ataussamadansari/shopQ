# ShopQ - Grocery Delivery App

A complete Flutter grocery delivery app that replicates the design and functionality shown in the provided screenshots.

## Features

### 🏠 Home Screen
- **Multi-tab Navigation**: All, Rice, Kirana, Fresh, Body Care, Categories
- **Dynamic Banners**: Category-specific promotional banners with custom designs
- **Search Functionality**: Search bar with voice input support
- **Delivery Information**: Shows delivery time and location
- **Cart Badge**: Real-time cart item count display

### 🛒 Shopping Experience
- **Product Grid**: Beautiful product cards with images, prices, and discounts
- **Featured Products**: Horizontal scrolling carousel for special items
- **Add to Cart**: One-tap add to cart functionality
- **Product Details**: Detailed product pages with size options and descriptions
- **Favorites**: Heart icon to mark favorite products

### 🛍️ Cart Management
- **Cart Page**: Complete cart management with quantity controls
- **Best Deals**: Special offers and promotions section
- **Order Summary**: Price calculation and delivery information
- **Minimum Order**: Order validation with minimum amount requirements

### 📱 Categories
- **Category Grid**: Organized product categories
- **Visual Categories**: Image-based category selection
- **Nested Categories**: Fruits & Vegetables, Dairy & Breakfast, Grocery sections

## Technical Implementation

### Architecture
- **State Management**: Provider pattern for cart and app state
- **Navigation**: Material Design navigation with tabs and routes
- **Responsive Design**: Adaptive layouts for different screen sizes

### Key Components
- `HomePage`: Main screen with tab navigation
- `ProductCard`: Reusable product display component
- `CartPage`: Shopping cart management
- `ProductDetailPage`: Individual product details
- `CategoriesPage`: Category browsing interface

### Data Structure
- **Products**: Complete product information with images, prices, categories
- **Categories**: Dynamic category system with custom banners
- **Cart**: Real-time cart management with quantity tracking

## Demo Data

The app includes comprehensive demo data:
- **Rice Products**: Basmati, Katarni, Usna, Miniket varieties
- **Fresh Products**: Fruits like guava, strawberry, oranges
- **Kirana Items**: Milk products from Amul brand
- **Body Care**: Soaps and personal care items

## Screenshots Match

The implementation closely matches all provided screenshots:
1. ✅ Home screen with blue theme and category tabs
2. ✅ Rice category with yellow promotional banner
3. ✅ Kirana category with delivery assurance
4. ✅ Fresh category with green theme and product grid
5. ✅ Body Care category with brand showcase
6. ✅ Categories page with organized sections
7. ✅ Product detail page with size options
8. ✅ Cart page with deals and order summary

## Getting Started

1. **Prerequisites**:
   - Flutter SDK installed
   - Android/iOS development environment set up

2. **Installation**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Dependencies

- `flutter`: Core Flutter framework
- `provider`: State management solution
- `cupertino_icons`: iOS-style icons

## Project Structure

```
lib/
├── main.dart              # Main app entry point with all components
├── models/
│   ├── cart_provider.dart # Cart state management
│   └── cart_item.dart     # Cart item model
├── screens/
│   ├── home_page.dart     # Main home screen
│   ├── cart_page.dart     # Shopping cart
│   ├── product_detail.dart # Product details
│   └── categories_page.dart # Category browser
└── widgets/
    ├── product_card.dart   # Product display card
    ├── featured_card.dart  # Featured product card
    └── tab_content.dart    # Tab content widget
```

## Features Implemented

- ✅ Complete UI matching provided screenshots
- ✅ Cart functionality with add/remove/update
- ✅ Product browsing and filtering by category
- ✅ Product detail pages with size selection
- ✅ Category-specific banners and themes
- ✅ Search functionality (UI ready)
- ✅ Delivery information display
- ✅ Promotional offers and deals
- ✅ Responsive design for mobile devices

## Future Enhancements

- Backend integration for real product data
- User authentication and profiles
- Payment gateway integration
- Order tracking and history
- Push notifications for offers
- Location-based delivery
- Product reviews and ratings

---

**Note**: This is a demo application with static data. All product images are sourced from Unsplash for demonstration purposes.