import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/widgets/app_bar_widget.dart';
import '../controller/home_page_controller.dart';
import '../widgets/home_page_capture_point_alert.dart';
import '../widgets/home_page_empty_state_widget.dart';
import '../widgets/home_page_header_widget.dart';
import '../widgets/home_page_properties_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.ownerIdentifier});

  final String ownerIdentifier;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomePageController(ownerIdentifier: widget.ownerIdentifier)
      ..addListener(_onControllerChanged)
      ..load();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _controller.viewData;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget.brand(
        brandLabel: 'ARARA',
        leadingIcon: Icons.home_outlined,
        trailing: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.person_outline, color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _controller.load,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: _buildBody(constraints.maxHeight, data),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(double minHeight, HomePageViewData? data) {
    if (_controller.isLoading && data == null) {
      return SizedBox(
        height: minHeight,
        child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (data == null) {
      return SizedBox(
        height: minHeight,
        child: HomePageEmptyStateWidget(
          message: _controller.errorMessage ?? 'Nenhum dado disponivel para o proprietario.',
          onRetry: _controller.load,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomePageHeaderWidget(data: data),
        if (data.hasPendingCapturePoint) ...[
          const SizedBox(height: 20),
          HomePageCapturePointAlertWidget(
            deadlineLabel: data.nextCaptureDeadline,
            onTap: () => context.push('/navigation'),
          ),
        ],
        const SizedBox(height: 20),
        HomePagePropertiesWidget(properties: data.properties),
      ],
    );
  }
}