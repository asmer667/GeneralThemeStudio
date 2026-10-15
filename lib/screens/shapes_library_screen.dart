import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/apply_target.dart';
import '../models/key_shape.dart';
import '../models/shape_category.dart';
import '../providers/theme_provider.dart';
import '../services/apply_service.dart';
import '../widgets/preview_bottom_sheet.dart';
import '../widgets/shape_picker_grid.dart';
import '../widgets/shape_widget.dart';
import '../widgets/sticky_keyboard_preview.dart';

/// مكتبة الأشكال — مع Bottom Sheet تفاعلي
class ShapesLibraryScreen extends StatefulWidget {
  const ShapesLibraryScreen({super.key});

  @override
  State<ShapesLibraryScreen> createState() => _ShapesLibraryScreenState();
}

class _ShapesLibraryScreenState extends State<ShapesLibraryScreen> {
  ShapeCategory? _filter;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onShapeSelected(KeyShape shape) async {
    final provider = context.read<ThemeProvider>();

    // عرض Bottom Sheet
    final selection = await PreviewBottomSheet.show(
      context,
      itemName: shape.label,
      previewShape: shape,
      previewColor: AppColors.neonPurple,
      previewWidget: ShapeWidget(
        shape: shape,
        color: Colors.white.withValues(alpha: 0.9),
        width: 28,
        height: 28,
      ),
      allowBackground: false,
    );

    if (selection == null) return;

    // تطبيق
    final updated = ApplyService.applyShape(
      project: provider.project,
      shape: shape,
      selection: selection,
    );

    provider.loadProject(updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تطبيق "${shape.label}" على ${selection.target.labelAr}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shapes = _filter == null
        ? KeyShape.values
        : KeyShape.values.where((s) => s.category == _filter).toList();

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Column(
        children: [
          // رأس الشاشة
          SafeArea(
            bottom: false,
            child: CompactPreviewHeader(
              title: 'مكتبة الأشكال',
              subtitle: '${shapes.length} شكل متاح',
              icon: Icons.category,
              color: AppColors.neonPurple,
              onBack: () => Navigator.pop(context),
            ),
          ),
          // فلتر الفئات
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.darkBg,
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            child: ShapeCategoryFilter(
              selected: _filter,
              onSelected: (cat) => setState(() => _filter = cat),
            ),
          ),
          // شبكة الأشكال
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              child: ShapePickerGrid(
                selected: KeyShape.roundedRectangle,
                filterCategory: _filter,
                previewColor: AppColors.neonCyan,
                previewBorderColor: Colors.white.withValues(alpha: 0.4),
                crossAxisCount: 4,
                onSelected: _onShapeSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
