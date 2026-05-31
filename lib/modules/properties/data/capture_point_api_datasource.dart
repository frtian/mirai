import 'package:dio/dio.dart';
import 'capture_point_model.dart';

class CapturePointApiDatasource {
  CapturePointApiDatasource({required this.dio});

  final Dio dio;

  /// Fetch capture points for the given owner identifier.
  /// Expects a JSON array of capture point objects.
  Future<List<CapturePointModel>> fetchCapturePoints(String ownerId) async {
    final response = await dio.get<List<dynamic>>('/owners/$ownerId/capture-points');
    final data = response.data ?? <dynamic>[];

    return data
        .whereType<Map<String, dynamic>>()
        .map((m) => CapturePointModel.fromMap(m))
        .toList();
  }
}
