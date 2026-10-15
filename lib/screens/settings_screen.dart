import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/app_colors.dart';
import '../core/constants.dart';
import '../providers/settings_provider.dart';
import '../services/project_store_service.dart';
import '../widgets/glass_card.dart';

/// الإعدادات
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return Scaffold(
          backgroundColor: AppColors.darkBg,
          appBar: AppBar(title: const Text('الإعدادات')),
          body: ListView(
            children: [
              _section('المظهر'),
              _switchTile(
                icon: Icons.dark_mode,
                title: 'الوضع الليلي',
                subtitle: 'تبديل بين الفاتح والداكن',
                value: settings.isDark,
                onChanged: (v) => settings.setThemeMode(
                  v ? ThemeMode.dark : ThemeMode.light,
                ),
              ),
              _switchTile(
                icon: Icons.grid_view,
                title: 'عرض الشبكة',
                subtitle: 'إظهار شبكة في المحرر',
                value: settings.showGrid,
                onChanged: settings.setShowGrid,
              ),

              _section('السلوك'),
              _switchTile(
                icon: Icons.vibration,
                title: 'الاهتزاز',
                subtitle: 'اهتزاز خفيف عند التفاعل',
                value: settings.hapticFeedback,
                onChanged: settings.setHapticFeedback,
              ),
              _switchTile(
                icon: Icons.save,
                title: 'الحفظ التلقائي',
                subtitle: 'حفظ تلقائي عند التعديل',
                value: settings.autoSave,
                onChanged: settings.setAutoSave,
              ),

              _section('اللغة'),
              GlassCard(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.language,
                        color: AppColors.neonCyan),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'لغة التطبيق',
                            style: TextStyle(
                              color: AppColors.textDarkPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'العربية / English',
                            style: TextStyle(
                              color: AppColors.textDarkHint,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'ar', label: Text('ع')),
                        ButtonSegment(value: 'en', label: Text('EN')),
                      ],
                      selected: {settings.locale.languageCode},
                      onSelectionChanged: (s) {
                        settings.setLocale(Locale(s.first));
                      },
                    ),
                  ],
                ),
              ),

              _section('البيانات'),
              _tile(
                icon: Icons.backup_outlined,
                color: AppColors.neonPurple,
                title: 'تصدير نسخة احتياطية',
                subtitle: 'حفظ كل الثيمات في ملف JSON',
                onTap: () async {
                  try {
                    final file = await ProjectStoreService.exportAllToFile();
                    await Share.shareXFiles([XFile(file.path)]);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فشل: $e')),
                    );
                  }
                },
              ),
              _tile(
                icon: Icons.delete_sweep_outlined,
                color: AppColors.error,
                title: 'حذف كل الثيمات',
                subtitle: 'لا يمكن التراجع',
                onTap: () => _confirmClearAll(context),
              ),

              _section('حول'),
              _tile(
                icon: Icons.info_outline,
                color: AppColors.neonBlue,
                title: AppConstants.appName,
                subtitle:
                    'الإصدار ${AppConstants.appVersion} (${AppConstants.appBuildNumber})',
                onTap: null,
              ),
              _tile(
                icon: Icons.code,
                color: AppColors.textDarkHint,
                title: 'مفتوح المصدر',
                subtitle: 'MIT License',
                onTap: null,
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.neonCyan,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.neonCyan),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textDarkHint,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _tile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textDarkHint,
        ),
      ),
      trailing: onTap != null
          ? const Icon(Icons.arrow_forward_ios, size: 14)
          : null,
      onTap: onTap,
    );
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text(
            'سيتم حذف كل الثيمات المحفوظة. لا يمكن التراجع.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              await ProjectStoreService.deleteAll();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم الحذف')),
              );
            },
            child: const Text(
              'حذف الكل',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
