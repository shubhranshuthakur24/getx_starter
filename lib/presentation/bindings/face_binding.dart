import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../data/datasources/local/face_local_datasource.dart';
import '../../data/repositories/face_repository_impl.dart';
import '../../domain/repositories/face_repository.dart';
import '../../domain/usecases/generate_face_embedding_usecase.dart';
import '../../domain/usecases/verify_face_usecase.dart';
import '../controllers/face_controller.dart';

class FaceBinding extends Bindings {
  @override
  void dependencies() {
    // Data source
    Get.lazyPut<FaceLocalDatasource>(
      () => FaceLocalDatasourceImpl(),
      fenix: true,
    );

    // Repository
    Get.lazyPut<FaceRepository>(
      () => FaceRepositoryImpl(
        Get.find<FaceLocalDatasource>(),
        FirebaseFirestore.instance,
      ),
      fenix: true,
    );

    // Use cases
    Get.lazyPut<GenerateFaceEmbeddingUseCase>(
      () => GenerateFaceEmbeddingUseCase(Get.find<FaceRepository>()),
      fenix: true,
    );
    Get.lazyPut<VerifyFaceUseCase>(
      () => VerifyFaceUseCase(Get.find<FaceRepository>()),
      fenix: true,
    );

    // Controller
    Get.lazyPut<FaceController>(
      () => FaceController(
        generateUsecase: Get.find<GenerateFaceEmbeddingUseCase>(),
        verifyUsecase: Get.find<VerifyFaceUseCase>(),
      ),
    );
  }
}
