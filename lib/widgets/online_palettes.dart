import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../services/palette_api.dart';

/// شبكة عرض Palettes من الإنترنت
class OnlinePalettesGrid extends StatefulWidget {
  final PaletteSource source;
  final ValueChanged<OnlinePalette> onSelected;
  final ValueChanged<List<Color>>? onColorsSelected;

  const OnlinePalettesGrid({
    super.key,
    required this.source,
    required this.onSelected,
    this.onColorsSelected,
  });

  @override
  State<OnlinePalettesGrid> createState() => _OnlinePalettesGridState();
}

class _OnlinePalettesGridState extends State<OnlinePalettesGrid> {
  List<OnlinePalette> _palettes = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(OnlinePalettesGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await PaletteApi.fetchPalettes(
        source: widget.source,
        count: 20,
      );
      if (!mounted) return;
      setState(() {
        _palettes = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
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
              'جارٍ جلب الألوان...',
              style: TextStyle(color: AppColors.textDarkHint),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textDarkHint),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('حاول مرة أخرى'),
              ),
            ],
          ),
        ),
      );
    }

    if (_palettes.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد palettes',
          style: TextStyle(color: AppColors.textDarkHint),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.neonCyan,
      backgroundColor: AppColors.darkContainer,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _palettes.length,
        itemBuilder: (_, i) => _paletteCard(_palettes[i]),
      ),
    );
  }

  Widget _paletteCard(OnlinePalette palette) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          widget.onSelected(palette);
          widget.onColorsSelected?.call(palette.colors);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.darkContainer,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient Preview
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(13),
                ),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: palette.toGradient(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            palette.name,
                            style: const TextStyle(
                              color: AppColors.textDarkPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${palette.source} • ${palette.colors.length} ألوان',
                            style: const TextStyle(
                              color: AppColors.textDarkHint,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Color swatches
                    Row(
                      children: palette.colors
                          .take(4)
                          .map((c) => Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(left: 2),
                                decoration: BoxDecoration(
                                  color: c,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
