import 'dart:io';
import '../repositories/face_repository.dart';

class GenerateFaceEmbeddingUseCase {
  final FaceRepository repository;

  GenerateFaceEmbeddingUseCase(this.repository);

  Future<List<double>> call(File image) {
    return repository.generateEmbedding(image);
  }
}
