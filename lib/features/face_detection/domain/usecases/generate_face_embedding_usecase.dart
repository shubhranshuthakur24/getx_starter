import 'dart:io';
import '../repos/face_repository.dart';

class GenerateFaceEmbeddingUseCase {
  final FaceRepository repository;

  GenerateFaceEmbeddingUseCase(this.repository);

  Future<List<double>> call(File image) {
    return repository.generateEmbedding(image);
  }
}
