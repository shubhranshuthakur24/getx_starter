import 'package:get/get.dart';
import 'package:getx_starter/features/auth/presentation/bindings/login_binding.dart';
import 'package:getx_starter/features/auth/presentation/views/login/login_page.dart';
import 'package:getx_starter/routes/app_routes.dart';

import '../features/auth/presentation/bindings/register_binding.dart';
import '../features/auth/presentation/views/signup/register_page.dart';


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

  ];
}
