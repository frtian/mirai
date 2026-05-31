import 'package:flutter/material.dart';

import '../../../../design_system/app_text_styles.dart';

class HomePageCapturePointAlertWidget extends StatelessWidget {
  const HomePageCapturePointAlertWidget({
    super.key,
    required this.deadlineLabel,
    required this.onTap,
  });

  final String deadlineLabel;
  final VoidCallback onTap;

  static const Color _alertBackground = Color(0xFFFFF3D5);
  static const Color _alertBorder = Color(0xFFF4C97B);
  static const Color _alertTitle = Color(0xFF7A4E00);
  static const Color _alertBody = Color(0xFF8A620F);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          decoration: BoxDecoration(
            color: _alertBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _alertBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _alertBorder.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: _alertTitle,
                  size: 36,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data da proxima captura',
                      style: AppTextStyles.link.copyWith(
                        color: _alertTitle,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deadlineLabel,
                      style: AppTextStyles.link.copyWith(
                        color: _alertBody,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: _alertTitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
