import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_names.dart';
import '../state/demo_store.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/micro_action_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.showBackButton = true,
  });

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoStore>(
      builder: (context, store, child) {
        final user = store.currentUser;
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Profile',
            showBackButton: showBackButton,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color(0xFF1D4ED8),
                      Color(0xFF15803D),
                    ],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(
                        CupertinoIcons.person_fill,
                        color: Color(0xFF1D4ED8),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            user?.name ?? 'Guest User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.phone ?? 'Not logged in',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _ProfileTile(
                icon: CupertinoIcons.cube_box_fill,
                title: 'My Orders',
                subtitle: '${store.orders.length} order(s) synced',
                onTap: () => Navigator.pushNamed(context, RouteNames.orders),
              ),
              _ProfileTile(
                icon: CupertinoIcons.location_solid,
                title: 'Saved Addresses',
                subtitle: '${store.addresses.length} address(es) loaded from backend',
                onTap: () => Navigator.pushNamed(context, RouteNames.addresses),
              ),
              _ProfileTile(
                icon: CupertinoIcons.creditcard_fill,
                title: 'Payment Methods',
                subtitle: '${store.paymentMethods.length} method(s) available',
                onTap: () => Navigator.pushNamed(context, RouteNames.paymentMethods),
              ),
              _ProfileTile(
                icon: CupertinoIcons.question_circle_fill,
                title: 'API Status',
                subtitle: store.apiBaseUrl,
                onTap: () {},
              ),
              const SizedBox(height: 14),
              MicroActionButton(
                label: 'Log Out',
                icon: CupertinoIcons.square_arrow_right,
                filled: false,
                onTap: () async {
                  await store.logout();
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.auth,
                    (route) => false,
                  );
                },
                expand: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: const Color(0xFF1D4ED8)),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(CupertinoIcons.chevron_right, size: 18),
        onTap: onTap,
      ),
    );
  }
}
