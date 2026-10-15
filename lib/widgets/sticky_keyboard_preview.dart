import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/theme_project.dart';
import '../providers/theme_provider.dart';
import 'keyboard_preview.dart';

/// معاينة حية ثابتة (Sticky) في الأعلى
/// تستخدم في كل شاشات المحرر
class StickyKeyboardPreview extends StatefulWidget {
  final double scale;
  final bool collapsible;
  final double expandedHeight;
  final double collapsedHeight;

  const StickyKeyboardPreview({
    super.key,
    this.scale = 0.75,
    this.collapsible = true,
    this.expandedHeight = 240,
    this.collapsedHeight = 60,
  });

  @override
  State<StickyKeyboardPreview> createState() => _StickyKeyboardPreviewState();
}

class _StickyKeyboardPreviewState extends State<StickyKeyboardPreview>
    with SingleTickerProviderStateMixin {
  bool _collapsed = false;
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.normal,
    );
    _sizeAnimation = Tween<double>(
      begin: widget.expandedHeight,
      end: widget.collapsedHeight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.emphasized,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCollapse() {
    setState(() => _collapsed = !_collapsed);
    if (_collapsed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return AnimatedBuilder(
          animation: _sizeAnimation,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              child: Column(
                children: [
                  // شريط الرأس
                  _buildHeader(provider),
                  // المعاينة
                  AnimatedContainer(
                    duration: AppAnimations.normal,
                    height: _collapsed ? 0 : null,
                    child: AnimatedOpacity(
                      duration: AppAnimations.fast,
                      opacity: _collapsed ? 0 : 1,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: widget.expandedHeight,
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: KeyboardPreview(
                              project: provider.project,
                              scale: widget.scale,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(ThemeProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // مؤشر
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.neonCyan,
              shape: BoxShape.circle,
              boxShadow: AppColors.glow(AppColors.neonCyan, intensity: 0.6),
            ),
          ),
          const SizedBox(width: 8),
          // النص
          const Text(
            'معاينة حية',
            style: TextStyle(
              color: AppColors.textDarkHint,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          // الاسم
          Expanded(
            child: Text(
              provider.project.name,
              style: const TextStyle(
                color: AppColors.textDarkPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // حالة الحفظ
          _statusChip(provider),
          // زر الطي/التوسيع
          if (widget.collapsible)
            IconButton(
              icon: Icon(
                _collapsed ? Icons.expand_more : Icons.expand_less,
                color: AppColors.textDarkHint,
                size: 20,
              ),
              onPressed: _toggleCollapse,
              tooltip: _collapsed ? 'توسيع' : 'طي',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
        ],
      ),
    );
  }

  Widget _statusChip(ThemeProvider provider) {
    final isSaved = !provider.hasUnsavedChanges;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isSaved
            ? AppColors.neonGreen.withOpacity(0.15)
            : AppColors.warning.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSaved
              ? AppColors.neonGreen.withOpacity(0.4)
              : AppColors.warning.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: isSaved ? AppColors.neonGreen : AppColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isSaved ? 'محفوظ' : 'غير محفوظ',
            style: TextStyle(
              color: isSaved ? AppColors.neonGreen : AppColors.warning,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// معاينة صغيرة (Compact) لشاشات المكتبات
class CompactPreviewHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const CompactPreviewHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    this.actions,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: onBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            )
          else
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: color.withOpacity(0.4),
                ),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textDarkPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: AppColors.textDarkHint,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          ...?actions,
        ],
      ),
    );
  }
}
