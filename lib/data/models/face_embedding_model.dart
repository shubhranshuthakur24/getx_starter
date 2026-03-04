import '../../domain/entities/face_embedding_entity.dart';

class FaceEmbeddingModel extends FaceEmbeddingEntity {
  FaceEmbeddingModel(List<double> vector) : super(vector);

  Map<String, dynamic> toJson() => {"embedding": vector};
  factory FaceEmbeddingModel.fromJson(Map<String, dynamic> json) {
    return FaceEmbeddingModel(List<double>.from(json["embedding"]));
  }
}
