import 'package:get/get.dart';
import 'package:shopq/app/modules/auth_view/bindings/auth_binding.dart';
import 'package:shopq/app/modules/auth_view/views/auth_screen.dart';
import 'package:shopq/app/modules/home_view/bindings/home_binding.dart';
import 'package:shopq/app/modules/home_view/views/home_screen.dart';
import 'package:shopq/app/modules/location_view/bindings/location_binding.dart';
import 'package:shopq/app/modules/location_view/views/location_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.auth,
      page: () => AuthScreen(),
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
    ),
  ];
}
