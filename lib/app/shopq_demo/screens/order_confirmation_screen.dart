import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_names.dart';
import '../state/demo_store.dart';
import '../widgets/micro_action_button.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutBack,
                      tween: Tween<double>(begin: 0.7, end: 1),
                      builder: (context, value, child) => Transform.scale(
                        scale: value,
                        child: child,
                      ),
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          size: 58,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Order placed successfully',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order ID: ${store.lastOrderId}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF334155),
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Thank you for shopping with ShopQ.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 22),
                    MicroActionButton(
                      label: 'Track Order',
                      icon: CupertinoIcons.location_solid,
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        RouteNames.orderTracking,
                        arguments: store.lastOrderDatabaseId,
                      ),
                      expand: true,
                    ),
                    const SizedBox(height: 10),
                    MicroActionButton(
                      label: 'Continue Shopping',
                      icon: CupertinoIcons.bag_fill,
                      onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.mainNavigation,
                        (route) => false,
                      ),
                      filled: false,
                      expand: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
