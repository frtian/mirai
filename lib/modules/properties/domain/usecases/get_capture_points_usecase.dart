import '../entities/capture_point_entity.dart';
import '../repositories/capture_point_repository.dart';

class GetCapturePointsUseCase {
  GetCapturePointsUseCase({required this.repository});

  final CapturePointRepository repository;

  Future<List<CapturePointEntity>> call(String ownerId) async {
    return repository.getCapturePointsForOwner(ownerId);
  }
}
