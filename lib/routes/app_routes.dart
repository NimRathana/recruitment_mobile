import 'package:get/get.dart';
import '../views/bottom_navigation/appearance_view.dart';
import '../views/home_view.dart';
import '../views/login_view.dart';

abstract class Routes {
  static const login = '/login';
  static const home = '/home';
  static const appearance = '/appearance';
}

class AppPages {
  static final routes = [
    GetPage(name: Routes.login, page: () => LoginView()),
    GetPage(name: Routes.home, page: () => HomeView()),
    GetPage(name: Routes.appearance, page: () => AppearanceView()),
  ];
}