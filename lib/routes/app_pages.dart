import 'package:get/get.dart';
import 'package:getx_starter/presentation/bindings/login_binding.dart';
import 'package:getx_starter/presentation/bindings/register_binding.dart';
import 'package:getx_starter/presentation/pages/home/home_page.dart';
import 'package:getx_starter/presentation/pages/login/login_page.dart';
import 'package:getx_starter/presentation/pages/register/register_page.dart';
import 'package:getx_starter/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
  ];
}
