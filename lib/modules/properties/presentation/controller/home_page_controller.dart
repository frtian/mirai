import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mirai/modules/properties/data/capture_point_api_datasource.dart';
import 'package:mirai/modules/properties/data/capture_point_repository_impl.dart';
import 'package:mirai/modules/properties/domain/usecases/get_capture_points_usecase.dart';

class HomePageController extends ChangeNotifier {
  HomePageController({
    required this.ownerIdentifier,
    Dio? dio,
    this.useMock = true,
    this.loader,
  }) : _dio = dio ?? Dio();

  final String ownerIdentifier;
  final Dio _dio;
  final bool useMock;
  final Future<HomePageViewData> Function(String ownerIdentifier, Dio dio)?
  loader;

  bool _isLoading = true;
  String? _errorMessage;
  HomePageViewData? _viewData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  HomePageViewData? get viewData => _viewData;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final customLoader = loader;
      _viewData = customLoader != null
          ? await customLoader(ownerIdentifier, _dio)
          : await _loadDashboard();
    } catch (_) {
      _errorMessage = 'Nao foi possivel carregar os dados da propriedade.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<HomePageViewData> _loadDashboard() async {
    if (useMock) {
      return _buildMockDashboard(ownerIdentifier);
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '/owners/$ownerIdentifier/home',
    );

    final Map<String, dynamic> base = Map<String, dynamic>.from(
      response.data ?? <String, dynamic>{},
    );

    // Attempt to sync capture points from backend. Failure should not block dashboard rendering.
    try {
      final datasource = CapturePointApiDatasource(dio: _dio);
      final repository = CapturePointRepositoryImpl(datasource: datasource);
      final usecase = GetCapturePointsUseCase(repository: repository);

      final capturePoints = await usecase.call(ownerIdentifier);

      final pending = capturePoints.where((c) => c.needsEvidence).toList();

      base['hasPendingCapturePoint'] = pending.isNotEmpty;

      if (pending.isNotEmpty) {
        final dates = pending.map((p) => p.nextCaptureAt).whereType<DateTime>();
        if (dates.isNotEmpty) {
          final earliest = dates.reduce((a, b) => a.isBefore(b) ? a : b);
          final d = earliest.toLocal();
          base['nextCaptureDeadline'] =
              '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} • ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
        }
      }
    } catch (_) {
      // ignore capture point sync errors — dashboard still renders with server-provided data
    }

    return HomePageViewData.fromMap(base);
  }

  HomePageViewData _buildMockDashboard(String ownerCode) {
    final sanitizedCode = ownerCode.trim().isEmpty ? '001' : ownerCode.trim();

    return HomePageViewData(
      greeting: 'Bem-vindo de volta',
      ownerName: 'Sr. José Pires',
      ownerRegion: 'Polo Sul • Monitoramento ambiental ativo',
      highlightLabel: '3 propriedades vinculadas',
      lastSyncLabel: 'Atualizado ha 5 minutos',
      hasPendingCapturePoint: true,
      nextCaptureDeadline: '31/05/2026 • 15:30',
      stats: const [
        HomePageStat(
          label: 'Area monitorada',
          value: '231 ha',
          detail: 'Cobertura consolidada',
        ),
        HomePageStat(
          label: 'Alertas ativos',
          value: '08',
          detail: '2 criticos pendentes',
        ),
        HomePageStat(
          label: 'Planos em curso',
          value: '04',
          detail: 'Recuperacao acompanhada',
        ),
      ],
      properties: const [
        HomePropertyCardData(
          name: 'Fazenda Boa Esperanca',
          location: 'Paragominas • PA',
          areaLabel: '128 ha',
          statusLabel: 'Monitoramento ativo',
          progressLabel: 'Recuperacao 72%',
          progressValue: 0.72,
          alertCount: 3,
        ),
        HomePropertyCardData(
          name: 'Sitio Lago Verde',
          location: 'Ulianopolis • PA',
          areaLabel: '64 ha',
          statusLabel: 'Vistoria agendada',
          progressLabel: 'Plano tecnico 48%',
          progressValue: 0.48,
          alertCount: 1,
        ),
        HomePropertyCardData(
          name: 'Chacara Horizonte',
          location: 'Dom Eliseu • PA',
          areaLabel: '39 ha',
          statusLabel: 'Sem alertas recentes',
          progressLabel: 'Cobertura validada 91%',
          progressValue: 0.91,
          alertCount: 0,
        ),
      ],
      actions: const [
        HomeQuickActionData(
          label: 'Navegacao',
          description: 'Acessar rota guiada',
          icon: Icons.explore_outlined,
        ),
        HomeQuickActionData(
          label: 'Evidencias',
          description: 'Registrar nova captura',
          icon: Icons.camera_alt_outlined,
        ),
        HomeQuickActionData(
          label: 'Alertas',
          description: 'Consultar pendencias',
          icon: Icons.warning_amber_rounded,
        ),
      ],
    );
  }
}

