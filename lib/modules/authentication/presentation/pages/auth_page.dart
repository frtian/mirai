import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/app_colors.dart';
import '../controller/auth_page_contrller.dart';
import '../widgets/auth_page_actions_widget.dart';
import '../widgets/auth_page_code_field_widget.dart';
import '../widgets/auth_page_footer_widget.dart';
import '../widgets/auth_page_header_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.onCodeSubmitted});

  final Future<void> Function(String code)? onCodeSubmitted;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final AuthPageContrller _controller;

  @override
  void initState() {
    super.initState();
    _controller = AuthPageContrller(onCodeSubmitted: widget.onCodeSubmitted)
      ..addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleSubmit() {
    // Navegação direta e simples para a home
    final ownerCode = _controller.codeController.text.trim();
    final code = ownerCode.isEmpty ? 'demo-user' : ownerCode;
    context.go('/home?ownerCode=$code');
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthPageHeaderWidget(),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthPageCodeFieldWidget(
                            controller: _controller,
                            onSubmitted: _handleSubmit,
                          ),
                          const SizedBox(height: 24),
                          AuthPageActionsWidget(
                            controller: _controller,
                            onSubmit: _handleSubmit,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const AuthPageFooterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
