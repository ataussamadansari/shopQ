import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageServices extends GetxService {
  static StorageServices get to => Get.find();
  GetStorage _box = GetStorage();

  RxString token = "".obs;
  RxString pinCode = "".obs;

  @override
  void onInit() {
    super.onInit();
    // GetStorage is already initialized in main.dart
    _box = GetStorage();

    // Initialize reactive variables from storage
    token.value = _box.read("token") ?? "";
    pinCode.value = _box.read("pinCode") ?? "";
  }

  // Token Management
  String? getToken() => _box.read('token');
  void setToken(String t) {
    _box.write('token', t);
    token.value = t; // reactive update
  }

  void removeToken() {
    _box.remove('token');
    token.value = "";
  }

  // PinCode
  String? getPinCode() => _box.read('pinCode');
  void setPinCode(String pin) {
    _box.write('pinCode', pin);
    pinCode.value = pin;
  }

  void removePinCode() {
    _box.remove('pinCode');
    pinCode.value = "";
  }

  // Language Management
  String? getLanguage() => _box.read('language');
  void setLanguage(String language) => _box.write('language', language);

  // Theme Management
  bool isDarkMode() => _box.read('darkMode') ?? false;
  void setDarkMode(bool value) => _box.write('darkMode', value);

  // Generic Storage Methods
  T? read<T>(String key) => _box.read(key);
  void write<T>(String key, T value) => _box.write(key, value);
  void remove<T>(String key) => _box.remove(key);
  void clear() {
    _box.erase();
    token.value = "";
    pinCode.value = "";
  }
}
