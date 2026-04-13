import 'package:get/get.dart';

import '../../../data/services/storage/storage_services.dart';
import '../../../routes/app_routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 2200));

    final storedToken = StorageServices.to.getToken();
    final pinCode = StorageServices.to.getPinCode();

    if (storedToken != null && storedToken.isNotEmpty) {
      if (pinCode != null && pinCode.isNotEmpty) {
        Get.offAllNamed(Routes.home);
      } else {
        Get.offAllNamed(Routes.location);
      }
    } else {
      Get.offAllNamed(Routes.auth);
    }
  }
}
