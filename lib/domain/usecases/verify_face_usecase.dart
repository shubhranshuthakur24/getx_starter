import 'dart:io';
import '../repositories/face_repository.dart';

class VerifyFaceUseCase {
  final FaceRepository repository;

  VerifyFaceUseCase(this.repository);

  Future<bool> call(String userId, File image) {
    return repository.verifyFace(userId, image);
  }
}
