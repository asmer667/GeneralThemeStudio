import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/app_colors.dart';
import '../models/background_asset.dart';
import '../providers/theme_provider.dart';
import '../services/theme_export_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  ExportResult? _result;
  bool _isExporting = false;
  String? _error;

  Future<void> _export() async {
    setState(() {
      _isExporting = true;
      _error = null;
    });

    try {
      final provider = context.read<ThemeProvider>();
      final result = await ThemeExportService.exportTheme(provider.project);
      if (!mounted) return;
      setState(() => _result = result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _share() async {
    if (_result == null) return;
    try {
      await Share.shareXFiles(
        [XFile(_result!.file.path)],
        subject: 'FUTO Theme: ${_result!.project.name}',
        text: 'ثيم FUTO Keyboard — ${_result!.project.name}',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل المشاركة: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.darkBg,
          appBar: AppBar(title: const Text('تصدير الثيم')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildInfoCard(),
              const SizedBox(height: 16),
              _buildFilePreview(provider.project),
              const SizedBox(height: 16),
              if (_error != null) _buildError(),
              if (_result != null) _buildResult(_result!),
              const SizedBox(height: 20),
              if (_result == null)
                NeonButton(
                  label: 'تصدير الآن',
                  icon: Icons.download,
                  isLoading: _isExporting,
                  onPressed: _export,
                  fullWidth: true,
                  size: NeonButtonSize.large,
                )
              else ...[
                NeonButton(
                  label: 'مشاركة الملف',
                  icon: Icons.share,
                  onPressed: _share,
                  fullWidth: true,
                  size: NeonButtonSize.large,
                  color: AppColors.neonGreen,
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _result = null),
                  icon: const Icon(Icons.refresh),
                  label: const Text('تصدير مرة أخرى'),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.glow(AppColors.neonCyan, intensity: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.file_download_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تصدير الثيم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ملف ZIP جاهز للاستيراد في FUTO Keyboard',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreview(dynamic project) {
    final assets = ThemeExportService.collectAssets(project);
    final bg = project.background;

    return GlassCard(
      padding: const EdgeInsets.all(14),
      glowColor: AppColors.neonCyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.folder_open,
                  color: AppColors.neonCyan, size: 20),
              SizedBox(width: 8),
              Text(
                'محتويات الحزمة',
                style: TextStyle(
                  color: AppColors.textDarkPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _fileRow(Icons.description, 'theme.txt', 'إعدادات الثيم'),
          _fileRow(Icons.description, 'README.md', 'دليل'),
          _fileRow(Icons.description, 'LICENSE.txt', 'ترخيص'),
          if (assets.borders.isNotEmpty)
            _fileRow(
              Icons.image,
              '${assets.borders.length} صورة زر',
              'Borders',
            ),
          if (assets.icons.isNotEmpty)
            _fileRow(
              Icons.image,
              '${assets.icons.length} أيقونة',
              'Icons',
            ),
          if (bg != null &&
              (bg.type == BackgroundType.image ||
                  bg.type == BackgroundType.builtin))
            _fileRow(
              Icons.wallpaper,
              'background.png',
              'خلفية',
            ),
          if (project.fontName != null)
            _fileRow(
              Icons.text_fields,
              'font.ttf',
              project.fontName!,
            ),
        ],
      ),
    );
  }

  Widget _fileRow(IconData icon, String name, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textDarkHint, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: AppColors.textDarkPrimary,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textDarkHint,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'فشل التصدير: $_error',
              style: const TextStyle(
                color: AppColors.textDarkPrimary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(ExportResult result) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      glowColor: AppColors.neonGreen,
      child: Column(
        children: [
          const Icon(Icons.check_circle,
              color: AppColors.neonGreen, size: 44),
          const SizedBox(height: 12),
          const Text(
            'تم التصدير بنجاح!',
            style: TextStyle(
              color: AppColors.neonGreen,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${result.fileCount} ملف • ${result.sizeFormatted}',
            style: const TextStyle(
              color: AppColors.textDarkSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.file.path.split('/').last,
            style: const TextStyle(
              color: AppColors.textDarkHint,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
