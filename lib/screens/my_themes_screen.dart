import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../models/theme_project.dart';
import '../providers/theme_provider.dart';
import '../services/project_store_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/theme_card.dart';
import 'editor_screen.dart';

/// شاشة إدارة الثيمات
class MyThemesScreen extends StatefulWidget {
  const MyThemesScreen({super.key});

  @override
  State<MyThemesScreen> createState() => _MyThemesScreenState();
}

class _MyThemesScreenState extends State<MyThemesScreen> {
  List<ThemeProject> _projects = [];
  List<ThemeProject> _filtered = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await ProjectStoreService.loadAllProjects();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    if (!mounted) return;
    setState(() {
      _projects = list;
      _filtered = list;
      _loading = false;
    });
  }

  void _filter(String query) {
    setState(() {
      _search = query;
      if (query.isEmpty) {
        _filtered = _projects;
      } else {
        final q = query.toLowerCase();
        _filtered = _projects
            .where((p) =>
                p.name.toLowerCase().contains(q) ||
                p.author.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  Future<void> _delete(ThemeProject project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف الثيم'),
        content: Text('حذف "${project.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ProjectStoreService.deleteProject(project.id);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الحذف')),
      );
    }
  }

  Future<void> _duplicate(ThemeProject project) async {
    await ProjectStoreService.duplicateProject(project.id);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم النسخ')),
    );
  }

  Future<void> _open(ThemeProject project) async {
    context.read<ThemeProvider>().loadProject(project);
    await ProjectStoreService.saveCurrentProject(project);
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditorScreen()),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('ثيماتي (${_projects.length})'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ابحث باسم أو مؤلف...',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: _filter,
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.neonCyan),
            )
          : _filtered.isEmpty
              ? _empty()
              : RefreshIndicator(
                  onRefresh: _load,
                  color: AppColors.neonCyan,
                  backgroundColor: AppColors.darkContainer,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => ThemeCard(
                      project: _filtered[i],
                      onTap: () => _open(_filtered[i]),
                      onDuplicate: () => _duplicate(_filtered[i]),
                      onDelete: () => _delete(_filtered[i]),
                    ),
                  ),
                ),
    );
  }

  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.darkContainer,
                shape: BoxShape.circle,
                boxShadow: AppColors.glow(AppColors.neonCyan, intensity: 0.3),
              ),
              child: const Icon(
                Icons.collections_bookmark_outlined,
                size: 48,
                color: AppColors.textDarkHint,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _search.isEmpty ? 'لا توجد ثيمات محفوظة' : 'لا نتائج للبحث',
              style: const TextStyle(
                color: AppColors.textDarkPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _search.isEmpty
                  ? 'ابدأ بإنشاء ثيمك الأول'
                  : 'جرّب كلمة بحث أخرى',
              style: const TextStyle(
                color: AppColors.textDarkSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
