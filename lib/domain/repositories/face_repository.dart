import 'dart:io';

abstract class FaceRepository {
  Future<List<double>> generatedEmbedding(File image);
  Future<bool> verifyFace(String userId, File image);
  Future<void> saveEmbedding(String userId, List<double> embedding);
}
