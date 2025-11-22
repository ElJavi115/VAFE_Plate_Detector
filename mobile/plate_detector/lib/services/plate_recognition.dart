import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import 'package:paddle_ocr/paddle_ocr.dart';
import 'package:paddle_ocr/bean/ocr_results.dart';
import 'package:paddle_ocr/bean/ocr_result.dart';


class PlateRecognitionResult {
  final String plateText;

  final String ocrImagePath;

  final OcrResultInfo? rawOcrResult;

  PlateRecognitionResult({
    required this.plateText,
    required this.ocrImagePath,
    required this.rawOcrResult,
  });
}

class PlateRecognitionPipeline {

  Future<void> preload() async {
    await _init();
  }

  PlateRecognitionPipeline._internal();
  static final PlateRecognitionPipeline instance =
      PlateRecognitionPipeline._internal();

  // === CONFIGURA AQUÍ TU MODELO TFLITE ===
  static const String _detectorModelAsset =
      'assets/models/plate_detector_int8.tflite';

  tfl.Interpreter? _detector;
  List<int>? _inputShape;
  List<int>? _outputShape;
  tfl.TfLiteType? _inputType;
  tfl.TfLiteType? _outputType;

  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;

    try {
      final options = tfl.InterpreterOptions()
        ..threads = 2; 

      _detector = await tfl.Interpreter.fromAsset(
        _detectorModelAsset,
        options: options,
      );

      final inputTensor = _detector!.getInputTensor(0);
      final outputTensor = _detector!.getOutputTensor(0);

      _inputShape = inputTensor.shape;
      _outputShape = outputTensor.shape;
      _inputType = inputTensor.type as tfl.TfLiteType?;
      _outputType = outputTensor.type as tfl.TfLiteType?;

      debugPrint('TFLite detector cargado:');
      debugPrint('  inputShape:  $_inputShape');
      debugPrint('  outputShape: $_outputShape');
      debugPrint('  inputType:   $_inputType');
      debugPrint('  outputType:  $_outputType');

      _initialized = true;
    } catch (e, st) {
      debugPrint('Error inicializando modelo TFLite: $e');
      debugPrint('$st');
    }
  }

  /// Punto de entrada principal:
  /// - Recibe una foto (File),
  /// - Opcional: intenta detectar región de placa con TFLite,
  /// - Ejecuta PaddleOCR sobre la región seleccionada,
  /// - Devuelve `PlateRecognitionResult` con la placa.
  Future<PlateRecognitionResult?> recognizePlateFromImage(File imageFile) async {
    await _init();

    // 1. Decodificar imagen
    final bytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      debugPrint('No se pudo decodificar la imagen');
      return null;
    }

    // 2. Intentar obtener recorte de la placa mediante el modelo TFLite
    //    Por ahora, dejamos un stub que devuelve null (usa imagen completa).
    final plateRegion = await _detectPlateRegion(decoded);

    final regionForOcr = plateRegion ?? decoded;

    // 3. Guardar la región en un archivo temporal para usar con PaddleOCR
    final tempDir = await getTemporaryDirectory();
    final ocrFile = File(
      '${tempDir.path}/plate_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final regionJpg = img.encodeJpg(regionForOcr, quality: 95);
    ocrFile
      ..create(recursive: true)
      ..writeAsBytes(regionJpg);

    // 4. Ejecutar PaddleOCR
    final ocrMap = await PaddleOcr.ocrFromImage(
      ocrFile.path,
      isRotate: false,
      isPrint: false,
      ocr_type: 'OTHER', // podrías cambiarlo según el caso
    );

    if (ocrMap is! Map) {
      debugPrint('Respuesta inesperada de PaddleOCR: $ocrMap');
      return null;
    }

    if (ocrMap['success'] != true) {
      debugPrint('PaddleOCR falló: ${ocrMap['message']}');
      return null;
    }

    final dynamic rawOcr = ocrMap['ocrResult'];

    // El plugin ya convierte a OcrResultInfo internamente
    final OcrResultInfo? resultInfo =
        rawOcr is OcrResultInfo ? rawOcr : null;

    final List<OcrResult> results = resultInfo?.ocrResults ?? const [];

    if (results.isEmpty) {
      debugPrint('PaddleOCR no encontró texto');
      return null;
    }

    // 5. Juntar todo el texto detectado
    final rawText =
        results.map((r) => (r.name ?? '').trim()).where((t) => t.isNotEmpty).join(' ');

    return PlateRecognitionResult(
      plateText: rawText,
      ocrImagePath: ocrFile.path,
      rawOcrResult: resultInfo,
    );
  }

  Future<img.Image?> _detectPlateRegion(img.Image original) async {
    if (_detector == null || _inputShape == null || _outputShape == null) {
      return null;
    }


    try {
      final h = _inputShape![1];
      final w = _inputShape![2];
      final channels = _inputShape!.length > 3 ? _inputShape![3] : 3;

      final resized = img.copyResize(
        original,
        width: w,
        height: h,
        interpolation: img.Interpolation.nearest,
      );

      final input = List.generate(
        1,
        (_) => List.generate(
          h,
          (y) => List.generate(
            w,
            (x) {
              final pixel = resized.getPixel(x, y);
              final r = img.getRed(pixel);
              final g = img.getGreen(pixel);
              final b = img.getBlue(pixel);

              if (channels == 1) {
                final gray = ((r + g + b) / 3).round();
                return gray - 128;
              } else {
                return <int>[
                  r - 128,
                  g - 128,
                  b - 128,
                ];
              }
            },
          ),
        ),
      );

      final totalOutputSize =
          _outputShape!.fold<int>(1, (prev, dim) => prev * dim);

      final output = List<int>.filled(totalOutputSize, 0);

      _detector!.run(input, output);
      return null;
    } catch (e, st) {
      debugPrint('Error ejecutando detector TFLite: $e');
      debugPrint('$st');
      return null;
    }
  }
}
