import 'package:equatable/equatable.dart';

class CapturePointEntity extends Equatable {
  const CapturePointEntity({
    required this.id,
    required this.name,
    required this.hasEvidences,
    required this.evidencesCount,
    this.propertyName,
    this.nextCaptureAt,
  });

  final String id;
  final String name;
  final String? propertyName;
  final DateTime? nextCaptureAt;
  final bool hasEvidences;
  final int evidencesCount;

  bool get needsEvidence => !hasEvidences;

  @override
  List<Object?> get props => [
        id,
        name,
        propertyName,
        nextCaptureAt,
        hasEvidences,
        evidencesCount,
      ];
}
