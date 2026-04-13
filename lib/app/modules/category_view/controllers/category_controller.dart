import 'package:get/get.dart';

import '../../../data/models/category/sub_category.dart';
import '../../../data/models/home/section_item.dart';
import '../../../data/repositories/category/category_repository.dart';
import '../../../data/services/storage/storage_services.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository = CategoryRepository();
  final StorageServices _storage = Get.find();

  final rootCategory = Rx<SectionItem?>(null);
  final mainCategories = <SectionItem>[].obs;
  final selectedMain = Rx<SectionItem?>(null);
  final subCategories = <SectionItem>[].obs;
  final selectedSub = Rx<SectionItem?>(null);
  final products = <Products>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  int _requestId = 0;

  String get pinCode => _storage.getPinCode() ?? '';

  String get appBarTitle =>
      rootCategory.value?.name ?? selectedMain.value?.name ?? 'Category';

  String get activeBrowseLabel =>
      selectedSub.value?.name ??
      selectedMain.value?.name ??
      rootCategory.value?.name ??
      'Products';

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is! SectionItem) {
      return;
    }

    rootCategory.value = args;
    final categories = _resolveMainCategories(args);
    mainCategories.assignAll(categories);

    if (categories.isNotEmpty) {
      selectMain(categories.first);
    }
  }

  Future<void> selectMain(SectionItem item) async {
    final current = selectedMain.value;
    if (_isSameCategory(current, item) &&
        selectedSub.value == null &&
        (products.isNotEmpty || isLoading.value)) {
      return;
    }

    selectedMain.value = item;
    selectedSub.value = null;
    subCategories.clear();

    await _load(slug: item.slug ?? '', refreshSubCategories: true);
  }

  Future<void> toggleSub(SectionItem item) async {
    final mainCategory = selectedMain.value;
    if (mainCategory == null) {
      return;
    }

    if (_isSameCategory(selectedSub.value, item)) {
      selectedSub.value = null;
      await _load(slug: mainCategory.slug ?? '', refreshSubCategories: true);
      return;
    }

    selectedSub.value = item;
    await _load(slug: item.slug ?? '', refreshSubCategories: false);
  }

  Future<void> _load({
    required String slug,
    required bool refreshSubCategories,
  }) async {
    if (slug.isEmpty) {
      products.clear();
      if (refreshSubCategories) {
        subCategories.clear();
      }
      return;
    }

    final requestId = ++_requestId;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      products.clear();

      final res = await _repository.home(pinCode, slug);
      if (requestId != _requestId) {
        return;
      }

      if (res.success && res.data?.data != null) {
        final data = res.data!.data!;
        products.assignAll(data.products ?? const <Products>[]);

        if (refreshSubCategories) {
          subCategories.assignAll(_mapChildren(data.category?.children));
        }
      } else {
        errorMessage.value = res.message;
        if (refreshSubCategories) {
          subCategories.clear();
        }
      }
    } catch (e) {
      if (requestId != _requestId) {
        return;
      }
      errorMessage.value = e.toString();
    } finally {
      if (requestId == _requestId) {
        isLoading.value = false;
      }
    }
  }

  List<SectionItem> _resolveMainCategories(SectionItem root) {
    final validChildren = (root.children ?? const <SectionItem>[])
        .where((item) => (item.slug ?? '').trim().isNotEmpty)
        .toList(growable: false);

    if (validChildren.isNotEmpty) {
      return validChildren;
    }

    return [root];
  }

  List<SectionItem> _mapChildren(List<Children>? children) {
    if (children == null || children.isEmpty) {
      return const <SectionItem>[];
    }

    return children
        .where((child) => (child.slug ?? '').trim().isNotEmpty)
        .map(
          (child) => SectionItem.fromJson({
            'id': child.id,
            'name': child.name,
            'slug': child.slug,
            'featured_image': child.featuredImage,
            'parent_id': child.parentId,
          }),
        )
        .toList(growable: false);
  }

  bool _isSameCategory(SectionItem? a, SectionItem? b) {
    if (a == null || b == null) {
      return false;
    }

    if (a.id != null && b.id != null) {
      return a.id == b.id;
    }

    return a.slug == b.slug && a.name == b.name;
  }

  @override
  void onClose() {
    _repository.cancel();
    super.onClose();
  }
}
