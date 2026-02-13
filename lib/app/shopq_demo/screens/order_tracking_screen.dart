import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order_status_step.dart';
import '../routes/route_names.dart';
import '../state/demo_store.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/micro_action_button.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({
    super.key,
    this.orderId,
  });

  final int? orderId;

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DemoStore>().refreshOrderTracking(orderId: widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        final timeline = store.orderTimeline;
        return Scaffold(
          appBar: const CustomAppBar(title: 'Track Order'),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Order ${store.lastOrderId}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      timeline.map((step) => step.title).join('  •  '),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (store.isTrackingLoading) ...<Widget>[
                      const SizedBox(height: 10),
                      const LinearProgressIndicator(minHeight: 3),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...List<Widget>.generate(timeline.length, (index) {
                final step = timeline[index];
                return _TimelineStep(
                  step: step,
                  isLast: index == timeline.length - 1,
                );
              }),
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: MicroActionButton(
              label: 'Back to Home',
              icon: CupertinoIcons.house_fill,
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.mainNavigation,
                (route) => false,
              ),
              expand: true,
            ),
          ),
        );
      },
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.step,
    required this.isLast,
  });

  final OrderStatusStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final timeText = step.time == null ? 'Pending update' : DateFormat('MMM d, h:mm a').format(step.time!);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: step.completed ? const Color(0xFF15803D) : const Color(0xFFCBD5E1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                step.completed ? CupertinoIcons.checkmark : CupertinoIcons.time,
                color: Colors.white,
                size: 14,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 72,
                color: const Color(0xFFCBD5E1),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  timeText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
