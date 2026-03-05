import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repos/face_repository.dart';
import '../sources/local/face_local_datasource.dart';

class FaceRepositoryImpl implements FaceRepository {
  final FaceLocalDatasource datasource;
  final FirebaseFirestore firestore;

  FaceRepositoryImpl(this.datasource, this.firestore);

  @override
  Future<List<double>> generateEmbedding(File image) {
    return datasource.generateEmbedding(image);
  }

  @override
  Future<void> saveEmbedding(String userId, List<double> embedding) async {
    await firestore.collection('users').doc(userId).update({
      "face_embedding": embedding,
    });
  }

  @override
  Future<bool> verifyFace(String userId, File image) async {
    final newEmbedding = await datasource.generateEmbedding(image);
    final doc = await firestore.collection('users').doc(userId).get();
    final storedEmbedding = List<double>.from(doc.data()?['face_embedding']);
    final similarity = _cosineSimilarity(newEmbedding, storedEmbedding);
    return similarity > 0.7;
  }

  double _cosineSimilarity(List<double> e1, List<double> e2) {
    double dot = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < e1.length; i++) {
      dot += e1[i] * e1[i];
      norm1 += e1[i] * e1[i];
      norm2 += e2[i] * e2[i];
    }
    return dot / (sqrt(norm1) * sqrt(norm2));
  }
}
