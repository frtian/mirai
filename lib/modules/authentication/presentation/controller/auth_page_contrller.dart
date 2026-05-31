import 'package:flutter/material.dart';

class AuthPageContrller extends ChangeNotifier {
  AuthPageContrller({this.onCodeSubmitted});

  final Future<void> Function(String code)? onCodeSubmitted;
  final TextEditingController codeController = TextEditingController();

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  // Método submit simplificado para não quebrar referências, 
  // mas a navegação agora é direta na UI.
  Future<bool> submit() async {
    return true;
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}
