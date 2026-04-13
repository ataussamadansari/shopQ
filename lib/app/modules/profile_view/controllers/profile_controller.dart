import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/address/address_model.dart';
import '../../../data/repositories/address/address_repository.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/profile/profile_repository.dart';
import '../../../data/services/storage/storage_services.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();
  final AddressRepository _addressRepo = AddressRepository();
  final AuthRepository _authRepo = AuthRepository();
  final StorageServices _storage = Get.find();

  final userName = ''.obs;
  final userPhone = ''.obs;
  final userEmail = ''.obs;
  final addresses = <AddressModel>[].obs;
  final isLoading = true.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadAddresses();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    final res = await _profileRepo.getProfile();
    if (res.success && res.data?.data != null) {
      final d = res.data!.data!;
      userName.value = d.name ?? '';
      userPhone.value = d.phone ?? '';
      userEmail.value = d.email ?? '';
      nameController.text = d.name ?? '';
      emailController.text = d.email ?? '';
    }
    isLoading.value = false;
  }

  Future<void> loadAddresses() async {
    final res = await _addressRepo.getAddresses();
    if (res.success && res.data != null) {
      addresses.assignAll(res.data!);
    }
  }

  Future<void> setDefaultAddress(int id) async {
    final res = await _addressRepo.setDefault(id);
    if (res.success) {
      await loadAddresses();
      AppHelpers.showSnackBar(
        title: 'Success',
        message: 'Default address updated',
        isError: false,
      );
    } else {
      AppHelpers.showSnackBar(
        title: 'Error',
        message: res.message,
        isError: true,
      );
    }
  }

  Future<void> deleteAddress(int id) async {
    final res = await _addressRepo.deleteAddress(id);
    if (res.success) {
      addresses.removeWhere((a) => a.id == id);
    } else {
      AppHelpers.showSnackBar(
        title: 'Error',
        message: res.message,
        isError: true,
      );
    }
  }

  Future<void> logout() async {
    await _authRepo.me(); // just to ensure token is valid
    _storage.removeToken();
    _storage.removePinCode();
    Get.offAllNamed(Routes.auth);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
