import 'package:get/get.dart';
import '../../../data/models/product/product_detail_model.dart';
import '../../../data/repositories/cart/cart_repository.dart';
import '../../../data/repositories/product/product_repository.dart';
import '../../../data/services/storage/storage_services.dart';
import '../../../core/utils/helpers.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _productRepo = ProductRepository();
  final CartRepository _cartRepo = CartRepository();
  final StorageServices _storage = Get.find();

  final product = Rx<ProductDetailModel?>(null);
  final isLoading = true.obs;
  final isAddingToCart = false.obs;
  final errorMessage = ''.obs;
  final selectedImageIndex = 0.obs;
  final selectedVariantId = Rx<int?>(null);
  final qty = 1.obs;

  final String slug;

  ProductDetailController({required this.slug});

  @override
  void onInit() {
    super.onInit();
    loadProduct();
  }

  Future<void> loadProduct() async {
    isLoading.value = true;
    errorMessage.value = '';

    final res = await _productRepo.getProduct(
      slug,
      pincode: _storage.getPinCode(),
    );
    if (res.success && res.data != null) {
      product.value = res.data;
    } else {
      errorMessage.value = res.message;
    }
    isLoading.value = false;
  }

  void selectImage(int index) => selectedImageIndex.value = index;

  void selectVariant(int? id) => selectedVariantId.value = id;

  void incrementQty() {
    final maxStock = product.value?.stock ?? 1;
    if (qty.value < maxStock) qty.value++;
  }

  void decrementQty() {
    if (qty.value > 1) qty.value--;
  }

  Future<void> addToCart() async {
    final p = product.value;
    if (p == null) return;

    final token = _storage.getToken();
    if (token == null || token.isEmpty) {
      Get.toNamed('/auth');
      return;
    }

    isAddingToCart.value = true;
    final res = await _cartRepo.addItem(
      productId: p.id,
      qty: qty.value,
      variantId: selectedVariantId.value,
      pincode: _storage.getPinCode(),
    );

    if (res.success) {
      AppHelpers.showSnackBar(
        title: 'Added to Cart',
        message: '${p.title} added',
        isError: false,
      );
    } else {
      AppHelpers.showSnackBar(
        title: 'Error',
        message: res.message,
        isError: true,
      );
    }
    isAddingToCart.value = false;
  }
}
