import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../services/font_download_service.dart';
import '../services/font_service.dart';
import '../services/google_fonts_api.dart';

/// بطاقة خط قابلة للتنزيل (Google Fonts)
class GoogleFontCard extends StatelessWidget {
  final GoogleFont font;
  final bool isDownloaded;
  final bool isDownloading;
  final double? downloadProgress;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;
  final VoidCallback? onSelect;
  final bool isSelected;

  const GoogleFontCard({
    super.key,
    required this.font,
    this.isDownloaded = false,
    this.isDownloading = false,
    this.downloadProgress,
    this.onDownload,
    this.onDelete,
    this.onSelect,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppAnimations.fast,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.08),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Aa',
                    style: TextStyle(
                      fontFamily: isDownloaded ? font.family : null,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      font.family,
                      style: const TextStyle(
                        color: AppColors.textDarkPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _tag(font.categoryLabel, AppColors.neonPurple),
                        if (font.supportsArabic) ...[
                          const SizedBox(width: 6),
                          _tag('عربي', AppColors.neonGreen),
                        ],
                        if (font.isPopular) ...[
                          const SizedBox(width: 6),
                          _tag('شائع', AppColors.neonOrange),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              _buildAction(),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'بسم الله الرحمن الرحيم — ABCDEFG 12345',
              style: TextStyle(
                fontFamily: isDownloaded ? font.family : null,
                fontSize: 16,
                color: AppColors.textDarkPrimary,
                height: 1.5,
              ),
            ),
          ),
          if (isDownloading && downloadProgress != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: downloadProgress,
                minHeight: 4,
                backgroundColor: AppColors.darkDivider,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAction() {
    if (isDownloading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation(AppColors.primary),
        ),
      );
    }

    if (isDownloaded) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            const Icon(Icons.check_circle, color: AppColors.neonGreen, size: 24)
          else if (onSelect != null)
            IconButton(
              onPressed: onSelect,
              icon: const Icon(Icons.touch_app,
                  color: AppColors.primary, size: 22),
              tooltip: 'استخدام',
            ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.error, size: 20),
              tooltip: 'حذف',
            ),
        ],
      );
    }

    return IconButton(
      onPressed: onDownload,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.download,
          color: AppColors.primary,
          size: 20,
        ),
      ),
      tooltip: 'تنزيل',
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// بطاقة خط محلي (مدمج أو مخصص)
class LocalFontCard extends StatelessWidget {
  final String family;
  final String displayName;
  final String? subtitle;
  final bool isSelected;
  final bool isCustom;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const LocalFontCard({
    super.key,
    required this.family,
    required this.displayName,
    this.subtitle,
    this.isSelected = false,
    this.isCustom = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  'Aa',
                  style: TextStyle(
                    fontFamily: family,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      color: AppColors.textDarkPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: AppColors.textDarkHint,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: AppColors.neonGreen, size: 22),
            if (isCustom && onDelete != null && !isSelected)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
