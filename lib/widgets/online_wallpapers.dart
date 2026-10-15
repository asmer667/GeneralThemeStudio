import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../services/wallpaper_api.dart';
import 'neon_button.dart';

/// شبكة عرض الخلفيات من الإنترنت
class OnlineWallpapersGrid extends StatefulWidget {
  final WallpaperSource source;
  final ValueChanged<OnlineWallpaper> onSelected;

  const OnlineWallpapersGrid({
    super.key,
    required this.source,
    required this.onSelected,
  });

  @override
  State<OnlineWallpapersGrid> createState() => _OnlineWallpapersGridState();
}

class _OnlineWallpapersGridState extends State<OnlineWallpapersGrid> {
  List<OnlineWallpaper> _wallpapers = [];
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  int _page = 1;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _load();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(OnlineWallpapersGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      _page = 1;
      _wallpapers.clear();
      _load();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await WallpaperApi.fetchWallpapers(
        source: widget.source,
        count: 30,
        page: 1,
      );
      if (!mounted) return;
      setState(() {
        _wallpapers = list;
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

  Future<void> _loadMore() async {
    if (_loadingMore || _loading) return;
    setState(() => _loadingMore = true);

    try {
      _page++;
      final more = await WallpaperApi.fetchWallpapers(
        source: widget.source,
        count: 30,
        page: _page,
      );
      if (!mounted) return;
      setState(() {
        _wallpapers.addAll(more);
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
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
              'جارٍ جلب الخلفيات...',
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
              NeonButton(
                label: 'حاول مرة أخرى',
                icon: Icons.refresh,
                onPressed: _load,
                size: NeonButtonSize.small,
              ),
            ],
          ),
        ),
      );
    }

    if (_wallpapers.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد خلفيات',
          style: TextStyle(color: AppColors.textDarkHint),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.neonCyan,
      backgroundColor: AppColors.darkContainer,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: _wallpapers.length + (_loadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == _wallpapers.length) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.neonCyan,
                strokeWidth: 2,
              ),
            );
          }
          return _wallpaperTile(_wallpapers[i]);
        },
      ),
    );
  }

  Widget _wallpaperTile(OnlineWallpaper wallpaper) {
    return GestureDetector(
      onTap: () => widget.onSelected(wallpaper),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                wallpaper.thumbnailUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: AppColors.darkContainer,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                        color: AppColors.neonCyan,
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.darkContainer,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.textDarkHint,
                  ),
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
                        Colors.black.withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wallpaper.author,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        wallpaper.source,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.download_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
