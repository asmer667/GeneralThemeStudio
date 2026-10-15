import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../data/gradients_catalog.dart';
import '../models/gradient_preset.dart';
import '../providers/theme_provider.dart';
import '../services/apply_service.dart';
import '../widgets/gradient_preview.dart';
import '../widgets/preview_bottom_sheet.dart';
import '../widgets/sticky_keyboard_preview.dart';
import 'online_palettes_screen.dart';

enum ColorFilter { all, dark, light, neon, pastel, metal }

extension ColorFilterExt on ColorFilter {
  String get label {
    switch (this) {
      case ColorFilter.all:
        return 'الكل';
      case ColorFilter.dark:
        return 'داكنة';
      case ColorFilter.light:
        return 'فاتحة';
      case ColorFilter.neon:
        return 'نيون';
      case ColorFilter.pastel:
        return 'باستيل';
      case ColorFilter.metal:
        return 'معدنية';
    }
  }

  IconData get icon {
    switch (this) {
      case ColorFilter.all:
        return Icons.apps;
      case ColorFilter.dark:
        return Icons.dark_mode;
      case ColorFilter.light:
        return Icons.light_mode;
      case ColorFilter.neon:
        return Icons.flash_on;
      case ColorFilter.pastel:
        return Icons.colorize;
      case ColorFilter.metal:
        return Icons.auto_awesome;
    }
  }

  Color get color {
    switch (this) {
      case ColorFilter.all:
        return const Color(0xFF16D9F2);
      case ColorFilter.dark:
        return const Color(0xFF5C6BC0);
      case ColorFilter.light:
        return const Color(0xFFFFD700);
      case ColorFilter.neon:
        return const Color(0xFF00E5FF);
      case ColorFilter.pastel:
        return const Color(0xFFFFB4CE);
      case ColorFilter.metal:
        return const Color(0xFFC0C0C0);
    }
  }
}

/// استوديو الألوان الموحّد
class ColorStudioScreen extends StatefulWidget {
  const ColorStudioScreen({super.key});

  @override
  State<ColorStudioScreen> createState() => _ColorStudioScreenState();
}

