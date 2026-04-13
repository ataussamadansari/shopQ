import 'package:get/get.dart';
import '../../../data/models/cart/cart_model.dart';
import '../../../data/repositories/cart/cart_repository.dart';
import '../../../data/services/storage/storage_services.dart';
import '../../../core/utils/helpers.dart';

class CartController extends GetxController {
  final CartRepository _repo = CartRepository();
  final StorageServices _storage = Get.find();

  final cart = Rx<CartModel?>(null);
  final isLoading = true.obs;
  final updatingItemId = Rx<int?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    isLoading.value = true;
    final res = await _repo.getCart(pincode: _storage.getPinCode());
    if (res.success) cart.value = res.data;
    isLoading.value = false;
  }

  Future<void> updateQty(int itemId, int qty) async {
    updatingItemId.value = itemId;
    final res = qty <= 0
        ? await _repo.removeItem(itemId)
        : await _repo.updateItem(itemId, qty);
    if (res.success) {
      cart.value = res.data;
    } else {
      AppHelpers.showSnackBar(
        title: 'Error',
        message: res.message,
        isError: true,
      );
    }
    updatingItemId.value = null;
  }

  Future<void> removeItem(int itemId) async => updateQty(itemId, 0);

  void proceedToCheckout() {
    if (cart.value == null || cart.value!.items.isEmpty) return;
    Get.toNamed('/orders/checkout');
  }
}
