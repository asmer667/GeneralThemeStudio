import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/background_asset.dart';
import '../services/background_service.dart';
import '../utils/validators.dart';
import 'glass_card.dart';
import 'neon_button.dart';

/// منتقي الخلفيات
class BackgroundPicker extends StatefulWidget {
  final BackgroundAsset? selected;
  final ValueChanged<BackgroundAsset?> onSelected;

  const BackgroundPicker({
    super.key,
    this.selected,
    required this.onSelected,
  });

  @override
  State<BackgroundPicker> createState() => _BackgroundPickerState();
}

class _BackgroundPickerState extends State<BackgroundPicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<BackgroundAsset> _builtin = [];
  List<BackgroundAsset> _uploaded = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final all = await BackgroundService.loadAll();
    if (!mounted) return;
    setState(() {
      _builtin = all.builtin;
      _uploaded = all.uploaded;
      _loading = false;
    });
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;
      final path = result.files.first.path;
      if (path == null) return;

      final file = File(path);
      final v = await Validators.imageFile(file);
      if (!v.isValid) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(v.error ?? 'ملف غير صالح')),
        );
        return;
      }

      final bg = await BackgroundService.uploadBackground(file);
      if (!mounted) return;

      setState(() {
        _uploaded.add(bg);
      });

      widget.onSelected(bg);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم رفع الخلفية')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل: $e')),
      );
    }
  }

  Future<void> _deleteBackground(BackgroundAsset bg) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف الخلفية'),
        content: Text('حذف "${bg.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (ok == true) {
      await BackgroundService.deleteBackground(bg);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.darkBg,
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.neonCyan,
                  labelColor: AppColors.neonCyan,
                  unselectedLabelColor: AppColors.textDarkHint,
                  tabs: const [
                    Tab(text: 'مدمج'),
                    Tab(text: 'مرفوعة'),
                  ],
                ),
              ),
              NeonIconButton(
                icon: Icons.add_photo_alternate,
                color: AppColors.neonPurple,
                onPressed: _pickImage,
                tooltip: 'رفع صورة',
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGrid(_builtin, allowDelete: false),
                    _buildGrid(_uploaded, allowDelete: true),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<BackgroundAsset> items, {required bool allowDelete}) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                allowDelete ? Icons.image_outlined : Icons.wallpaper,
                size: 48,
                color: AppColors.textDarkHint,
              ),
              const SizedBox(height: 16),
              Text(
                allowDelete
                    ? 'لا توجد خلفيات مرفوعة'
                    : 'لا توجد خلفيات مدمجة',
                style: const TextStyle(
                  color: AppColors.textDarkHint,
                  fontSize: 14,
                ),
              ),
              if (allowDelete) ...[
                const SizedBox(height: 12),
                NeonButton(
                  label: 'رفع صورة',
                  icon: Icons.add_photo_alternate,
                  onPressed: _pickImage,
                  size: NeonButtonSize.small,
                ),
              ],
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length + (allowDelete ? 0 : 0),
      itemBuilder: (_, i) {
        final bg = items[i];
        return _backgroundTile(bg, allowDelete);
      },
    );
  }

  Widget _backgroundTile(BackgroundAsset bg, bool allowDelete) {
    final isSelected = widget.selected?.id == bg.id;
    return GestureDetector(
      onTap: () => widget.onSelected(bg),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.neonCyan
                : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? AppColors.glow(AppColors.neonCyan, intensity: 0.5)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(child: _buildBackgroundPreview(bg)),
              if (bg.type == BackgroundType.image && allowDelete)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 14),
                      color: Colors.white,
                      onPressed: () => _deleteBackground(bg),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                    ),
                  ),
                ),
              if (isSelected)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.neonCyan,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        size: 12, color: AppColors.darkBg),
                  ),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    bg.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundPreview(BackgroundAsset bg) {
    switch (bg.type) {
      case BackgroundType.color:
        return Container(color: bg.solidColor);
      case BackgroundType.gradient:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: bg.gradientColors ?? [Colors.black, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      case BackgroundType.image:
      case BackgroundType.builtin:
        if (bg.imagePath == null) return Container(color: Colors.grey);
        final file = File(bg.imagePath!);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.darkContainer,
              child: const Icon(Icons.broken_image),
            ),
          );
        }
        return Container(color: AppColors.darkContainer);
      case BackgroundType.mesh:
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: bg.gradientColors ?? [Colors.black, Colors.white],
            ),
          ),
        );
    }
  }
}
