import 'package:get/get.dart';

import '../../data/services/storage/storage_services.dart';


class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageServices>(() => StorageServices(), fenix: true);

  }
}