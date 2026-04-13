import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product/product_card_model.dart';
import '../../../data/repositories/product/product_repository.dart';
import '../../../data/services/storage/storage_services.dart';

class ProductListController extends GetxController {
  final ProductRepository _repo = ProductRepository();
  final StorageServices _storage = Get.find();

  final products = <ProductCardModel>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final selectedSort = 'latest'.obs;

  final searchController = TextEditingController();

  String? categorySlug;
  String? categoryName;

  int _page = 1;
  bool _hasMore = true;

  final sortOptions = [
    {'label': 'Latest', 'value': 'latest'},
    {'label': 'Price: Low to High', 'value': 'price_asc'},
    {'label': 'Price: High to Low', 'value': 'price_desc'},
    {'label': 'Best Seller', 'value': 'best_seller'},
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      categorySlug = Get.arguments['slug'];
      categoryName = Get.arguments['name'];
    }
    loadProducts();
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      products.clear();
    }
    isLoading.value = true;
    errorMessage.value = '';

    final res = await _repo.getProducts(
      pincode: _storage.getPinCode(),
      categorySlug: categorySlug,
      search: searchQuery.value.isEmpty ? null : searchQuery.value,
      sort: selectedSort.value == 'latest' ? null : selectedSort.value,
      page: _page,
    );

    if (res.success && res.data != null) {
      products.addAll(res.data!);
      _hasMore = res.data!.length >= 20;
    } else {
      errorMessage.value = res.message;
    }
    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore.value) return;
    _page++;
    isLoadingMore.value = true;

    final res = await _repo.getProducts(
      pincode: _storage.getPinCode(),
      categorySlug: categorySlug,
      search: searchQuery.value.isEmpty ? null : searchQuery.value,
      sort: selectedSort.value == 'latest' ? null : selectedSort.value,
      page: _page,
    );

    if (res.success && res.data != null) {
      products.addAll(res.data!);
      _hasMore = res.data!.length >= 20;
    } else {
      _page--;
    }
    isLoadingMore.value = false;
  }

  void onSearch(String q) {
    searchQuery.value = q;
    loadProducts(refresh: true);
  }

  void onSortChanged(String sort) {
    selectedSort.value = sort;
    loadProducts(refresh: true);
  }

  @override
  void onClose() {
    searchController.dispose();
    _repo.cancel();
    super.onClose();
  }
}
