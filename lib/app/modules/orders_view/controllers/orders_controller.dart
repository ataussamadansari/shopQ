import 'package:get/get.dart';
import '../../../data/models/order/order_model.dart';
import '../../../data/repositories/order/order_repository.dart';

class OrdersController extends GetxController {
  final OrderRepository _repo = OrderRepository();

  final orders = <OrderModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    errorMessage.value = '';
    final res = await _repo.getOrders();
    if (res.success && res.data != null) {
      orders.assignAll(res.data!);
    } else {
      errorMessage.value = res.message;
    }
    isLoading.value = false;
  }
}