class _ColorStudioScreenState extends State<ColorStudioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  ColorFilter _colorFilter = ColorFilter.all;
  ColorFilter _gradientFilter = ColorFilter.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onColorSelected(Color color) async {
    final provider = context.read<ThemeProvider>();

    final selection = await PreviewBottomSheet.show(
      context,
      itemName: _colorHex(color),
      previewColor: color,
      previewWidget: const SizedBox.shrink(),
    );

    if (selection == null) return;

    final updated = ApplyService.applyColor(
      project: provider.project,
      color: color,
      selection: selection,
    );

    provider.loadProject(updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تطبيق ${_colorHex(color)} على ${selection.target.labelAr}',
        ),
      ),
    );
  }

  Future<void> _onGradientSelected(GradientPreset gradient) async {
    final provider = context.read<ThemeProvider>();

    final selection = await PreviewBottomSheet.show(
      context,
      itemName: gradient.name,
      previewGradient: gradient,
      previewColor: gradient.colors.isNotEmpty
          ? gradient.colors.first
          : AppColors.neonCyan,
      previewWidget: const SizedBox.shrink(),
    );

    if (selection == null) return;

    final updated = ApplyService.applyGradient(
      project: provider.project,
      gradient: gradient,
      selection: selection,
    );

    provider.loadProject(updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تطبيق ${gradient.name} على ${selection.target.labelAr}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: CompactPreviewHeader(
              title: 'استوديو الألوان',
              subtitle: 'ألوان أحادية • تدرجات • خلفيات',
              icon: Icons.palette,
              color: AppColors.neonCyan,
              onBack: () => Navigator.pop(context),
              actions: [
                IconButton(
                  icon: const Icon(Icons.cloud_download_outlined, size: 20),
                  tooltip: 'تصفح من الإنترنت',
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OnlinePalettesScreen(
                          onGradientSelected: (grad) {
                            _onGradientSelected(grad);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const StickyKeyboardPreview(scale: 0.7),
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkBg,
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.neonCyan,
              labelColor: AppColors.neonCyan,
              unselectedLabelColor: AppColors.textDarkHint,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
              tabs: const [
                Tab(icon: Icon(Icons.format_color_fill, size: 16), text: 'ألوان'),
                Tab(icon: Icon(Icons.gradient, size: 16), text: 'تدرجات'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSolidColors(),
                _buildGradients(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══ Solid Colors ═══

  Widget _buildSolidColors() {
    final colors = _getFilteredSolidColors();

    return Column(
      children: [
        _buildFilters(_colorFilter, (f) => setState(() => _colorFilter = f)),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: colors.length,
            itemBuilder: (_, i) => _colorTile(colors[i]),
          ),
        ),
      ],
    );
  }

  Widget _colorTile(Color color) {
    return GestureDetector(
      onTap: () => _onColorSelected(color),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.touch_app,
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══ Gradients ═══

  Widget _buildGradients() {
    final gradients = _getFilteredGradients();

    return Column(
      children: [
        _buildFilters(
          _gradientFilter,
          (f) => setState(() => _gradientFilter = f),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.4,
            ),
            itemCount: gradients.length,
            itemBuilder: (_, i) => GradientPreviewCard(
              gradient: gradients[i],
              onTap: () => _onGradientSelected(gradients[i]),
            ),
          ),
        ),
      ],
    );
  }

  // ═══ Filters ═══

  Widget _buildFilters(
    ColorFilter current,
    ValueChanged<ColorFilter> onChanged,
  ) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: ColorFilter.values.map((f) {
          final isSelected = current == f;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onChanged(f),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? f.color.withOpacity(0.2)
                      : AppColors.darkContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? f.color
                        : Colors.white.withOpacity(0.08),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? AppColors.glow(f.color, intensity: 0.3)
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      f.icon,
                      size: 14,
                      color: isSelected ? f.color : AppColors.textDarkHint,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      f.label,
                      style: TextStyle(
                        color: isSelected
                            ? f.color
                            : AppColors.textDarkPrimary,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ═══ Data ═══

  List<Color> _getFilteredSolidColors() {
    final all = _generateSolidColors();
    switch (_colorFilter) {
      case ColorFilter.all:
        return all;
      case ColorFilter.dark:
        return all.where((c) => c.computeLuminance() < 0.25).toList();
      case ColorFilter.light:
        return all.where((c) => c.computeLuminance() > 0.7).toList();
      case ColorFilter.neon:
        return all.where((c) {
          final hsl = HSLColor.fromColor(c);
          return hsl.saturation > 0.7 && hsl.lightness > 0.4;
        }).toList();
      case ColorFilter.pastel:
        return all.where((c) {
          final hsl = HSLColor.fromColor(c);
          return hsl.lightness > 0.75;
        }).toList();
      case ColorFilter.metal:
        return all.where((c) {
          final hsl = HSLColor.fromColor(c);
          return hsl.saturation < 0.3 &&
              hsl.lightness > 0.3 &&
              hsl.lightness < 0.9;
        }).toList();
    }
  }

  List<Color> _generateSolidColors() {
    return [
      const Color(0xFF16D9F2),
      const Color(0xFF8B5CF6),
      const Color(0xFFFF6B9D),
      const Color(0xFF10E5A0),
      const Color(0xFF3B82F6),
      const Color(0xFFFF9500),
      const Color(0xFFFFD700),
      const Color(0xFFFF3D5A),
      const Color(0xFFE91E63),
      const Color(0xFFCDDC39),
      const Color(0xFF00BCD4),
      const Color(0xFF5C6BC0),
      const Color(0xFF00E5FF),
      const Color(0xFFFF6E40),
      const Color(0xFF651FFF),
      const Color(0xFF00E676),
      const Color(0xFF6EE8F5),
      const Color(0xFFA989F9),
      const Color(0xFFFFB4CE),
      const Color(0xFF7EE8B5),
      const Color(0xFF85BAFF),
      const Color(0xFFFFC685),
      const Color(0xFFFFF085),
      const Color(0xFFFF8888),
      const Color(0xFF071426),
      const Color(0xFF102C43),
      const Color(0xFF183D58),
      const Color(0xFF0A1A28),
      const Color(0xFF0F1621),
      const Color(0xFF141C2B),
      const Color(0xFF1A2536),
      const Color(0xFF223046),
      const Color(0xFF05070D),
      const Color(0xFF0A0F1A),
      const Color(0xFFFFFFFF),
      const Color(0xFFF5F8FC),
      const Color(0xFFB8D4E2),
      const Color(0xFF808080),
      const Color(0xFF404040),
      const Color(0xFF000000),
      const Color(0xFF8B5A2B),
      const Color(0xFF654321),
      const Color(0xFFD2691E),
      const Color(0xFFCD853F),
      const Color(0xFFE5E4E2),
      const Color(0xFFC0C0C0),
      const Color(0xFFA9A9A9),
      const Color(0xFFD4AF37),
      const Color(0xFFB8860B),
    ];
  }

  List<GradientPreset> _getFilteredGradients() {
    final all = GradientsCatalog.all;
    switch (_gradientFilter) {
      case ColorFilter.all:
        return all;
      case ColorFilter.dark:
        return all.where((g) {
          if (g.colors.isEmpty) return false;
          final avgLum = g.colors
                  .map((c) => c.computeLuminance())
                  .reduce((a, b) => a + b) /
              g.colors.length;
          return avgLum < 0.35;
        }).toList();
      case ColorFilter.light:
        return all.where((g) {
          if (g.colors.isEmpty) return false;
          final avgLum = g.colors
                  .map((c) => c.computeLuminance())
                  .reduce((a, b) => a + b) /
              g.colors.length;
          return avgLum > 0.6;
        }).toList();
      case ColorFilter.neon:
        return all
            .where((g) =>
                g.name.toLowerCase().contains('neon') ||
                g.name.toLowerCase().contains('cyan') ||
                g.name.toLowerCase().contains('purple') ||
                g.name.toLowerCase().contains('pink'))
            .toList();
      case ColorFilter.pastel:
        return all
            .where((g) =>
                g.name.toLowerCase().contains('pastel') ||
                g.name.toLowerCase().contains('light'))
            .toList();
      case ColorFilter.metal:
        return all
            .where((g) =>
                g.name.toLowerCase().contains('gold') ||
                g.name.toLowerCase().contains('silver') ||
                g.name.toLowerCase().contains('bronze') ||
                g.name.toLowerCase().contains('platinum'))
            .toList();
    }
  }

  String _colorHex(Color c) {
    final r = c.red.toRadixString(16).padLeft(2, '0');
    final g = c.green.toRadixString(16).padLeft(2, '0');
    final b = c.blue.toRadixString(16).padLeft(2, '0');
    return '#${r.toUpperCase()}${g.toUpperCase()}${b.toUpperCase()}';
  }
}
