import 'package:get/get.dart';

// --- MODEL ---
class Product {
  final String name;
  final double price;
  final String image;
  final String weight;

  Product({required this.name, required this.price, required this.image, this.weight = "1 unit"});
}

// --- CONTROLLER ---
class HomeController extends GetxController {
  var selectedCategoryIndex = 0.obs;
  var cartCount = 0.obs;
  var totalPrice = 0.0.obs;

  // Category-wise lists with CDN Images
  var fruits = <Product>[].obs;
  var riceList = <Product>[].obs;
  var milkProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    fruits.assignAll([
      Product(name: "Desi Tamatar", price: 45, image: "https://cdn.pixabay.com/photo/2011/03/16/16/01/tomatoes-5356_1280.jpg", weight: "500g"),
      Product(name: "Shimla Mirch", price: 32, image: "https://cdn.pixabay.com/photo/2016/04/25/20/00/bell-pepper-1352803_1280.jpg", weight: "250g"),
      Product(name: "Fresh Palak", price: 20, image: "https://cdn.pixabay.com/photo/2017/05/11/19/44/spinach-2305192_1280.jpg", weight: "1 bunch"),
    ]);

    riceList.assignAll([
      Product(name: "Fortune Basmati Rice", price: 145, image: "https://www.bigbasket.com/media/uploads/p/l/40160538_1-fortune-biryani-special-basmati-rice.jpg", weight: "1kg"),
      Product(name: "India Gate Dubar", price: 95, image: "https://www.bigbasket.com/media/uploads/p/l/241315_12-india-gate-basmati-rice-dubar.jpg", weight: "1kg"),
      Product(name: "Daawat Rozana Rice", price: 78, image: "https://www.bigbasket.com/media/uploads/p/l/40040441_5-daawat-rozana-super-basmati-rice.jpg", weight: "1kg"),
    ]);

    milkProducts.assignAll([
      Product(name: "Amul Gold Milk", price: 33, image: "https://www.bigbasket.com/media/uploads/p/l/161124_4-amul-gold-milk-homogenised-standardised.jpg", weight: "500ml"),
      Product(name: "Amul Masti Dahi", price: 20, image: "https://www.bigbasket.com/media/uploads/p/l/40013014_5-amul-masti-curd.jpg", weight: "200g"),
      Product(name: "Amul Butter", price: 56, image: "https://www.bigbasket.com/media/uploads/p/l/1200039_10-amul-butter-pasteurised.jpg", weight: "100g"),
    ]);
  }

  void changeCategory(int index) => selectedCategoryIndex.value = index;

  void addToCart(double price) {
    cartCount.value++;
    totalPrice.value += price;
  }
}