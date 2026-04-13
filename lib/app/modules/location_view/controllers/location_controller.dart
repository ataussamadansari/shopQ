import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopq/app/core/utils/helpers.dart';
import 'package:shopq/app/routes/app_routes.dart';

import '../../../data/repositories/location/location_repository.dart';
import '../../../data/services/storage/storage_services.dart';

class LocationController extends GetxController {

  final LocationRepository _repo = LocationRepository();
  final StorageServices _storage = StorageServices.to;

  final pinCodeController = TextEditingController();
  var pinCodeText = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    pinCodeController.addListener(
      () => pinCodeText.value = pinCodeController.text,
    );
  }

  // PinCode is usually 6 digits in India
  bool get isValid => pinCodeText.value.length == 6;

  Future<void> onVerifyPinCode() async {
    if (!isValid) return;

    try {
      isLoading.value = true;

      final response =
      await _repo.validatePinCode(pinCodeText.value);

      if (response.success && response.data != null) {

        // 🔐 Save pincode locally
        _storage.setPinCode(pinCodeText.value);

        debugPrint("Pin Saved: ${pinCodeText.value}");

        AppHelpers.showSnackBar(
          title: "Location Found",
          message: response.message,
          isError: false,
        );

        Get.offAllNamed(Routes.home);

      } else {
        AppHelpers.showSnackBar(
          title: "Error",
          message: response.message,
          isError: true,
        );
      }

    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    pinCodeController.dispose();
    super.onClose();
  }
}
