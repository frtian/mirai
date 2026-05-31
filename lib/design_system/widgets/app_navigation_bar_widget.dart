import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';

class AppNavigationBarItem {
  const AppNavigationBarItem({
    required this.label,
    required this.icon,
    this.hasNotification = false,
  });

  final String label;
  final IconData icon;
  final bool hasNotification;
}

class AppNavigationBarWidget extends StatelessWidget {
  const AppNavigationBarWidget({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final List<AppNavigationBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == selectedIndex;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onItemSelected(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primarySoft : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            item.icon,
                            size: 24,
                            color: isSelected ? AppColors.onPrimary : AppColors.footerText,
                          ),
                          if (item.hasNotification)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: isSelected
                          ? AppTextStyles.link.copyWith(
                              color: AppColors.primarySoft,
                              fontSize: 12,
                            )
                          : AppTextStyles.footerText.copyWith(
                              fontSize: 12,
                              color: AppColors.footerText,
                            ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}