class HomePageViewData {
  const HomePageViewData({
    required this.greeting,
    required this.ownerName,
    required this.ownerRegion,
    required this.highlightLabel,
    required this.lastSyncLabel,
    required this.hasPendingCapturePoint,
    required this.nextCaptureDeadline,
    required this.stats,
    required this.properties,
    required this.actions,
  });

  final String greeting;
  final String ownerName;
  final String ownerRegion;
  final String highlightLabel;
  final String lastSyncLabel;
  final bool hasPendingCapturePoint;
  final String nextCaptureDeadline;
  final List<HomePageStat> stats;
  final List<HomePropertyCardData> properties;
  final List<HomeQuickActionData> actions;

  factory HomePageViewData.fromMap(Map<String, dynamic> map) {
    return HomePageViewData(
      greeting: map['greeting'] as String? ?? 'Bem-vindo',
      ownerName: map['ownerName'] as String? ?? 'Proprietario',
      ownerRegion: map['ownerRegion'] as String? ?? 'Sem regiao definida',
      highlightLabel:
          map['highlightLabel'] as String? ?? '0 propriedades vinculadas',
      lastSyncLabel:
          map['lastSyncLabel'] as String? ?? 'Sem atualizacao registrada',
      hasPendingCapturePoint: map['hasPendingCapturePoint'] as bool? ?? false,
      nextCaptureDeadline:
          map['nextCaptureDeadline'] as String? ?? 'Sem prazo definido',
      stats: (map['stats'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(HomePageStat.fromMap)
          .toList(),
      properties: (map['properties'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(HomePropertyCardData.fromMap)
          .toList(),
      actions: (map['actions'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(HomeQuickActionData.fromMap)
          .toList(),
    );
  }
}

class HomePageStat {
  const HomePageStat({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  factory HomePageStat.fromMap(Map<String, dynamic> map) {
    return HomePageStat(
      label: map['label'] as String? ?? '',
      value: map['value'] as String? ?? '',
      detail: map['detail'] as String? ?? '',
    );
  }
}

class HomePropertyCardData {
  const HomePropertyCardData({
    required this.name,
    required this.location,
    required this.areaLabel,
    required this.statusLabel,
    required this.progressLabel,
    required this.progressValue,
    required this.alertCount,
  });

  final String name;
  final String location;
  final String areaLabel;
  final String statusLabel;
  final String progressLabel;
  final double progressValue;
  final int alertCount;

  factory HomePropertyCardData.fromMap(Map<String, dynamic> map) {
    return HomePropertyCardData(
      name: map['name'] as String? ?? '',
      location: map['location'] as String? ?? '',
      areaLabel: map['areaLabel'] as String? ?? '',
      statusLabel: map['statusLabel'] as String? ?? '',
      progressLabel: map['progressLabel'] as String? ?? '',
      progressValue: (map['progressValue'] as num? ?? 0).toDouble(),
      alertCount: map['alertCount'] as int? ?? 0,
    );
  }
}

class HomeQuickActionData {
  const HomeQuickActionData({
    required this.label,
    required this.description,
    required this.icon,
  });

  final String label;
  final String description;
  final IconData icon;

  factory HomeQuickActionData.fromMap(Map<String, dynamic> map) {
    return HomeQuickActionData(
      label: map['label'] as String? ?? '',
      description: map['description'] as String? ?? '',
      icon: Icons.circle_outlined,
    );
  }
}
