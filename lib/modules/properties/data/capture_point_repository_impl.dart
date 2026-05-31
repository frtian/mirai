import 'package:mirai/modules/properties/domain/entities/capture_point_entity.dart';
import 'package:mirai/modules/properties/domain/repositories/capture_point_repository.dart';
import 'capture_point_api_datasource.dart';

class CapturePointRepositoryImpl implements CapturePointRepository {
  CapturePointRepositoryImpl({required this.datasource});

  final CapturePointApiDatasource datasource;

  @override
  Future<List<CapturePointEntity>> getCapturePointsForOwner(String ownerId) async {
    final models = await datasource.fetchCapturePoints(ownerId);
    return models;
  }
}
