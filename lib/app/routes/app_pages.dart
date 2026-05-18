import 'package:get/get.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/register/register_binding.dart';
import '../modules/register/register_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/list/list_binding.dart';
import '../modules/list/list_view.dart';
import '../modules/detail/detail_binding.dart';
import '../modules/detail/detail_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LIST,
      page: () => const ArticleListView(),
      binding: ListBinding(),
    ),
    GetPage(
      name: Routes.DETAIL,
      page: () => const DetailView(),
      binding: DetailBinding(),
    ),
  ];
}