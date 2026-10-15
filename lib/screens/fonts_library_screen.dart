import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../services/font_download_service.dart';
import '../services/font_service.dart';
import '../services/google_fonts_api.dart';
import '../utils/validators.dart';
import '../widgets/font_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

/// مكتبة الخطوط — مدمج + Google Fonts (لا محدود)
class FontsLibraryScreen extends StatefulWidget {
  const FontsLibraryScreen({super.key});

  @override
  State<FontsLibraryScreen> createState() => _FontsLibraryScreenState();
}

class _FontsLibraryScreenState extends State<FontsLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('مكتبة الخطوط'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.neonCyan,
          labelColor: AppColors.neonCyan,
          unselectedLabelColor: AppColors.textDarkHint,
          tabs: const [
            Tab(text: 'المدمجة والمنزّلة'),
            Tab(text: 'Google Fonts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _LocalFontsTab(),
          _GoogleFontsTab(),
        ],
      ),
    );
  }
}

// ═══ Local Fonts ═══

class _LocalFontsTab extends StatefulWidget {
  const _LocalFontsTab();

  @override
  State<_LocalFontsTab> createState() => _LocalFontsTabState();
}

class _LocalFontsTabState extends State<_LocalFontsTab> {
  dynamic _fonts;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final all = await FontService.loadAllFonts();
    if (!mounted) return;
    setState(() {
      _fonts = all;
      _loading = false;
    });
  }

  Future<void> _pickFont() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ttf', 'otf', 'woff', 'woff2'],
      );
      if (result == null || result.files.isEmpty) return;
      final path = result.files.first.path;
      if (path == null) return;

      final file = File(path);
      final v = await Validators.fontFile(file);
      if (!v.isValid) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(v.error ?? 'ملف غير صالح')),
        );
        return;
      }

      await FontService.addCustomFont(file);
      await _load();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.neonCyan),
      );
    }

    if (_fonts == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            const Text(
              'خطوط محلية',
              style: TextStyle(
                color: AppColors.textDarkPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            NeonIconButton(
              icon: Icons.add,
              color: AppColors.neonCyan,
              onPressed: _pickFont,
              tooltip: 'رفع خط مخصص',
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...(_fonts.builtIn as List).map(
          (f) => LocalFontCard(
            family: f.family,
            displayName: f.displayName,
            subtitle: f.displayNameAr,
            onTap: () {},
          ),
        ),
        if ((_fonts.downloaded as List).isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'منزّلة من Google',
            style: TextStyle(
              color: AppColors.textDarkPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ...(_fonts.downloaded as List).map(
            (f) => LocalFontCard(
              family: f.family,
              displayName: f.family,
              subtitle: f.sizeFormatted,
              onTap: () {},
              onDelete: () async {
                await FontDownloadService.delete(f.family);
                await _load();
              },
            ),
          ),
        ],
        if ((_fonts.custom as List).isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'مخصصة',
            style: TextStyle(
              color: AppColors.textDarkPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ...(_fonts.custom as List).map(
            (f) => LocalFontCard(
              family: f.family,
              displayName: f.family,
              subtitle: f.sizeFormatted,
              isCustom: true,
              onTap: () {},
              onDelete: () async {
                await FontService.deleteCustomFont(f.family);
                await _load();
              },
            ),
          ),
        ],
      ],
    );
  }
}

// ═══ Google Fonts ═══

class _GoogleFontsTab extends StatefulWidget {
  const _GoogleFontsTab();

  @override
  State<_GoogleFontsTab> createState() => _GoogleFontsTabState();
}

class _GoogleFontsTabState extends State<_GoogleFontsTab> {
  List<GoogleFont> _fonts = [];
  List<GoogleFont> _filtered = [];
  Set<String> _downloaded = {};
  Map<String, double> _progress = {};
  bool _loading = true;
  String _search = '';
  bool _arabicOnly = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final fonts = await GoogleFontsApi.fetchAllFonts();
      final dl = await FontDownloadService.listDownloaded();
      if (!mounted) return;
      setState(() {
        _fonts = fonts;
        _filtered = fonts;
        _downloaded = dl.map((d) => d.family).toSet();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _filter(String q) {
    setState(() {
      _search = q;
      var list = _fonts;
      if (_arabicOnly) {
        list = list.where((f) => f.supportsArabic).toList();
      }
      if (q.isNotEmpty) {
        final lq = q.toLowerCase();
        list = list
            .where((f) => f.family.toLowerCase().contains(lq))
            .toList();
      }
      _filtered = list;
    });
  }

  void _toggleArabic() {
    setState(() {
      _arabicOnly = !_arabicOnly;
    });
    _filter(_search);
  }

  Future<void> _download(GoogleFont font) async {
    setState(() => _progress[font.family] = 0);
    try {
      final result = await FontDownloadService.downloadWithFallback(
        font,
        onProgress: (r, t) {
          if (t > 0) {
            setState(() => _progress[font.family] = r / t);
          }
        },
      );

      if (!mounted) return;
      setState(() {
        _progress.remove(font.family);
        if (result.success) {
          _downloaded.add(font.family);
        }
      });

      if (!result.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل: ${result.error}')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _progress.remove(font.family));
    }
  }

  Future<void> _delete(String family) async {
    await FontDownloadService.delete(family);
    if (!mounted) return;
    setState(() => _downloaded.remove(family));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.neonCyan),
            SizedBox(height: 16),
            Text(
              'جارٍ تحميل قائمة الخطوط من Google...',
              style: TextStyle(color: AppColors.textDarkHint),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'ابحث في كل خطوط Google...',
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                ),
                onChanged: _filter,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  FilterChip(
                    label: const Text('الكل'),
                    selected: !_arabicOnly,
                    onSelected: (_) => _toggleArabic(),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('عربي فقط'),
                    selected: _arabicOnly,
                    onSelected: (_) => _toggleArabic(),
                  ),
                  const Spacer(),
                  Text(
                    '${_filtered.length} خط',
                    style: const TextStyle(
                      color: AppColors.textDarkHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _filtered.length,
            itemBuilder: (_, i) {
              final f = _filtered[i];
              return GoogleFontCard(
                font: f,
                isDownloaded: _downloaded.contains(f.family),
                isDownloading: _progress.containsKey(f.family),
                downloadProgress: _progress[f.family],
                onDownload: () => _download(f),
                onDelete: () => _delete(f.family),
              );
            },
          ),
        ),
      ],
    );
  }
}
