import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    // Coba ambil dari arguments dulu, kalau tidak ada ambil dari SharedPreferences
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['username'] != null) {
      username.value = args['username'];
    } else {
      final prefs = await SharedPreferences.getInstance();
      username.value = prefs.getString('username') ?? '';
    }
  }

  void goToList(String type, String title) {
    Get.toNamed(Routes.LIST, arguments: {'type': type, 'title': title});
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.offAllNamed(Routes.LOGIN);
  }
}