import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/theme_project.dart';
import '../providers/theme_provider.dart';
import '../services/project_store_service.dart';
import '../widgets/aurora_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/theme_card.dart';
import 'editor_screen.dart';
import 'my_themes_screen.dart';
import 'shapes_library_screen.dart';
import 'fonts_library_screen.dart';
import 'color_studio_screen.dart';
import 'settings_screen.dart';

/// الشاشة الرئيسية
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ThemeProject> _recent = [];
  int _totalCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final recent = await ProjectStoreService.getRecent(limit: 6);
    final count = await ProjectStoreService.count();
    if (!mounted) return;
    setState(() {
      _recent = recent;
      _totalCount = count;
      _isLoading = false;
    });
  }

  Future<void> _newTheme() async {
    final provider = context.read<ThemeProvider>();
    provider.newProject();
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditorScreen()),
    );
    _loadData();
  }

  Future<void> _importTheme() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;
      final path = result.files.first.path;
      if (path == null) return;

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.neonCyan),
        ),
      );

      final provider = context.read<ThemeProvider>();
      await provider.importTheme(File(path));

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الاستيراد بنجاح')),
      );

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditorScreen()),
      );
      _loadData();
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل الاستيراد: $e')),
      );
    }
  }

  Future<void> _openTheme(ThemeProject project) async {
    context.read<ThemeProvider>().loadProject(project);
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditorScreen()),
    );
    _loadData();
  }

  void _openScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen))
        .then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: AuroraFullBackground(
        intensity: 0.6,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadData,
            color: AppColors.neonCyan,
            backgroundColor: AppColors.darkContainer,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                  const SizedBox(height: 16),
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  _buildRecentThemes(),
                  const SizedBox(height: 24),
                  _buildLibraryGrid(),
                  const SizedBox(height: 24),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // Header
  // ═══════════════════════════════════════════

  Widget _buildHeader() {
    return GlassCardWithGlow(
      glowColor: AppColors.neonCyan,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.glow(AppColors.neonCyan, intensity: 0.6),
            ),
            child: const Icon(
              Icons.palette_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'General Theme Studio',
                  style: TextStyle(
                    color: AppColors.textDarkPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'أنشئ • عدّل • صمّم • شارك',
                  style: TextStyle(
                    color: AppColors.textDarkSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 20),
            color: AppColors.textDarkSecondary,
            onPressed: () => _openScreen(const SettingsScreen()),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // Quick Actions
  // ═══════════════════════════════════════════

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: QuickActionCard(
            icon: Icons.add_circle_outline,
            title: 'ثيم جديد',
            subtitle: 'ابدأ من الصفر',
            color: AppColors.neonCyan,
            onTap: _newTheme,
            isPrimary: true,
            gradient: const LinearGradient(
              colors: [Color(0x4016D9F2), Color(0x1016D9F2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: QuickActionCard(
            icon: Icons.file_download_outlined,
            title: 'استيراد',
            subtitle: 'ملف ZIP',
            color: AppColors.neonPurple,
            onTap: _importTheme,
            isPrimary: true,
            gradient: const LinearGradient(
              colors: [Color(0x408B5CF6), Color(0x108B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════
  // Stats Row
  // ═══════════════════════════════════════════

  Widget _buildStatsRow() {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          StatBadge(
            icon: Icons.collections_bookmark_outlined,
            value: '$_totalCount',
            label: 'ثيم',
            color: AppColors.neonCyan,
          ),
          const SizedBox(width: 8),
          const StatBadge(
            icon: Icons.category_outlined,
            value: '527',
            label: 'شكل',
            color: AppColors.neonPurple,
          ),
          const SizedBox(width: 8),
          const StatBadge(
            icon: Icons.gradient,
            value: '60+',
            label: 'تدرج',
            color: AppColors.neonPink,
          ),
          const SizedBox(width: 8),
          const StatBadge(
            icon: Icons.text_fields_outlined,
            value: '2000+',
            label: 'خط',
            color: AppColors.neonGreen,
          ),
          const SizedBox(width: 8),
          const StatBadge(
            icon: Icons.emoji_emotions_outlined,
            value: '380',
            label: 'إيموجي',
            color: AppColors.neonOrange,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // Recent Themes
  // ═══════════════════════════════════════════

  Widget _buildRecentThemes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.neonCyan,
                borderRadius: BorderRadius.circular(2),
                boxShadow: AppColors.glow(AppColors.neonCyan, intensity: 0.5),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'الثيمات الأخيرة',
              style: TextStyle(
                color: AppColors.textDarkPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            if (_totalCount > 0)
              SeeAllCard(
                onTap: () => _openScreen(const MyThemesScreen()),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: AppColors.neonCyan),
            ),
          )
        else if (_recent.isEmpty)
          _emptyRecent()
        else
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _recent.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SizedBox(
                width: 150,
                child: ThemeCard(
                  project: _recent[i],
                  compact: true,
                  onTap: () => _openTheme(_recent[i]),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _emptyRecent() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.textDarkHint.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              color: AppColors.textDarkHint,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'لا توجد ثيمات محفوظة بعد\nابدأ بإنشاء ثيمك الأول',
              style: TextStyle(
                color: AppColors.textDarkSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // Library Grid
  // ═══════════════════════════════════════════

  Widget _buildLibraryGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.neonPurple,
                borderRadius: BorderRadius.circular(2),
                boxShadow: AppColors.glow(AppColors.neonPurple, intensity: 0.5),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'استكشف',
              style: TextStyle(
                color: AppColors.textDarkPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            LibraryCard(
              icon: Icons.collections_bookmark_outlined,
              title: 'ثيماتي',
              subtitle: 'إدارة كاملة',
              color: AppColors.neonCyan,
              badge: _totalCount > 0 ? _totalCount : null,
              onTap: () => _openScreen(const MyThemesScreen()),
            ),
            LibraryCard(
              icon: Icons.category_outlined,
              title: 'مكتبة الأشكال',
              subtitle: '527 شكل (2D + 3D)',
              color: AppColors.neonPurple,
              onTap: () => _openScreen(const ShapesLibraryScreen()),
            ),
            LibraryCard(
              icon: Icons.color_lens_outlined,
              title: 'استوديو الألوان',
              subtitle: 'ألوان + تدرجات',
              color: AppColors.neonOrange,
              onTap: () => _openScreen(const ColorStudioScreen()),
            ),
            LibraryCard(
              icon: Icons.text_fields_outlined,
              title: 'مكتبة الخطوط',
              subtitle: '20 مدمج + Google',
              color: AppColors.neonPink,
              onTap: () => _openScreen(const FontsLibraryScreen()),
            ),
            LibraryCard(
              icon: Icons.wallpaper,
              title: 'الخلفيات',
              subtitle: '12 + إنترنت',
              color: AppColors.neonGreen,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('افتح ثيماً أولاً للوصول للخلفيات'),
                  ),
                );
              },
            ),
            LibraryCard(
              icon: Icons.cloud_download_outlined,
              title: 'من الإنترنت',
              subtitle: 'خطوط + خلفيات + ألوان',
              color: AppColors.neonBlue,
              onTap: () => _openScreen(const FontsLibraryScreen()),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════
  // Footer
  // ═══════════════════════════════════════════

  Widget _buildFooter() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.darkContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.neonGreen,
                      shape: BoxShape.circle,
                      boxShadow:
                          AppColors.glow(AppColors.neonGreen, intensity: 0.6),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'General Theme Studio v1.0.0',
                    style: TextStyle(
                      color: AppColors.textDarkHint.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
