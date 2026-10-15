import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../providers/theme_provider.dart';
import '../widgets/sticky_keyboard_preview.dart';
import 'colors_tab.dart';
import 'gradients_tab.dart';
import 'backgrounds_tab.dart';
import 'shapes_tab.dart';
import 'keys_tab.dart';
import 'emojis_tab.dart';
import 'assets_tab.dart';
import 'fonts_tab.dart';
import 'export_screen.dart';
import 'preview_screen.dart';

/// المحرر الرئيسي — 8 تبويبات
class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.darkBg,
          appBar: AppBar(
            title: Text(provider.project.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.fullscreen),
                tooltip: 'معاينة كاملة',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PreviewScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.save_alt),
                tooltip: 'تصدير',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExportScreen(),
                    ),
                  );
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.neonCyan,
              indicatorWeight: 3,
              labelColor: AppColors.neonCyan,
              unselectedLabelColor: AppColors.textDarkHint,
              labelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
              tabs: const [
                Tab(icon: Icon(Icons.palette, size: 18), text: 'ألوان'),
                Tab(icon: Icon(Icons.gradient, size: 18), text: 'تدرجات'),
                Tab(icon: Icon(Icons.wallpaper, size: 18), text: 'خلفيات'),
                Tab(icon: Icon(Icons.category, size: 18), text: 'أشكال'),
                Tab(icon: Icon(Icons.keyboard, size: 18), text: 'أزرار'),
                Tab(icon: Icon(Icons.emoji_emotions, size: 18), text: 'إيموجي'),
                Tab(icon: Icon(Icons.image, size: 18), text: 'أصول'),
                Tab(icon: Icon(Icons.text_fields, size: 18), text: 'خطوط'),
              ],
            ),
          ),
          body: Column(
            children: [
              // المعاينة الثابتة في الأعلى
              const StickyKeyboardPreview(scale: 0.75),
              // التبويبات
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    ColorsTab(),
                    GradientsTab(),
                    BackgroundsTab(),
                    ShapesTab(),
                    KeysTab(),
                    EmojisTab(),
                    AssetsTab(),
                    FontsTab(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
