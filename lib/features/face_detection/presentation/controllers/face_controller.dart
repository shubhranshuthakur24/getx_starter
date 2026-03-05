import 'dart:io';
import 'package:get/get.dart';
import '../../domain/usecases/generate_face_embedding_usecase.dart';
import '../../domain/usecases/verify_face_usecase.dart';

class FaceController extends GetxController {
  final GenerateFaceEmbeddingUseCase generateUsecase;
  final VerifyFaceUseCase verifyUsecase;

  FaceController({required this.generateUsecase, required this.verifyUsecase});

  RxBool isLoading = false.obs;

  Future<void> registerFace(String userId, File image) async {
    isLoading.value = true;

    final embedding = await generateUsecase(image);
    await verifyUsecase.repository.saveEmbedding(userId, embedding);

    isLoading.value = false;
  }

  Future<bool> verify(String userId, File image) async {
    isLoading.value = true;
    final result = await verifyUsecase(userId, image);
    isLoading.value = false;
    return result;
  }
}
