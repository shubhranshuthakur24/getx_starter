import 'package:get/get.dart';
import 'package:getx_starter/domain/usecases/register_usecase.dart';
import 'package:getx_starter/presentation/controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(Get.find<RegisterUseCase>()),
    );
  }
}
