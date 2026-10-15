import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/background_asset.dart';
import '../services/background_service.dart';
import '../services/wallpaper_api.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../widgets/online_wallpapers.dart';

/// شاشة تصفح الخلفيات من الإنترنت
class OnlineWallpapersScreen extends StatefulWidget {
  final ValueChanged<BackgroundAsset>? onWallpaperSelected;

  const OnlineWallpapersScreen({super.key, this.onWallpaperSelected});

  @override
  State<OnlineWallpapersScreen> createState() =>
      _OnlineWallpapersScreenState();
}

class _OnlineWallpapersScreenState extends State<OnlineWallpapersScreen> {
  WallpaperSource _source = WallpaperSource.picsum;
  bool _isDownloading = false;
  double _progress = 0;

  Future<void> _downloadWallpaper(OnlineWallpaper wallpaper) async {
    setState(() {
      _isDownloading = true;
      _progress = 0;
    });

    try {
      final file = await WallpaperApi.downloadWallpaper(
        wallpaper: wallpaper,
        onProgress: (received, total) {
          if (total > 0) {
            setState(() => _progress = received / total);
          }
        },
      );

      if (!mounted) return;

      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل التنزيل')),
        );
        return;
      }

      // حفظها كخلفية في المشروع
      final bg = await BackgroundService.uploadBackground(file);

      if (!mounted) return;

      if (widget.onWallpaperSelected != null) {
        widget.onWallpaperSelected!(bg);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تنزيل: ${bg.name}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _progress = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('خلفيات من الإنترنت'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSourceSelector(),
              Expanded(
                child: OnlineWallpapersGrid(
                  source: _source,
                  onSelected: _downloadWallpaper,
                ),
              ),
            ],
          ),
          if (_isDownloading) _buildDownloadOverlay(),
        ],
      ),
    );
  }

  Widget _buildSourceSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المصدر',
            style: TextStyle(
              color: AppColors.textDarkSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: WallpaperSource.values.map((s) {
                final isSelected = _source == s;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _source = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.neonCyan.withOpacity(0.2)
                            : AppColors.darkContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.neonCyan
                              : Colors.white.withOpacity(0.08),
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? AppColors.glow(
                                AppColors.neonCyan,
                                intensity: 0.3,
                              )
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.neonCyan
                                  : AppColors.textDarkPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s.description,
                            style: const TextStyle(
                              color: AppColors.textDarkHint,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            glowColor: AppColors.neonCyan,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.neonCyan,
                ),
                const SizedBox(height: 16),
                const Text(
                  'جارٍ التنزيل...',
                  style: TextStyle(
                    color: AppColors.textDarkPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColors.neonCyan,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
