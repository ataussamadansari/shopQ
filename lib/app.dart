import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopq/app/routes/app_routes.dart';

import 'app/core/bindings/app_bindings.dart';
import 'app/core/themes/app_theme.dart';
import 'app/routes/app_pages.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      // darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      initialRoute: Routes.home,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
    );
  }
}



