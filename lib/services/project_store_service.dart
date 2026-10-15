import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/theme_project.dart';

/// خدمة حفظ المشاريع
class ProjectStoreService {
  ProjectStoreService._();

  static const String _keyProjects = 'saved_projects_v1';
  static const String _keyLastProject = 'last_project_v1';

  // ═══ Current Project ═══

  static Future<void> saveCurrentProject(ThemeProject project) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastProject, jsonEncode(project.toJson()));
  }

  static Future<ThemeProject?> loadCurrentProject() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyLastProject);
    if (json == null) return null;
    try {
      return ThemeProject.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearCurrentProject() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLastProject);
  }

  // ═══ Library ═══

  static Future<void> saveProject(ThemeProject project) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _loadList(prefs);

    final idx = list.indexWhere((p) => p.id == project.id);
    if (idx != -1) {
      list[idx] = project;
    } else {
      list.add(project);
    }

    await _saveList(prefs, list);
  }

  static Future<List<ThemeProject>> loadAllProjects() async {
    final prefs = await SharedPreferences.getInstance();
    return _loadList(prefs);
  }

  static Future<void> deleteProject(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _loadList(prefs);
    list.removeWhere((p) => p.id == id);
    await _saveList(prefs, list);
  }

  static Future<ThemeProject> duplicateProject(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _loadList(prefs);
    final original = list.firstWhere((p) => p.id == id);

    final copy = original.copyWith(
      id: 'studio.${DateTime.now().millisecondsSinceEpoch}',
      name: '${original.name} (نسخة)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    list.add(copy);
    await _saveList(prefs, list);
    return copy;
  }

  static Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProjects);
  }

  static Future<int> count() async {
    final list = await loadAllProjects();
    return list.length;
  }

  static Future<List<ThemeProject>> getRecent({int limit = 5}) async {
    final list = await loadAllProjects();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list.take(limit).toList();
  }

  static Future<List<ThemeProject>> search(String query) async {
    if (query.trim().isEmpty) return loadAllProjects();
    final list = await loadAllProjects();
    final q = query.toLowerCase();
    return list
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.author.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }

  // ═══ Backup ═══

  static Future<File> exportAllToFile() async {
    final projects = await loadAllProjects();
    final json = jsonEncode({
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'projects': projects.map((p) => p.toJson()).toList(),
    });

    final tempDir = await getTemporaryDirectory();
    final file =
        File('${tempDir.path}/general_theme_studio_backup.json');
    await file.writeAsString(json);
    return file;
  }

  static Future<int> importFromFile(File file) async {
    final json = await file.readAsString();
    final map = jsonDecode(json) as Map<String, dynamic>;
    final projectsJson = map['projects'] as List;

    final prefs = await SharedPreferences.getInstance();
    final existing = await _loadList(prefs);
    final existingIds = existing.map((p) => p.id).toSet();

    int imported = 0;
    for (final p in projectsJson) {
      final project = ThemeProject.fromJson(p as Map<String, dynamic>);
      if (!existingIds.contains(project.id)) {
        existing.add(project);
        imported++;
      }
    }

    await _saveList(prefs, existing);
    return imported;
  }

  // ═══ Private ═══

  static Future<List<ThemeProject>> _loadList(
      SharedPreferences prefs) async {
    final json = prefs.getString(_keyProjects);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List;
      return list
          .map((e) => ThemeProject.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveList(
      SharedPreferences prefs, List<ThemeProject> list) async {
    final json = jsonEncode(list.map((p) => p.toJson()).toList());
    await prefs.setString(_keyProjects, json);
  }
}
