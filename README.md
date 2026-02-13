# ShopQ Flutter Demo (Connected to Laravel Backend)

ShopQ is a Flutter mobile e-commerce demo app with full UI flows connected to a Laravel API backend (`backend/`). The app still keeps local fallback data so UI can render even if backend is temporarily unreachable.

## What is included

- Material 3 theme with Cupertino-style icons and hybrid components
- Smooth page transitions and Hero animation for product images
- Backend integration using `Dio` + Provider (`ChangeNotifier`)
- Auth, catalog, cart, checkout, and order tracking wired to API

## Screens implemented

- Splash
- Onboarding
- Login / Sign Up (Email + Phone OTP UI)
- Home (banner carousel, categories, featured, flash sale)
- Search (input + filter bottom sheet)
- Profile (account, orders, settings tiles)
- Product Details (carousel, rating, reviews, add/buy actions)
- Cart (empty state + quantity update + summary)
- Checkout (address + payment UI)
- Order Confirmation
- Order Tracking timeline (Confirmed, Packed, Shipped, Delivered)
- Bottom navigation shell (Home, Search, Cart, Profile)

## Folder guide

```text
lib/
  main.dart
  app/
    shopq_demo/
      shopq_app.dart
      core/
        theme/
          app_theme.dart
      data/
        api/
          shopq_api_client.dart
        demo_repository.dart
      models/
        address_item.dart
        banner_item.dart
        cart_item.dart
        category_item.dart
        order_status_step.dart
        product.dart
        user_profile.dart
      routes/
        app_router.dart
        route_names.dart
      screens/
        auth_screen.dart
        cart_screen.dart
        checkout_screen.dart
        home_screen.dart
        main_navigation_screen.dart
        onboarding_screen.dart
        order_confirmation_screen.dart
        order_tracking_screen.dart
        profile_screen.dart
        product_details_screen.dart
        search_screen.dart
        splash_screen.dart
      state/
        demo_store.dart
      widgets/
        category_card.dart
        custom_app_bar.dart
        loading_shimmer.dart
        micro_action_button.dart
        product_card.dart
        quantity_selector.dart
        rating_stars.dart
```

## Run the app

1. Start backend from `backend/`:
   - `composer install`
   - `php artisan migrate:fresh --seed`
   - `php artisan serve`
2. In project root:
   - `flutter pub get`
   - `flutter run`

Optional custom API URL:

- `flutter run --dart-define=SHOPQ_API_BASE_URL=http://192.168.1.6:8000/api/v1`
- Current default (if not passed): `http://192.168.1.6:8000/api/v1`

## Demo test flow (for manual QA or video recording)

Use this exact sequence for a clean end-to-end demo video:

1. Launch app and wait for Splash -> Onboarding.
2. Tap `Next` through onboarding, then `Get Started`.
3. On Auth screen, switch between `Email` and `Phone OTP`, tap `Send OTP`, then login.
4. On Home, swipe banners, open Search, apply filters, and open a product.
5. On Product Details, test image carousel and Hero animation, tap `Add to Cart`, then `Buy Now`.
6. In Cart, increase/decrease quantity and verify summary updates.
7. In Checkout, change address and payment option, then `Place Order`.
8. On Order Confirmation, open `Track Order` and verify status timeline.
9. Return to Home using `Back to Home`.

## Backend connection status

The app now calls these backend endpoints:

- `POST /api/v1/auth/login`, `POST /api/v1/auth/register`, `POST /api/v1/auth/request-otp`, `POST /api/v1/auth/verify-otp`
- `GET /api/v1/categories`, `GET /api/v1/banners`, `GET /api/v1/products`
- `GET /api/v1/cart`, `POST /api/v1/cart/items`, `PATCH /api/v1/cart/items/{id}`, `DELETE /api/v1/cart/items/{id}`
- `GET /api/v1/addresses`, `POST /api/v1/checkout`
- `GET /api/v1/orders`, `GET /api/v1/orders/{id}/tracking`

## Future enhancements

1. Create a network data source
- Add `api_client.dart` (Dio/Http) with typed request methods.
- Keep `demo_repository.dart` as fallback for offline/dev mode.

2. Add DTO + mapper layer
- Define API response DTOs (e.g. `product_dto.dart`).
- Map DTOs -> domain models (`Product`, `CategoryItem`, `CartItem`).

3. Introduce repository abstraction
- Create `abstract class ShopRepository` with methods like:
  - `Future<List<Product>> fetchProducts()`
  - `Future<List<BannerItem>> fetchBanners()`
  - `Future<void> placeOrder(...)`
- Implement `MockShopRepository` (current) and `ApiShopRepository`.

4. Update Provider store (`demo_store.dart`)
- Inject `ShopRepository` into store constructor.
- Convert static reads to async loaders with loading/error states.
- Preserve current UI contracts so screens require minimal changes.

5. Authentication + token handling
- Replace Auth UI-only actions with API calls.
- Add secure token storage and attach token via request interceptor.

6. Error handling and retries
- Add centralized error mapper (timeout, 401, 500, no internet).
- Show dedicated retry UI in Home/Search/Checkout when API fails.

7. Gradual rollout
- Use feature flag/env to switch between mock and API repos.
- Validate parity screen-by-screen before removing mock fallback.

## Notes

- Fallback UI data still exists in `demo_repository.dart` for resilience.
- Current token is in-memory; add secure persistent storage for production sessions.
