import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/background_asset.dart';
import '../models/border_asset.dart';
import '../models/gradient_preset.dart';
import '../models/icon_asset.dart';
import '../models/key_config.dart';
import '../models/key_group.dart';
import '../models/key_shape.dart';
import '../models/theme_project.dart';
import '../services/project_store_service.dart';
import '../services/theme_import_service.dart';

/// إدارة حالة الثيم الحالي
class ThemeProvider extends ChangeNotifier {
  ThemeProject _project = ThemeProject.createDefault();
  ThemeProject get project => _project;

  bool _hasUnsavedChanges = false;
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  String? _activeGroupId;
  String? get activeGroupId => _activeGroupId;

  Timer? _autoSaveTimer;

  ThemeProvider() {
    _loadLastProject();
  }

  // ═══ Load / Save ═══

  Future<void> _loadLastProject() async {
    try {
      final saved = await ProjectStoreService.loadCurrentProject();
      if (saved != null) {
        _project = saved;
        _activeGroupId =
            saved.groups.isNotEmpty ? saved.groups.first.id : null;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> saveCurrent() async {
    await ProjectStoreService.saveCurrentProject(_project);
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  Future<void> saveToLibrary() async {
    _project = _project.touch();
    await ProjectStoreService.saveProject(_project);
    await ProjectStoreService.saveCurrentProject(_project);
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  // ═══ New / Load ═══

  void newProject() {
    _project = ThemeProject.createDefault();
    _activeGroupId =
        _project.groups.isNotEmpty ? _project.groups.first.id : null;
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  void loadProject(ThemeProject project) {
    _project = project;
    _activeGroupId =
        project.groups.isNotEmpty ? project.groups.first.id : null;
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  /// Replace the current project after an edit and keep autosave/dirty state.
  void replaceProject(ThemeProject project) {
    _project = project.copyWith(updatedAt: DateTime.now());
    if (_activeGroupId != null &&
        !_project.groups.any((group) => group.id == _activeGroupId)) {
      _activeGroupId = _project.groups.isNotEmpty ? _project.groups.first.id : null;
    }
    _touch();
  }

  // ═══ Import Theme ═══

  Future<void> importTheme(File file) async {
    try {
      final imported = await ThemeImportService.importTheme(file);
      _project = imported;
      _activeGroupId =
          imported.groups.isNotEmpty ? imported.groups.first.id : null;
      _hasUnsavedChanges = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ═══ Metadata ═══

  void updateName(String name) {
    _project = _project.copyWith(name: name, updatedAt: DateTime.now());
    _touch();
  }

  void updateAuthor(String author) {
    _project = _project.copyWith(author: author, updatedAt: DateTime.now());
    _touch();
  }

  void updateDescription(String description) {
    _project = _project.copyWith(
      description: description,
      updatedAt: DateTime.now(),
    );
    _touch();
  }

  // ═══ Colors ═══

  void updateColor(String field, Color color) {
    switch (field) {
      case 'primary':
        _project = _project.copyWith(primary: color);
        break;
      case 'onPrimary':
        _project = _project.copyWith(onPrimary: color);
        break;
      case 'primaryContainer':
        _project = _project.copyWith(primaryContainer: color);
        break;
      case 'onPrimaryContainer':
        _project = _project.copyWith(onPrimaryContainer: color);
        break;
      case 'secondary':
        _project = _project.copyWith(secondary: color);
        break;
      case 'onSecondary':
        _project = _project.copyWith(onSecondary: color);
        break;
      case 'secondaryContainer':
        _project = _project.copyWith(secondaryContainer: color);
        break;
      case 'onSecondaryContainer':
        _project = _project.copyWith(onSecondaryContainer: color);
        break;
      case 'tertiary':
        _project = _project.copyWith(tertiary: color);
        break;
      case 'onTertiary':
        _project = _project.copyWith(onTertiary: color);
        break;
      case 'background':
        _project = _project.copyWith(background: color);
        break;
      case 'onBackground':
        _project = _project.copyWith(onBackground: color);
        break;
      case 'surface':
        _project = _project.copyWith(surface: color);
        break;
      case 'onSurface':
        _project = _project.copyWith(onSurface: color);
        break;
      case 'surfaceVariant':
        _project = _project.copyWith(surfaceVariant: color);
        break;
      case 'onSurfaceVariant':
        _project = _project.copyWith(onSurfaceVariant: color);
        break;
      case 'error':
        _project = _project.copyWith(error: color);
        break;
      case 'onError':
        _project = _project.copyWith(onError: color);
        break;
      case 'outline':
        _project = _project.copyWith(outline: color);
        break;
      case 'outlineVariant':
        _project = _project.copyWith(outlineVariant: color);
        break;
      case 'keyboardSurface':
        _project = _project.copyWith(keyboardSurface: color);
        break;
      case 'keyboardContainer':
        _project = _project.copyWith(keyboardContainer: color);
        break;
      case 'keyboardContainerVariant':
        _project = _project.copyWith(keyboardContainerVariant: color);
        break;
      case 'onKeyboardContainer':
        _project = _project.copyWith(onKeyboardContainer: color);
        break;
      case 'keyboardPress':
        _project = _project.copyWith(keyboardPress: color);
        break;
      case 'keyboardContainerPressed':
        _project = _project.copyWith(keyboardContainerPressed: color);
        break;
      case 'onKeyboardContainerPressed':
        _project = _project.copyWith(onKeyboardContainerPressed: color);
        break;
    }
    _project = _project.copyWith(updatedAt: DateTime.now());
    _touch();
  }

  // ═══ Options ═══

  void updateRoundedness(double v) {
    _project = _project.copyWith(roundedness: v, updatedAt: DateTime.now());
    _touch();
  }

  void updateScaleText(double v) {
    _project = _project.copyWith(scaleText: v, updatedAt: DateTime.now());
    _touch();
  }

  void updateScaleHints(double v) {
    _project = _project.copyWith(scaleHints: v, updatedAt: DateTime.now());
    _touch();
  }

  void updateAutoBorders(bool v) {
    _project = _project.copyWith(autoBorders: v, updatedAt: DateTime.now());
    _touch();
  }

  void updateCenterHints(bool v) {
    _project = _project.copyWith(centerHints: v, updatedAt: DateTime.now());
    _touch();
  }

  // ═══ Background ═══

  void updateBackground(BackgroundAsset? bg) {
    _project = _project.copyWith(
      backgroundAsset: bg,
      clearBackgroundAsset: bg == null,
      updatedAt: DateTime.now(),
    );
    _touch();
  }

  // ═══ Font ═══

  void updateFont(String? family, String? path) {
    _project = _project.copyWith(
      fontName: family,
      fontPath: path,
      updatedAt: DateTime.now(),
    );
    _touch();
  }

  void clearFont() {
    _project = _project.copyWith(
      clearFont: true,
      updatedAt: DateTime.now(),
    );
    _touch();
  }

  // ═══ Groups ═══

  void setActiveGroup(String? id) {
    _activeGroupId = id;
    notifyListeners();
  }

  KeyGroup? get activeGroup {
    if (_activeGroupId == null) return null;
    try {
      return _project.groups.firstWhere((g) => g.id == _activeGroupId);
    } catch (_) {
      return null;
    }
  }

  void addGroup(KeyGroup group) {
    final list = [..._project.groups, group];
    _project = _project.copyWith(groups: list, updatedAt: DateTime.now());
    _activeGroupId = group.id;
    _touch();
  }

  void updateGroup(KeyGroup group) {
    final list =
        _project.groups.map((g) => g.id == group.id ? group : g).toList();
    _project = _project.copyWith(groups: list, updatedAt: DateTime.now());
    _touch();
  }

  void removeGroup(String id) {
    final list = _project.groups.where((g) => g.id != id).toList();
    _project = _project.copyWith(groups: list, updatedAt: DateTime.now());
    if (_activeGroupId == id) {
      _activeGroupId = list.isNotEmpty ? list.first.id : null;
    }
    _touch();
  }

  void changeGroupShape(String groupId, KeyShape shape) {
    try {
      final group = _project.groups.firstWhere((g) => g.id == groupId);
      updateGroup(group.copyWith(shape: shape));
    } catch (_) {}
  }

  void setGroupBorder(String groupId, BorderAsset? border) {
    try {
      final group = _project.groups.firstWhere((g) => g.id == groupId);
      updateGroup(group.copyWith(border: border));
    } catch (_) {}
  }

  void setGroupPressedBorder(String groupId, BorderAsset? border) {
    try {
      final group = _project.groups.firstWhere((g) => g.id == groupId);
      updateGroup(group.copyWith(pressedBorder: border));
    } catch (_) {}
  }

  void setGroupLongPressBorder(String groupId, BorderAsset? border) {
    try {
      final group = _project.groups.firstWhere((g) => g.id == groupId);
      updateGroup(group.copyWith(longPressBorder: border));
    } catch (_) {}
  }

  void setGroupGradient(String groupId, GradientPreset? gradient) {
    try {
      final group = _project.groups.firstWhere((g) => g.id == groupId);
      updateGroup(group.copyWith(gradient: gradient));
    } catch (_) {}
  }

  void setGroupPressedGradient(String groupId, GradientPreset? gradient) {
    try {
      final group = _project.groups.firstWhere((g) => g.id == groupId);
      updateGroup(group.copyWith(pressedGradient: gradient));
    } catch (_) {}
  }

  void setGroupConfig(String groupId, KeyConfig config) {
    try {
      final group = _project.groups.firstWhere((g) => g.id == groupId);
      updateGroup(group.copyWith(config: config));
    } catch (_) {}
  }

  void setGroupIcon(String groupId, IconAsset? icon) {
    try {
      final group = _project.groups.firstWhere((g) => g.id == groupId);
      updateGroup(group.copyWith(icon: icon));
    } catch (_) {}
  }

  void setGroupPressedIcon(String groupId, IconAsset? icon) {
    try {
      final group = _project.groups.firstWhere((g) => g.id == groupId);
      updateGroup(group.copyWith(pressedIcon: icon));
    } catch (_) {}
  }

  void toggleGroupEnabled(String groupId) {
    try {
      final group = _project.groups.firstWhere((g) => g.id == groupId);
      updateGroup(group.copyWith(enabled: !group.enabled));
    } catch (_) {}
  }

  // ═══ Private ═══

  void _touch() {
    _hasUnsavedChanges = true;
    notifyListeners();
    _autoSave();
  }

  void _autoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), () async {
      await ProjectStoreService.saveCurrentProject(_project);
      _hasUnsavedChanges = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}
