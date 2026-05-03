import 'package:get/get.dart';
import '../bindings/home_binding.dart';
import '../views/article_detail_page.dart';
import '../views/home_page.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.articleDetail,
      page: () => const ArticleDetailPage(),
    ),
  ];
}