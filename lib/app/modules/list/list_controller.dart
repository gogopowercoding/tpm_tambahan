import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/article.dart';
import '../../data/services/api_service.dart';
import '../../routes/app_pages.dart';

class ListController extends GetxController {
  final articles = <Article>[].obs;
  final isLoading = true.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;

  late String type;
  late String title;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    type = args?['type'] ?? 'articles';
    title = args?['title'] ?? 'Berita Terkini';
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    isError.value = false;

    try {
      final data = await ApiService.fetchList(type);
      articles.assignAll(data);
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
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

  void goToDetail(int id) {
    String detailTitle = 'News Detail';
    if (type == 'blogs') detailTitle = 'Blog Detail';
    if (type == 'reports') detailTitle = 'Report Detail';

    Get.toNamed(Routes.DETAIL, arguments: {
      'type': type,
      'id': id,
      'title': detailTitle,
    });
  }
}
