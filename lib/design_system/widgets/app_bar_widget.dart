import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget.brand({
    super.key,
    this.brandLabel,
    this.brandLogoPath,
    this.onLeadingPressed,
    this.leadingIcon = Icons.menu,
    this.trailing,
    this.backgroundColor = AppColors.background,
    this.leadingIconColor = AppColors.primary,
    this.brandStyle = AppTextStyles.brand,
    this.leadingWidth = 152,
    this.toolbarHeight = kToolbarHeight,
  }) : title = null,
       titleStyle = null,
       centerTitle = false;

  const AppBarWidget.page({
    super.key,
    required this.title,
    this.onLeadingPressed,
    this.leadingIcon = Icons.arrow_back,
    this.trailing,
    this.backgroundColor = AppColors.background,
    this.leadingIconColor = AppColors.primary,
    this.titleStyle = AppTextStyles.appBarTitle,
    this.leadingWidth = 56,
    this.toolbarHeight = kToolbarHeight,
    this.centerTitle = true,
  }) : brandLabel = null,
       brandStyle = null,
       brandLogoPath = null;

  final String? brandLabel;
  final String? brandLogoPath;
  final String? title;
  final VoidCallback? onLeadingPressed;
  final IconData leadingIcon;
  final Widget? trailing;
  final Color backgroundColor;
  final Color leadingIconColor;
  final TextStyle? brandStyle;
  final TextStyle? titleStyle;
  final double leadingWidth;
  final double toolbarHeight;
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final brandMode = brandLabel != null || brandLogoPath != null;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      foregroundColor: AppColors.primaryStrong,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      toolbarHeight: toolbarHeight,
      titleSpacing: 0,
      centerTitle: centerTitle,
      leadingWidth: leadingWidth,
      leading: brandMode
          ? _buildBrandLeading(context)
          : _buildIconLeading(context),
      title: title == null
          ? null
          : Text(
              title!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
            ),
      actions: trailing == null
          ? null
          : [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Center(child: trailing),
              ),
            ],
    );
  }

  Widget _buildIconLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        onPressed: onLeadingPressed,
        icon: Icon(leadingIcon, color: leadingIconColor),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      ),
    );
  }

  Widget _buildBrandLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkResponse(
          onTap: onLeadingPressed,
          radius: 28,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(leadingIcon, color: leadingIconColor, size: 26),
              const SizedBox(width: 10),
              if (brandLogoPath != null)
                Image.asset(
                  brandLogoPath!,
                  height: 52,
                  errorBuilder: (context, _, __) =>
                      Text(brandLabel ?? '', style: brandStyle),
                )
              else if (brandLabel != null)
                Text(brandLabel!, style: brandStyle),
            ],
          ),
        ),
      ),
    );
  }
}
