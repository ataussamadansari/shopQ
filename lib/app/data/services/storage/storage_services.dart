import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageServices extends GetxService{
  static StorageServices get to => Get.find();
  late GetStorage _box;

  @override
  void onInit() async {
    super.onInit();
    await GetStorage.init();
    _box = GetStorage();
  }

  // Token Management

  String? getToken() => _box.read('token');
  void setToken(String token) => _box.write('token',token);
  void removeToken() => _box.remove('token');

  // Language Management

  String? getLanguage() => _box.read('language');
  void setLanguage(String language) => _box.write('language',language);

  // Theme Management

  bool isDarkMode() => _box.read('darkMode') ?? false;
  void setDarkMode(String value) => _box.write('darkMode',value);

  // Generic storage methods

  T? read<T>(String key) => _box.read(key);
  void write<T>(String key,T value) => _box.write(key,value);
  void remove(String key) => _box.remove(key);
  void clear() => _box.erase();
}


