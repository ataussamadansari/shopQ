import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    final slug = Get.arguments['slug'] as String?;
    if (slug != null) {
      Get.lazyPut<ProductDetailController>(
        () => ProductDetailController(slug: slug),
        tag: slug,
      );
    }
  }
}
