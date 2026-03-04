import 'dart:io';
import '../repositories/face_repository.dart';

class GeneratedFaceEmbeddingUseCase {
  final FaceRepository repository;

  GeneratedFaceEmbeddingUseCase(this.repository);

  Future<List<double>> call(File image) {
    return repository.generatedEmbedding(image);
  }
}
