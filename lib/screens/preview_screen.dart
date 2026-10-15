import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../providers/theme_provider.dart';
import '../widgets/aurora_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/keyboard_preview.dart';
import '../widgets/neon_button.dart';

/// شاشة المعاينة الكاملة
class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.darkBg,
          appBar: AppBar(
            title: const Text('المعاينة الكاملة'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => setState(() => _scale = 1.0),
                tooltip: 'إعادة الحجم',
              ),
            ],
          ),
          body: AuroraFullBackground(
            intensity: 0.5,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Transform.scale(
                        scale: _scale,
                        child: KeyboardPreview(
                          project: provider.project,
                          scale: 1.0,
                          showBorder: true,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildToolbar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolbar() {
    return GlassCard(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 16,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const Icon(Icons.zoom_out,
                color: AppColors.textDarkHint, size: 20),
            Expanded(
              child: Slider(
                value: _scale,
                min: 0.5,
                max: 1.5,
                divisions: 20,
                label: '${(_scale * 100).round()}%',
                onChanged: (v) => setState(() => _scale = v),
              ),
            ),
            const Icon(Icons.zoom_in,
                color: AppColors.textDarkHint, size: 20),
            const SizedBox(width: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.neonCyan.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.neonCyan.withOpacity(0.3),
                ),
              ),
              child: Text(
                '${(_scale * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.neonCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
