import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../data/emojis_catalog.dart';
import 'neon_button.dart';

/// منتقي الإيموجي (شاشة كاملة أو bottom sheet)
class EmojiPicker extends StatefulWidget {
  final ValueChanged<String> onEmojiSelected;
  final bool showTitle;

  const EmojiPicker({
    super.key,
    required this.onEmojiSelected,
    this.showTitle = true,
  });

  /// فتح كـ bottom sheet
  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: EmojiPicker(
          onEmojiSelected: (emoji) => Navigator.pop(context, emoji),
        ),
      ),
    );
  }

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  String _search = '';
  String? _activeCategory;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = EmojisCatalog.search(_search);

    return Column(
      children: [
        if (widget.showTitle) _buildHandle(),
        _buildSearch(),
        _buildCategoryChips(),
        const Divider(height: 1),
        Expanded(
          child: categories.isEmpty
              ? _buildEmpty()
              : _buildEmojiList(categories),
        ),
      ],
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textDarkHint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'اختر إيموجي',
                  style: TextStyle(
                    color: AppColors.textDarkPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  icon: const Icon(Icons.close,
                      color: AppColors.textDarkSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'ابحث في الفئات...',
          prefixIcon: Icon(Icons.search, size: 20),
          isDense: true,
        ),
        onChanged: (v) => setState(() => _search = v),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: NeonChip(
              label: 'الكل',
              icon: Icons.apps,
              selected: _activeCategory == null,
              onTap: () => setState(() => _activeCategory = null),
            ),
          ),
          ...EmojisCatalog.categoryNames.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: NeonChip(
                label: cat,
                selected: _activeCategory == cat,
                onTap: () => setState(() => _activeCategory = cat),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: AppColors.textDarkHint),
          SizedBox(height: 12),
          Text(
            'لا توجد نتائج',
            style: TextStyle(color: AppColors.textDarkHint),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiList(Map<String, List<String>> categories) {
    final filtered = <MapEntry<String, List<String>>>[];

    categories.forEach((cat, list) {
      if (_activeCategory == null || cat == _activeCategory) {
        filtered.add(MapEntry(cat, list));
      }
    });

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final entry = filtered[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.neonCyan,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: AppColors.glow(
                        AppColors.neonCyan,
                        intensity: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.key,
                    style: const TextStyle(
                      color: AppColors.textDarkPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${entry.value.length})',
                    style: const TextStyle(
                      color: AppColors.textDarkHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: entry.value.map(_emojiTile).toList(),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _emojiTile(String emoji) {
    return GestureDetector(
      onTap: () => widget.onEmojiSelected(emoji),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.darkContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

/// زر إيموجي سريع (chip)
class EmojiQuickChip extends StatelessWidget {
  final String emoji;
  final VoidCallback? onTap;
  final bool isSelected;

  const EmojiQuickChip({
    super.key,
    required this.emoji,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.neonCyan.withOpacity(0.2)
              : AppColors.darkContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.neonCyan
                : Colors.white.withOpacity(0.08),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? AppColors.glow(AppColors.neonCyan, intensity: 0.4)
              : null,
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 26),
        ),
      ),
    );
  }
}
