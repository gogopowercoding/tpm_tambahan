import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/article.dart';
import '../../data/services/api_service.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/location_service.dart';

class DetailController extends GetxController {
  final article = Rxn<Article>();
  final isLoading = true.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;

  // LBS
  final currentLocation = ''.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final isLoadingLocation = false.obs;

  late String type;
  late int id;
  late String title;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    type = args?['type'] ?? 'articles';
    id = args?['id'] ?? 0;
    title = args?['title'] ?? 'Detail';
    fetchDetail();
    // getLocation dipanggil manual, tidak saat init
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    isError.value = false;
    try {
      final data = await ApiService.fetchDetail(type, id);
      article.value = data;
      // Notifikasi artikel
      NotificationService.showArticleNotification(data.title);
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getLocation() async {
    isLoadingLocation.value = true;
    currentLocation.value = '';
    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;
        final address = await LocationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        currentLocation.value = address;
        NotificationService.showLocationNotification(address);
      } else {
        currentLocation.value = 'Lokasi tidak tersedia';
      }
    } catch (e) {
      currentLocation.value = 'Gagal mendapatkan lokasi';
    } finally {
      isLoadingLocation.value = false;
    }
  }

  String formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  Future<void> launchArticleUrl() async {
    final url = article.value?.url ?? '';
    if (url.isEmpty) {
      Get.snackbar('Error', 'URL tidak tersedia',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Tidak dapat membuka halaman web',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}