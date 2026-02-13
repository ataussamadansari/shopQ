import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/addresses_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/order_confirmation_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/order_tracking_screen.dart';
import '../screens/payment_methods_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/product_details_screen.dart';
import '../screens/search_screen.dart';
import '../screens/splash_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return _buildRoute(settings, const SplashScreen());
      case RouteNames.onboarding:
        return _buildRoute(settings, const OnboardingScreen());
      case RouteNames.auth:
        return _buildRoute(settings, const AuthScreen());
      case RouteNames.mainNavigation:
        final initialIndex = settings.arguments is int ? settings.arguments as int : 0;
        return _buildRoute(
          settings,
          MainNavigationScreen(initialIndex: initialIndex),
        );
      case RouteNames.home:
        return _buildRoute(settings, const HomeScreen());
      case RouteNames.search:
        return _buildRoute(settings, const SearchScreen());
      case RouteNames.profile:
        return _buildRoute(settings, const ProfileScreen());
      case RouteNames.addresses:
        return _buildRoute(settings, const AddressesScreen());
      case RouteNames.paymentMethods:
        return _buildRoute(settings, const PaymentMethodsScreen());
      case RouteNames.orders:
        return _buildRoute(settings, const OrdersScreen());
      case RouteNames.productDetails:
        final argument = settings.arguments;
        if (argument is Product) {
          return _buildRoute(settings, ProductDetailsScreen(product: argument));
        }
        return _errorRoute(settings, 'Missing product data.');
      case RouteNames.cart:
        return _buildRoute(settings, const CartScreen());
      case RouteNames.checkout:
        return _buildRoute(settings, const CheckoutScreen());
      case RouteNames.orderConfirmation:
        return _buildRoute(settings, const OrderConfirmationScreen());
      case RouteNames.orderTracking:
        final argument = settings.arguments;
        final orderId = argument is int ? argument : null;
        return _buildRoute(settings, OrderTrackingScreen(orderId: orderId));
      default:
        return _errorRoute(settings, 'Route ${settings.name} is not configured.');
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings, String message) {
    return _buildRoute(
      settings,
      Scaffold(
        appBar: AppBar(title: const Text('Navigation error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          )
        ),
      ),
    );
  }

  static PageRouteBuilder<dynamic> _buildRoute(
    RouteSettings settings,
    Widget child,
  ) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, pageChild) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final slideTween = Tween<Offset>(
          begin: const Offset(0.07, 0),
          end: Offset.zero,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: curvedAnimation.drive(slideTween),
            child: pageChild,
          ),
        );
      },
    );
  }
}
