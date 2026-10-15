import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../data/emojis_catalog.dart';
import '../models/icon_asset.dart';
import '../providers/theme_provider.dart';
import '../widgets/emoji_picker.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

/// تبويب الإيموجي — لإضافة إيموجي للأزرار
class EmojisTab extends StatefulWidget {
  const EmojisTab({super.key});

  @override
  State<EmojisTab> createState() => _EmojisTabState();
}

class _EmojisTabState extends State<EmojisTab> {
  String? _selectedGroupId;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        final groups = provider.project.groups;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const GlassCard(
              padding: EdgeInsets.all(14),
              glowColor: AppColors.neonPink,
              child: Row(
                children: [
                  Icon(Icons.emoji_emotions,
                      color: AppColors.neonPink, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'أضف إيموجي كأيقونة لأي زر. سيظهر في المعاينة وفي الثيم المُصدّر.',
                      style: TextStyle(
                        color: AppColors.textDarkPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // المجموعات
            GlassCard(
              padding: const EdgeInsets.all(14),
              glowColor: AppColors.neonCyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.neonCyan.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.neonCyan.withOpacity(0.4),
                          ),
                        ),
                        child: const Icon(
                          Icons.keyboard,
                          color: AppColors.neonCyan,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'اختر المجموعة',
                        style: TextStyle(
                          color: AppColors.textDarkPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...groups.map((g) => _groupTile(context, provider, g)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // منتقي الإيموجي
            if (_selectedGroupId != null)
              GlassCard(
                padding: const EdgeInsets.all(14),
                glowColor: AppColors.neonPurple,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اختر إيموجي',
                      style: TextStyle(
                        color: AppColors.textDarkPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    NeonButton(
                      label: 'فتح منتقي الإيموجي',
                      icon: Icons.emoji_emotions_outlined,
                      onPressed: () async {
                        final emoji = await EmojiPicker.show(context);
                        if (emoji != null && _selectedGroupId != null) {
                          final group = provider.project.groups
                              .firstWhere((g) => g.id == _selectedGroupId);
                          final icon = IconAsset.fromEmoji(
                            name: 'Emoji-${group.selector.replaceAll(" ", "_")}.png',
                            emoji: emoji,
                          );
                          provider.setGroupIcon(group.id, icon);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('تم إضافة $emoji')),
                          );
                        }
                      },
                      fullWidth: true,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'أو اختر سريعاً:',
                      style: TextStyle(
                        color: AppColors.textDarkHint,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: const [
                        '😀', '😍', '🥰', '😂', '🤣',
                        '❤️', '💜', '⭐', '✨', '🔥',
                        '👍', '👏', '🙏', '💪', '🎉',
                      ].map(_quickEmoji).toList(),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _groupTile(
      BuildContext context, ThemeProvider provider, dynamic group) {
    final isSelected = _selectedGroupId == group.id;
    final currentIcon = group.icon;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: () => setState(() => _selectedGroupId = group.id),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.neonCyan.withOpacity(0.15)
                : AppColors.darkSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.neonCyan.withOpacity(0.5)
                  : Colors.white.withOpacity(0.05),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.neonCyan.withOpacity(0.2)
                      : AppColors.darkContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: currentIcon?.isEmoji == true
                      ? Text(
                          currentIcon!.emoji!,
                          style: const TextStyle(fontSize: 20),
                        )
                      : Icon(
                          _groupIcon(group.selector),
                          color: isSelected
                              ? AppColors.neonCyan
                              : AppColors.textDarkHint,
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
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.neonCyan
                            : AppColors.textDarkPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (currentIcon?.isEmoji == true)
                      Text(
                        'إيموجي: ${currentIcon!.emoji}',
                        style: const TextStyle(
                          color: AppColors.neonPink,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),
              if (currentIcon?.isEmoji == true)
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  color: AppColors.error,
                  onPressed: () =>
                      provider.setGroupIcon(group.id, null),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickEmoji(String emoji) {
    return GestureDetector(
      onTap: () {
        if (_selectedGroupId == null) return;
        final provider = context.read<ThemeProvider>();
        final group = provider.project.groups
            .firstWhere((g) => g.id == _selectedGroupId);
        final icon = IconAsset.fromEmoji(
          name: 'Emoji-${group.selector.replaceAll(" ", "_")}.png',
          emoji: emoji,
        );
        provider.setGroupIcon(group.id, icon);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إضافة $emoji')),
        );
      },
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  IconData _groupIcon(String selector) {
    if (selector.contains('delete')) return Icons.backspace;
    if (selector.contains('enter')) return Icons.keyboard_return;
    if (selector.contains('shift')) return Icons.keyboard_arrow_up;
    if (selector.contains('space')) return Icons.space_bar;
    if (selector.contains('functional')) return Icons.functions;
    return Icons.keyboard;
  }
}
