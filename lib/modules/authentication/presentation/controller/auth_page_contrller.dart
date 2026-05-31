import 'package:flutter/material.dart';

class AuthPageContrller extends ChangeNotifier {
  AuthPageContrller({this.onCodeSubmitted});

  final Future<void> Function(String code)? onCodeSubmitted;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();

  bool _isSubmitting = false;
  String? _submissionError;

  bool get isSubmitting => _isSubmitting;
  String? get submissionError => _submissionError;

  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    _isSubmitting = true;
    _submissionError = null;
    notifyListeners();

    try {
      final callback = onCodeSubmitted;
      if (callback != null) {
        await callback(codeController.text.trim());
      }
      return true;
    } catch (_) {
      _submissionError = 'Nao foi possivel validar o acesso.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  String? validateCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o código recebido por e-mail.';
    }

    return null;
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}