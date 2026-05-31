import '../entities/capture_point_entity.dart';

abstract class CapturePointRepository {
  Future<List<CapturePointEntity>> getCapturePointsForOwner(String ownerId);
}
