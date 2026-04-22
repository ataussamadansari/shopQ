import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String apiUrl = "$baseUrl/api/v1";
  static String imageBaseUrl = "$baseUrl/storage";

  // ------------------ AUTH Endpoints ------------------

  static const String sendOtp = "/auth/otp/send";
  static const String verifyOtp = "/auth/otp/verify";
  static const String me = "/auth/me";

  // ------------------ LOCATION Endpoints ------------------

  static const String validatePinCode = "/pincodes/validate";

  // ------------------ COMMON Endpoints ------------------
  static const String home = "/home";
  static const String categories = "/categories";
  static const String categorySlug = "/categories/{slug}";
  static const String products = "/products";
  static const String productSlug = "/products/{slug}";

  // ------------------ CUSTOMER Endpoints ------------------
  static const String cart = "/customer/cart";
  static const String cartItems = "/customer/cart/items";
  static const String cartItem = "/customer/cart/items/{item}";

  static const String wishlist = "/customer/wishlist";
  static const String wishlistToggle = "/customer/wishlist/toggle";

  static const String addresses = "/customer/addresses";
  static const String addressById = "/customer/addresses/{id}";
  static const String addressDefault = "/customer/addresses/{id}/default";

  static const String orders = "/customer/orders";
  static const String orderByNo = "/customer/orders/{orderNo}";

  static const String checkoutPlace = "/customer/checkout/place";

  static const String profile = "/me/profile";

  // ------------------ VENDOR Endpoints ------------------
  static const String vendorProducts = "/vendor/products";
  static const String vendorProductById = "/vendor/products/{id}";

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String acceptLanguage = 'Accept-Language';

  //Timeouts
  static const int connectTimerOutsMs = 30000;
  static const int receiveTimerOutsMs = 30000;
  static const int sendTimerOutsMs = 30000;
}
