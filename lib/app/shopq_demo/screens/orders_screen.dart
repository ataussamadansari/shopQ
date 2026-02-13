import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order_summary_item.dart';
import '../routes/route_names.dart';
import '../state/demo_store.dart';
import '../widgets/custom_app_bar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DemoStore>().refreshOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        final statusOptions = _statusOptions(store.orders);
        final effectiveFilter = statusOptions.contains(_statusFilter) ? _statusFilter : 'all';
        final orders = _filteredOrders(store.orders, effectiveFilter);

        return Scaffold(
          appBar: const CustomAppBar(title: 'My Orders'),
          body: RefreshIndicator(
            onRefresh: () => store.refreshOrders(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              children: <Widget>[
                if (statusOptions.length > 1) ...<Widget>[
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final status = statusOptions[index];
                        final selected = status == effectiveFilter;
                        return ChoiceChip(
                          label: Text(_statusLabel(status)),
                          selected: selected,
                          onSelected: (_) => setState(() => _statusFilter = status),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: statusOptions.length,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (store.isOrdersLoading && store.orders.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (orders.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Column(
                      children: <Widget>[
                        const Icon(
                          CupertinoIcons.cube_box,
                          size: 58,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No orders in this status',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  )
                else
                  ...orders.map((order) => _OrderCard(order: order)),
              ],
            ),
          ),
        );
      },
    );
  }

  List<OrderSummaryItem> _filteredOrders(List<OrderSummaryItem> source, String statusFilter) {
    if (statusFilter == 'all') {
      return source;
    }
    return source.where((order) => order.status == statusFilter).toList(growable: false);
  }

  List<String> _statusOptions(List<OrderSummaryItem> source) {
    const orderedStatuses = <String>[
      'all',
      'confirmed',
      'packed',
      'shipped',
      'out_for_delivery',
      'delivered',
      'canceled',
    ];

    return orderedStatuses
        .where((status) => status == 'all' || source.any((order) => order.status == status))
        .toList(growable: false);
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'all':
        return 'All';
      case 'confirmed':
        return 'Confirmed';
      case 'packed':
        return 'Packed';
      case 'shipped':
        return 'Shipped';
      case 'out_for_delivery':
        return 'Delivery';
      case 'delivered':
        return 'Delivered';
      case 'canceled':
        return 'Canceled';
      default:
        return status;
    }
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderSummaryItem order;

  @override
  Widget build(BuildContext context) {
    final dateLabel = order.placedAt == null ? 'Date unavailable' : DateFormat('MMM d, yyyy').format(order.placedAt!);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  order.orderNumber,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              _StatusChip(status: order.status),
            ],
          ),
          const SizedBox(height: 8),
          Text('Items: ${order.itemsCount}'),
          Text('Total: \$${order.total.toStringAsFixed(2)}'),
          Text('Placed: $dateLabel'),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => Navigator.pushNamed(
              context,
              RouteNames.orderTracking,
              arguments: order.id,
            ),
            icon: const Icon(CupertinoIcons.location_solid, size: 16),
            label: const Text('Track Order'),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(status),
        style: TextStyle(
          color: colors.$2,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  (Color, Color) _statusColors(String value) {
    switch (value) {
      case 'delivered':
        return (const Color(0xFFDCFCE7), const Color(0xFF15803D));
      case 'canceled':
        return (const Color(0xFFFEE2E2), const Color(0xFFB91C1C));
      case 'out_for_delivery':
      case 'shipped':
        return (const Color(0xFFDBEAFE), const Color(0xFF1D4ED8));
      default:
        return (const Color(0xFFF1F5F9), const Color(0xFF334155));
    }
  }

  String _label(String value) {
    switch (value) {
      case 'out_for_delivery':
        return 'Delivery';
      default:
        return value.replaceAll('_', ' ').toUpperCase();
    }
  }
}
