import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/theme_project.dart';

/// بطاقة عرض ثيم محفوظ
class ThemeCard extends StatefulWidget {
  final ThemeProject project;
  final VoidCallback? onTap;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final bool compact;

  const ThemeCard({
    super.key,
    required this.project,
    this.onTap,
    this.onDuplicate,
    this.onDelete,
    this.compact = false,
  });

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.fast,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) return _buildCompact();

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedScale(
        scale: _controller.isAnimating ? 0.97 : 1.0,
        duration: AppAnimations.fast,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.darkContainer,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildThumbnail(),
                const SizedBox(width: 12),
                Expanded(child: _buildInfo()),
                _buildMenu(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompact() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: AppColors.darkContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildThumbnailFull()),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.project.name,
                    style: const TextStyle(
                      color: AppColors.textDarkPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.project.author,
                    style: const TextStyle(
                      color: AppColors.textDarkHint,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.project.keyboardContainer,
            widget.project.keyboardPress,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.project.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.project.primary.withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: widget.project.primary,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailFull() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.project.keyboardContainer,
            widget.project.keyboardPress,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: widget.project.primary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: widget.project.primary.withValues(alpha: 0.5),
                blurRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.project.name,
          style: const TextStyle(
            color: AppColors.textDarkPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          widget.project.author,
          style: const TextStyle(
            color: AppColors.textDarkHint,
            fontSize: 11,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _miniStat(Icons.palette, '${widget.project.groups.length}'),
            const SizedBox(width: 10),
            _miniStat(Icons.schedule, _timeAgo(widget.project.updatedAt)),
          ],
        ),
      ],
    );
  }

  Widget _buildMenu() {
    if (widget.onDuplicate == null && widget.onDelete == null) {
      return const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.textDarkHint,
      );
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.textDarkHint),
      color: AppColors.darkContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      onSelected: (v) {
        switch (v) {
          case 'duplicate':
            widget.onDuplicate?.call();
            break;
          case 'delete':
            widget.onDelete?.call();
            break;
        }
      },
      itemBuilder: (_) => [
        if (widget.onDuplicate != null)
          const PopupMenuItem(
            value: 'duplicate',
            child: Row(
              children: [
                Icon(Icons.copy, size: 16, color: AppColors.primary),
                SizedBox(width: 8),
                Text('نسخ', style: TextStyle(color: AppColors.textDarkPrimary)),
              ],
            ),
          ),
        if (widget.onDelete != null)
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                SizedBox(width: 8),
                Text('حذف', style: TextStyle(color: AppColors.error)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _miniStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 11, color: AppColors.textDarkHint),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDarkHint,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}ي';
    if (diff.inHours > 0) return '${diff.inHours}س';
    if (diff.inMinutes > 0) return '${diff.inMinutes}د';
    return 'الآن';
  }
}
