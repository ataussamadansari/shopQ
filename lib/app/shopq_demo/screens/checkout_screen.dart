import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_names.dart';
import '../state/demo_store.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/micro_action_button.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static const List<_PaymentOption> _fallbackPaymentOptions = <_PaymentOption>[
    _PaymentOption(
      id: 'upi',
      selectionValue: 'upi',
      label: 'UPI',
      subtitle: 'Add UPI ID in Payment Methods',
      icon: CupertinoIcons.qrcode,
    ),
    _PaymentOption(
      id: 'card',
      selectionValue: 'card',
      label: 'Card',
      subtitle: 'Add card in Payment Methods',
      icon: CupertinoIcons.creditcard,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        final paymentOptions = store.paymentMethods.isEmpty
            ? _fallbackPaymentOptions
            : store.paymentMethods
                .map(
                  (item) => _PaymentOption(
                    id: item.type,
                    selectionValue: 'pm-${item.id}',
                    label: item.label,
                    subtitle: item.displaySubtitle,
                    icon: _iconForType(item.type),
                    paymentMethodId: item.id,
                  ),
                )
                .toList(growable: false);
        final selectedPaymentValue = store.selectedPaymentMethodId == null ? store.selectedPaymentMethod : 'pm-${store.selectedPaymentMethodId}';

        return Scaffold(
          appBar: const CustomAppBar(title: 'Checkout'),
          body: store.isCartEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          CupertinoIcons.cart,
                          size: 56,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No items to checkout',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteNames.mainNavigation,
                            (route) => false,
                          ),
                          child: const Text('Back to Home'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 130),
                  children: <Widget>[
                    _Title(title: 'Select Address'),
                    const SizedBox(height: 10),
                    if (store.addresses.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'No saved address found. Add an address first.',
                        ),
                      ),
                    if (store.addresses.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, RouteNames.addresses),
                          icon: const Icon(CupertinoIcons.add),
                          label: const Text('Add Address'),
                        ),
                      ),
                    ...List<Widget>.generate(store.addresses.length, (index) {
                      final selected = store.selectedAddressIndex == index;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? const Color(0xFF15803D) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: RadioListTile<int>(
                          value: index,
                          groupValue: store.selectedAddressIndex,
                          onChanged: (value) {
                            if (value != null) {
                              store.setSelectedAddress(value);
                            }
                          },
                          title: Text(store.addresses[index]),
                        ),
                      );
                    }),
                    if (store.addresses.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => Navigator.pushNamed(context, RouteNames.addresses),
                          icon: const Icon(CupertinoIcons.pencil, size: 16),
                          label: const Text('Manage Addresses'),
                        ),
                      ),
                    const SizedBox(height: 18),
                    _Title(title: 'Payment Method'),
                    const SizedBox(height: 10),
                    if (paymentOptions.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text('No payment method available. Please add one.'),
                      ),
                    ...paymentOptions.map((option) {
                      final selected = option.selectionValue == selectedPaymentValue;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: RadioListTile<String>(
                          value: option.selectionValue,
                          groupValue: selectedPaymentValue,
                          onChanged: (value) {
                            if (value != null) {
                              store.setSelectedPaymentMethod(
                                option.id,
                                paymentMethodId: option.paymentMethodId,
                              );
                            }
                          },
                          secondary: Icon(option.icon),
                          title: Text(option.label),
                          subtitle: Text(option.subtitle),
                        ),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => Navigator.pushNamed(context, RouteNames.paymentMethods),
                        icon: const Icon(CupertinoIcons.pencil, size: 16),
                        label: const Text('Manage Payment Methods'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _Title(title: 'Price Summary'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: <Widget>[
                          _SummaryLine(
                            label: 'Items (${store.cartCount})',
                            value: store.money(store.subtotal),
                          ),
                          const SizedBox(height: 8),
                          _SummaryLine(label: 'Shipping', value: store.money(store.shippingFee)),
                          const Divider(height: 20),
                          _SummaryLine(
                            label: 'Payable Amount',
                            value: store.money(store.total),
                            emphasized: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: store.isCartEmpty
              ? null
              : SafeArea(
                  minimum: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                  child: store.isPlacingOrder
                      ? const Center(child: CircularProgressIndicator())
                      : MicroActionButton(
                          label: 'Place Order',
                          icon: CupertinoIcons.check_mark_circled_solid,
                          onTap: () async {
                            final success = await store.placeOrder();
                            if (!context.mounted) {
                              return;
                            }
                            if (!success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    store.lastErrorMessage ?? 'Unable to place order.',
                                  ),
                                ),
                              );
                              return;
                            }
                            Navigator.pushReplacementNamed(context, RouteNames.orderConfirmation);
                          },
                          expand: true,
                        ),
                ),
        );
      },
    );
  }
}

class _PaymentOption {
  const _PaymentOption({
    required this.id,
    required this.selectionValue,
    required this.label,
    required this.subtitle,
    required this.icon,
    this.paymentMethodId,
  });

  final String id;
  final String selectionValue;
  final String label;
  final String subtitle;
  final IconData icon;
  final int? paymentMethodId;
}

IconData _iconForType(String type) {
  switch (type) {
    case 'card':
      return CupertinoIcons.creditcard;
    case 'cod':
      return CupertinoIcons.money_dollar_circle;
    case 'upi':
    default:
      return CupertinoIcons.qrcode;
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
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
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: emphasized ? FontWeight.w800 : FontWeight.w700,
                color: emphasized ? const Color(0xFF0F172A) : const Color(0xFF334155),
              ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }
}
