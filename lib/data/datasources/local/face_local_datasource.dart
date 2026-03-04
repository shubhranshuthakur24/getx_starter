import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

abstract class FaceLocalDatasource {
  Future<List<double>> generateEmbedding(File image);
}

class FaceLocalDatasourceImpl implements FaceLocalDatasource {
  late Interpreter _interpreter;

  FaceLocalDatasourceImpl() {
    _localModel();
  }
  Future<void> _localModel() async {
    _interpreter = await Interpreter.fromAsset("models/mobilefaenet.tflite");
  }

  @override
  Future<List<double>> generateEmbedding(File image) async {
    final inputImage = InputImage.fromFile(image);

    final detector = FaceDetector(
      options: FaceDetectorOptions(enableLandmarks: true),
    );
    final faces = await detector.processImage(inputImage);

    if (faces.isEmpty) {
      throw Exception("No face detected");
    }
    // Todo: Crop face properly here
    // Todo: Preprocess image to 112x112
    // Todo: Convert to Float32List

    return _generateEmbeddingFromModel();
  }

  List<double> _generateEmbeddingFromModel() {
    // Placeholder 192D vector

    final output = List.filled(192, 0.0);
    return output;
  }
}
