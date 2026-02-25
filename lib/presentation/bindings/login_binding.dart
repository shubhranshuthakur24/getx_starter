import 'package:get/get.dart';
import 'package:getx_starter/domain/usecases/login_usecase.dart';
import 'package:getx_starter/presentation/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<LoginUseCase>()),
    );
  }
}
