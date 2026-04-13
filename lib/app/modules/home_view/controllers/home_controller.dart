import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/api_constants.dart';
import '../../../data/models/home/section_item.dart';
import '../../../data/models/home/section_model.dart';
import '../../../data/models/home/tabs.dart';
import '../../../data/repositories/home/home_repository.dart';
import '../../../data/services/storage/storage_services.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final HomeRepository _repo = HomeRepository();
  final StorageServices _storage = Get.find();

  // ── State ────────────────────────────────────────────────────────
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final selectedTabIndex = 0.obs;

  // ── Data ─────────────────────────────────────────────────────────
  final tabs = <Tabs>[].obs;
  final sections = <SectionModel>[].obs;

  // ── Scroll offset for animated header ────────────────────────────
  final scrollOffset = 0.0.obs;

  // ── Derived helpers ──────────────────────────────────────────────
  Color get activeColor {
    if (tabs.isEmpty) return const Color(0xFF6273f9);
    final hex = tabs[selectedTabIndex.value].themeColor ?? '#6273f9';
    return _hexToColor(hex);
  }

  String get pinCode => _storage.getPinCode() ?? '';
  String get userName => _storage.read<String>('user_name') ?? '';

  @override
  void onInit() {
    super.onInit();
    loadHome();
  }

  Future<void> loadHome({bool refresh = false}) async {
    if (!refresh) isLoading.value = true;
    errorMessage.value = '';

    final res = await _repo.home(pinCode);

    if (res.success && res.data?.data != null) {
      final data = res.data!.data!;
      tabs.assignAll(data.tabs ?? []);
      sections.assignAll(data.sections ?? []);
    } else {
      errorMessage.value = res.message;
    }
    isLoading.value = false;
  }

  void onTabSelected(int index) => selectedTabIndex.value = index;

  void onScrollChanged(double offset) => scrollOffset.value = offset;

  // ── Navigation ───────────────────────────────────────────────────
  void goToProductList({String? categorySlug, String? categoryName}) {
    Get.toNamed(
      Routes.productList,
      arguments: {'slug': categorySlug, 'name': categoryName ?? 'Products'},
    );
  }

  void goToCategory(SectionItem item) {
    Get.toNamed(Routes.category, arguments: item);
  }

  void goToProductDetail(String slug) {
    Get.toNamed(Routes.productDetail, arguments: {'slug': slug});
  }

  void goToCart() => Get.toNamed(Routes.cart);
  void goToProfile() => Get.toNamed(Routes.profile);
  void goToOrders() => Get.toNamed(Routes.orders);

  // ── Image URL helper ─────────────────────────────────────────────
  String resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    var resolved = url;
    // Replace localhost/127.0.0.1 with the configured production base URL
    if (resolved.contains('localhost') || resolved.contains('127.0.0.1')) {
      final prod = ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '');
      resolved = resolved
          .replaceAll(RegExp(r'https?://localhost:\d+'), prod)
          .replaceAll(RegExp(r'https?://127\.0\.0\.1:\d+'), prod);
    }
    if (resolved.startsWith('http')) return resolved;
    return '${ApiConstants.imageBaseUrl}/$resolved';
  }

  // ── Color helpers ────────────────────────────────────────────────
  Color lighten(Color color, [double amount = .2]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color darken(Color color, [double amount = .2]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _hexToColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return const Color(0xFF6273f9);
    }
  }

  // ── Section helpers ──────────────────────────────────────────────
  SectionModel? sectionById(String id) =>
      sections.firstWhereOrNull((s) => s.id == id);

  List<SectionItem> itemsForSection(String id) => sectionById(id)?.items ?? [];
}
