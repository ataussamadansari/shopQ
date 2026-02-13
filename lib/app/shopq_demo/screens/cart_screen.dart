import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_names.dart';
import '../state/demo_store.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/micro_action_button.dart';
import '../widgets/quantity_selector.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    this.showBackButton = true,
  });

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'My Cart',
            showBackButton: showBackButton,
          ),
          body: store.isCartEmpty
              ? _EmptyCartView(
                  onContinue: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.mainNavigation,
                    (route) => false,
                  ),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        itemCount: store.cartItems.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = store.cartItems[index];
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _CartImage(path: item.product.imageAssets.first),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        item.product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        store.money(item.unitPrice),
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              color: const Color(0xFF15803D),
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      QuantitySelector(
                                        quantity: item.quantity,
                                        onChanged: (value) async {
                                          final success = await store.updateQuantity(item.product.id, value);
                                          if (!context.mounted || success) {
                                            return;
                                          }
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                store.lastErrorMessage ?? 'Unable to update quantity.',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final success = await store.removeFromCart(item.product.id);
                                    if (!context.mounted || success) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          store.lastErrorMessage ?? 'Unable to remove item.',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(CupertinoIcons.trash, color: Color(0xFFDC2626)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: <Widget>[
                          _SummaryRow(label: 'Subtotal', value: store.money(store.subtotal)),
                          const SizedBox(height: 8),
                          _SummaryRow(label: 'Shipping', value: store.money(store.shippingFee)),
                          const Divider(height: 20),
                          _SummaryRow(
                            label: 'Total',
                            value: store.money(store.total),
                            emphasized: true,
                          ),
                          const SizedBox(height: 14),
                          MicroActionButton(
                            label: 'Proceed to Checkout',
                            icon: CupertinoIcons.arrow_right,
                            onTap: () => Navigator.pushNamed(context, RouteNames.checkout),
                            expand: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
                color: emphasized ? Colors.black : const Color(0xFF475569),
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
                color: emphasized ? const Color(0xFF0F172A) : const Color(0xFF334155),
              ),
        ),
      ],
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                CupertinoIcons.cart_fill_badge_minus,
                color: Color(0xFF15803D),
                size: 54,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Looks like you have not added anything yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            MicroActionButton(
              label: 'Start Shopping',
              icon: CupertinoIcons.bag_fill,
              onTap: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartImage extends StatelessWidget {
  const _CartImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final isRemote = path.startsWith('http://') || path.startsWith('https://');
    return isRemote
        ? Image.network(
            path,
            width: 78,
            height: 78,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          )
        : Image.asset(
            path,
            width: 78,
            height: 78,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          );
  }

  Widget _fallback() {
    return Container(
      width: 78,
      height: 78,
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.photo),
    );
  }
}
