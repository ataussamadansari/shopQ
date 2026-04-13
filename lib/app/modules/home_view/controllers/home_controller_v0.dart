import 'package:get/get.dart';
import 'package:shopq/app/data/models/home/section_item.dart';
import 'package:shopq/app/data/models/home/section_model.dart';
import 'package:shopq/app/data/models/home/tabs.dart';

import '../../../core/utils/helpers.dart';
import '../../../data/models/home/home_model.dart';
import '../../../data/repositories/home/home_repository.dart';
import '../../../data/services/storage/storage_services.dart';

class HomeController extends GetxController {
  final HomeRepository _repository = HomeRepository();

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = "".obs;

  Rx<HomeModel?> homeData = Rx<HomeModel?>(null);

  List<SectionModel> get sections => homeData.value?.data?.sections ?? [];
  List<Tabs> get tabs => homeData.value?.data?.tabs ?? [];

  String get activePinCode {
    final pin = StorageServices.to.getPinCode()?.trim();
    return (pin != null && pin.isNotEmpty) ? pin : "221307";
  }

  SectionModel? get bannerSection =>
      sections.firstWhereOrNull((e) => e.type == "banner_slider");

  List<SectionItem> get banners => bannerSection?.items ?? [];

  var selectedCategoryId = 0.obs;

  void selectCategory(int id) {
    selectedCategoryId.value = id;
  }

  @override
  void onInit() {
    super.onInit();
    fetchHome();
  }

  Future<void> fetchHome() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = "";

      final response = await _repository.home(activePinCode);

      if (response.success && response.data != null) {
        homeData.value = response.data!;
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
        AppHelpers.showSnackBar(
          title: "Error",
          message: response.message,
          isError: true,
        );
      }
    } catch (_) {
      hasError.value = true;
      errorMessage.value = "Unable to load home data right now.";
      AppHelpers.showSnackBar(
        title: "Error",
        message: errorMessage.value,
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
