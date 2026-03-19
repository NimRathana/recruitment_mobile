import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';
import '../storage/storage_keys.dart';

class AuthController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var token = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final savedToken = box.read(StorageKeys.token);
    if (savedToken != null) {
      token.value = savedToken;

      ApiService.verifyToken(savedToken).then((isValid) {
        if (isValid) {
          Get.offAllNamed(Routes.home);
        } else {
          logout();
        }
      });
    }
  }

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    final result = await ApiService.login(username, password);
    isLoading.value = false;

    if (result != null) {
      token.value = result;
      box.write(StorageKeys.token, result);
      Get.offAllNamed(Routes.home);
    } else {
      Get.snackbar("Error", "Invalid login");
    }
  }

  void logout() {
    box.remove(StorageKeys.token);
    token.value = '';
    Get.offAllNamed(Routes.login);
  }
}