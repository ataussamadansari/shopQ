import 'package:get/get.dart';
import '../../../data/models/address/address_model.dart';
import '../../../data/repositories/address/address_repository.dart';
import '../../../data/repositories/order/order_repository.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_routes.dart';

class CheckoutController extends GetxController {
  final AddressRepository _addressRepo = AddressRepository();
  final OrderRepository _orderRepo = OrderRepository();

  final addresses = <AddressModel>[].obs;
  final selectedAddressId = Rx<int?>(null);
  final isLoading = true.obs;
  final isPlacingOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    isLoading.value = true;
    final res = await _addressRepo.getAddresses();
    if (res.success && res.data != null) {
      addresses.assignAll(res.data!);
      final def = res.data!.where((a) => a.isDefault).firstOrNull;
      selectedAddressId.value = def?.id ?? res.data!.firstOrNull?.id;
    }
    isLoading.value = false;
  }

  Future<void> placeOrder() async {
    if (selectedAddressId.value == null) {
      AppHelpers.showSnackBar(
        title: 'Error',
        message: 'Please select an address',
        isError: true,
      );
      return;
    }

    isPlacingOrder.value = true;
    final res = await _orderRepo.placeOrder(
      addressId: selectedAddressId.value!,
    );

    if (res.success && res.data != null) {
      AppHelpers.showSnackBar(
        title: 'Order Placed',
        message: 'Order #${res.data!.orderNo} placed successfully',
        isError: false,
      );
      Get.offAllNamed(Routes.orders);
    } else {
      AppHelpers.showSnackBar(
        title: 'Error',
        message: res.message,
        isError: true,
      );
    }
    isPlacingOrder.value = false;
  }
}
