import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../models/key_shape.dart';
import '../providers/theme_provider.dart';
import '../widgets/color_picker_dialog.dart';
import '../widgets/glass_card.dart';
import '../widgets/shape_picker_grid.dart';

/// تبويب الأزرار — تحكم فردي بكل مجموعة
class KeysTab extends StatelessWidget {
  const KeysTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppColors.neonCyan, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تحكم بكل مجموعة على حدة',
                      style: TextStyle(
                        color: AppColors.textDarkSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...provider.project.groups
                .map((g) => _groupCard(context, provider, g)),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _groupCard(BuildContext context, ThemeProvider provider, dynamic group) {
    final border = group.border;
    final pressedBorder = group.pressedBorder;
    final longPressBorder = group.longPressBorder;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        glowColor: group.enabled ? AppColors.neonCyan : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (border?.backgroundTint ?? AppColors.neonCyan)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: border?.borderColor ?? AppColors.neonCyan,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (border?.backgroundTint ?? AppColors.neonCyan)
                            .withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _groupIcon(group.selector),
                      color: border?.foregroundTint ?? AppColors.neonCyan,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          color: AppColors.textDarkPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'selector: ${group.selector}',
                        style: const TextStyle(
                          color: AppColors.textDarkHint,
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: group.enabled,
                  onChanged: (_) => provider.toggleGroupEnabled(group.id),
                ),
              ],
            ),
            if (group.enabled) ...[
              const Divider(height: 20),
              if (border != null) ...[
                _subsectionTitle('الألوان'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ColorSwatchButton(
                        color: border.backgroundTint,
                        label: 'الخلفية',
                        size: 46,
                        onTap: () async {
                          final picked = await ColorPickerDialog.show(
                            context,
                            initialColor: border.backgroundTint,
                            title: 'خلفية ${group.name}',
                          );
                          if (picked != null) {
                            provider.setGroupBorder(
                              group.id,
                              border.copyWith(backgroundTint: picked),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ColorSwatchButton(
                        color: border.foregroundTint,
                        label: 'النص',
                        size: 46,
                        onTap: () async {
                          final picked = await ColorPickerDialog.show(
                            context,
                            initialColor: border.foregroundTint,
                            title: 'نص ${group.name}',
                          );
                          if (picked != null) {
                            provider.setGroupBorder(
                              group.id,
                              border.copyWith(foregroundTint: picked),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ColorSwatchButton(
                        color: border.borderColor,
                        label: 'الحدود',
                        size: 46,
                        onTap: () async {
                          final picked = await ColorPickerDialog.show(
                            context,
                            initialColor: border.borderColor,
                            title: 'حدود ${group.name}',
                          );
                          if (picked != null) {
                            provider.setGroupBorder(
                              group.id,
                              border.copyWith(borderColor: picked),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              _subsectionTitle('الشكل'),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ShapePickerGrid(
                  selected: group.shape,
                  crossAxisCount: 6,
                  previewColor:
                      border?.backgroundTint ?? AppColors.neonCyan,
                  previewBorderColor:
                      border?.borderColor ?? Colors.transparent,
                  onSelected: (shape) {
                    provider.changeGroupShape(group.id, shape);
                  },
                ),
              ),
              const SizedBox(height: 16),
              _subsectionTitle('عند الضغط'),
              const SizedBox(height: 8),
              _stateRow(
                context: context,
                provider: provider,
                groupId: group.id,
                stateBorder: pressedBorder,
                stateName: 'مضغوط',
                onColor: (color) {
                  final newBorder =
                      (pressedBorder ?? border)?.copyWith(
                    backgroundTint: color,
                  );
                  provider.setGroupPressedBorder(group.id, newBorder);
                },
                onClear: () =>
                    provider.setGroupPressedBorder(group.id, null),
              ),
              const SizedBox(height: 12),
              _subsectionTitle('الضغط المطول'),
              const SizedBox(height: 8),
              _stateRow(
                context: context,
                provider: provider,
                groupId: group.id,
                stateBorder: longPressBorder,
                stateName: 'مطول',
                onColor: (color) {
                  final newBorder =
                      (longPressBorder ?? border)?.copyWith(
                    backgroundTint: color,
                  );
                  provider.setGroupLongPressBorder(group.id, newBorder);
                },
                onClear: () =>
                    provider.setGroupLongPressBorder(group.id, null),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _subsectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textDarkSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _stateRow({
    required BuildContext context,
    required ThemeProvider provider,
    required String groupId,
    required dynamic stateBorder,
    required String stateName,
    required ValueChanged<Color> onColor,
    required VoidCallback onClear,
  }) {
    final hasState = stateBorder != null;

    return Row(
      children: [
        if (hasState)
          ColorSwatchButton(
            color: stateBorder.backgroundTint,
            label: stateName,
            size: 46,
            onTap: () async {
              final picked = await ColorPickerDialog.show(
                context,
                initialColor: stateBorder.backgroundTint,
                title: stateName,
              );
              if (picked != null) onColor(picked);
            },
          )
        else
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.textDarkHint,
              size: 22,
            ),
          ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            hasState ? 'مخصص' : 'افتراضي (نفس الأصل)',
            style: TextStyle(
              color: hasState ? AppColors.neonCyan : AppColors.textDarkHint,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (hasState)
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: AppColors.error,
            onPressed: onClear,
          )
        else
          TextButton(
            onPressed: () {
              onColor(provider.project.keyboardContainerPressed);
            },
            child: const Text('تخصيص'),
          ),
      ],
    );
  }

  IconData _groupIcon(String selector) {
    if (selector.contains('delete')) return Icons.backspace;
    if (selector.contains('enter')) return Icons.keyboard_return;
    if (selector.contains('shift')) return Icons.keyboard_arrow_up;
    if (selector.contains('space')) return Icons.space_bar;
    if (selector.contains('emoji')) return Icons.emoji_emotions;
    if (selector.contains('functional')) return Icons.functions;
    return Icons.keyboard;
  }
}
