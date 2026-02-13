import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'routes/route_names.dart';
import 'state/demo_store.dart';

class ShopQDemoApp extends StatelessWidget {
  const ShopQDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DemoStore(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ShopQ',
        theme: AppTheme.lightTheme,
        initialRoute: RouteNames.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
