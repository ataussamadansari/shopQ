import 'package:get/get.dart';
import 'package:shopq/app/modules/auth_view/bindings/auth_binding.dart';
import 'package:shopq/app/modules/auth_view/views/auth_screen.dart';
import 'package:shopq/app/modules/cart_view/bindings/cart_binding.dart';
import 'package:shopq/app/modules/cart_view/views/cart_screen.dart';
import 'package:shopq/app/modules/category_view/bindings/category_binding.dart';
import 'package:shopq/app/modules/category_view/views/category_screen.dart';
import 'package:shopq/app/modules/checkout_view/bindings/checkout_binding.dart';
import 'package:shopq/app/modules/checkout_view/views/checkout_screen.dart';
import 'package:shopq/app/modules/home_view/bindings/home_binding.dart';
import 'package:shopq/app/modules/home_view/views/home_screen.dart';
import 'package:shopq/app/modules/location_view/bindings/location_binding.dart';
import 'package:shopq/app/modules/location_view/views/location_screen.dart';
import 'package:shopq/app/modules/orders_view/bindings/orders_binding.dart';
import 'package:shopq/app/modules/orders_view/views/orders_screen.dart';
import 'package:shopq/app/modules/product_detail_view/bindings/product_detail_binding.dart';
import 'package:shopq/app/modules/product_detail_view/views/product_detail_screen.dart';
import 'package:shopq/app/modules/product_list_view/bindings/product_list_binding.dart';
import 'package:shopq/app/modules/product_list_view/views/product_list_screen.dart';
import 'package:shopq/app/modules/profile_view/bindings/profile_binding.dart';
import 'package:shopq/app/modules/profile_view/views/profile_screen.dart';
import 'package:shopq/app/modules/splash_view/bindings/splash_binding.dart';
import 'package:shopq/app/modules/splash_view/views/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: Routes.auth,
      page: () => const AuthScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.location,
      page: () => LocationScreen(),
      binding: LocationBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.category,
      page: () => CategoryScreen(),
      binding: CategoryBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.productList,
      page: () => const ProductListScreen(),
      binding: ProductListBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.productDetail,
      page: () => const ProductDetailScreen(),
      binding: ProductDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.cart,
      page: () => const CartScreen(),
      binding: CartBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.checkout,
      page: () => const CheckoutScreen(),
      binding: CheckoutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.orders,
      page: () => const OrdersScreen(),
      binding: OrdersBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
