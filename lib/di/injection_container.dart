import 'package:get/get.dart';
import 'package:getx_starter/data/datasources/remote/auth_remote_datasource.dart';
import 'package:getx_starter/data/repositories/auth_repository_impl.dart';
import 'package:getx_starter/domain/repositories/auth_repository.dart';
import 'package:getx_starter/domain/usecases/login_usecase.dart';
import 'package:getx_starter/domain/usecases/register_usecase.dart';

/// Registers all dependencies with GetX's service locator.
/// Call [InjectionContainer.init()] once in main() before runApp().
class InjectionContainer {
  static void init() {
    // Data sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
      fenix: true,
    );

    // Use cases
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<RegisterUseCase>(
      () => RegisterUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
  }
}
